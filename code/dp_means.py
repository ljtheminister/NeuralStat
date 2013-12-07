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
        clusters = Clusters()
        clusters.c = 1
        m1 = sum([x*freq[x] for x in freq.keys()])/float(len(freq.keys()))  
        clusters.assignments[
