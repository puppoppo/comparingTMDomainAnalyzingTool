
open( DAT,   "ft269.dat" );
open( FASTA, ">ft269.fasta" );

$, = ",";
$\ = "\n";

while (<DAT>) {
    chomp;

    $readingLine = $_ . " ";

    if ( $readingLine =~ /^ID   / ) {
        $swissID = substr( $readingLine, 5, 12 );
        $swissID =~ s/\s//g;
    }
    elsif ( $readingLine =~ /^     / ) {    #配列にU,Xが含まれているかフラグ化
        $sequence .= substr( $_, 5, 100 );
        $sequence =~ s/\s//g;
    }

    elsif ( $readingLine =~ /^\/\// ) {
        printf FASTA ">" . $swissID . "\n";
        printf FASTA $sequence . "\n";
        $swissID  = "";
        $sequence = "";
    }
}

print chr(7);    #終了時に音が鳴ります
