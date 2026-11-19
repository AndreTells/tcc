import sys
import pandas as pd
import seaborn as sns

if(len(sys.argv) != 3):
    raise RuntimeError("Incorrect number of cli arguments")

df = pd.read_csv(sys.argv[1])
df_num_files = df[["Project","File"]].groupby("Project").nunique()
ax = sns.displot(data=df_num_files,x='File')
ax.figure.savefig(sys.argv[2])
