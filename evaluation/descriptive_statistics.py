from typing import Iterable
from functools import reduce
import numpy as np
import sys 

def get_data(input_file:str)->list[set[str]]:
    data = []
    curr_key = None
    curr_set = []
    input_file = sys.argv[1]
    with open(input_file) as f:
        f.readline() # skip header line
        for line in f:
            elements = line.split(',')
            key = elements[0:3]
            if(curr_key == None):
                curr_key = key

            elif(key != curr_key):
                curr_key = key
                data.append(set(curr_set))
                curr_set = []
            curr_set.append(elements[-1].strip())

        data.append(set(curr_set))

    return data

def get_patterns(input_file:str)->list[set[str]]:
    data = []
    with open(input_file) as file:
        for line in file:
            data.append(set(
                line.strip().split(',')
            ))

    return data

def calculate_pattern_usage(data:list[set[str]], pattern: set[str])->float:
    data_len = len(data)
    usage = 0
    for point in data:
        if (pattern & point) ==  pattern: 
            usage +=1
    return usage / data_len

def count_elem(acc:dict[str,int], pattern:set[str]):
    for func in pattern:
        if func not in acc:
            acc[func] = 0

        acc[func]+=1
    return acc

def pattern_str(pattern:Iterable[str]):
    return f"({ ','.join(pattern) })"
    

def main():
    if (len(sys.argv) != 4):
        print("incorrect ammount of command line arguments")
        exit()

    data_file = sys.argv[1]
    data = get_data(data_file)
    pattern_file = sys.argv[2]
    patterns = get_patterns(pattern_file)

    usages = list(map(
        lambda x: (x, calculate_pattern_usage(data, x)),
        patterns
    ))
    usages_num = list(map(
        lambda x: x[1],
        usages 
    ))

    patterns_usage_ord = sorted(
        usages,
        key=lambda x: x[1],
        reverse=True
    )

    sizes = list(map(
        len,
        patterns
    ))

    num_elements = reduce(
        count_elem ,
        patterns,
        {}
    )
    popular_elem = max(num_elements.keys() ,key=lambda x: num_elements[x])

    print(
        sys.argv[3],
        patterns_usage_ord[0][1],
        pattern_str(patterns_usage_ord[0][0]),
        patterns_usage_ord[-1][1],
        pattern_str(patterns_usage_ord[-1][0]),
        patterns_usage_ord[len(patterns_usage_ord)//2][1],
        pattern_str(patterns_usage_ord[len(patterns_usage_ord)//2][0]),
        np.std(usages_num),
        max(sizes),
        min(sizes),
        np.mean(sizes),
        np.std(sizes),
        popular_elem,
        len(patterns),
        sep=','
    )

main()


"""
- common element mode
- max / min representation %
- average representation %
- std of representation %
- max / min size of patterns
- average size of patterns
- std of size of patterns
"""
