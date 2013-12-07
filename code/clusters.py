import pandas as pd
from collections import defaultdict



class Cluster():
    def __init__(self):
	self.assignments = dict() #key is mean, values are the indices of x in values
	self.map = list()
	self.c = 0
