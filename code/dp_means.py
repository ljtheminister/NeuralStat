import pandas as pd
import numpy as np
from clusters import Clusters
from collections import defaultdict
import operator

class DP_means(self):

    def __init__(self, freq, lamb):
        self.lamb = lamb
        self.clusters = dp_means(freq,lamb)

    def __dp_means(self, freq, lamb):
	## INITIALIZATION
        clusters = Clusters()
        clusters.c = 1
        m1 = sum([x*freq[x] for x in freq.keys()])/float(len(freq.keys()))  
        clusters.assignments[
	clusters.map = []


    def __check_convergence(self, old_clusters, new_clusters, epsilon):

        if old_clusters.c != new_clusters.c:
            return False

        else:
            diff = np.subtract(new_clusters.assignments.keys(), old_clusters.assignments.keys())
            for elem in diff:
                if elem > epsilon: 
                    return False
            return True






