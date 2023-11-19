import biolib
import shutil
import time
import argparse
import os


def calc():
    print("Job request start")
    deeptmhmm = biolib.load("DTU/DeepTMHMM")
    biolib.utils.STREAM_STDOUT = True  # Stream progress from app in real time
    deeptmhmm_job = deeptmhmm.cli(args="--fasta pro.fasta")  # Blocks until done
    deeptmhmm_job.save_files("one_result")  # Saves all results to `result` dir


# 相対パスを使用してファイルを削除する場合
relative_path = "path/to/your/file.txt"

# 現在の作業ディレクトリを取得
current_directory = os.getcwd()

# ArgumentParserオブジェクトを作成
parser = argparse.ArgumentParser(description="--input オプションの値を表示するサンプルスクリプト")

# --inputオプションを追加
parser.add_argument("--input", type=str, help="入力ファイル名の指定")

# コマンドライン引数を解析
args = parser.parse_args()

i = 0
sequence = []
with open(args.input, "r") as type2:
    for line in type2:
        if i < 100:
            sequence.append(line)
            i = i + 1
        else:
            with open("pro.fasta", "w") as process:
                for single_line in sequence:
                    process.write(single_line)
            calc()
            with open("one_result/TMRs.gff3", "r") as result:
                # 一行目を除いて読み込む
                content_of_result = result.readlines()[1:]
            with open("all_result.txt", "a") as all_result:
                # 改行を入れて連結し、最後に"//\n"を追加
                all_result.write("\n".join(content_of_result) + "//\n")
            shutil.rmtree(os.path.join(current_directory, "one_result"))
            os.remove(os.path.join(current_directory, "pro.fasta"))
            i = 0
            sequence = []
            time.sleep(15)
