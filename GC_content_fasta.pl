#!/usr/bin/perl -w
use strict;
use Data::Dumper;
die "Usage: perl $0 </whole_path/fasta_file> </whole_path/GC_content_file> \n" unless (@ARGV == 2);

my %GC_content; # id=>GC_content
my %sequences; # id=>sequence
my %WS;
my ($id, $sum); # id, base number
my @num;
open(FASTA,"<",$ARGV[0]);
while(<FASTA>){
	chomp;
	#print $_,"\n";
	my $seq = $_;
	if($seq =~ m/^>(\S+)/){
		$id = $1;
		next;
	}

	@num = ($seq =~ m/(G|C)/g);
	$GC_content{$id} += @num;
	$WS{"GC"} += @num;

	@num = ($seq =~ m/(A|T|G|C)/g);
	$sequences{$id} += @num; 
	$WS{"ATCG"} += @num;
}
close FASTA;

foreach (keys %GC_content){
  		$GC_content{$_} /= $sequences{$_};
}
#print Dumper(\%GC_content),"\n";


 open(GC_C,">",$ARGV[1]);
 select GC_C;

 foreach (1..22,"X","Y","M"){
 #foreach (1..4){

 		printf "%s\t%.3f%%\n", "chr".$_, $GC_content{"chr".$_}*100;
 }
printf "%s\t%.3f%%\n", "Total",$WS{"GC"} / $WS{"ATCG"} *100;
 close GC_C;
