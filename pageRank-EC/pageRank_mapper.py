#!/usr/bin/env python
import sys

for line in sys.stdin:
    node = line[0]
    outlinks = line.split()[1:-1]
    pr = line.split()[-1]
    for outlink in outlinks:
        print("{0} {1}, {2}".format(outlink, node, float(pr)/len(outlinks)))
    print("{0} {1}".format(node, " ".join(outlinks)))
