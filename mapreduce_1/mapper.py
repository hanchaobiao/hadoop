# encoding=utf-8

import sys

"""
使用python写MapReduce的“诀窍”是利用Hadoop流的API，通过STDIN(标准输入)、STDOUT(标准输出)在Map函数和Reduce函数之间传递数据。
我们唯一需要做的是利用Python的sys.stdin读取输入数据，并把我们的输出传送给sys.stdout。Hadoop流将会帮助我们处理别的任何事情。
"""

# 调用标准输入流
for line in sys.stdin:
    # 读入文本内容,每次读入一行
    words = line.strip().split()
    for word in words:
        print "%s\t%s" % (word, 1)
        # 文件从STDIN读取文件。把单词切开，并把单词和词频输出STDOUT。Map脚本不会计算单词的总数，而是输出 < word > 1。在我们的例子中，我们让随后的Reduce阶段做统计工作。