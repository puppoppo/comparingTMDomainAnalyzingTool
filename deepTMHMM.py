import biolib
import shutil
import time


def calc():
    print("Job request start")
    deeptmhmm = biolib.load("DTU/DeepTMHMM")
    biolib.utils.STREAM_STDOUT = True  # Stream progress from app in real time
    deeptmhmm_job = deeptmhmm.cli(args="--fasta pro.fasta")  # Blocks until done
    deeptmhmm_job.save_files("one_result")  # Saves all results to `result` dir


with open("newtype2.fasta", "r") as type2:
    for line in type2:
        if line.startswith(">"):  # シーケンスの名前の行
            sequence_name = line
        else:
            sequence = line
            with open("pro.fasta", "w") as process:
                process.write(sequence_name + sequence)
            calc()
            with open("one_result/TMRs.gff3", "r") as result:
                content_of_result = result.read()
            with open("all_result.txt", "a") as all_result:
                all_result.write(content_of_result + "\n")
            shutil.rmtree(
                "C:\\Users\\scher\\research\\comparingTMDomainAnalyzingTool\\one_result"
            )
            # time.sleep(15)
