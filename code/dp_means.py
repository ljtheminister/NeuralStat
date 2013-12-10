import pandas as pd
import numpy as np
from clusters import Clusters
from collections import defaultdict
import operator

class DP_means(self):

    def __init__(self, freq, lamb, epsilon=.01):
        self.lamb = lamb
        self.clusters = dp_means(freq,lamb, epsilon)
	self.epsilon = epsilon
	
    def __dp_means(self, freq, lamb, epsilon):
	## INITIALIZATION
        clusters = Clusters()
        m1 = sum([x*freq[x] for x in freq.keys()])/float(len(freq.keys()))  
        clusters.c = 1
        clusters.assignments[m1] = []
	clusters.map = []

	notConverged = True
	while notConverged:	
	    old_clusters = clusters

	    for x in freq.keys():
		d = dict()

		for cluster_mean in clusters.assignments.keys():
                    d[cluster_mean] = np.power((x - cluster_mean),2) #squared difference between x and cluster mean
                    min_d = min(d.values())
                    new_cluster = min(d, key=d.get)  #get cluster mean with minimum distance from x

                    if min_d - theta > lamb - np.log(clusters.c)*theta: #make new cluster
			clusters.c += 1
			clusters.assignments[x] = [x]

                    else: #assign to nearest existing cluster
                        clusters = assign_cluster(x, new_cluster, clusters)

	    notConverged = check_converge(old_clusters, clusters, self.epsilon)

    def __check_convergence(self, old_clusters, new_clusters, epsilon):

        if old_clusters.c != new_clusters.c:
            return False

        else:
            diff = np.subtract(new_clusters.assignments.keys(), old_clusters.assignments.keys())
            for elem in diff:
                if elem > epsilon: 
                    return False
            return True
