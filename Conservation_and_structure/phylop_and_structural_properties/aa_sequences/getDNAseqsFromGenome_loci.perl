#!/usr/bin/perl -w

use strict;

use List::Util qw[min max];

if($#ARGV<2) {
   print "Don't have enough parameters to run!\n";
   exit(1);
   }

my $fn00 = $ARGV[0]; #the bed file containing the loci, in the ENSEMBL conventions or others
my $fastaFile = $ARGV[1]; # the fasta file for the genome downloaded from ENSEMBL web site, using the primary_assembly file
my $fnOut = $ARGV[2]; #the output file

###### first get the DNA seq from the fasta file
if($fastaFile =~ /^(.+).gz$/ ) {
  open (DOC, "gunzip -c $fastaFile |") or die "can't open pipe to $fastaFile\n";
} else {
  open DOC, $fastaFile or die "Cannot open the file $fastaFile\n";
}

my @chrs;
my %refGseq;
my $numChrs=0;

my $dnaSeq = '';

### ORIGINAL LOOP TO GET CHROMS (USED FOR HSAP)
# my $num=0;
# while(<DOC>) {
#   ++$num;
#   s/[\r\n]+//; #chomp;
#   if(/^>([^ ]+) /) {
#     #print "$num $_\n" ;
#     if($dnaSeq ne '') {
#       $refGseq{$chrs[$numChrs-1]} = $dnaSeq;
#     }
#     $chrs[$numChrs]=$1;
#     ++$numChrs;
#     $dnaSeq = '';
#   } else {
#     $dnaSeq .= $_;
#   }
# }

my $num=0;
while(<DOC>) {
  ++$num;
  s/[\r\n]+//; #chomp;
  if(/^>(\S+)/) { #Use a more general pattern that does not require a space after the >chr1
    #print "$num $_\n" ;
    if($dnaSeq ne '') {
      $refGseq{$chrs[$numChrs-1]} = $dnaSeq;
    }
    $chrs[$numChrs]=$1;
    ++$numChrs;
    $dnaSeq = '';
  } else {
    $dnaSeq .= $_;
  }
}

#the last one
if($dnaSeq ne '') {
  $refGseq{$chrs[$numChrs-1]} = $dnaSeq;
}

close DOC;


## print out the chromosomes and their lengths.
# foreach(keys %refGseq) {
# printf "$_ %d\n", length($refGseq{$_}); 
# }
## print chrom and seq 
# foreach my $chrKey (sort keys %refGseq) {
#     print "Chromosome: $chrKey\n";
#     print "Sequence: $refGseq{$chrKey}\n\n";
# }
# exit;


######now get the loci from the bed file
$num = 0;

open DOC, $fn00 or die "Cannot open the file $!";
my $numLoci = 0;

my @lociChr;
my @lociSt;
my @lociEnd;
my @lociStr;
my @lociNames;
my @bedLines;
while(<DOC>) {
  s/[\r\n]+//; #chomp;
  
  $bedLines[$numLoci] = $_;
  my @terms = split/[\t ]+/;
  
  # foreach my $t (@terms) {
  #   print "$t\n";
  # }

  my $chrNow = $terms[0];
  ### BEFORE
  # $chrNow=$1 if $chrNow =~ /^chr(.+)$/; # make the chromosome name in the ENSEMBL convention.
  # $chrNow='MT' if $chrNow eq 'M';
  #$lociChr[$numLoci] = $chrNow;
  ### NOW
  $lociChr[$numLoci] = $terms[0];
  ###
  $lociSt[$numLoci] = $terms[1]; #don't care about the bed file
  $lociEnd[$numLoci] = $terms[2];
  $lociStr[$numLoci] = $terms[3]; # the strand
  if(scalar @terms >= 5) { # if it's a proper bed file
    $lociNames[$numLoci] = $terms[4]; # get a name
  } else {
    $lociNames[$numLoci] = join('_', @terms); # .'_'.$terms[4];
  }
  ++$numLoci;
  
}
close DOC;
#print "Number of loci in the list is $numLoci.\n";


######get the DNA sequence
open OUTDOC, ">".$fnOut or die "Cannot open the file for output.\n";

###
# foreach my $c (sort keys %refGseq) {
#     print "Found chrom key in refGseq: $c\n";
# }
###

my $seqSel;
for(my $indexPr=0; $indexPr < $numLoci; ++$indexPr) {
  
  # print "Chrom: $lociChr[$indexPr]\n";          # Show which chromosome
  # print "DNA: $refGseq{$lociChr[$indexPr]}\n";  # The actual sequence string
  # print "Start: ", $lociSt[$indexPr] - 1, "\n";
  # print "End:   ", $lociEnd[$indexPr],   "\n";
  # print "Length to extract: ", 
  #       $lociEnd[$indexPr] - $lociSt[$indexPr] + 1, "\n";
  # exit;
  $seqSel = substr($refGseq{$lociChr[$indexPr]}, $lociSt[$indexPr]-1,  $lociEnd[$indexPr]- $lociSt[$indexPr]+1);
  # print "test ",$seqSel,   "\n";
  
  if($lociStr[$indexPr] eq '-') {
    $seqSel = complementDNA($seqSel);
    $seqSel = reverse($seqSel); #do the reverse as well.
  }
  
  print OUTDOC "$bedLines[$indexPr]\t$seqSel\n";
  
  #print "protein $indexPr\n";
  # my $iii=<STDIN>;
}

close OUTDOC;

# print "Finished!\n";

sub complementDNA {
  my $str=$_[0];
  $str =~ s/G/9/g;
  $str =~ s/C/G/g;
  $str =~ s/9/C/g;
  $str =~ s/T/9/g;
  $str =~ s/A/T/g;
  $str =~ s/9/A/g;
  
  $str =~ s/g/9/g;
  $str =~ s/c/g/g;
  $str =~ s/9/c/g;
  $str =~ s/t/9/g;
  $str =~ s/a/t/g;
  $str =~ s/9/a/g;
  
  $str;
}