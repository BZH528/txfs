#!/bin/bash
#
# 产品名称：爱机护卫埋点数据DM层库表设计
# 模块名称：每周各渠道各行为次数和人数
# 模块版本：0.0.0.1
# 编译环境：linux
# 开发人员：毕智豪
# 修改维护人员：
# 修改日期：2020-04-19
# 说明：

basepath=$(cd `dirname $0`; pwd)
echo "basepath=$basepath"

script_name="$( basename "${BASH_SOURCE[0]}" )"
# 引入基础函数
source $basepath/../../sbin/util/error_helper.sh


echo "=======================$script_name:Hive Data Process Script Start======================================"
##create data path
before_day=$1

week_start_day=`/bin/date "+%Y-%m-%d" -d "$before_day -6 day"`
week_end_day=`/bin/date "+%Y-%m-%d" -d "$before_day"`

statis_week_start_day=`/bin/date "+%Y.%m.%d" -d "$before_day -6 day"`
statis_week_end_day=`/bin/date "+%Y.%m.%d" -d "$before_day"`

echo "\$before_day=$before_day"

echo "\$week_start_day=$week_start_day"
echo "\$week_end_day=$week_end_day"
echo "\$statis_week_start_day=$statis_week_start_day"
echo "\$statis_week_end_day=$statis_week_end_day"




echo "=======================$script_name at a week from $week_start_day to $week_end_day:hive data process======================================"

hive -e "
set mapred.job.queue.name=produce;

with pv_count as
(
select t.statis_week statis_week,
       t.app_id app_id,
       t.channel channel,
       t.joint_spm_value joint_spm_value,
       sum(t.action_num) pv
  from txfs_dw.dw_m_spm_action_weekly t
 where t.statis_week = concat('${statis_week_start_day}','-','${statis_week_end_day}')
 group by t.statis_week,
          t.app_id,
          t.channel,
          t.joint_spm_value
),
distinct_user as
(
select t.statis_week statis_week,
       t.app_id app_id,
       t.uid uid,
       t.channel channel,
       t.joint_spm_value joint_spm_value
  from txfs_dw.dw_m_spm_action_weekly t
 where t.statis_week = concat('${statis_week_start_day}','-','${statis_week_end_day}')
 group by t.statis_week,
          t.app_id,
          t.uid,
          t.channel,
          t.joint_spm_value
),
uv_count as
(
select t.statis_week statis_week,
       t.app_id app_id,
       t.channel channel,
       t.joint_spm_value joint_spm_value,
       count(*) uv
  from distinct_user t
 group by t.statis_week,
          t.app_id,
          t.channel,
          t.joint_spm_value
),
-- 特殊总计pv,包括首页总计,IMEI有效性校验成功
special_page_pv_count as (
    select t.statis_week statis_week,
           t.app_id app_id,
           t.channel channel,
            (case when split(t.joint_spm_value,'_')[0]='a4.p32' then 'a4.p32'
             when split(t.joint_spm_value,'_')[0]='a4.p33.m74' then concat(split(t.joint_spm_value,'_')[0],'-',split(t.joint_spm_value,'_')[2])
               else 'NA' end) joint_spm_value,
           sum(t.action_num) pv
      from txfs_dw.dw_m_spm_action_weekly t
     where t.statis_week = concat('${statis_week_start_day}','-','${statis_week_end_day}')
       and (t.joint_spm_value like 'a4.p32%' or t.joint_spm_value like 'a4.p33.m74%')
     group by t.statis_week,
              t.app_id,
              t.channel,
              (case when split(t.joint_spm_value,'_')[0]='a4.p32' then 'a4.p32'
               when split(t.joint_spm_value,'_')[0]='a4.p33.m74' then concat(split(t.joint_spm_value,'_')[0],'-',split(t.joint_spm_value,'_')[2])
               else 'NA' end)

),
-- 特殊总计uv去重,包括首页总计,IMEI有效性校验成功
special_page_distinct_user as (
select t.statis_week statis_week,
       t.app_id app_id,
       t.uid uid,
       t.channel channel,
       (case when split(t.joint_spm_value,'_')[0]='a4.p32' then 'a4.p32'
        when split(t.joint_spm_value,'_')[0]='a4.p33.m74' then concat(split(t.joint_spm_value,'_')[0],'-',split(t.joint_spm_value,'_')[2])
         else 'NA' end) joint_spm_value
  from txfs_dw.dw_m_spm_action_weekly t
 where t.statis_week = concat('${statis_week_start_day}','-','${statis_week_end_day}')
   and (t.joint_spm_value like 'a4.p32%' or t.joint_spm_value like 'a4.p33.m74%')
 group by t.statis_week,
          t.app_id,
          t.uid,
          t.channel,
          (case when split(t.joint_spm_value,'_')[0]='a4.p32' then 'a4.p32'
           when split(t.joint_spm_value,'_')[0]='a4.p33.m74' then concat(split(t.joint_spm_value,'_')[0],'-',split(t.joint_spm_value,'_')[2])
           else 'NA' end)
),
-- 特殊总计uv,包括首页总计,IMEI有效性校验成功
special_page_uv_count as
(
select t.statis_week statis_week,
       t.app_id app_id,
       t.channel channel,
       t.joint_spm_value joint_spm_value,
       count(*) uv
  from special_page_distinct_user t
 group by t.statis_week,
          t.app_id,
          t.channel,
          t.joint_spm_value
),
-- 统计指标为完成表单填写的uv，去重uid
finish_table_distinct_user as
(
select
             t1.statis_week statis_week,
             t1.app_id app_id,
             t1.uid uid,
             t1.channel channel
from
    (
    select *
      from special_page_distinct_user t
      where t.joint_spm_value = 'a4.p33.m74-1'
    ) t1
    join
    (
    select *
      from distinct_user t
     where t.joint_spm_value='a4.p32.m61.b54_1'
    ) t2
    on t1.statis_week=t2.statis_week and t1.app_id=t2.app_id and t1.uid=t2.uid and t1.channel=t2.channel
    group by t1.statis_week,
             t1.app_id,
             t1.uid,
             t1.channel
),
-- 统计指标为完成表单填写的uv
finish_table_uv_count as(
select t.statis_week statis_week,
       t.app_id app_id,
       t.channel channel,
       count(*) uv
  from finish_table_distinct_user t
 group by t.statis_week,
          t.app_id,
          t.channel
),
-- 统计指标为收银台成功呼起的uv，去重uid
checkstand_up_distinct_user as
(
select t.statis_week statis_week,
       t.app_id app_id,
       t.uid uid,
       t.channel channel
  from distinct_user t
 where t.joint_spm_value in ('a4.p32.m67_success','a4.p32.m68_success')
 group by t.statis_week,
          t.app_id,
          t.uid,
          t.channel
),
-- 统计指标为收银台成功呼起的uv
checkstand_up_uv_count as
(
select t.statis_week statis_week,
       t.app_id app_id,
       t.channel channel,
       count(*) uv
  from checkstand_up_distinct_user t
 group by t.statis_week,
          t.app_id,
          t.channel
)
insert overwrite table txfs_dm.dm_m_spm_channel_flow_weekly
select t1.statis_week statis_week,
       t1.app_id app_id,
       t1.channel channel,
       t1.joint_spm_value joint_spm_value,
       nvl(t2.uv,0) uv,
       t1.pv pv
  from pv_count t1
  left join uv_count t2
    on t1.statis_week=t2.statis_week and t1.app_id=t2.app_id and t1.channel=t2.channel and t1.joint_spm_value=t2.joint_spm_value
 where t1.joint_spm_value<>'NA'
union all
select t1.statis_week statis_week,
       t1.app_id app_id,
       t1.channel channel,
       t1.joint_spm_value joint_spm_value,
       nvl(t2.uv,0) uv,
       t1.pv pv
  from special_page_pv_count t1
  left join special_page_uv_count t2
    on t1.statis_week=t2.statis_week and t1.app_id=t2.app_id and t1.channel=t2.channel and t1.joint_spm_value=t2.joint_spm_value
 where t1.joint_spm_value<>'NA'
union all
select statis_week,
       app_id,
       channel,
       'finish_table' joint_spm_value,
       uv,
       0 pv
  from finish_table_uv_count
union all
select statis_week,
       app_id,
       channel,
       'checkstand_up' joint_spm_value,
       uv,
       0 pv
  from checkstand_up_uv_count
;

" || error_report_and_exit $script_name $? $LINENO


echo "=======================$script_name:Hive Data Process Script End======================================"