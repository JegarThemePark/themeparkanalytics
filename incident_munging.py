import pandas as pd
import re
import csv

i = ""
with open("../../Data/unformatted_incidents_2.csv", 'rb') as csvfile:
	incidentreader = csv.reader(csvfile)
	for row in incidentreader:
		for item in row:
			i = i + " " + str(item)
i = re.sub(r"Wet ?.{1,2}Wild:|Disney:|Universal:|Sea World:|Busch Gardens:|Disney World:|Legoland:|None [Rr]eported|/{0,1}MGM:{0,1}|Epcot,{0,1}|USF", "", i)

splitlist = re.split(r'\s+(?=\d+/\d+/\d+\s)', i)

incidents = pd.DataFrame(splitlist, columns = ['a'])
incidents['date'], incidents['stuff'] = incidents['a'].str.split(' ', 1).str
incidents["age"] = incidents.stuff.str.extract("(\d+)", expand = True)

incidents["gender"] = incidents.stuff.str.extract("((?<=year old ).|(?<=yo).)", expand = True)
incidents["ride"] = incidents.stuff.str.extract("(.* (?=[0-9]))", expand = True)
print incidents
"""

incidents['ride'], incidents['age'], incidents['event'] = incidents['stuff'].str.split(',', 2).str
incidents['age'], incidents['sex'] = incidents['age'].str.split(' yo', 1).str
incidents = incidents.drop(['a', 'stuff'], axis = 1)
print incidents
#incidents.to_csv("~/Data/dis_incidents.csv")
"""
