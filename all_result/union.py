def read_file(file_path):
    result_dict = {}
    with open(file_path, "r") as file:
        for line in file:
            line = line.strip()
            if line.startswith(">"):
                key = line[1:]
                result_dict[key] = {}
            else:
                parts = line.split(", ")
                result_dict[key][parts[0]] = ", ".join(parts[1:])
    return result_dict


def merge_dicts(dict1, dict2, dict3):
    result_dict = {}
    for key in dict1.keys():
        result_dict[key] = {
            "uniprot": dict1[key].get("uniprot", ""),
            "start": f"pos={dict2[key].get('pos', '')},score={dict2[key].get('score', '')}",
            "end": f"pos={dict3[key].get('pos', '')},score={dict3[key].get('score', '')}",
        }
    return result_dict


# ファイルの読み込み
uniprot_dict = read_file("TMD_uniprot.txt")
start_dict = read_file("TMD_ori_start.txt")
end_dict = read_file("TMD_ori_end.txt")

# 辞書の結合
result_dict = merge_dicts(uniprot_dict, start_dict, end_dict)

# 結果の出力
for key, value in result_dict.items():
    print(f"{key}: {value}")
