import pandas as pd
import cPickle as pickle
import numpy as np
from clusters import Cluster
from collections import defaultdict
import operator

class DP_means:

    def __init__(self, freq, lamb, epsilon=.01):
        self.lamb = lamb
	self.epsilon = epsilon
	self.clusters = Cluster()

    def dp_means(self, clusters, freq, lamb, epsilon):
	m1 = sum([x*freq[x] for x in freq.keys()])/float(sum(freq.keys()))  
	clusters.c = 1
	clusters.assignments[m1] = []
	clusters.map = []

	notConverged = True
	while notConverged:	
	    old_clusters = clusters

	    #x_dict = dict()
	    for x in freq.keys():
		d = dict()
		for cluster_mean in clusters.assignments.keys():
		    d[cluster_mean] = np.power((x - cluster_mean),2) #squared difference between x and cluster mean
		    min_d = min(d.values())
		    new_cluster = min(d, key=d.get)  #get cluster mean with minimum distance from x
	    #x_dict[x] = min_d

                    if min_d > lamb: #make new cluster if distance is above threshold
			clusters.c += 1
			clusters.assignments[x] = [x]
			clusters.map[x] = x

                    else: #assign to nearest existing cluster
			self.clusters = self.assign_cluster(x, new_cluster, clusters)
			#self.assign_cluster(x, new_cluster, self.clusters)

	    clusters = self.update(clusters, freq)
	    notConverged = self.check_converge(old_clusters, clusters, self.epsilon)

	self.clusters = clusters

    def check_convergence(self, old_clusters, new_clusters, epsilon):
        if old_clusters.c != new_clusters.c:
            return False

        else:
            diff = np.subtract(new_clusters.assignments.keys(), old_clusters.assignments.keys())
            for elem in diff:
                if elem > epsilon: 
                    return False
            return True

    def assign_cluster(self, x, new_cluster, clusters):
        # find and remove old assignment
        prev_cluster = clusters.map(x)
        clusters.assignments[prev_cluster].remove(x)
        # assign to new cluster
        clusters.map[x] = new_cluster
        clusters.assignments[new_cluster].append(x)
	return clusters

    def update(self, clusters, freq):
        # Update c, the number of clusters
        clusters.c = len(clusters.assignments.keys())

        # Update cluster Means
        for cluster_mean, cluster_list in clusters.assignments.iteritems():
            new_mean = sum([x*freq[x] for x in cluster_list])/len(cluster_list) # calculate new cluster mean
            clusters.assignments[new_mean] = clusters.assignments.pop(cluster_mean) # update cluster mean

        return clusters



if __name__ == '__main__':
    lamb = 1000
    epsilon = .1
    data = pickle.load(open('/Users/LJ/MSOR/NeuralStat/FinalProj/data/e2_freqs.p'))
    dp_clusters = DP_means(data, lamb, epsilon)
    dp_clusters.dp_means(data, lamb, epsilon)

