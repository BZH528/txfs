#!/bin/bash

# 产品名称：导出SQL执行结果
# 模块名称：shell脚本-导出结果到csv文件
# 模块版本：0.0.0.1
# 编译环境：linux
# 修改人员：bizh
# 修改日期：2020-03-26
# 修改内容：将传入的SQL执行结果导出到固定名称的csv文件中
# 参数：export_file(带路径的导出文件名称)
#       export_sql(导出的数据对应的sql)

script_name="$( basename "${BASH_SOURCE[0]}" )"
export_file=$1
export_sql=$2

echo "=======================$script_name to $export_file : Process Script Start======================================"

# 导出的临时文件名称
tmp_filename="${export_file}.tmp"
# 导出文件名称
export_filename="${export_file}.csv"

# 将sql执行结果导出到csv文件
hive -f "${export_sql}"   | grep -v "WARN" >> "${tmp_filename}"

# 将csv文件的编码由UTF-8改为GBK
iconv -f UTF-8 -c -t GBK "${tmp_filename}" > "${export_filename}"

# 删除临时文件
rm "${tmp_filename}"

echo "=======================$script_name to $export_file : Process Script End======================================"
