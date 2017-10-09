#!/bin/sh

HADOOP_CMD="/usr/local/hadoop/bin/hadoop"
STREAM_JAR_PATH="/usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.6.5.jar"

INPUT_FILE_PATH_1="/test_data/LICENSE.txt"
OUTPUT_PATH="/output/white_list"


$HADOOP_CMD jar $STREAM_JAR_PATH \
                -input $INPUT_FILE_PATH_1 \
                -output $OUTPUT_PATH \
                -mapper "python mapper.py mapper_func white_list.txt" \
                -reducer "python reduce.py reduce_word" \
                -jobconf "mapred.job.name=white_list" \
                -jobconf "maperd.reduce.tasks=3" \
                -file "./mapper.py" \
                -file "./reduce.py" \
                -file "./white_list.txt"  # 分发白名单

本地执行测试语法
cat /home/hadoop/LICENSE.txt | python mapper.py mapper_func white_list.txt| sort -k1 | python reduce.py reduce_word|head sort -k2

执行脚本出现这种错误
run.sh: line 2: $'\r': command not found
run.sh: line 5: $'\r': command not found
run.sh: line 8: $'\r': command not found

yun install dos2unix
dos2unix 将windows文本格式转化为unix格式
dos2unix run.sh



-input # 指定输入hdfs文件里路径，支持*号通配符
-output # 指定作业结果输出hdfs路径，路径存在，且有操作权限，只能使用一次
-mapper 指定如何启动你的mapper程序
-file 提交程序
-jonconf mapred.job.name="xxxx" 指定这个任务的名字，不设置默认随机字符串
-cacheFile
-cacheArchive
-mapred.map.tasks  map的任务数
mapred.reduce.tasks reduce的任务数
stream.num.mapoutput.key.fileds 指定map task记录输出所占的域数目
num.key.fileds.for.partition 指定对key分出来的前几部分做partition 而不是整个key
