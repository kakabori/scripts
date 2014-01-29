'''documentation'''

import sys, os, shutil

def read_header(f):
    '''Read the first line of .sim file, which should be the headers separated
    by a white space(s). Then, display the number of header words.'''
    line = f.readline()
    headers = line.split()
    print(len(headers))
    
  
def read_line(f):
    '''Read a line in .sim file and display the Z value and the last three 
    values, which are the water number densities. Return true if a non-zero
    value is present other than the last three; otherwise, return false.'''
    line = f.readline()
    densities = line.split()
    z = densities.pop(0) # The Z value
    HW2 = densities.pop() # The second hydrogen in water
    HW1 = densities.pop() # The first hydrogen in water
    OW = densities.pop() # The oxygen in water
    print("z OW HW1 HW2", z, OW, HW1, HW2)
    
    # Check whether any non-zero value exists
    for i, val in enumerate(densities):
        if val != '0.000000':
            return i, val, True
    return False
    

def clean_up_header(name):
    fr = open(name, "r")
    first_line = fr.readline()
    headers = first_line.split()
    rest_of_lines = fr.readlines()
    fr.close()
  
    fw = open("tmp.sim", "w")
    for word in headers:
        print("{0:>15}".format(word), file=fw, end='')
    print("\n", file=fw, end='')
    for line in rest_of_lines:
        print(line, file=fw, end='')
    fw.close()
    
    shutil.copyfile("tmp.sim", name)
    

def main():
    # The length of sys.argv should be 2; otherwise, complain
    if len(sys.argv) == 1:
        print("Enter a filename. The syntax:\n",
              "python sim_file filename.sim")
        return
    elif len(sys.argv) == 2:
        filename = sys.argv[1]
    else:
        print("Too many input arguments.")
    
    input_file = open(filename, "r")
    read_header(input_file)
    


if __name__ == '__main__':
    main()    
