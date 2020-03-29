#!/bin/bash
# 产品名称：电信鱼卡活动
# 模块名称：shell脚本-失败重试功能
# 模块版本：0.0.0.1
# 编译环境：linux
# 修改人员：bizh
# 修改日期：2020-03-26
# 修改内容：判断返回码，非0重试最多两次，重试间隔为10s和30s
# 参数：basepath(嵌套脚本路径)  parameter（嵌套脚本的输入参数）

basepath=$1
parameter=$2

count=0     #记录重试次数
flag=0      # 重试标识，flag=0 表示任务正常，flag=1 表示需要进行重试

while [ 0 -eq 0 ]
do
    echo ".................. job begin  ..................."
    sh $basepath $parameter
    flag=$?
    # 检查和重试过程
    if [ $flag -eq 0 ]; then     #执行成功，不重试
        echo "--------------- job complete ---------------"
        break;
    else                        #执行失败，重试
        count=$[${count}+1]
        echo "flag=$flag"
        if [ ${count} -eq 3 ]; then     #指定重试次数，重试超过2次即失败
            echo "Error: Exception in ${basepath} ${flag} at line:$LINENO"
            break
        fi
        if [ ${count} -eq 1 ]; then
           echo "...............retry in 10 seconds .........."
           sleep 10
        else
           echo "...............retry in 30 seconds .........."
           sleep 30
        fi
    fi
done