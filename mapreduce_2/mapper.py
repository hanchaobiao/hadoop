# encoding=utf-8

import sys


def read_local_file(local_file):
    # 读取本地白名单
    word_set = set()
    with open(local_file, 'r') as reader:
        for line in reader:
            word_set.add(line.strip())
    return word_set


def mapper_func(white_list_path):
    # 分割单词
    white_list = read_local_file(white_list_path)
    for line in sys.stdin:
        words = line.strip().split(' ')
        for word in words:
            word = word.strip()
            if word is not '' and word in white_list:
                print "%s\t%s" % (word, 1)

if __name__ == '__main__':
    module = sys.modules[__name__]
    # 获取run.sh里配置的函数名 mapper_func
    fun = getattr(module, sys.argv[1])
    args = None
    if len(sys.argv) > 0:
        args = sys.argv[2:]  # 获取run.sh里配置的参数
    fun(*args)
