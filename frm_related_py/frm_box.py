#!/usr/bin/env python

'''This module creates par files for form factor box from par files output by 
NFIT. It accepts qzlow and qzhigh separated by a whitespace as the arguments.'''

import sys, math, os

'''Return the value of qrzero as a float'''
def get_qrzero(r):
    for line in r:
        if line.startswith('paraset set p qrzero'):
            return float(line.split()[4])

'''Return a list for the dataset, consisting of five floating point elements.
list[0]: sig_back
list[1]: qrlow
list[2]: qrhigh 
list[3]: qzlow 
list[4]: qzhigh'''    
def get_dataset(r):
    for line in r:
        if line.startswith('set dataset'):
            tmp = line.split()
            # for the first and last elements, remove double-quotation marks
            dataset = [float(tmp[2][1:3]), float(tmp[3]), float(tmp[4]), \
                       float(tmp[5]), float(tmp[6][0:3])]
            return dataset

'''Return the value of iter as an int'''
def get_iter(r):
    for line in r:
        if line.startswith('set iter'):
            return int(line.split()[2])
            


'''Write a par file with a dataset for the form factor box,
given an original par file name'''       
def writeNewParFile(filename, qrzero, qrlow, qrhigh, sig_back):
    # open input and output par files
    outFilename = filename.replace('.par', 'f.par')
    input_file = open(filename, "r")
    output_file = open(outFilename, "w")
                
    # if the line is for dataset, write with new values
    # otherwise, write without a change
    for line in input_file:
        if line.startswith('set dataset'):
            new_line = 'set dataset \"%.1f %.0f %.0f %.0f %.0f\"\n' % \
                       (sig_back, qrzero+30, qrzero+130, qrlow, qrhigh)         
            output_file.write(new_line)
            print new_line,
        elif line.startswith('set iter'):
            new_line = 'set iter 1\n'
            output_file.write(new_line)
            print new_line,     
        else:
            output_file.write(line)
    
    input_file.close()
    output_file.close()

# the length of sys.argv should be 2, otherwise, complain
if len(sys.argv) != 4:
    #print "Input absolute path to .par files, qzlow value and qzhigh value"
    print("Input absolute path to .par files, qzlow value and qzhigh value")
    print("for example: python frmBox.py ~/data/fits 240 950")
    print "if par files are located in /home/biophysicists/data/fits"
else:
    for root, dirs, files in os.walk(sys.argv[1]):
        for f in files:
            if f.endswith('.par'):
                name = sys.argv[1] + f
                print '\n',name
                input_file = open(name, "r")
                qrzero = get_qrzero(input_file)
                print 'qrzero:', qrzero
                dataset = get_dataset(input_file)
                print 'dataset:', dataset
                input_file.close()
                
                qrlow = float(sys.argv[2])
                qrhigh = float(sys.argv[3])
                writeNewParFile(name, qrzero, qrlow, qrhigh, dataset[0])

    

    
    


