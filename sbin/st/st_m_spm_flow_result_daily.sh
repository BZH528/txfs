#!/bin/bash
#
# 产品名称：爱机护卫埋点数据ST层库表设计
# 模块名称：每天各渠道各行为次数和人数结果表
# 模块版本：0.0.0.1
# 编译环境：linux
# 开发人员：毕智豪
# 修改维护人员：
# 修改日期：2020-03-28
# 说明：

basepath=$(cd `dirname $0`; pwd)
echo "basepath=$basepath"

script_name="$( basename "${BASH_SOURCE[0]}" )"
# 引入基础函数
source $basepath/../../sbin/util/error_helper.sh


echo "=======================$script_name:Hive Data Process Script Start======================================"
##create data path
before_day=$1

echo "\$before_day=$before_day"


echo "=======================$script_name:hive data process======================================"

hive -e "
set mapred.job.queue.name=produce;


insert overwrite table txfs_st.st_m_spm_flow_result_daily
select t.statis_day statis_day,t.app_id app_id,
       '首页访问' indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value='a4.p32'

union all
select t.statis_day statis_day,t.app_id app_id,
       (case t.joint_spm_value when 'a4.p32_1' then '成功推荐IOS服务页'
        when 'a4.p32_2' then '失败推荐IOS服务页'
        when 'a4.p32_3' then '成功推荐安卓服务页'
        when 'a4.p32_4' then '失败推荐安卓服务页'
        else 'NA' end) indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p32_%'
union all
select t.statis_day statis_day,t.app_id app_id,
       (case t.joint_spm_value when 'a4.p32.m59_1' then '2元优惠券弹框'
        when 'a4.p32.m59_2' then '3元优惠券弹框'
        when 'a4.p32.m59_3' then '5元优惠券弹框'
        when 'a4.p32.m59_4' then '新3元优惠券弹框'
        else 'NA' end) indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p32.m59_%'

union all
select t.statis_day statis_day,t.app_id app_id,
       (case t.joint_spm_value when 'a4.p32.m59.b52_1_1' then '2元优惠券弹框-领取按钮'
        when 'a4.p32.m59.b52_2_1' then '3元优惠券弹框-领取按钮'
        when 'a4.p32.m59.b52_3_1' then '5元优惠券弹框-领取按钮'
        when 'a4.p32.m59.b52_4_1' then '新3元优惠券弹框-领取按钮'
        else 'NA' end) indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p32.m59.b52_%_1'

 union all
select t.statis_day statis_day,t.app_id app_id,
       (case t.joint_spm_value when 'a4.p32.m59.b52_1_0' then '2元优惠券弹框-关闭按钮'
        when 'a4.p32.m59.b52_2_0' then '3元优惠券弹框-关闭按钮'
        when 'a4.p32.m59.b52_3_0' then '5元优惠券弹框-关闭按钮'
        when 'a4.p32.m59.b52_4_0' then '新3元优惠券弹框-关闭按钮'
        else 'NA' end) indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p32.m59.b52_%_0'

 union all
select t.statis_day statis_day,t.app_id app_id,
       concat('首屏头图区第',split(t.joint_spm_value,'_')[1],'帧') indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p32.m60.b53_%'

  union all
select t.statis_day statis_day,t.app_id app_id,
       (case t.joint_spm_value when 'a4.p32.m61.b54_1' then '同意授权获取手机号'
        when 'a4.p32.m61.b54_0' then '拒绝授权获取手机号'
        else 'NA' end) indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p32.m61.b54_%'

   union all
select t.statis_day statis_day,t.app_id app_id,
       concat('首页Banner区第',split(t.joint_spm_value,'_')[1],'帧') indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p32.m62.b55_%'

    union all
select t.statis_day statis_day,t.app_id app_id,
       '首页在线客服按钮' indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value = 'a4.p32.m63.b56'

    union all
select t.statis_day statis_day,t.app_id app_id,
       '首页支付按钮' indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value = 'a4.p32.m63.b57'

     union all
select t.statis_day statis_day,t.app_id app_id,
       (case t.joint_spm_value when 'a4.p32.m64_success' then '营销反作弊校验成功'
        when 'a4.p32.m64_fail' then '营销反作弊校验失败'
        else 'NA' end) indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p32.m64_%'

      union all
select t.statis_day statis_day,t.app_id app_id,
       (case t.joint_spm_value when 'a4.p32.m65_success' then 'verifyimei校验成功'
        when 'a4.p32.m65_fail' then 'verifyimei校验失败'
        else 'NA' end) indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p32.m65_%'

     union all
select t.statis_day statis_day,t.app_id app_id,
       (case t.joint_spm_value when 'a4.p32.m66_success' then '办理资格校验成功'
        when 'a4.p32.m66_fail' then '办理资格校验失败'
        else 'NA' end) indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p32.m66_%'

     union all
select t.statis_day statis_day,t.app_id app_id,
       (case t.joint_spm_value when 'a4.p32.m67_success' then '一次性支付收银台组件成功呼起'
        when 'a4.p32.m67_fail' then '一次性支付收银台组件失败呼起'
        else 'NA' end) indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p32.m67_%'

    union all
select t.statis_day statis_day,t.app_id app_id,
       (case t.joint_spm_value when 'a4.p32.m68_success' then '资金授信收银台组件成功呼起'
        when 'a4.p32.m68_fail' then '资金授信收银台组件失败呼起'
        else 'NA' end) indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p32.m68_%'

     union all
select t.statis_day statis_day,t.app_id app_id,
       '取消支付弹框' indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value = 'a4.p32.m69'

      union all
select t.statis_day statis_day,t.app_id app_id,
       (case t.joint_spm_value when 'a4.p32.m69.b58_1' then '取消支付弹框继续办理按钮'
        when 'a4.p32.m69.b58_0' then '取消支付弹框继续放弃按钮'
        else 'NA' end) indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p32.m69.b58_%'

      union all
select t.statis_day statis_day,t.app_id app_id,
       '办理成功弹框' indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value = 'a4.p32.m70'


       union all
select t.statis_day statis_day,t.app_id app_id,
       (case t.joint_spm_value when 'a4.p32.m70.b59_1' then '办理成功弹框领取会员卡按钮'
        when 'a4.p32.m70.b59_0' then '办理成功弹框关闭按钮'
        else 'NA' end) indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p32.m70.b59_%'

       union all
select t.statis_day statis_day,t.app_id app_id,
       'IMEI页访问' indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value = 'a4.p33'

        union all
select t.statis_day statis_day,t.app_id app_id,
       (case t.joint_spm_value when 'a4.p33.m73_1' then 'IMEI图片智能识别成功'
        when 'a4.p33.m73_0' then 'IMEI图片智能识别失败'
        else 'NA' end) indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p33.m73_%'

        union all
select t.statis_day statis_day,t.app_id app_id,
       '手动输入文字链点击' indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value = 'a4.p33.m71.b60'

         union all
select t.statis_day statis_day,t.app_id app_id,
       '完成IMEI码手动输入' indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value = 'a4.p33.m72.b61'

 union all
 select t.statis_day statis_day,t.app_id app_id,
       '关闭手动输入组件' indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value = 'a4.p33.m72.b62'

 union all
select t.statis_day statis_day,t.app_id app_id,
       (case t.joint_spm_value when 'a4.p33.m74-1' then 'IMEI有效性校验成功'
        when 'a4.p33.m74-0' then 'IMEI有效性校验失败'
        else 'NA' end) indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p33.m74-%'

  union all
select t.statis_day statis_day,t.app_id app_id,
       (case t.joint_spm_value when 'a4.p33.m74_0_1' then '图片识别IMEI有效性校验成功'
        when 'a4.p33.m74_0_0' then '图片识别IMEI有效性校验失败'
        when 'a4.p33.m74_1_1' then '手动输入IMEI有效性校验成功'
        when 'a4.p33.m74_1_0' then '手动输入IMEI有效性校验失败'
        else 'NA' end) indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p33.m74_%'

   union all
select t.statis_day statis_day,t.app_id app_id,
       '完成表单填写' indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value = 'finish_table'

 union all
select t.statis_day statis_day,t.app_id app_id,
       '在保期落地页访问' indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value = 'a4.p34'

  union all
select t.statis_day statis_day,t.app_id app_id,
       '在保期落地页我要报修按钮' indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value = 'a4.p34.m75.b64'

   union all
select t.statis_day statis_day,t.app_id app_id,
       '在保期落地页领取会员卡按钮' indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value = 'a4.p34.m75.b65'


  union all
select t.statis_day statis_day,t.app_id app_id,
       concat('在保期Banner区第',split(t.joint_spm_value,'_')[1],'帧') indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p34.m76.b69_%'

    union all
select t.statis_day statis_day,t.app_id app_id,
       '在保期在线客服按钮' indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value = 'a4.p34.m77.b67'

     union all
select t.statis_day statis_day,t.app_id app_id,
       '在保期客服热线文字链' indicator_name,
       t.channel channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_channel_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value = 'a4.p34.m77.b68'

 -- 不区分渠道的 channel:'all'
 union all
select t.statis_day statis_day,t.app_id app_id,
       '首页访问' indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value='a4.p32'

union all
select t.statis_day statis_day,t.app_id app_id,
       (case t.joint_spm_value when 'a4.p32_1' then '成功推荐IOS服务页'
        when 'a4.p32_2' then '失败推荐IOS服务页'
        when 'a4.p32_3' then '成功推荐安卓服务页'
        when 'a4.p32_4' then '失败推荐安卓服务页'
        else 'NA' end) indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p32_%'

union all
select t.statis_day statis_day,t.app_id app_id,
       (case t.joint_spm_value when 'a4.p32.m59_1' then '2元优惠券弹框'
        when 'a4.p32.m59_2' then '3元优惠券弹框'
        when 'a4.p32.m59_3' then '5元优惠券弹框'
        when 'a4.p32.m59_4' then '新3元优惠券弹框'
        else 'NA' end) indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p32.m59_%'

union all
select t.statis_day statis_day,t.app_id app_id,
       (case t.joint_spm_value when 'a4.p32.m59.b52_1_1' then '2元优惠券弹框-领取按钮'
        when 'a4.p32.m59.b52_2_1' then '3元优惠券弹框-领取按钮'
        when 'a4.p32.m59.b52_3_1' then '5元优惠券弹框-领取按钮'
        when 'a4.p32.m59.b52_4_1' then '新3元优惠券弹框-领取按钮'
        else 'NA' end) indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p32.m59.b52_%_1'

 union all
select t.statis_day statis_day,t.app_id app_id,
       (case t.joint_spm_value when 'a4.p32.m59.b52_1_0' then '2元优惠券弹框-关闭按钮'
        when 'a4.p32.m59.b52_2_0' then '3元优惠券弹框-关闭按钮'
        when 'a4.p32.m59.b52_3_0' then '5元优惠券弹框-关闭按钮'
        when 'a4.p32.m59.b52_4_0' then '新3元优惠券弹框-关闭按钮'
        else 'NA' end) indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p32.m59.b52_%_0'

 union all
select t.statis_day statis_day,t.app_id app_id,
       concat('首屏头图区第',split(t.joint_spm_value,'_')[1],'帧') indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p32.m60.b53_%'

  union all
select t.statis_day statis_day,t.app_id app_id,
       (case t.joint_spm_value when 'a4.p32.m61.b54_1' then '同意授权获取手机号'
        when 'a4.p32.m61.b54_0' then '拒绝授权获取手机号'
        else 'NA' end) indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p32.m61.b54_%'

   union all
select t.statis_day statis_day,t.app_id app_id,
       concat('首页Banner区第',split(t.joint_spm_value,'_')[1],'帧') indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p32.m62.b55_%'

    union all
select t.statis_day statis_day,t.app_id app_id,
       '首页在线客服按钮' indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value = 'a4.p32.m63.b56'

    union all
select t.statis_day statis_day,t.app_id app_id,
       '首页支付按钮' indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value = 'a4.p32.m63.b57'

     union all
select t.statis_day statis_day,t.app_id app_id,
       (case t.joint_spm_value when 'a4.p32.m64_success' then '营销反作弊校验成功'
        when 'a4.p32.m64_fail' then '营销反作弊校验失败'
        else 'NA' end) indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p32.m64_%'

      union all
select t.statis_day statis_day,t.app_id app_id,
       (case t.joint_spm_value when 'a4.p32.m65_success' then 'verifyimei校验成功'
        when 'a4.p32.m65_fail' then 'verifyimei校验失败'
        else 'NA' end) indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p32.m65_%'

     union all
select t.statis_day statis_day,t.app_id app_id,
       (case t.joint_spm_value when 'a4.p32.m66_success' then '办理资格校验成功'
        when 'a4.p32.m66_fail' then '办理资格校验失败'
        else 'NA' end) indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p32.m66_%'

     union all
select t.statis_day statis_day,t.app_id app_id,
       (case t.joint_spm_value when 'a4.p32.m67_success' then '一次性支付收银台组件成功呼起'
        when 'a4.p32.m67_fail' then '一次性支付收银台组件失败呼起'
        else 'NA' end) indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p32.m67_%'

    union all
select t.statis_day statis_day,t.app_id app_id,
       (case t.joint_spm_value when 'a4.p32.m68_success' then '资金授信收银台组件成功呼起'
        when 'a4.p32.m68_fail' then '资金授信收银台组件失败呼起'
        else 'NA' end) indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p32.m68_%'

     union all
select t.statis_day statis_day,t.app_id app_id,
       '取消支付弹框' indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value = 'a4.p32.m69'

      union all
select t.statis_day statis_day,t.app_id app_id,
       (case t.joint_spm_value when 'a4.p32.m69.b58_1' then '取消支付弹框继续办理按钮'
        when 'a4.p32.m69.b58_0' then '取消支付弹框继续放弃按钮'
        else 'NA' end) indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p32.m69.b58_%'

      union all
select t.statis_day statis_day,t.app_id app_id,
       '办理成功弹框' indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value = 'a4.p32.m70'

       union all
select t.statis_day statis_day,t.app_id app_id,
       (case t.joint_spm_value when 'a4.p32.m70.b59_1' then '办理成功弹框领取会员卡按钮'
        when 'a4.p32.m70.b59_0' then '办理成功弹框关闭按钮'
        else 'NA' end) indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p32.m70.b59_%'

       union all
select t.statis_day statis_day,t.app_id app_id,
       'IMEI页访问' indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value = 'a4.p33'

        union all
select t.statis_day statis_day,t.app_id app_id,
       (case t.joint_spm_value when 'a4.p33.m73_1' then 'IMEI图片智能识别成功'
        when 'a4.p33.m73_0' then 'IMEI图片智能识别失败'
        else 'NA' end) indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p33.m73_%'

        union all
select t.statis_day statis_day,t.app_id app_id,
       '手动输入文字链点击' indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value = 'a4.p33.m71.b60'

         union all
select t.statis_day statis_day,t.app_id app_id,
       '完成IMEI码手动输入' indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value = 'a4.p33.m72.b61'

 union all
 select t.statis_day statis_day,t.app_id app_id,
       '关闭手动输入组件' indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value = 'a4.p33.m72.b62'

 union all
select t.statis_day statis_day,t.app_id app_id,
       (case t.joint_spm_value when 'a4.p33.m74-1' then 'IMEI有效性校验成功'
        when 'a4.p33.m74-0' then 'IMEI有效性校验失败'
        else 'NA' end) indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p33.m74-%'

  union all
select t.statis_day statis_day,t.app_id app_id,
       (case t.joint_spm_value when 'a4.p33.m74_0_1' then '图片识别IMEI有效性校验成功'
        when 'a4.p33.m74_0_0' then '图片识别IMEI有效性校验失败'
        when 'a4.p33.m74_1_1' then '手动输入IMEI有效性校验成功'
        when 'a4.p33.m74_1_0' then '手动输入IMEI有效性校验失败'
        else 'NA' end) indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p33.m74_%'

   union all
select t.statis_day statis_day,t.app_id app_id,
       '完成表单填写' indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value = 'finish_table'

 union all
select t.statis_day statis_day,t.app_id app_id,
       '在保期落地页访问' indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value = 'a4.p34'

  union all
select t.statis_day statis_day,t.app_id app_id,
       '在保期落地页我要报修按钮' indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value = 'a4.p34.m75.b64'

   union all
select t.statis_day statis_day,t.app_id app_id,
       '在保期落地页领取会员卡按钮' indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value = 'a4.p34.m75.b65'

  union all
select t.statis_day statis_day,t.app_id app_id,
       concat('在保期Banner区第',split(t.joint_spm_value,'_')[1],'帧') indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value like 'a4.p34.m76.b69_%'

    union all
select t.statis_day statis_day,t.app_id app_id,
       '在保期在线客服按钮' indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value = 'a4.p34.m77.b67'

     union all
select t.statis_day statis_day,t.app_id app_id,
       '在保期客服热线文字链' indicator_name,
       'all' channel,t.uv uv,t.pv pv
  from txfs_dm.dm_m_spm_flow_daily t
 where t.statis_day='$before_day' and t.joint_spm_value = 'a4.p34.m77.b68'



" || error_report_and_exit $script_name $? $LINENO


echo "=======================$script_name:Hive Data Process Script End======================================"