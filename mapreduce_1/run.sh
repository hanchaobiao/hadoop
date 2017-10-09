#!/bin/sh
HADOOP_CMD="/usr/local/hadoop/bin/hadoop"
STREAM_JAR_PATH="/usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.6.5.jar"

INPUT_FILE_PATH_1="/test_data/test.txt"
OUTPUT_PATH="/output/test_1"


$HADOOP_CMD jar $STREAM_JAR_PATH \
                -input $INPUT_FILE_PATH_1 \
                -output $OUTPUT_PATH \
                -mapper "python mapper.py" \
                -reducer "python reduce.py" \
                -file "./mapper.py" \
                -file "./reduce.py"


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
