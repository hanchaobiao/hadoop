#!/bin/python
# encoding=utf-8

import sys
# 统计单词个数


def reduce_word():

    current_word = None
    current_count = 0
    word = None

    for line in sys.stdin:

        word, count = line.strip().split('\t', 1)

        if current_word is None:
            current_word = word
        if current_word != word:
            print "%s\t%s" % (current_word, current_count)
            current_word = word
            current_count = 0
        current_count += int(count)

    if current_word is not None:
        print "%s\t%s" % (current_word, current_count)

if __name__ == '__main__':
    module = sys.modules[__name__]
    # 获取run.sh里配置的函数名 mapper_func
    fun = getattr(module, sys.argv[1])
    args = None
    if len(sys.argv) > 0:
        args = sys.argv[2:]  # 获取run.sh里配置的参数
    fun(*args)