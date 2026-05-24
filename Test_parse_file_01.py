# string to search in file
word = '[Channel 1 from data header]'
with open(r'Test_file.MON', 'r') as fp:
    # read all lines in a list
    lines = fp.readlines()
   # print(lines)
    for line in lines:
        # check if string present on a current line
        if line.find(word) != -1:
            print(word, 'string exists in file')
            print('Line Number:', lines.index(line))
            print('Line:', line)
