# hadoop
hadoop学习代码Demo
hadoop2.6.5版本学习Demo 用于记录自己学习过程

基础配置参数介绍

下面参数中-files,-archives,-libjars为hadoop命令

    -file将客户端本地文件打成jar包上传到HDFS然后分发到计算节点
    -cacheFile将HDFS文件分发到计算节点
    -cacheArchive将HDFS压缩文件分发到计算节点并解压，也可以指定符号链接
    -files：将指定的本地/hdfs文件分发到各个Task的工作目录下，不对文件进行任何处理，例如：-files hdfs://host:fs_port/user/testfile.txt#testlink ；
    -archives选项允许用户复制jar包到当前任务的工作路径，并且自动解压jar包，例如：-archives hdfs://host:fs_port/user/testfile.jar#testlink3 。在这个例子中，符号链接testlink3创建在当前任务的工作路径中。符号链接指向存放解压jar包的文件路径
    -libjars：指定待分发的jar包，Hadoop将这些jar包分发到各个节点上后，会将其自动添加到任务的CLASSPATH环境变量中
    -input：指定作业输入，可以是文件或者目录，可以使用*通配符，也可以使用多次指定多个文件或者目录作为输入
    -output：指定作业输出目录，并且必须不存在，并且必须有创建该目录的权限，-output只能使用一次
    -mapper：指定mapper可执行程序或Java类，必须指定且唯一
    -reducer：指定reducer可执行程序或Java类
    -numReduceTasks： 指定reducer的个数，如果设置为0或者-reducer NONE 则没有reducer程序，mapper的输出直接作为整个作业的输出

其他参数配置

一般用 -jobconf | -D NAME=VALUE 指定作业参数，指定 mapper or reducer 的 task 官方上说要用 -jobconf 但是这个参数已经过时，不可以用了，官方说要用 -D, 注意这个-D是要作为最开始的配置出现的，因为是在maper 和 reducer　执行之前，就需要硬性指定好的，所以要出现在参数的最前面 ./bin/hadoop jar hadoop-0.19.2-streaming.jar -D ………-input ……..　类似这样

    mapred.job.name=”jobname” 设置作业名，特别建议
    mapred.job.priority=VERY_HIGH|HIGH|NORMAL|LOW|VERY_LOW 设置作业优先级
    * mapred.job.map.capacity=M设置同时最多运行M个map任务*
    mapred.job.reduce.capacity=N 设置同时最多运行N个reduce任务
    mapred.map.tasks 设置map任务个数
    mapred.reduce.tasks 设置reduce任务个数
    mapred.job.groups 作业可运行的计算节点分组
    mapred.task.timeout 任务没有响应（输入输出）的最大时间
    mapred.compress.map.output 设置map的输出是否压缩
    mapred.map.output.compression.codec 设置map的输出压缩方式
    mapred.output.compress 设置map的输出是否压缩
    mapred.output.compression.codec 设置reduce的输出压缩方式
    stream.map.output.field.separator 指定map输出分隔符，默认情况下Streaming框架将map输出的每一行的第一个’\t’之前的部分作为key，之后的部分作为value，key\value再作为reduce的输入；
    stream.num.map.output.key.fields 设置分隔符的位置，如果设置为2，指定在第2个分隔符处分割，也就是第二个之前作为key，之后作为value，如果分隔符少于2个，则以整行为key，value为空
    stream.reduce.output.field.separator 指定reduce输出分隔符
    stream.num.reduce.output.key.fields 指定reduce输出分隔符位置

其中sort和partition的参数用的比较多
map.output.key.field.separator： map中key内部的分隔符
num.key.fields.for.partition： 分桶时，key按前面指定的分隔符分隔之后，用于分桶的key占的列数。通俗地讲，就是partition时候按照key中的前几列进行划分，相同的key会被打到同一个reduce里。
-partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner 前两个参数，要配合partitioner选项使用！

stream.map.output.field.separator： map中的key与value分隔符
stream.num.map.output.key.fields： map中分隔符的位置
stream.reduce.output.field.separator： reduce中key与value的分隔符
stream.num.reduce.output.key.fields： reduce中分隔符的位置

另外还有压缩参数

Job输出结果是否压缩

mapred.output.compress

是否压缩，默认值false。

mapred.output.compression.type

压缩类型，有NONE, RECORD和BLOCK，默认值RECORD。

mapred.output.compression.codec

压缩算法，默认值org.apache.hadoop.io.compress.DefaultCodec。

map task输出是否压缩

mapred.compress.map.output

是否压缩，默认值false

mapred.map.output.compression.codec

压缩算法，默认值org.apache.hadoop.io.compress.DefaultCodec

另外，Hadoop本身还自带一些好用的Mapper和Reducer：

1、Hadoop聚集功能：Aggregate提供一个特殊的reducer类和一个特殊的combiner类，并且有一系列的“聚合器”（例如：sum、max、min等）用于聚合一组value的序列。可以使用Aggredate定义一个mapper插件类，这个类用于为mapper输入的每个key/value对产生“可聚合项”。combiner/reducer利用适当的聚合器聚合这些可聚合项。要使用Aggregate，只需指定”-reducer aggregate”。
2、字段的选取（类似于Unix中的’cut’）：Hadoop的工具类org.apache.hadoop.mapred.lib.FieldSelectionMapReduc帮助用户高效处理文本数据，就像unix中的“cut”工具。工具类中的map函数把输入的key/value对看作字段的列表。 用户可以指定字段的分隔符（默认是tab），可以选择字段列表中任意一段（由列表中一个或多个字段组成）作为map输出的key或者value。 同样，工具类中的reduce函数也把输入的key/value对看作字段的列表，用户可以选取任意一段作为reduce输出的key或value。
二次排序 Partitioner

一个典型的Map-Reduce的过程包括：Input->Map->Patition->Reduce->Output，Partition负责把Map任务输出的中间结果按key分发给不同的Reduce任务进行处理。Hadoop提供了一个非常实用的partitioner类KeyFieldBasedPartitioner，使用方法：

-partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner 

    1

一般会配合

-D map.output.key.field.separator  ###key内部的分隔符
-D num.key.fields.for.partition    ###对key分出来的前即部分做parititon，而不是整个key

    1
    2

使用，但是map.output.key.field.separator对tab键好像不管用，待验证。
例3：

测试数据：
1,2,1,1,1

1,2,2,1,1

1,3,1,1,1

1,3,2,1,1

1,3,3,1,1

1,2,3,1,1

1,3,1,1,1

1,3,2,1,1

1,3,3,1,1

-D stream.map.output.field.separator=, /    

-D stream.num.map.output.key.fields=4 /    

-D map.output.key.field.separator=, /    

-D num.key.fields.for.partition=2 /    

-partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner /

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10

结果数据：
$ hadoop fs –cat /app/test/test_result/part-00003

1,2,1,1 1

1,2,2,1 1

1,2,3,1 1

$ hadoop fs –cat /app/test/test_result/part-00004

1,3,1,1 1

1,3,1,1 1

1,3,2,1 1

1,3,2,1 1

1,3,3,1 1

1,3,3,1 1
例4

测试数据：
D&10.2.3.40 1
D&11.22.33.33 1
W&www.renren.com 1
W&www.baidu.com 1
D&10.2.3.40 1
然后通过传递命令参数
-partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner //指定要求二次排序
-jobconf map.output.key.field.separator=’&’　//这里如果不加两个单引号的话我的命令会死掉
-jobconf num.key.fields.for.partition=1　//这里指第一个 &　符号来分割，保证不会出错

-combiner？？
Comparator类
