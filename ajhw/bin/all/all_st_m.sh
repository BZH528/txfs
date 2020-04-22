#!/bin/bash
# 产品名称：爱机护卫埋点数据统计
# 模块名称：shell脚本-数据仓库汇总脚本
# 模块版本：0.0.0.1
# 编译环境：linux
# 修改人员：bizhihao
# 修改日期：2020-04-19
# 修改内容：每月1号定时执行st统计脚本
# 参数：now_day(统计时间)
basepath=$(cd `dirname $0`; pwd)
echo "basepath=$basepath"

# 引入基础函数
source $basepath/../../sbin/util/error_helper.sh
script_name="$( basename "${BASH_SOURCE[0]}" )"
now_day=$1

echo "=======================$script_name in $now_day : Process Script Start======================================"
start_time=`/bin/date "+%Y-%m-%d %H:%M:%S"`
echo "now_day=$now_day"

basepath1=$basepath/../../sbin/st/st_m_spm_flow_result_monthly.sh

parameter1=$now_day
sh $basepath/../../sbin/util/loop.sh $basepath1 $parameter1 || error_report_and_exit $script_name $? $LINENO


end_time=`/bin/date "+%Y-%m-%d %H:%M:%S"`
echo "end_time=$end_time"
spend=$(( $(date -u -d "$end_time" +%s) - $(date -u -d "$start_time" +%s) ))
echo "spend time: $spend s"
echo "=======================$script_name in $now_day : Process Script End======================================"