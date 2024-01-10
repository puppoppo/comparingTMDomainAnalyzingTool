use Getopt::Long;

my $input_file_path;
my $output_file_path;

# オプションの定義
GetOptions(
    'input=s'  => \$input_file_path,     # --input オプションとその値
    'output=s' => \$output_file_path,    # --output オプションとその値
);

open( SWISS, $input_file_path )
  or die "Cannot open input file: $!";
open( WRITE, '>', $output_file_path )
  or die "Cannot open output file: $!";

$,   = ",";
$\   = "\n";
$U   = 0;      #配列にU,Xが含まれているかフラグ化
@all = (0);

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

                @su = split( /\.|\;/, $swisssu );

                for ( $i = 0 ; $i < @su ; $i++ ) {
                    if ( $su[$i] =~ /Note/ ) {
                        $note = 1;
                    }
                    if ( $note == 0 && $su[$i] =~ /type II/ ) {
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
