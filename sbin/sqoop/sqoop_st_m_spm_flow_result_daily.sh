#!/bin/bash
#
# 产品名称：爱机护卫页面埋点-sqoop层
# 模块名称：每天各渠道（包含不分区渠道）行为次数和人数
# 模块版本：0.0.0.1
# 编译环境：linux
# 开发人员：bizhihao
# 修改日期：2020-03-29

script_name="$( basename "${BASH_SOURCE[0]}" )"
now_day=$1
basepath=$(cd `dirname $0`; pwd)
echo "basepath=$basepath"

# 引入基础函数
source $basepath/../../sbin/util/error_helper.sh
echo "=======================$script_name in $now_day : Process Script Start======================================"

# 数据库域名
db_domain=10.193.11.12
# 数据库端口
db_port=3306
# 数据库名
db_name=xiaojinhe
# 数据库用户名
db_username=finebi
# 数据库密码
db_password=
# 表名
sqoop_table="st_m_spm_flow_result_daily"
# 表列名
sqoop_columns="statis_day,app_id,indicator_name,channel,uv,pv"
# 表主键
sqoop_keys="statis_day,app_id,indicator_name,channel"

# 导出到临时表
basepath=$(cd `dirname $0`; pwd)
sh $basepath/export2temp.sh $now_day $sqoop_table $sqoop_columns


# 导出统计数据
command="sqoop export
-D mapred.job.queue.name=produce
--connect 'jdbc:mysql://$db_domain:$db_port/$db_name?useUnicode=true&characterEncoding=utf-8'
--username $db_username
--password 'Fine>1939BI'
--table '"$sqoop_table"'
--fields-terminated-by '\t'
--columns $sqoop_columns
--hcatalog-database txfs_st_temp
--hcatalog-table '"$sqoop_table"'
--update-key $sqoop_keys
--update-mode allowinsert
--input-null-string '\\\\N'
--input-null-non-string '\\\\N'"
#echo ${command}
eval ${command}  || error_report_and_exit $script_name $? $LINENO
echo "=======================$script_name in $now_day : Process Script End======================================"