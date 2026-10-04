import sys 
from efficient_apriori import apriori

# dictionary with the transactions that will be read from the csv
if (len(sys.argv) != 2):
    print("incorrect ammount of command line arguments")
    exit()

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

itemsets, rules = apriori(data, min_support=0.003)
for i in filter(lambda x: x>1,itemsets):
    for pattern in itemsets[i]:
        print(','.join(pattern))
