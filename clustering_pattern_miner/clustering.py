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

    k = 80
    model = KModes(n_clusters=k, init='Huang', n_init=100)
    model.fit_predict(np.array(points))
    prev_cost = model.cost_

    while True:
        k= k+1
        model_ = KModes(n_clusters=k, init='Huang', n_init=100)
        model_.fit_predict(np.array(points))
        new_cost = model_.cost_

        if( new_cost > prev_cost * 0.9999):
            break

        model = model_
        prev_cost = new_cost


    for cluster in model.cluster_centroids_:
        cluester_funcs = filter(
            lambda x: x!='None',
            cluster
        )
        print(','.join(cluester_funcs))
