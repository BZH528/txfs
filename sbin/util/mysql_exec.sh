#!/bin/bash

# 产品名称：导出SQL执行结果
# 模块名称：shell脚本-导出SQL执行结果
# 模块版本：0.0.0.1
# 编译环境：linux
# 修改人员：bizh
# 修改日期：2020-03-26
# 修改内容：将传入的SQL执行结果导出到固定名称的txt文件中

script_name="$( basename "${BASH_SOURCE[0]}" )"
export_file=$1
export_sql=$2

echo "=======================$script_name to $export_file : Process Script Start======================================"


source /etc/profile
source ~/.bash_profile

# 导出文件名称
export_filename="${export_file}.txt"

HOSTNAME="10.192.11.130"
PORT="3307"
USERNAME="bd_admin"
PASSWORD="F%L24&6%x"
DBNAME="bdjeecgdb"

mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD} ${DBNAME} -Bse "source ${export_sql}" >  "${export_filename}"

echo "=======================$script_name to $export_file : Process Script End======================================"
