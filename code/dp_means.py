
import cPickle as pickle
import numpy as np
from clusters import Cluster
from collections import defaultdict
import operator
from copy import deepcopy

class DP_means:

    def __init__(self, data, lamb, epsilon=.01):
        self.lamb = lamb
	self.epsilon = epsilon
	self.clusters = Cluster()
	self.notConverged = True
	self.iterations = 0


    def init_dp_means(self, data):
	mean_sum = 0
	N = 0
	for x, count in data.iteritems():
	    mean_sum += x*count
	    N += count
	m1 = float(mean_sum)/N

	self.clusters.c = 1
	self.clusters.assignments[m1] = data.keys()

	for x in data.keys():
	    self.clusters.map[x] = m1

    def dp_means(self, data):

	batch = 0

	while self.notConverged:	
	    #self.iterations += 1	
	    batch += 1 
	    print 'BATCH NUMBER', batch
	    print 'ITERATION NUMBER', self.iterations
	    print 'CLUSTERS: ', self.clusters.c
	    old_clusters = deepcopy(self.clusters)
	    print 'old cluster means: ', old_clusters.assignments.keys()

	    #x_dict = dict()
	    for x in sorted(data.keys()):
		self.iterations +=1
		print 'x NUMBER', self.iterations
		print 'x', x
		print 'c', self.clusters.c
		d = dict()

		print 'cluster means', self.clusters.assignments.keys()
		for cluster_mean in self.clusters.assignments.keys():
		    d[cluster_mean] = np.power((x - cluster_mean),2) #squared difference between x and cluster mean
		min_d = min(d.values())
		new_cluster = min(d, key=d.get)  #get cluster mean with minimum distance from x
		print 'min_d', min_d

		if min_d > self.lamb: #make new cluster if distance is above threshold
		    print 'new cluster', x
		    self.clusters.c += 1
		    self.clusters.assignments[x] = [x]
		    self.clusters.map[x] = x

		else: #assign to nearest existing cluster
		    if (x - self.clusters.map[x])**2 > min_d:
			self.reassign_cluster(x, new_cluster)
		    #self.assign_cluster(x, new_cluster, self.clusters)


		self.update(data)
	    print old_clusters.assignments.keys()
	    print self.clusters.assignments.keys()
	    self.notConverged = self.check_convergence(old_clusters)
	    print self.notConverged
	print 'DONE CLUSTERING'
	print self.clusters.assignments.keys()

    def check_convergence(self, old_clusters):
        if old_clusters.c != self.clusters.c:
            return True 

        else:
            diff = np.absolute(np.subtract(self.clusters.assignments.keys(), old_clusters.assignments.keys()))
	    print diff
            for elem in diff:
                if elem > self.epsilon: 
                    return True
            return False

    def reassign_cluster(self, x, new_cluster):
	#print clusters.map
        # find and remove old assignment
        prev_cluster = self.clusters.map[x]
        self.clusters.assignments[prev_cluster].remove(x)
        # assign to new cluster
        self.clusters.map[x] = new_cluster
        self.clusters.assignments[new_cluster].append(x)

    def update(self, data):
	clusters = deepcopy(self.clusters)
	# Update cluster means, assignments, maps
	for cluster_mean, cluster_list in clusters.assignments.iteritems():
	    if cluster_list == []:
		del self.clusters.assignments[cluster_mean]
	    else:
		# calculate new cluster means
		sum = 0
		N = 0
		for x in cluster_list:
		    sum += x*data[x]
		    N += data[x]
		new_mean = sum/float(N)
		#update assignment map
		for x in cluster_list:
		    self.clusters.map[x] = new_mean
		# update cluster means and assignments
		self.clusters.assignments[new_mean] = self.clusters.assignments.pop(cluster_mean) # update cluster mean

	# Update c, the number of clusters
        self.clusters.c = len(clusters.assignments.keys())

if __name__ == '__main__':
    lamb = 50000
    epsilon = .1
    data = pickle.load(open('/Users/LJ/MSOR/NeuralStat/FinalProj/data/e2_freqs.p'))
    dp_clusters = DP_means(data, lamb, epsilon)
    dp_clusters.init_dp_means(data)
    dp_clusters.dp_means(data)

