#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use JSON qw(decode_json); # apt-get install libjson-perl, or cpan JSON
use Encode qw /from_to decode_utf8 encode encode_utf8/;
binmode(STDOUT, ":utf8");

my $fh;

print STDERR  "\tArgument 1: path to file to process.\n\tArgument 2: Cyrillic flag (any char).\n\tWithout arguments, demo-mode:\n\tbuilt-in text is transcripted in Latin-based alphabet.\n";
# print STDERR '*', "\n";

if ($ARGV[0]){
	if (-e $ARGV[0]) {
		open $fh, '<:encoding(UTF-8)', $ARGV[0];
		print STDERR  'Processing: '.$ARGV[0]."\n";
	} else {
		print STDERR  'File '.$ARGV[0]." doesn't exist!\n";
	}
}
unless ($fh) {
	print STDERR "Processing built-in text\n";
	open $fh, "<&DATA"  or  die "Can't get : $!\n" 
}

my $cyr = !!$ARGV[1] || 0;

my $data; {
 open(my $fh, '<:encoding(UTF-8)', 'swh-abc.json')   or die "Could not load transcription rules -> $!";
 local $/ = undef; $data = <$fh>; close $fh; # slurp
}

my %letters = %{decode_json(encode_utf8($data))};
my $abc = quotemeta(join ('', keys %letters)); # accurately convert Swahili alphabet to regular expression


while (my $l = <$fh>) {
	chomp $l;
	$l =~ s/^\s+//;
	my @a;
	foreach my $token (split(/\s+/, $l)){
		
		if ($token !~ m/^[\W\d$abc]+$/i){ # everything that is not Swahili alphabet
			$token = '■'.$token; # mark it in text
		} elsif ($token =~ /c(?!h)/i) { # 'c' not followed by 'h'
			$token = '■'.$token; # mark it in text
		} else {
			foreach my $char(sort {length $b <=> length $a} keys %letters) { 
				# sort - at first translate digraphs, then simple letters
				my $repl = $letters{$char}[$cyr];
				$token =~ s/$char/$repl/g;
				my $charU = ucfirst($char);
				my $replU = ucfirst($repl);
				$token =~ s/$charU/$replU/g;		
			}
		}
		push @a, $token;
	}
	my $n = join (' ', @a); # reconstructing the line
	$n =~ s/[йь]а/я/g;
	$n =~ s/[йь]у/ю/g;
	$n =~ s/[йь]о/ё/g;
	$n =~ s/[йь]э/е/g;
	$n =~ s/[йь]а/я/g;
	$n =~ s/ьи/и/g;
	print $n."\n" if $n =~ m/\w/;
}
close $fh;
print STDERR "Done!\n";
__DATA__
Kiswahili
Kiswahili ni lugha ya Kibantu yenye misamiati mingi ya Kiarabu (30%), lakini sasa ya Kiingereza pia (10%), inayozungumzwa katika eneo kubwa la Afrika ya Mashariki.
Lugha hii ina utajiri mkubwa wa misamiati, misemo, methali, mashairi, mafumbo, vitendawili na nyimbo. Kiswahili hutumika kufundishia shuleni na kuna vitabu vingi vilivyotungwa kwa kutumia lugha hiyo, vikiwa pamoja na vile vya hadithi, hekaya au riwaya.
Kwa karne nyingi iliandikwa kwa herufi za Kiarabu (سواحلي sawaHili au لغة سواحيلية lugha sawaHiliya).