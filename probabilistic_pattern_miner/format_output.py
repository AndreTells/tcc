from dataclasses import dataclass
from sys import argv

@dataclass
class Pattern:
    prob: float
    pattern: list[str]

def patterns(file_name:str):
    with open(file_name,'r') as file:

        while(True):
            prob_txt = file.readline().strip()
            if(prob_txt == ""):
                break

            patt_txt = file.readline().strip()
            _ = file.readline() # skip line

            if prob_txt[:5] != 'prob:':
                raise Exception(f"Unexpected label in line: {prob_txt}")

            if(patt_txt[0] != '[' or patt_txt[-1] != ']'):
                raise Exception(f"Unexpected format in line: {patt_txt}")


            yield Pattern(
                float(prob_txt[5:].strip()),
                list(map(
                    lambda x: x.strip(),
                    patt_txt[1:-1].split(',')
                ))
            )

def main():
    if(len(argv) != 2):
        raise Exception("Incorrect number of command line arguments")

    for pat in patterns(argv[1]):
        print(','.join(pat.pattern))
main()
