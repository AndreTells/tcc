import sys
import pandas as pd 
import numpy as np

if(len(sys.argv) != 2):
    raise RuntimeError("Incorrect number of cli arguments")

df = pd.read_csv(sys.argv[1])
num_projs = df["Project"].nunique()
num_files = (df["Project"]+ df["File"]).nunique()
num_callers = (df["Project"]+df["File"]+df["Caller"]).nunique()
num_callees = len(df)
print(f'Number of Projects used {num_projs}')
print(f'Number of Files used {num_files}')
print(f'Number of Calleers used {num_callers}')
print(f'Average number of Callers per file {num_callers/num_files}')
print(f'Average number of Callees per Caller {num_callees/num_callers}')
