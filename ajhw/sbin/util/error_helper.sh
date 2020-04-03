#!/bin/bash

# 产品名称：基础函数
# 模块名称：shell脚本-错误提示
# 模块版本：0.0.0.1
# 编译环境：linux
# 修改人员：bizh
# 修改日期：2020-03-26
# 修改内容：提示错误并退出执行
# 参数：script_name 报错脚本名称
#      error_code 错误码
#      error_line 报错行数位置

function error_report_and_exit()
{

    script_name=$1
    error_code=$2
    error_line=$3

    echo "Error: Exception in ${script_name} ${error_code} at line:$error_line"

    exit 1
}




