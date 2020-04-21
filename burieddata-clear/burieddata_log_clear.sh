#!/bin/bash
#
# 产品名称：惠充值
# 模块名称：数据埋点
# 模块版本：0.0.0.1
# 编译环境：linux
# 开发人员：zhangyj
# 修改日期：2020-03-08

basepath=$(cd `dirname $0`; pwd)
echo "basepath=$basepath"
now_day=`/bin/date "+%Y-%m-%d"`

# 清洗埋点日志程序
echo "=======================burieddata_log_clear.sh ${now_day} log clear starting ..."
hadoop jar /opt/txfs/mapper_app/burieddata-mapper-1.0-SNAPSHOT.jar
echo "=======================burieddata_log_clear.sh ${now_day} log clear finished."

# 加载埋点数据到hive
echo "=======================burieddata_log_clear.sh Data load to Hive starting ..."
hive -e "
  load data inpath '/user/dx_yuka/dx_intelli_recharge/mapreduce/output/tlog/txfs-burydata/' into table txfs_ods.spm_data partition (static_day='${now_day}');
"
hive -e "
  load data inpath '/user/dx_yuka/dx_intelli_recharge/mapreduce/output/elog/txfs-burydata/' into table txfs_ods.burydata_error;
"
echo "=======================burieddata_log_clear.sh Data load to Hive end."

echo "=======================burieddata_log_clear.sh:hadoop hsfs Data load to Hive end."