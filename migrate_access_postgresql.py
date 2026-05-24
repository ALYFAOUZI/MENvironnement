# Create Python script to convert .accdb to SQL
import subprocess

def accdb_to_postgres(accdb_file, db_name, host, user, password):
    # get a list of tables
    tables = (
        subprocess.check_output(["mdb-tables", "-1", accdb_file])
        .decode()
        .strip()
        .split("\n")
    )

    # construct postgresql connection string
    pg_conn = f"postgresql://{user}:{password}@{host}/{db_name}"

    # iterate through tables
    for table in tables:
        print(f"Processing table {table}...")

        # get schema (need to convert Access types to PostgreSQL types)
        # supported backends: `access`, `sybase`, `oracle`, `postgres`, `mysql` and `sqlite`
        schema = subprocess.check_output(["mdb-schema", f"--table={table}", accdb_file, "postgres"]).decode()

        # temporarily store schema
        with open("temp.sql", "w") as f:
            f.write(schema)
        
        # create table in postgres
        subprocess.run(["psql", pg_conn, "-f", "temp.sql"])

        # export data and import to postgres
        data = subprocess.check_output(["mdb-export", accdb_file, table]).decode()
        process = subprocess.Popen(
            ["psql", pg_conn, "-c", f"\copy {table} FROM STDIN WITH CSV HEADER"],
            stdin=subprocess.PIPE,
        )
        process.communicate(data.encode())
accdb_to_postgres(
    "AUS_be.accdb", 
    "postgres",
    "127.0.0.1",
    "postgres",
    "postgres",
)