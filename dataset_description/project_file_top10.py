import sys
import pandas as pd
import seaborn as sns

if(len(sys.argv) != 3):
    raise RuntimeError("Incorrect number of cli arguments")

df = pd.read_csv(sys.argv[1])
df_num_files = df[["Project","File"]].groupby("Project").nunique()
largest_projs = df_num_files.nlargest(10,"File")
ax = sns.barplot(data=largest_projs,x=largest_projs.index, y='File')
ax.set_xticklabels([])
ax.figure.savefig(sys.argv[2])
