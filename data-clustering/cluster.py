__author__ = 'jason'
import pandas as pd
import csv
from numpy import array
import numpy as np
from scipy.cluster.vq import kmeans

input_csv = "/Users/jason/Documents/UCSC/CS198/POP_GDP_MERGE_ENERGY.csv"
output_csv = "out.csv"
final_outfile = "final.csv"
clusters = 3
cmin = 1
cmax = 10

def cluster(df, means, csv_min, csv_max):
    data = []
    for i in range(csv_min, csv_max):
        a = array(df.ix[:, i].values)
        b = a[a != "--"]
        data.append(np.sort(kmeans(b.astype(np.float), means)[0]))
    return data

def reshape(output_csv, clusters):
    final_output = csv.writer(file(final_outfile, 'w+'))
    df = pd.read_csv(file(output_csv, 'r'))
    to_zip = []
    for i in range(1,clusters+1):
        to_zip.append("Trend" + str(i))
    df.columns = pd.MultiIndex.from_tuples(zip(to_zip), df.columns)
    rows = [row for row in csv.reader(file(input_csv, 'r'))]
    frow = rows[0][cmin:cmax+2]
    frow[:0] = ['Trends']
    final_output.writerow(frow)
    for row in df:
        outstring = array(eval("df." + row + ".values")).tolist()
        outstring[:0] = [row]
        final_output.writerow(outstring)

def main():
    df = pd.read_csv(file(input_csv, 'r'))
    out = file(output_csv, 'w+')
    output = csv.writer(out)
    blank_str = " "*clusters
    output.writerow(blank_str)
    for c in cluster(df, clusters, cmin, cmax+2):
        output.writerow(array(c).tolist())
    file.close(out)
    reshape(output_csv, clusters)

main()