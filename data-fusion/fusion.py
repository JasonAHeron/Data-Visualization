__author__ = 'jason'
import csv
from Tkinter import Tk
from tkFileDialog import askopenfilename
from fuzzywuzzy import fuzz
from fuzzywuzzy import process

DEBUG = False


def mergeCSV(c1, c2, outfile, field_name):

    headerSearch = True
    fuzzy_matching = False

    csvfile1 = file(str(c1), 'r')
    csvfile2 = file(str(c2), 'r')
    new_csvfile = file(str(outfile), 'w+')
    csv1 = csv.reader(csvfile1, delimiter=",")
    csv2 = csv.reader(csvfile2, delimiter=",")
    output = csv.writer(new_csvfile)
    csv2_rows = [row for row in csv2]

    if headerSearch:
        print "headers in " + str(c2) + " " + str(zip(csv2_rows[0], range(0, len(csv2_rows[0]))))
        csv2_extract = int(raw_input("text above formatted ('data','index') select a header index to merge: "))

    first_pass = True
    for csv1_row in csv1:

        match = False
        second_match = False

        for csv2_row in csv2_rows:
            output_row = csv1_row
            if first_pass:
                output_row = output_row + [str(field_name)]
            #found a match
            if str(csv1_row[0]) == str(csv2_row[0]):
                match = True
                output_row.append(((csv2_row[csv2_extract].split('.'))[0]).replace(',', ''))

        if not match and fuzzy_matching:
            for csv2_row in csv2_rows:
                #didn't find a match but want to try fuzzy matching
                #found a fuzzy match
                if (not match) and ((fuzz.partial_ratio(str(csv1_row[0]), str(csv2_row[0])) > 95) or (fuzz.partial_ratio(str(csv2_row[0]), str(csv1_row[0])) > 95)):
                    #it's the first fuzzy match, ask the usr about it
                    if (not second_match) and (str(raw_input("Fuzzy match FOR: {" + str(csv1_row[0]) + "} FOUND: {" + str(csv2_row[0]) + "} (y/n):\n")) is "y" or "Y"):
                        output_row.append(((csv2_row[csv2_extract].split('.'))[0]).replace(',', ''))
                        match = True
                        second_match = True
                    #it's a fuzzy match but it's not the first
                    elif second_match:
                        if str(raw_input("WARNING: Second fuzzy match FOR: {" + str(csv1_row[0]) + "} FOUND: {" + str(csv2_row[0]) + "}:\n" + "This will cause an extra col in your data and is probably not what you want (y/n):\n")) is "y" or "Y":
                            output_row.append(((csv2_row[csv2_extract].split('.'))[0]).replace(',', ''))
                            

        if not match:
            print "failed to find " + csv1_row[0] + " in second csv file"
        output.writerow(output_row)
        first_pass = False


arg1 = raw_input("Enter name of file to merge data into (press 'c' for file chooser): ")
if arg1 == "-":
    arg1 = "GDP_MERGE_ENERGY_PER.csv"
if arg1 == "c":
    Tk().withdraw()
    arg1 = askopenfilename()
arg2 = raw_input("Enter name of file to merge data from: ")
if arg2 == "-":
    arg2 = "POPULATION_DATA_THOUSANDS.csv"
if arg2 == "c":
    Tk().withdraw()
    arg2 = askopenfilename()
arg3 = raw_input("Enter name of desired output file: ")
if arg3 == "-":
    arg3 = "out.csv"
if arg3 == "c":
    Tk().withdraw()
    arg3 = askopenfilename()
arg4 = raw_input("Enter name of new data field: ")

mergeCSV(arg1, arg2, arg3, arg4)