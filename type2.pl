
open( SWISS, "uniprot_sprot.dat" );
open( WRITE, ">type2.dat" );

$,   = ",";
$\   = "\n";
$U   = 0;      #配列にU,Xが含まれているかフラグ化
@all = (0);

while (<SWISS>) {
    chomp;

    $all[$j] = substr( $_, 0, 1000 );
    $j += 1;

    if ( $_ =~ /^ID   / ) {
    }
    elsif ( $_ =~ /^DE/ ) {
        if ( $_ =~ /Fragment/ ) {
            $frag = 1;
        }
    }
    elsif ( $_ =~ /^OC   / ) {
        $swissoc .= substr( $_, 5, 100 );
    }

    elsif ( $_ =~ /^CC   -!- SUBCELLULAR LOCATION/ ) {
        $suswitch = 1;
        $swisssu .= substr( $_, 30, 100 );
    }
    elsif ( $_ =~ /^CC   -!-|CC   ---/ ) {
        $suswitch = 0;
    }
    elsif ( $_ =~ /^CC       / && $suswitch == 1 ) {
        $swisssu .= substr( $_, 9, 100 );
    }
    elsif ( $_ =~ /^FT   TRANSMEM/ ) {
        $ftnumber++;
        $ftswitch = 1;
    }
    elsif ( $_ =~ /^FT       / && $ftswitch >= 1 && $ftswitch < 3 )
    {    #FT TRANSMEM行の後ろ2行をfteviに格納
        $ftevi .= substr( $_, 21, 100 );
        $ftswitch++;
    }
    elsif ( $_ =~ /^     / ) {    #配列にU,Xが含まれているかフラグ化
        if ( $_ =~ /U|X/ ) {
            $U = 1;
        }
    }

    elsif ( $_ =~ /^\/\// ) {
        if ( $swissoc =~ /Mammalia/ && $frag == 0 && $ftnumber == 1 && $U == 0 )
        {
            if ( $swisssu =~ /type II |typeII / ) {

                @su = split( /\.|\;/, $swisssu );

                for ( $i = 0 ; $i < @su ; $i++ ) {
                    if ( $su[$i] =~ /Note/ ) {
                        $note = 1;
                    }
                    if ( $note == 0 && $su[$i] =~ /type II |typeII / ) {
                        if    ( $su[$i] =~ /ECO:0000269/ ) { $t2eco = 269; }
                        elsif ( $su[$i] =~ /ECO:0000303/ ) { $t2eco = 303; }
                        elsif ( $su[$i] =~ /ECO:0000305/ ) { $t2eco = 305; }
                        elsif ( $su[$i] =~ /ECO:0000250/ ) { $t2eco = 250; }
                        elsif ( $su[$i] =~ /ECO:0000255/ ) { $t2eco = 255; }
                        elsif ( $su[$i] =~ /ECO:0000256/ ) { $t2eco = 256; }
                        elsif ( $su[$i] =~ /ECO:0000259/ ) { $t2eco = 259; }
                        elsif ( $su[$i] =~ /ECO:0000312/ ) { $t2eco = 312; }
                        elsif ( $su[$i] =~ /ECO:0000313/ ) { $t2eco = 313; }
                        elsif ( $su[$i] =~ /ECO:0000244/ ) { $t2eco = 244; }
                        elsif ( $su[$i] =~ /ECO:0000213/ ) { $t2eco = 213; }
                        else {
                            $t2eco = 1;
                            if    ( $ftevi =~ /ECO:0000269/ ) { $t2eco = 269; }
                            elsif ( $ftevi =~ /ECO:0000303/ ) { $t2eco = 303; }
                            elsif ( $ftevi =~ /ECO:0000305/ ) { $t2eco = 305; }
                            elsif ( $ftevi =~ /ECO:0000250/ ) { $t2eco = 250; }
                            elsif ( $ftevi =~ /ECO:0000255/ ) { $t2eco = 255; }
                            elsif ( $ftevi =~ /ECO:0000256/ ) { $t2eco = 256; }
                            elsif ( $ftevi =~ /ECO:0000259/ ) { $t2eco = 259; }
                            elsif ( $ftevi =~ /ECO:0000312/ ) { $t2eco = 312; }
                            elsif ( $ftevi =~ /ECO:0000313/ ) { $t2eco = 313; }
                            elsif ( $ftevi =~ /ECO:0000244/ ) { $t2eco = 244; }
                            elsif ( $ftevi =~ /ECO:0000213/ ) { $t2eco = 213; }
                        }
                    }
                }

                if ( $t2eco != 1 && $t2eco != 255 ) {
                    for ( $i = 0 ; $i < @all ; $i++ ) {
                        printf WRITE $all[$i] . "\n";
                    }
                }

            }
        }
        $frag     = 0;
        $swissoc  = "";
        $suswitch = 0;
        $swisssu  = "";
        $U        = 0;
        $ftnumber = 0;
        $ftswitch = 0;
        $j        = 0;
        @all      = (0);
    }
}

print chr(7);    #終了時に音が鳴ります
