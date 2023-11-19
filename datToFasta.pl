use Getopt::Long;

my $input_file_path;
my $output_file_path;

# オプションの定義
GetOptions(
    'input=s'  => \$input_file_path,     # --input オプションとその値
    'output=s' => \$output_file_path,    # --output オプションとその値
);

# オプションの値を確認
print "Input file path: $input_file_path\n";
print "Output file path: $output_file_path\n";

# ファイルを開く
open( DAT, $input_file_path )
  or die "Cannot open input file: $!";
open( FASTA, ">", $output_file_path )
  or die "Cannot open output file: $!";

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
