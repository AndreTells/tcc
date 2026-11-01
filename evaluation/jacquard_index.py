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
    if (len(sys.argv) != 3):
        print("incorrect ammount of command line arguments")
        exit()

    patterns_1 = set(get_patterns(sys.argv[1]))
    patterns_2 = set(get_patterns(sys.argv[2]))

    m11 = len(patterns_1 & patterns_2)
    m10 = len(patterns_1)
    m01 = len(patterns_2)

    print(m11/(m11+m10+m01))
main()
