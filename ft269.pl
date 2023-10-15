
open( SWISS, "type2.dat" );
open( WRITE, ">ft269.dat" );

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
        $ftswitch = 1;
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
        if ( $swissoc =~ /Mammalia/ && $frag == 0 && $ftnumber == 1 && $U == 0 )
        {

            if ( $swisssu =~ /type II/ ) {
                if ( $ftevi =~ /ECO:0000269/ ) { $ft_transmem = 269; }
            }

            if ( $ft_transmem == 269 ) {
                for ( $i = 0 ; $i < @all ; $i++ ) {
                    printf WRITE $all[$i] . "\n";
                }
            }

        }
        $frag        = 0;
        $swissoc     = "";
        $suswitch    = 0;
        $swisssu     = "";
        $U           = 0;
        $ftnumber    = 0;
        $ftswitch    = 0;
        $j           = 0;
        @all         = (0);
        $ft_transmem = 0;
        $ftevi       = "";
    }
}

print chr(7);    #終了時に音が鳴ります
