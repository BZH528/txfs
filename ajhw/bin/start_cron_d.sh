#!/bin/bash
# 产品名称：爱机护卫埋点数据统计
# 模块名称：shell脚本-汇总脚本
# 模块版本：0.0.0.1
# 编译环境：linux
# 修改人员：bizhihao
# 修改日期：2020-04-19
# 修改内容：执行当前时间前一天的统计过程
# 引入基础函数
# 备注：2020-04-19新增调度周报和月报计算脚本

basepath=$(cd `dirname $0`; pwd)
echo "basepath=$basepath"
source $basepath/../sbin/util/error_helper.sh
script_name="$( basename "${BASH_SOURCE[0]}" )"
now_day=`/bin/date "+%Y-%m-%d"`

echo "=======================$script_name in $now_day : Process Script Start======================================"
## 初始化key table
kinit -kt /opt/keytab/dx_yuka.keytab dx_yuka
start_time=`/bin/date "+%Y-%m-%d %H:%M:%S"`
echo "start_time=$start_time"
# 统计时间
before_day=`/bin/date "+%Y-%m-%d" -d "$now_day -1 day"`

# 时间所在周几
partition_week=`/bin/date "+%w" -d "$now_day"`
# 时间所在日期
partition_month=`/bin/date "+%d" -d "$now_day"`

echo "before_day=$before_day"
echo "partition_week=$partition_week"
echo "partition_month=$partition_month"

#执行dw层脚本
sh $basepath/all/all_dw_d.sh $before_day || error_report_and_exit $script_name $? $LINENO

#执行dm层脚本
sh $basepath/all/all_dm_d.sh $before_day || error_report_and_exit $script_name $? $LINENO

#执行st层脚本
sh $basepath/all/all_st_d.sh $before_day || error_report_and_exit $script_name $? $LINENO

#执行sqoop层脚本
sh $basepath/all/all_sqoop_d.sh $before_day || error_report_and_exit $script_name $? $LINENO

#每周一执行
if [ $partition_week -eq 1 ]; then
  sh $basepath/week_start.sh $before_day
fi

#每月一号执行
if [ $partition_month -eq 01 ]; then
  sh $basepath/month_start.sh $before_day
fi

end_time=`/bin/date "+%Y-%m-%d %H:%M:%S"`
echo "end_time=$end_time"
spend=$(( $(date -u -d "$end_time" +%s) - $(date -u -d "$start_time" +%s) ))
echo "spend time: $spend s"
echo "=======================$script_name in $now_day : Process Script End======================================"