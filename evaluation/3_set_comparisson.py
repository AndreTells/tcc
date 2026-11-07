import sys

def get_patterns(input_file:str)->list[set[str]]:
    data = []
    with open(input_file) as file:
        for line in file:
            data.append(','.join(sorted(
                line.strip().split(',')
            )))

    return data

def main():
    if (len(sys.argv) != 4):
        print("incorrect ammount of command line arguments")
        exit()

    patterns_1 = set(get_patterns(sys.argv[1]))
    patterns_2 = set(get_patterns(sys.argv[2]))
    patterns_3 = set(get_patterns(sys.argv[3]))

    inter = len(patterns_1 & patterns_2 & patterns_3)
    union = len(patterns_1 | patterns_2 | patterns_3)

    print(inter/union)
main()
