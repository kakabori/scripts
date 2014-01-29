'''This module creates form factor file from the input frm.dat file, which 
contains scaling factors output from NFIT. The name of frm.dat file is 
specified by the command line argument.'''

import sys
from math import sqrt
from math import exp
from math import pi


def convert_scaling_to_form_factor(qz, scaling_factor):
    '''Convert the input scaling factor to the form factor. First apply the 
    absorption correction, then, the Lorentz correction, and finally take the 
    square root of the corrected scaling factor'''
    apply_absorp_correct(qz, scaling_factor)
    apply_lorentz_correct(qz, scaling_factor)
    for i in range(len(scaling_factor)):
        if scaling_factor[i] < 0:
            scaling_factor[i] = -1*sqrt(-1*scaling_factor[i])    
        else:
            scaling_factor[i] = sqrt(scaling_factor[i])


def apply_absorp_correct(qz, sc):
    '''Apply absorption correction to the input scaling factor, sc.
    All the lengths are in units of mm.'''
    thickness = 1e-2
    abs_length = 2.3
    Lz = 1e-4
    for i in range(len(qz)):
        sc[i] *= abs_correction(thickness, abs_length, Lz, qz[i])

        
def abs_correction(t, xa, Lz, qz):
    '''Return the absorption correction factor, given thickness t, absorption
    length xa, out of plane domain size Lz, and qz.'''
    wavelength = 1.175 # in Angstrom
    sin_theta = qz * wavelength / 4 / pi
    ac = 1 - exp(-2*Lz/xa/sin_theta)
    ac = ac / (1 - exp(-2*t/xa/sin_theta))
    ac = ac / exp(-Lz/xa/sin_theta)
    ac = ac * t / Lz
    return ac 

        
def apply_lorentz_correct(qz, sc):
    '''Apply Lorentz correction to the input scaling factor'''
    for i in range(len(qz)):
        sc[i] *= qz[i]


def read_frm_dot_dat(filename):
    '''Read in frm.dat and parse the data into lists, returning six lists in the 
    order of pz, scaling factor, cz, q, sigma in scaling factor, and sigma 
    in cz.'''
    
    pzList = []  # pz 
    scalingList = []  # scaling factor
    czList = []  # cz
    qList = []  # q space
    scalingSigmaList = []  # sigma in scaling factor
    czSigmaList = []  # simga in cz
    input_file = open(filename, "r")
    
    for line in input_file:
        pixel, scale, cz, q, scale_sig, cz_sig = line.split()
        pzList.append(float(pixel))
        scalingList.append(float(scale))
        czList.append(float(cz))
        qList.append(float(q))
        scalingSigmaList.append(float(scale_sig))
        czSigmaList.append(float(cz_sig))
        
    input_file.close()
    return pzList, scalingList, czList, qList, scalingSigmaList, czSigmaList
    
    
def write_to_a_file(filename, qz, form_factor):
    """Write qz and form_factor to a file named filename."""
    output_file = open(filename, "w")
    
    for (q, f) in zip(qz, form_factor):
        new_line = "%.6f %6f\n" % (q, f) 
        output_file.write(new_line)
        
    output_file.close()
    
        
def convert_frm_dot_dat(input_filename, output_filename):
    """Convert the scaling factor given by the input file to the form factor.
    After the conversion, save the values of qz and form factor to a file.
    The input file must be formatted as "frm.dat". The output file name can be
    anything, but .dat or .xff extensions are recommended for clarity."""
    pz, scaling, cz, qz, scaling_sigma, cz_sigma = read_frm_dot_dat(input_filename)
    convert_scaling_to_form_factor(qz, scaling)
    write_to_a_file(output_filename, qz, scaling)


def main():
    # the length of sys.argv should be 2, otherwise, complain
    if len(sys.argv) == 1:
        print("Enter input and output file names as command line arguments. Syntax:")
        print("python scaling2form input_filename output_filename")
        return
    elif len(sys.argv) == 2:
        input_filename = sys.argv[1]
        output_filename = 'out.xff'
    elif len(sys.argv) == 3:
        input_filename = sys.argv[1]
        output_filename = sys.argv[2]
    else:
        print("Too many input arguments. Syntax:")
        print("python scaling2form input_filename output_filename")
        return
    
    convert_frm_dot_dat(input_filename, output_filename)
       

if __name__ == '__main__':
    main()
