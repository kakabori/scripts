#!/usr/bin/perl -w

use strict;
use Spreadsheet::WriteExcel;
use File::Basename;
use Getopt::Std;

#my @attributes = ["Kc","B","lxctr","lyctr","mctr","D","mocsig","edisp","bFWHM","s","bc2b","alpha","R","wavelength","pz","qrzero","nindex","T","Dataset","ChiSquare","lambda","eta","xi","Iteration","aFactor"];

my @attributes = ["ChiSquare","Iter","dataset","Kc","B","lxctr","lyctr","mctr","D","mocsig","lambda","eta","xi","aFactor","edisp","bFWHM","s","bc2b","alpha","R","wavelength","pz","qrzero","nindex","T"];

my $dirName = $ARGV[0];
opendir(DIR, $dirName);
my @files = grep(/\.par$/,readdir(DIR));
closedir(DIR);

#Read an optional file name
shift @ARGV;
my %opt;
my $fileName;
#Look for a -f switch with an argument
getopt('f:', \%opt);
if(defined $opt{f}){
        $fileName = $opt{f};
        $fileName =~ /(^[^\.\/]+)/; #Ignore '.', '/', and anything that follows
	if(defined $1){
        	$fileName = $1 . ".xls";
        }
        #If no usable characters are extracted from the supplied file name,
        #use the default name fitdata.xls.
        else{
		$fileName = "fitdata.xls" 
	}
}
#If no file is given, name the output fitdata.xls
else{
	$fileName = 'fitdata.xls';
}
print "Using file name $fileName\n"; 
# Create a new Excel workbook
my $workbook = Spreadsheet::WriteExcel->new($fileName);
# Add a worksheet
my $worksheet = $workbook->add_worksheet();

#  Add and define a format
my $format = $workbook->add_format(); # Add a format
$format->set_bold();
$format->set_align('center');


## Write attribute headers
$worksheet->write(0,0,"File",$format);
for(my $counter = 0;$counter <($#attributes+1);$counter++)
{
$worksheet->write(0,$counter+1,$attributes[$counter],$format);

}


## Write attribute
my $itemsrow=1;
my $itemscol=0;

foreach my $file(@files)
{
  $file = $dirName."/".$file;
  open(PAR,"<$file");
  my $samplename = basename($file,".par");
  print "wrote $samplename\n";
  $worksheet->write($itemsrow,$itemscol,$samplename);
  while(<PAR>)#This will read the file line by line
  {
		my $things = $_;

		if($things =~ m/(# ChiSquare)/)
		{
			  $things =~ m/([-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?)/;
			  my $value = $1;
			  my $shiftcol = 1;
			  $worksheet->write($itemsrow,$shiftcol,$value)
		}

		if($things =~ m/(# lambda)/)
		{
			  $things =~ m/([-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?)/;
			  my $value = $1;
			  my $shiftcol = 11;
			  $worksheet->write($itemsrow,$shiftcol,$value)
		}

		if($things =~ m/(# eta)/)
		{
			  $things =~ m/([-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?)/;
			  my $value = $1;
			  my $shiftcol = 12;
			  $worksheet->write($itemsrow,$shiftcol,$value)
		}

		if($things =~ m/(# xi)/)
		{
			  $things =~ m/([-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?)/;
			  my $value = $1;
			  my $shiftcol = 13;
			  $worksheet->write($itemsrow,$shiftcol,$value)
		}

		if($things =~ m/(# Iteration)/)
		{
			  $things =~ m/([-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?)/;
			  my $value = $1;
			  my $shiftcol = 2;
			  $worksheet->write($itemsrow,$shiftcol,$value)
		}

		if($things =~ m/(# aFactor)/)
		{
			  $things =~ m/([-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?)/;
			  my $value = $1;
			  my $shiftcol = 14;
			  $worksheet->write($itemsrow,$shiftcol,$value)
		}

		if($things =~ m/paraset set p Kc/)
		{
			  my @array = split(" ",$things);#split by white space
			  my $value = $array[4];#the fifth word is the value of a parameter
			  my $shiftcol = 4;
			  $worksheet->write_number($itemsrow,$shiftcol,$value);
		}

		if($things =~ m/paraset set p B/)
		{
			  my @array = split(" ",$things);#split by white space
			  my $value = $array[4];#the fifth word is the value of a parameter
			  my $shiftcol = 5;
			  $worksheet->write_number($itemsrow,$shiftcol,$value);
		}

		if($things =~ m/paraset set p lxctr/)
		{
			  my @array = split(" ",$things);#split by white space
			  my $value = $array[4];#the fifth word is the value of a parameter
			  my $shiftcol = 6;
			  $worksheet->write_number($itemsrow,$shiftcol,$value);
		}

		if($things =~ m/paraset set p lyctr/)
		{
			  my @array = split(" ",$things);#split by white space
			  my $value = $array[4];#the fifth word is the value of a parameter
			  my $shiftcol = 7;
			  $worksheet->write_number($itemsrow,$shiftcol,$value);
		}

		if($things =~ m/paraset set p mctr/)
		{
			  my @array = split(" ",$things);#split by white space
			  my $value = $array[4];#the fifth word is the value of a parameter
			  my $shiftcol = 8;
			  $worksheet->write_number($itemsrow,$shiftcol,$value);
		}

		if($things =~ m/paraset set p D/)
		{
			  my @array = split(" ",$things);#split by white space
			  my $value = $array[4];#the fifth word is the value of a parameter
			  my $shiftcol = 9;
			  $worksheet->write_number($itemsrow,$shiftcol,$value);
		}

		if($things =~ m/paraset set p mocsig/)
		{
			  my @array = split(" ",$things);#split by white space
			  my $value = $array[4];#the fifth word is the value of a parameter
			  my $shiftcol = 10;
			  $worksheet->write_number($itemsrow,$shiftcol,$value);
		}

		if($things =~ m/paraset set p edisp/)
		{
			  my @array = split(" ",$things);#split by white space
			  my $value = $array[4];#the fifth word is the value of a parameter
			  my $shiftcol = 15;
			  $worksheet->write_number($itemsrow,$shiftcol,$value);
		}

		if($things =~ m/paraset set p bFWHM/)
		{
			  my @array = split(" ",$things);#split by white space
			  my $value = $array[4];#the fifth word is the value of a parameter
			  my $shiftcol = 16;
			  $worksheet->write_number($itemsrow,$shiftcol,$value);
		}

		if($things =~ m/paraset set p s/)
		{
			  my @array = split(" ",$things);#split by white space
			  my $value = $array[4];#the fifth word is the value of a parameter
			  my $shiftcol = 17;
			  $worksheet->write_number($itemsrow,$shiftcol,$value);
		}

		if($things =~ m/paraset set p bc2b/)
		{
			  my @array = split(" ",$things);#split by white space
			  my $value = $array[4];#the fifth word is the value of a parameter
			  my $shiftcol = 18;
			  $worksheet->write_number($itemsrow,$shiftcol,$value);
		}

		if($things =~ m/paraset set p alpha/)
		{
			  my @array = split(" ",$things);#split by white space
			  my $value = $array[4];#the fifth word is the value of a parameter
			  my $shiftcol = 19;
			  $worksheet->write_number($itemsrow,$shiftcol,$value);
		}

		if($things =~ m/paraset set p R/)
		{
			  my @array = split(" ",$things);#split by white space
			  my $value = $array[4];#the fifth word is the value of a parameter
			  my $shiftcol = 20;
			  $worksheet->write_number($itemsrow,$shiftcol,$value);
		}

		if($things =~ m/paraset set p wavelength/)
		{
			  my @array = split(" ",$things);#split by white space
			  my $value = $array[4];#the fifth word is the value of a parameter
			  my $shiftcol = 21;
			  $worksheet->write_number($itemsrow,$shiftcol,$value);
		}

		if($things =~ m/paraset set p pz/)
		{
			  my @array = split(" ",$things);#split by white space
			  my $value = $array[4];#the fifth word is the value of a parameter
			  my $shiftcol = 22;
			  $worksheet->write_number($itemsrow,$shiftcol,$value);
		}

		if($things =~ m/paraset set p qrzero/)
		{
			  my @array = split(" ",$things);#split by white space
			  my $value = $array[4];#the fifth word is the value of a parameter
			  my $shiftcol = 23;
			  $worksheet->write_number($itemsrow,$shiftcol,$value);
		}

		if($things =~ m/paraset set p nindex/)
		{
			  my @array = split(" ",$things);#split by white space
			  my $value = $array[4];#the fifth word is the value of a parameter
			  my $shiftcol = 24;
			  $worksheet->write_number($itemsrow,$shiftcol,$value);
		}

		if($things =~ m/paraset set p T/)
		{
			  my @array = split(" ",$things);#split by white space
			  my $value = $array[4];#the fifth word is the value of a parameter
			  my $shiftcol = 25;
			  $worksheet->write_number($itemsrow,$shiftcol,$value);
		}

		if($things =~ m/set dataset/)
		{
			  $things =~ m/"(.+?)"/g;
			  my $value = $1;
			  my $shiftcol = 3;
			  $worksheet->write($itemsrow,$shiftcol,$value);
		}
   
	#if($things =~ m/(ChiSquare)|(lambda)|(eta)|(xi)|(Iteration)|(# aFactor)/)
	#{
	#    $itemscol++;
	#    $things =~ m/([-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?)/;
	#    my $value = $1;
	#    my $shiftcol = $itemscol+19;
	#    #print $value,"@",$shiftcol,"\n";
	#    $worksheet->write($itemsrow,$shiftcol,$value)
	#}

	#if($things =~ m/paraset set p/)
	#{
	#    $itemscol++;
	#    #$things =~ m/([-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?)/g;
	#    my @array = split(" ",$things);#split by white space
	#    #print $array[4],"\n";
	#    my $value = $array[4];#the fifth word is the value of a parameter
	#    # print $value,"\n";
	#    my $shiftcol = $itemscol-6;
	#    $worksheet->write_number($itemsrow,$shiftcol,$value);
	#}

	#if($things =~ m/set dataset/)
	#{
	#    $things =~ m/"(.+?)"/g;
	#    my $value = $1;
	#    my $col = 19;
	#    $worksheet->write($itemsrow,$col,$value);
	#}   
	}
  $itemscol=0;
  $itemsrow++;
  close(PAR);
}

#system("cp fitdata.xls $dirName");
#system("ls -l");
