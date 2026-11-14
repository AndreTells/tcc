from dataclasses import dataclass
from typing import Iterable
from functools import reduce
import numpy as np
import sys 

def calculate_pattern_usage(data:list[set[str]], pattern: set[str])->float:
    data_len = len(data)
    usage = 0
    for point in data:
        if (pattern & point) ==  pattern: 
            usage +=1
    return usage / data_len

@dataclass
class Pattern:
    pattern:set[str]
    pattern_len: int
    pattern_sup: float
    def __init__(self, pattern, dataset):
        self.pattern = pattern
        self.pattern_len = len(pattern)
        self.pattern_sup =  calculate_pattern_usage(dataset, pattern)

    def __str__(self):
        return f"({ ','.join(self.pattern) })"

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

def count_elem(acc:dict[str,int], pattern:Pattern):
    for func in pattern.pattern:
        if func not in acc:
            acc[func] = 0

        acc[func]+=1
    return acc

def main():
    if (len(sys.argv) != 4):
        print("incorrect ammount of command line arguments")
        exit()

    data_file = sys.argv[1]
    data = get_data(data_file)
    pattern_file = sys.argv[2]
    patterns_str = get_patterns(pattern_file)

    patterns = list(map(
        lambda x: Pattern(x,data),
        patterns_str 
    ))

    num_patterns = len(patterns)

    patterns_sup = list(map(
        lambda x: x.pattern_sup,
        patterns
    ))

    std_sup =  np.std(patterns_sup)
    avg_sup =  np.mean(patterns_sup)

    patterns_sup_ord = sorted(
        patterns,
        key=lambda x: x.pattern_sup,
        reverse=True
    )

    patterns_size = list(map(
        lambda x: x.pattern_len,
        patterns
    ))

    std_size = np.std(patterns_size)
    avg_size = np.mean(patterns_size)

    patterns_size_ord = sorted(
        patterns,
        key=lambda x: x.pattern_len,
        reverse=True
    )


    num_elements = reduce(
        count_elem ,
        patterns,
        {}
    )
    popular_elem = max(num_elements.keys() ,key=lambda x: num_elements[x])

    print(
        f'method:                   {sys.argv[3]}',
        f'max pattern support:      {patterns_sup_ord[0].pattern_sup}',
        f'max supported pattern:    {patterns_sup_ord[0]}',
        f'min pattern support:      {patterns_sup_ord[-1].pattern_sup}',
        f'min supported pattern:    {patterns_sup_ord[-1]}',
        f'median pattern support:   {patterns_sup_ord[num_patterns//2].pattern_sup}',
        f'median supported pattern: {patterns_sup_ord[num_patterns//2]}',
        f'std pattern support:      {std_sup}',
        f'avg pattern support:      {avg_sup}',
        f'max pattern size:         {patterns_size_ord[0].pattern_len}',
        f'max size pattern:         {patterns_size_ord[0]}',
        f'med pattern size:         {patterns_size_ord[num_patterns//2].pattern_len}',
        f'med size pattern:         {patterns_size_ord[num_patterns//2]}',
        f'min pattern size:         {patterns_size_ord[-1].pattern_len}',
        f'min size pattern:         {patterns_size_ord[-1]}',
        f'avg pattern size:         {avg_size}',
        f'std pattern size:         {std_size}',
        f'most popular elem:        {popular_elem}',
        f'num patterns              {num_patterns}',
        sep='\n'
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
