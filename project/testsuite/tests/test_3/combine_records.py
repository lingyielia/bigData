#!/usr/bin/env python
import sys

def read_input(file):
    temp_cont = []
    for line in file:
        if not line[0].isdigit():
            continue
        process(line.split('\t'), temp_cont)

def process(data, temp_cont):
    station = data[0]
    day_of_week = data[1]
    time_of_day = data[2]

    if len(temp_cont) == 0:
        temp_cont.append(data)
        return

    if (len(temp_cont) == 1) and (temp_cont[0][:3] == data[:3]):
        temp1 = temp_cont.pop(0)

        if (temp1[3] == '0') and (data[3] == '1'):
            flow_avg_no = temp1[4]
            flow_avg_yes = data[4]

            print("{0}\t{1}\t{2}\t{3}\t{4}".format(
                station, day_of_week, time_of_day, flow_avg_no, flow_avg_yes))

    else:
        temp1 = temp_cont.pop(0)
        return

if __name__ == "__main__":
    read_input(sys.stdin)
