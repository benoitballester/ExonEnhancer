#!/usr/bin/perl
use strict;
use warnings;
use Bio::EnsEMBL::Registry;
use Bio::EnsEMBL::ApiVersion; 
use Data::Dumper;
#--------- WARNING -------------------
#  DO NOT FORGET !
#  module load  perl/5.26.2
#--------- How to run ----------------
# cd /shared/home/bballester/2.exons/ensembl_alnmt 
# perl wgaEnsembl.pl human datasets/hg38_exonhancers_candidates.bed 
my $query_species = $ARGV[0]; #human or mouse
my $filename = $ARGV[1]; # datasets/hg38_exonhancers_candidates.bed 
#my $filename = '/shared/home/bballester/2.exons/ensembl_alnmt/datasets/hg38_exonhancers_candidates.bed';
#--------------------------------------

my $verbose = 0; 
my $registry = 'Bio::EnsEMBL::Registry';

$registry->load_registry_from_db(
  -host => 'ensembldb.ensembl.org',
  -user => 'anonymous'
);

printf( "The API version used is %s\n", software_version() ) if $verbose ;

# Get the GenomeDB adaptor
my $genome_db_adaptor = $registry->get_adaptor( 'Multi', 'compara', 'GenomeDB' );

# Fetch GenomeDB objects for human and mouse, and others (just in case, for later)
my $hsap_genome_db = $genome_db_adaptor->fetch_by_name_assembly('homo_sapiens');
my $mmus_genome_db = $genome_db_adaptor->fetch_by_name_assembly('mus_musculus');

# Get the MethodLinkSpeciesSetAdaptor
my $method_link_species_set_adaptor = $registry->get_adaptor( 'Multi', 'compara', 'MethodLinkSpeciesSet');

# Fetch the MethodLinkSpeciesSet object corresponding to LASTZ_NET alignments between human and mouse genomic sequences
my $human_mouse_lastz_net_mlss = $method_link_species_set_adaptor->fetch_by_method_link_type_GenomeDBs( "LASTZ_NET", [$hsap_genome_db, $mmus_genome_db] );

# Get the GenomicAlignBlockAdaptor
my $genomic_align_block_adaptor = $registry->get_adaptor( 'Multi', 'compara', 'GenomicAlignBlock' );
print Dumper $genomic_align_block_adaptor if $verbose ;
# Get the SliceAdaptor and fetch a slice
my $slice_adaptor = $registry->get_adaptor( $query_species, 'core', 'Slice' );


#1 1759733 1759902
# 12  27297720  27297854
# Define the query species and the coordinates of the Slice
#my $query_species = 'human';
#my $seq_region = '12';
#my $seq_region_start = 27297720;
#my $seq_region_end   = 27297854;

#my $seq_region = '14';
#my $seq_region_start = 75002000;
#my $seq_region_end   = 75003000;


open(FH, '<', $filename) or  die "Can't open $filename"; 


while (my $line = <FH>) {
  my $outline;
  my @array = split(" ",$line);


  my $seq_region = substr($array[0], 3);
  my $seq_region_start = $array[1];
  my $seq_region_end   = $array[2];
  my $name = $array[3];

  print join("\t","chr".$seq_region, $seq_region_start, $seq_region_end, $name),"\t" ;

  my $query_slice = $slice_adaptor->fetch_by_region( 'toplevel', $seq_region, $seq_region_start, $seq_region_end );

    print  "\t--$seq_region--\t",$query_slice->start,"\n" if $verbose;


  # Fetch all the GenomicAlignBlocks corresponding to this Slice from the pairwise alignments (LASTZ_NET) between human and mouse
  my @genomic_align_blocks = @{ $genomic_align_block_adaptor->fetch_all_by_MethodLinkSpeciesSet_Slice( $human_mouse_lastz_net_mlss, $query_slice ) };

  # We will then (usually) need to restrict the blocks to the required positions in the reference sequence

  foreach my $genomic_align_block( @genomic_align_blocks ) {
      my $restricted_gab = $genomic_align_block->restrict_between_reference_positions($seq_region_start, $seq_region_end);
      
      # fetch the GenomicAligns and move through
      my @genomic_aligns = @ { $restricted_gab->get_all_GenomicAligns };
      foreach my $genomic_align (@genomic_aligns) {
        my $species = $genomic_align->genome_db->display_name;
        my $slice = $genomic_align->get_Slice;

        if (defined $slice) {
            print $species, "\t", $slice->seq_region_name, ":", $slice->seq_region_start, "-", $slice->seq_region_end, "\t";
        } else {
            warn "WARNING: No slice returned for $species at $seq_region:$seq_region_start-$seq_region_end\n";
        }

      }
      #$outline .=  "\n";
  }

print "\n";

}


close(FH);


__END__

