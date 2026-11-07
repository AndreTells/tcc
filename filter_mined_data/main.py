from sys import argv
import pandas as pd

def main():
    if len(argv) != 3:
        raise Exception("Incorrect number of command line arguments provided")

    df = pd.read_csv(argv[1])
    gdf = df.groupby(['Project', 'File', 'Caller'])
    filtered_gdf = gdf.filter(lambda x: x['Callee'].count() > 1)
    filtered_gdf.to_csv(argv[2], index=False)

main()
