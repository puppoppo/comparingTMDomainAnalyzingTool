import requests
import time


def extract_after_first_newline(s):
    # 文字列を改行で分割
    parts = s.split("\n", 1)
    # 2つ以上のパートがある場合、2つ目のパートを返す
    return parts[1] if len(parts) > 1 else ""


def getPhobiusResponse(sequence, count):
    # エンドポイントとヘッダー情報を設定
    firstRequestURL = "https://www.ebi.ac.uk/Tools/services/rest/phobius/run"
    firstRequestHeaders = {
        "Content-Type": "application/x-www-form-urlencoded",
        "Accept": "text/plain",
    }

    # POSTデータを設定
    data = {
        "email": "ryohei.a.watanabe@gmail.com",
        "title": "sequence" + str(count),
        "format": "short",
        "sequence": sequence,
    }

    # POSTリクエストを実行
    response1 = requests.post(firstRequestURL, headers=firstRequestHeaders, data=data)
    if response1.status_code != 200:
        print("\nPost " + str(count) + "th Sequence Failed")
        print("Response Code:", response1.status_code)
        print("Response Body:", response1.text)
        return ""

    print("\nPost " + str(count) + "th Sequence Succeeded")
    print("Response Code:", response1.status_code)
    print("Response Body:", response1.text)

    # エンドポイントとヘッダー情報を設定
    secoundRequestURL = (
        "https://www.ebi.ac.uk/Tools/services/rest/phobius/result/"
        + response1.text
        + "/out"
    )
    secoundRequestHeaders = {"Accept": "text/plain"}

    # GETリクエストを実行
    MAX_RETRIES = 10

    time.sleep(10)
    for i in range(MAX_RETRIES):
        response2 = requests.get(secoundRequestURL, headers=secoundRequestHeaders)

        if response2.status_code == 200:
            print("\nGet " + str(count) + "th Sequence Result Succeeded")
            print("Response Code:", response2.status_code)
            print("Response Body:", response2.text)
            return extract_after_first_newline(response2.text)
        elif response2.status_code != 400:
            return ""
        else:
            print("\nGet " + str(count) + "th Sequence Result Failed")
            print("Response Code:", response2.status_code)
            print("Response Body:", response2.text)
            print("retry:", i)
            time.sleep(30)
    return ""


# ファイルを開く
i = 0
with open("type2.fasta", "r", encoding="utf-8") as fasta:
    for line in fasta:
        readingLine = line.strip()
        if readingLine[0] == ">":
            IDline = readingLine
        if readingLine[0] == "M":
            i = i + 1
            output = getPhobiusResponse(readingLine, i)
            with open("output.txt", "a", encoding="utf-8") as out:
                out.write(IDline + "\n" + output)
