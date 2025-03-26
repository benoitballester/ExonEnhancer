#!/usr/bin/perl
use strict;
use warnings;
use Bio::EnsEMBL::Registry;
use Bio::EnsEMBL::ApiVersion; 
use Data::Dumper;

my $registry = 'Bio::EnsEMBL::Registry';

$registry->load_registry_from_db(
  -host => 'ensembldb.ensembl.org',
  -user => 'anonymous'
  #-verbose => '1'
);

printf( "The API version used is %s\n", software_version() );

my $query_species = 'human';

# Get the GenomeDB adaptor
my $genome_db_adaptor = $registry->get_adaptor( 'Multi', 'compara', 'GenomeDB' );

# Fetch GenomeDB objects for human and mouse, and others (just in case)
my $hsap_genome_db = $genome_db_adaptor->fetch_by_name_assembly('homo_sapiens');
my $mmul_genome_db = $genome_db_adaptor->fetch_by_name_assembly('macaca_mulata');
my $mmus_genome_db = $genome_db_adaptor->fetch_by_name_assembly('mus_musculus');
my $rnor_genome_db = $genome_db_adaptor->fetch_by_name_assembly('rattus_norvegicus');
my $cfam_genome_db = $genome_db_adaptor->fetch_by_name_assembly('canis_familiaris');

# Get the MethodLinkSpeciesSetAdaptor
my $method_link_species_set_adaptor = $registry->get_adaptor( 'Multi', 'compara', 'MethodLinkSpeciesSet');

# Fetch the MethodLinkSpeciesSet object corresponding to LASTZ_NET alignments between human and mouse genomic sequences
#my $human_mouse_lastz_net_mlss = $method_link_species_set_adaptor->fetch_by_method_link_type_GenomeDBs( "LASTZ_NET", [$hsap_genome_db, $mmus_genome_db] );
my $epo_mammals_mlss = $method_link_species_set_adaptor->fetch_by_method_link_type_species_set_name("EPO", "mammals");

# Get the GenomicAlignBlockAdaptor
my $genomic_align_block_adaptor = $registry->get_adaptor( 'Multi', 'compara', 'GenomicAlignBlock' );

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

#my $filename = '/shared/home/bballester/2.exons/ensembl_alnmt/datasets/hg38_exonhancers_candidates.bed';
my $filename = 'test.bed';
#my $filename = $ARGV[0];

open(FH, '<', $filename) or  die "Can't open $filename"; 

#-- Used to print only the species in the alignments. 
my %specie_hash = ( "Gsap" => 1,
                    "Mmus" => 1,
                    "Mmul" => 1,
                    "Rnor" => 1,
                    "Cfam" => 1);



while (my $line = <FH>) {
  my $outline;
  my @array = split("\t",$line);


  my $seq_region = substr($array[0], 3);
  my $seq_region_start = $array[1];
  my $seq_region_end   = $array[2];
  my $name = $array[3];

  print join("\t",$array[0], $seq_region_start, $seq_region_end, $name),"\t";

  my $query_slice = $slice_adaptor->fetch_by_region( 'toplevel', $seq_region, $seq_region_start, $seq_region_end );

  # Fetch all the GenomicAlignBlocks corresponding to this Slice from the pairwise alignments (LASTZ_NET) between human and mouse
  #my @genomic_align_blocks = @{ $genomic_align_block_adaptor->fetch_all_by_MethodLinkSpeciesSet_Slice( $human_mouse_lastz_net_mlss, $query_slice ) };
  my @genomic_align_blocks = @{ $genomic_align_block_adaptor->fetch_all_by_MethodLinkSpeciesSet_Slice( $epo_mammals_mlss, $query_slice ) };




  # We will then (usually) need to restrict the blocks to the required positions in the reference sequence

  foreach my $genomic_align_block( @genomic_align_blocks ) {
      my $restricted_gab = $genomic_align_block->restrict_between_reference_positions($seq_region_start, $seq_region_end);
      
      # fetch the GenomicAligns and move through
      my @genomic_aligns = @ { $restricted_gab->get_all_GenomicAligns };
      foreach my $genomic_align (@genomic_aligns) {
         if ( $specie_hash{$genomic_align->genome_db->get_short_name} ){
                my $species = $genomic_align->genome_db->display_name;
                print Dumper $genomic_align->get_Slice;
                my $slice = $genomic_align->get_Slice;
                print $species, "\t", $slice->seq_region_name, ":", $slice->seq_region_start, "-", $slice->seq_region_end, "\t";
              } else {
        next;
      }
      #$outline .=  "\n";
      } 
  }

print "\n";

}


close(FH);


__END__





