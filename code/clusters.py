class Cluster():
    def __init__(self):
	self.assignments = dict() #key is mean, values are lists of data points inside that cluster
	self.map = dict() #maps data points to cluster
	self.c = 0 #number of clusters
