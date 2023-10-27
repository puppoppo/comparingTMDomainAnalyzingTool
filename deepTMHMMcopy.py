import biolib
import shutil
import time


def calc():
    print("Job request start")
    deeptmhmm = biolib.load("DTU/DeepTMHMM")
    biolib.utils.STREAM_STDOUT = True  # Stream progress from app in real time
    deeptmhmm_job = deeptmhmm.cli(args="--fasta pro.fasta")  # Blocks until done
    deeptmhmm_job.save_files("one_result")  # Saves all results to `result` dir


i = 0
sequence = []
with open("newtype2.fasta", "r") as type2:
    for line in type2:
        if i < 40:
            sequence.append(line)
        else:
            with open("pro.fasta", "w") as process:
                for single_line in sequence:
                    process.write(single_line)
            calc()
            with open("one_result/TMRs.gff3", "r") as result:
                content_of_result = result.read()
            with open("all_result.txt", "a") as all_result:
                all_result.write(content_of_result + "\n")
            shutil.rmtree(
                "C:\\Users\\scher\\research\\comparingTMDomainAnalyzingTool\\one_result"
            )
            i = 0
            sequence = []
        i = i + 1
