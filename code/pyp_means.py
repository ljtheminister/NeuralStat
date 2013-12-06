import pandas as pd
import numpy as np
from clusters import Clusters
from collections import defaultdict

class Pyp_means(self):


    def __init__(self, freq, lamb, theta):
	self.freq = freq 
	self.lamb = lamb
	self.theta = theta

	self.clusters = pyp_means(self.freq, self.lamb, self.theta)


    def pyp_means(freq, lamb, theta):
	
	## INITIALIZATION
	N = len(values)
	m1 = np.dot(values, counts)/float(N)

	clusters = Clusters()
	clusters.assignments[m1] = []
	clusters.c = 1
	clusters.map = []

	D_r = []
	
	## NEED WHILE LOOP IN CONVERGENCE
	# main for loop
	for x in freq.keys():
	    d = dict()

	    for cluster_mean in clusters.assignments.keys():
		d[cluster_mean] = np.power((x - cluster_mean),2) #squared difference between x and cluster mean
		min_d = min(d)
		new_cluster = min(d, key=d.get)  #get cluster mean with minimum distance from x

		if min_d - theta > lamb - np.log(clusters.c)*theta:
		    D_r.append((idx, x)) 

		else:
		    clusters = assign_cluster(x, new_cluster, clusters)

	    clusters = re_cluster(D_r, clusters, freq, lamb, theta) #re-cluster the unclustered data set
	    clusters = center_agglomeration(clusters, lamb, theta) #center agglomeration
	    clusters = update(clusters, freq) #update c, re-compute cluster means

	return clusters


    def assign_clusters(x, new_cluster, clusters):

	# find and remove old assignment
	prev_cluster = clusters.map(x)
	clusters.assignments[prev_cluster].remove(x)
	# assign to new cluster
	clusters.map(x) = new_cluster 
	clusters.assignments[new_cluster].append(x)
	return clusters


    def update(clusters, freq):

	# Update c, the number of clusters
	clusters.c = len(clusters.assignments.keys())

	# Update Cluster Means
	for cluster_mean, cluster_list in clusters.assignments.iteritems():
	    new_mean = sum([x*freq[x] for x in cluster_list])/len(cluster_list) # calculate new cluster mean
	    clusters.assignments[new_mean] = clusters.assignments.pop(cluster_mean) # update cluster mean

	return clusters


    def re_cluster(D_r, clusters, values, counts, lambda, theta):

	for x in D_r:
	    d = dict()
	    
	    for cluster_mean in clusters.assignments.keys():
		d[cluster_mean] = np.power((x - cluster_mean),2) #squared difference between x and cluster mean
		max_d = max(d)
		
		x_1 = 0
	if d_max - theta > lamb - np.log(clusters.c)*theta:
	    clusters.c += 1
	    clusters.assignments[x_1] = [] 
    
	else:
	     

	return clusters


    def center_agglomeration(clusters, lamb, theta):
	c = clusters.c	
	agglom_term = lamb - theta*(np.log(np.power(c+1, c+1)/np.power(c, c)))
	
	means = clusters.assignments.keys()

	d = dict()
	for i in xrange(c-1): 
	    for j = xrange(i+1,c):
		d(i,j) = np.power(means(i) - means(j),2)	


	

	return clusters
    
    def combine_clusters(clusters, m1, m2):
	
