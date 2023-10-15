
open( SWISS, "type2.dat" );
open( WRITE, ">uniprot_range.txt" );

$,       = ",";
$\       = "\n";
$U       = 0;      #配列にU,Xが含まれているかフラグ化
@all     = (0);
$swissoc = "";

while (<SWISS>) {
    chomp;

    $all[$j] = substr( $_, 0, 1000 );
    $j += 1;

    $readingLine = $_ . " ";

    if ( $readingLine =~ /^ID   / ) {
        $swissID = substr( $readingLine, 5, 12 );
        $swissID =~ s/\s//g;
    }
    elsif ( $readingLine =~ /^DE/ ) {
        if ( $readingLine =~ /Fragment/ ) {
            $frag = 1;
        }
    }
    elsif ( $readingLine =~ /^OC   / ) {
        $swissoc .= substr( $readingLine, 5, 100 );
    }
    elsif ( $readingLine =~ /^CC   -!- SUBCELLULAR LOCATION/ ) {
        $suswitch = 1;
        $swisssu .= substr( $readingLine, 30, 100 );
    }
    elsif ( $readingLine =~ /^CC   -!-|CC   ---/ ) {
        $suswitch = 0;
    }
    elsif ( $readingLine =~ /^CC       / && $suswitch == 1 ) {
        $swisssu .= substr( $readingLine, 9, 100 );
    }
    elsif ( $readingLine =~ /^FT   TRANSMEM/ ) {
        $ftnumber++;
        $ftswitch    = 1;
        $ft_transmem = substr( $readingLine, 21, 100 );
    }
    elsif ( $readingLine =~ /^FT       / && $ftswitch >= 1 && $ftswitch < 3 )
    {    #FT TRANSMEM行の後ろ2行をfteviに格納
        $ftevi .= substr( $_, 21, 100 );
        $ftswitch++;
    }
    elsif ( $readingLine =~ /^     / ) {    #配列にU,Xが含まれているかフラグ化
        if ( $readingLine =~ /U|X/ ) {
            $U = 1;
        }
    }

    elsif ( $readingLine =~ /^\/\// ) {
        @TMRregion = split( /\.\./, $ft_transmem );
        $TMRstart  = int( $TMRregion[0] );
        $TMRend    = int( $TMRregion[1] );
        $TMRregion = (0);

        $fteco_num = &getECOnumber($ftevi);
        printf WRITE ">" . $swissID . "\n";
        printf WRITE "uniprot, "
          . $TMRstart . "-"
          . $TMRend
          . ", eco="
          . $fteco_num . "\n" . "\n";

        $frag        = 0;
        $swissoc     = "";
        $suswitch    = 0;
        $swisssu     = "";
        $U           = 0;
        $ftnumber    = 0;
        $ftswitch    = 0;
        $j           = 0;
        @all         = (0);
        $ftevi       = "";
        $ft_transmem = "";
    }
}

print chr(7);    #終了時に音が鳴ります

#引数の文字列からECO:0000を探して、その先の3桁の数字を返す
sub getECOnumber {
    $ecoPosition = index( $_[0], "ECO:0000", 0 );
    if ( $ecoPosition != -1 ) {
        $eco_string = substr( $_[0], $ecoPosition + 8, 3 );
        $eco_int    = int($eco_string);
        return $eco_int;
    }
    else {
        return -1;
    }
}
