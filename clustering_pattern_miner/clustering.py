from kmodes.kmodes import KModes
from sys import argv
import pandas as pd
import numpy as np

def pad_vector(transaction:list[str],vector_size:int):
    additional_elems = vector_size - len(transaction)
    return transaction + ([ 'None' ]*additional_elems)

def main():
    if len(argv) != 2:
        raise Exception("Incorrect number of command line arguments")

    df = pd.read_csv(argv[1])

    vector_size = int((df.groupby(['Project', 'File', 'Caller']).agg({'Callee':list}))['Callee'].str.len().max())

    points = list((df.groupby(['Project', 'File', 'Caller']).agg({'Callee':list}))['Callee'])

    points = list(map(
        lambda x: pad_vector(x, vector_size),
        points
    ))

    km = KModes(n_clusters=10, init='Huang', n_init=4)

    clusters = km.fit_predict(np.array(points))
    for cluster in km.cluster_centroids_:
        cluester_funcs = filter(
            lambda x: x!='None',
            cluster
        )
        print(','.join(cluester_funcs))

main()
