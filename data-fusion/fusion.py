__author__ = 'jason'
import csv
from fuzzywuzzy import fuzz
from fuzzywuzzy import process
import getopt
import sys

DEBUG = False
HEADER_SEARCH = True
FUZZY_MATCHING = True
MULTIMERGE = (10) + 1

def main(argv):
    try:
        optlist, args = getopt.getopt(argv, 'i:m::o:f:')
    except getopt.GetoptError as err:
        print str(err)
        usage()
        sys.exit(2)
    arguments = map(list, zip(*optlist))[1]
    mergeCSV(arguments[0], arguments[1], arguments[2], arguments[3])

def usage():
    print "\nUsage of fusion.py\nfusion.py -i input.csv -m filetomerge.csv -o outputfile.csv -f newfieldname"

def mergeCSV(c1, c2, outfile, field_name):

    csvfile1 = file(str(c1), 'r')
    csvfile2 = file(str(c2), 'r')
    new_csvfile = file(str(outfile), 'w+')
    csv1 = csv.reader(csvfile1, delimiter=",")
    csv2 = csv.reader(csvfile2, delimiter=",")
    output = csv.writer(new_csvfile)
    csv2_rows = [row for row in csv2]

    if HEADER_SEARCH:
        print "headers in " + str(c2) + " " + str(zip(csv2_rows[0], range(0, len(csv2_rows[0]))))
        csv2_extract = int(raw_input("text above formatted ('data','index') select a header index to merge: "))

    first_pass = True
    for csv1_row in csv1:
        match = False
        for csv2_row in csv2_rows:
            output_row = csv1_row
            if first_pass:
                output_row = output_row + [str(field_name) + item for item in (csv2_row[csv2_extract:csv2_extract+MULTIMERGE])]
                match = True
                break
            elif str(csv1_row[0]) == str(csv2_row[0]):
                match = True
                for data in csv2_row[csv2_extract:csv2_extract+MULTIMERGE]:
                    output_row.append(data.split('.')[0].replace(',', ''))
        if (not match) and (FUZZY_MATCHING):
            output_rows = []
            output_names = []
            fuzzy_match = False
            for csv2_row in csv2_rows:
                output_row = []
                output_row.extend(csv1_row)
                if (fuzz.partial_ratio(str(csv1_row[0]), str(csv2_row[0])) > 95) or (fuzz.partial_ratio(str(csv2_row[0]), str(csv1_row[0])) > 95):
                    for data in csv2_row[csv2_extract:csv2_extract+MULTIMERGE]:
                        output_row.append(data.split('.')[0].replace(',', ''))
                    output_rows.append(output_row)
                    output_names.append(csv2_row[0])
                    fuzzy_match = True
            if fuzzy_match:
                print "Found fuzzy matches for {" + str(csv1_row[0]) + "}:"
                for i, name in enumerate(output_names):
                    print " (" + str(i) + ") " + name
                extraction_val = str(raw_input("Please select an index or enter 'n' for none: "))
                if extraction_val is "n":
                    output_row = csv1_row
                else:
                    match = True
                    output_row = output_rows[int(extraction_val)]
        if (not match) and (not first_pass):
            print "failed to find " + csv1_row[0] + " in second csv file"
        output.writerow(output_row)
        first_pass = False


if __name__ == "__main__":
    main(sys.argv[1:])