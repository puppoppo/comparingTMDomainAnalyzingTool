import sys
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--input", help="input file name")
parser.add_argument("--output", help="output file name")
args = parser.parse_args()

print(args.input)
print(args.output)

if args.input == None:
    print("use --input to specify input file")
    sys.exit()

if args.output == None:
    print("use --output to specify output file")
    sys.exit()
    
print("end")