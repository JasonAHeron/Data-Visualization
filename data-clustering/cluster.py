__author__ = 'jason'
import pandas as pd
import csv
from numpy import array
import numpy as np
from scipy.cluster.vq import kmeans
csvfile = file("/Users/jason/Documents/UCSC/CS198/POP_GDP_MERGE_ENERGY.csv", 'r')
outfile = file("out.csv", 'w+')
output = csv.writer(outfile)
df = pd.read_csv(csvfile)
data = {}
for i in range(1,12):
    a = array(df.ix[:,i].values)
    b = a[a != "--"]
    data[i-1] = np.sort(kmeans(b.astype(np.float), 3)[0])
    #output.writerow(np.insert(np.sort(data[i][0]),0,array(i-1)))
    output.writerow(data[i-1])

file.close(outfile)
file.close(csvfile)

csvfile = file("out.csv", 'r')
outfile = file("out2.csv", 'w+')
output = csv.writer(outfile)
df = pd.read_csv(csvfile)
df.columns = pd.MultiIndex.from_tuples(zip(['Trend1','Trend2','Trend3']), df.columns)
#df.columns = pd.MultiIndex.from_tuples(zip(['Trend1','Trend2','Trend3','Trend4','Trend5']), df.columns)
#print df
output.writerow(df.Trend1.values)
output.writerow(df.Trend2.values)
output.writerow(df.Trend3.values)
#output.writerow(df.Trend4.values)
#output.writerow(df.Trend5.values)