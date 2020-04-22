#!/bin/bash
# 产品名称：爱机护卫埋点数据统计
# 模块名称：shell脚本-汇总脚本
# 模块版本：0.0.0.1
# 编译环境：linux
# 修改人员：bizhihao
# 修改日期：2020-04-19
# 修改内容：每周一执行前一周的统计过程
# 引入基础函数
# 备注：2020-04-19新增调度周报计算脚本

basepath=$(cd `dirname $0`; pwd)
echo "basepath=$basepath"
source $basepath/../sbin/util/error_helper.sh
script_name="$( basename "${BASH_SOURCE[0]}" )"

before_day=$1

echo "=======================$script_name in $before_day : Process Script Start======================================"
## 初始化key table
kinit -kt /opt/keytab/dx_yuka.keytab dx_yuka
start_time=`/bin/date "+%Y-%m-%d %H:%M:%S"`
echo "start_time=$start_time"

echo "before_day="$before_day

#执行dw层脚本
sh $basepath/all/all_dw_w.sh $before_day || error_report_and_exit $script_name $? $LINENO

#执行dm层脚本
sh $basepath/all/all_dm_w.sh $before_day || error_report_and_exit $script_name $? $LINENO

#执行st层脚本
sh $basepath/all/all_st_w.sh $before_day || error_report_and_exit $script_name $? $LINENO

#执行sqoop层脚本
sh $basepath/all/all_sqoop_w.sh $before_day || error_report_and_exit $script_name $? $LINENO

end_time=`/bin/date "+%Y-%m-%d %H:%M:%S"`
echo "end_time=$end_time"
spend=$(( $(date -u -d "$end_time" +%s) - $(date -u -d "$start_time" +%s) ))
echo "spend time: $spend s"
echo "=======================$script_name in $before_day : Process Script End======================================"