import cPickle as pickle
import numpy as np
from dp_means import DP_means

def load_data(proj_dir='/Users/LJ/MSOR/NeuralStat/FinalProj/data/', f='e2_freqs.p'):
    return pickle.load(open(proj_dir + f, 'rb'))

data = load_data()
lamb = 1e3
epsilon = .1

dp_clusters = DP_means(data, lamb, epsilon)
dp_clusters.dp_means(data, lamb, epsilon)



def dp_clustering(data, lamb=1, epsilon=.1):
    dp_clusters = DP_means(data, lamb, epsilon)
    dp_clusters.dp_means(data, lamb, epsilon)









