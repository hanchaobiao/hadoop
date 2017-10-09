#!/bin/python
# encoding=utf-8

import sys


# 统计单词个数

current_word = None
current_count = 0
word = None

for line in sys.stdin:

    word, count = line.strip().split('\t',1)

    if current_word is None:
        current_word = word
    if current_word != word:
        print "%s\t%s" %(current_word, current_count)
        current_word = word
        current_count = 0
    current_count += int(count)
if current_word is not None:
    print "%s\t%s" % (current_word, current_count)