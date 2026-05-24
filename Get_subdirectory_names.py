import os
#import pickle
def fast_scandir(dirname):
    subfolders= [f.path for f in os.scandir(dirname) if f.is_dir()]
    for dirname in list(subfolders):
        print(dirname)
        subfolders.extend(fast_scandir(dirname))
    return subfolders
dirname ='J:\Adm_données\Modèles conceptuels'
s_list =fast_scandir(dirname)
print('Done Successfully')

with open (r'dir_file.csv', 'w') as f:
    #pickle.dump(dirname,f)
           for line in s_list:
                  f.write('%s\n' %line)
#print(fast_scandir(dirname))
#dir_path = "c:\temp"
#files_dir = [
    #f for f in os.listdir(dir_path) if os.path.isdir(os.path.join(dir_path, f))
#]
#print(files_dir)