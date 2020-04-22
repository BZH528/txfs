#!/bin/bash

# 产品名称：爱机护卫
# 模块名称：shell脚本-将数据仓库统计数据导出到每周临时表
# 模块版本：0.0.0.1
# 编译环境：linux
# 修改人员：bizhihao
# 修改日期：2020-04-19
# 修改内容：导出统计数据到每周临时表


now_month=$1
export_table=$2
export_collums=$3

#导出到临时表的sql
echo "
set mapred.job.queue.name=produce;
insert overwrite table txfs_st_temp."${export_table}"
select "${export_collums}" from txfs_st."${export_table}"
where statis_month ='"${now_month}"';
"
hive -e "
set mapred.job.queue.name=produce;
insert overwrite table txfs_st_temp."${export_table}"
select "${export_collums}" from txfs_st."${export_table}"
where statis_month ='"${now_month}"';
"
