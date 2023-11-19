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
open( fastaFile, $input_file_path )
  or die "Cannot open input file: $!";
open( WRITE, '>', $output_file_path )
  or die "Cannot open output file: $!";

printf WRITE "aaa.\n";
