#!/usr/bin/env python

# Credit: http://hostingfu.com/article/quick-nginx-status-script

import re
import sys
import time
import urllib

TIME_SLEEP = 30


def get_data(url):
    data = urllib.urlopen(url)
    data = data.read()
    result = {}

    match1 = re.search(r'Active connections:\s+(\d+)', data)
    match2 = re.search(r'\s*(\d+)\s+(\d+)\s+(\d+)', data)
    match3 = re.search(r'Reading:\s*(\d+)\s*Writing:\s*(\d+)\s*'
        'Waiting:\s*(\d+)', data)
    if not match1 or not match2 or not match3:
        raise Exception('Unable to parse %s' % url)

    result['connections'] = int(match1.group(1))

    result['accepted'] = int(match2.group(1))
    result['handled'] = int(match2.group(2))
    result['requests'] = int(match2.group(3))

    result['reading'] = int(match3.group(1))
    result['writing'] = int(match3.group(2))
    result['waiting'] = int(match3.group(3))

    return result


def main():
    url = sys.argv[1]
    prev = None
    next = time.time() + TIME_SLEEP
    total = None
    count = 0
    try:
        while True:
            data = get_data(url)
            if prev:
                result = print_stat(prev, data)
                if total is None:
                    total = list(result)
                else:
                    for i, v in enumerate(result):
                        total[i] += v
                count += 1
            else:
                print_head()
            prev = data
            time.sleep(next - time.time())
            next += TIME_SLEEP
    except KeyboardInterrupt:
        if total:
            print_foot(total, count)


def print_foot(total, count):
    total = [v / count for v in total]
    print '-------- ---------- ---------- ----- ----- -----'
    print '%8d %10.2f %10.2f %5d %5d %5d' % tuple(total)


def print_head():
    print '%-8s %-10s %-10s %-5s %-5s %-5s' % (
        'Conn', 'Conn/s', 'Request/s', 'Read', 'Write', 'Wait')
    print '-------- ---------- ---------- ----- ----- -----'


def print_stat(prev, data):
    result = (
        data['connections'],
        float(data['accepted'] - prev['accepted']) / TIME_SLEEP,
        float(data['requests'] - prev['requests']) / TIME_SLEEP,
        data['reading'],
        data['writing'],
        data['waiting'])

    print '%8d %10.2f %10.2f %5d %5d %5d' % result
    return result
        

if __name__ == '__main__':
    main()
