#!/usr/bin/env python
import sys

node_dict = {'A':0, 'B':0, 'C':0, 'D':0, 'E':0, 'F':0}
outlink_dict = {}

for line in sys.stdin:
    items = line.split()
    if items[-1].replace('.','',1).isdigit():
        node, inlink, pr = items[0], items[1][:-1], items[2]
        node_dict[node] += float(pr)

    else:
        node, outlinks = items[0], " ".join(items[1:])
        outlink_dict[node] = outlinks
        
for nodename in sorted(node_dict.keys()):
    print("{0} {1} {2}".format(nodename, outlink_dict[nodename], node_dict[nodename]))
