__author__ = 'jason'
import pandas as pd
import csv
from numpy import array
import numpy as np
from scipy.cluster.vq import kmeans
import os
import sys
import getopt

meta_file = "meta.csv"
output_csv = "out.csv"
cmin = 1
cmax = 10

def cleanCSV(input_csv):
    input = csv.reader(file(input_csv,'r'))
    meta_file_open = file(meta_file,'w+')
    output = csv.writer(meta_file_open)
    for row in input:
        newrow = [cell.replace(',','') for cell in row]
        output.writerow(newrow)
    file.close(meta_file_open)

def cluster(df, means, csv_min, csv_max):
    data = []
    for i in range(csv_min, csv_max):
        a = array(df.ix[:, i].values)
        b = a[a != "--"]
        print np.sort(kmeans(b.astype(np.float), means)[0])
        data.append(np.sort(kmeans(b.astype(np.float), means)[0]))
    return data

def reshape(output_csv, clusters, final_outfile, input_csv):
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

def main(argv):
    try:
        optlist, args = getopt.getopt(argv, 'i:o:c:')
    except getopt.GetoptError as err:
        print str(err)
        usage()
        sys.exit(2)
    arguments = map(list, zip(*optlist))[1]
    input_csv = arguments[0]
    final_outfile = arguments[1]
    clusters = int(arguments[2])

    cleanCSV(input_csv)
    df = pd.read_csv(file(meta_file, 'r'))
    out = file(output_csv, 'w+')
    output = csv.writer(out)
    blank_str = " "*clusters
    output.writerow(blank_str)
    for c in cluster(df.dropna(), clusters, cmin, cmax+2):
        output.writerow(array(c).tolist())
    file.close(out)
    reshape(output_csv, clusters, final_outfile, input_csv)

def usage():
    print "\nUsage is cluster.py -i <input.csv> -o <output.csv> -c <choice of k (k-means)>"

if __name__ == "__main__":
    if len(sys.argv) > 1:
        main(sys.argv[1:])
        os.remove("meta.csv")
        os.remove("out.csv")

'''
if __name__ == "__main__":
    if sanitize(sys.argv):
        main(sys.argv[1:])
        os.remove("meta.csv")
        os.remove("out.csv")
def sanitize(argv):
'''