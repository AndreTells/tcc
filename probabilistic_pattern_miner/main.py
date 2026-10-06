import sys

if(len(sys.argv) != 2):
    print("incorrect number of command line arguments\n")
    exit()

input_file=sys.argv[1]

curr_key = None
curr_set = []
with open(input_file) as f:
    f.readline() # skip header line

    for line in f:
        elements = line.split(',')
        key = '.'.join(elements[0:3])
        if(curr_key == None):
            curr_key = key

        elif(key != curr_key):
            print(f"'{curr_key}','{' '.join(curr_set)}'")
            curr_key = key
            curr_set = []
        curr_set.append(elements[-1].strip())
