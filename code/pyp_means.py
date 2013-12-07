import pandas as pd
import numpy as np
from clusters import Clusters
from collections import defaultdict
import operator

class Pyp_means(self):

    def __init__(self, freq, lamb, theta):
	self.freq = freq 
	self.lamb = lamb
	self.theta = theta
	self.clusters = pyp_means(self.freq, self.lamb, self.theta)

    def __pyp_means(self, freq, lamb, theta):
	
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
		min_d = min(d.values())
		new_cluster = min(d, key=d.get)  #get cluster mean with minimum distance from x

		if min_d - theta > lamb - np.log(clusters.c)*theta:
		    D_r.append(x) 

		else:
		    clusters = assign_cluster(x, new_cluster, clusters)

	    clusters = re_cluster(D_r, clusters, freq, lamb, theta) #re-cluster the unclustered data set
	    clusters = center_agglomeration(clusters, lamb, theta) #center agglomeration
	    clusters = update(clusters, freq) #update c, re-compute cluster means

	return clusters


    def __assign_clusters(self, x, new_cluster, clusters):

	# find and remove old assignment
	prev_cluster = clusters.map(x)
	clusters.assignments[prev_cluster].remove(x)
	# assign to new cluster
	clusters.map(x) = new_cluster 
	clusters.assignments[new_cluster].append(x)
	return clusters


    def __update(self, clusters, freq):

	# Update c, the number of clusters
	clusters.c = len(clusters.assignments.keys())

	# Update cluster Means
	for cluster_mean, cluster_list in clusters.assignments.iteritems():
	    new_mean = sum([x*freq[x] for x in cluster_list])/len(cluster_list) # calculate new cluster mean
	    clusters.assignments[new_mean] = clusters.assignments.pop(cluster_mean) # update cluster mean

	return clusters


    def __re_cluster(self, D_r, clusters, lamb, theta):

	while D_r:
	    d_r = dict():

	    for x in D_r:
		d = dict()

		for cluster_mean in clusters.assignments.keys():
		    d[cluster_mean] = np.power((x - cluster_mean),2) #squared difference between x and cluster mean
		    min_d = min(d.values())
		    d_r[x] = min_d

	    d_r = sorted(d_r.iteritems(), key=operator.itemgetter(1))	
	    x_1, d_1 = d_r[0]

	    if d_1 - theta > lamb - np.log(clusters.c)*theta:
		# create new cluster where x_1 is mean
		clusters.c += 1
		clusters.assignments[x_1] = [x_1] 
		clusters.map(x_1) = x_1
	
	    else:
		# assign x_1 to existing cluster
		d = dict()
		for cluster_mean in clusters.assignments.keys():
		    d[cluster_mean] = np.power((x - cluster_mean),2) #squared difference between x and cluster mean
		    new_cluster = min(d, key=d.get)			

		clusters = assign_cluster(x_1, new_cluster, clusters)

	    D_r.remove(x_1)
	return clusters

    def __agglomeration_procedure(self, clusters, lamb, theta):
	center_agglom = agglomeration_check(clusters, lamb, theta)
 
	while center_agglom:
	    
	    clusters = combine_clusters(


	return clusters

    def __agglomeration_check(self, clusters, lamb, theta):
	c = clusters.c	
	agglom_term = lamb - theta*(np.log(np.power(c+1, c+1)/np.power(c, c)))
	means = clusters.assignments.keys()

	d = dict()
	for i in xrange(c-1): 
	    for j = xrange(i+1,c):
		d(i,j) = np.power(means(i) - means(j),2)	

	center_agglom = []
	for i,j in d.keys():
	    n1 = len(clusters.assignments[i])
	    n2 = len(clusters.assignments[j])
	    if d(i,j) < (n1+n2)/(n1*n2)*(lamb - theta*(np.log(np.power(c+1, c+1)/np.power(c, c))
		center_agglom.append((i,j))

	return center_agglom
	   

    def __center_agglomeration(self, clusters, lamb, theta):
	
	return clusters
    
    def __combine_clusters(clusters, freq, m1, m2):
	cluster1 = clusters.assignments[m1]
	cluster2 = clusters.assignments[m2]
	N = len(cluster1) + len(cluster2)

	new_mean = (sum([x*freq[x] for x in cluster1]) + sum([x*freq[x] for x in cluster2]))/float(N) # calculate new cluster mean
	clusters.assignments[new_mean] = cluster1  + cluster2
	clusters.assignments.pop(m1)
	clusters.assignments.pop(m2)

	return clusters	
