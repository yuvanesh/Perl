use strict;
use warnings;
use LWP 5.64;
my $browser = LWP::UserAgent->new;
open('file', 'stks.txt');
open my $fh, '>', 'Chumma.csv';
my @csv = <file>;
my @company;
sub conv {
        my $str = shift;
        my $len = 20 - length($str);
        if($len > 0) {
                for(my $i = 0; $i < $len; $i++) {
                        $str .= ' ';
                }
        }
        return $str;
}
foreach my $csv(@csv) {
        if(length($csv) > 2) {
                chomp($csv);
                my $url = 'http://money.rediff.com/snsproxy.php?type=all&prefix='.$csv;
#               my $url = 'http://money.rediff.com/money1/currentstatus.php?companycode=12140006';
#               my $url = 'http://money.rediff.com/quotes/all/'.$csv;
                my $response = $browser->get( $url );
                my ($lwp,$code) = 'unini';
                if( $response->content =~ /Suggestionr\.show\("(.*?)###/) {
                        $code = $1;
                }
                $url = 'http://money.rediff.com/money1/currentstatus.php?companycode='.$code;
                $response = $browser->get( $url );
                if( $response->content =~ /LastTradedPrice":"(.*?)","Volume/) {
                        $lwp = $1;
                }
                print $fh $response->content;
                $csv = conv($csv);
                print "$csv\t$lwp\n";
        }
        else {
                print "\n";
        }
}
