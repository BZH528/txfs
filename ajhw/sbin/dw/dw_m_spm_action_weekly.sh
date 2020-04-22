#!/bin/bash
#
# 产品名称：爱机护卫埋点数据DW层库表设计
# 模块名称：用户行为信息
# 模块版本：0.0.0.1
# 编译环境：linux
# 开发人员：毕智豪
# 修改维护人员：
# 修改日期：2020-04-15
# 说明：用户行为信息,周维度

basepath=$(cd `dirname $0`; pwd)
echo "basepath=$basepath"

script_name="$( basename "${BASH_SOURCE[0]}" )"
# 引入基础函数
source $basepath/../../sbin/util/error_helper.sh


echo "=======================$script_name:Hive Data Process Script Start======================================"
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



echo "=======================$script_name at a week from $week_start_day to $week_end_day :hive data process======================================"

hive -e "
set mapred.job.queue.name=produce;

insert overwrite table txfs_dw.dw_m_spm_action_weekly
select concat('${statis_week_start_day}','-','${statis_week_end_day}') statis_week,
       sd.app_id app_id,
       sd.uid uid,
       sd.channel channel,
       (case when sd.spm_value='a4.p32' then concat(sd.spm_value,'_',get_json_object(sd.other,'$.recommend_type'))-- 首页
        when sd.spm_value='a4.p32.m59' then concat(sd.spm_value,'_',get_json_object(sd.other,'$.coupon_type')) -- 首页-优惠券弹框访问
        when sd.spm_value='a4.p32.m59.b52' then concat(sd.spm_value,'_',get_json_object(sd.other,'$.coupon_type'),'_',get_json_object(sd.other,'$.click_param')) -- 首页-优惠券弹框点击
        when sd.spm_value='a4.p32.m60.b53' then concat(sd.spm_value,'_',get_json_object(sd.other,'$.top_picture_index')) -- 首页-首屏头图区
        when sd.spm_value='a4.p32.m61.b54' then concat(sd.spm_value,'_',get_json_object(sd.other,'$.phone_authorize')) -- 首页-授权获取手机号组件点击
        when sd.spm_value='a4.p32.m62.b55' then concat(sd.spm_value,'_',get_json_object(sd.other,'$.banner_index')) -- 首页-Banner区
        when sd.spm_value='a4.p32.m64' then concat(sd.spm_value,'_',get_json_object(sd.other,'$.verify_status')) -- 首页-营销反作弊校验
        when sd.spm_value='a4.p32.m65' then concat(sd.spm_value,'_',get_json_object(sd.other,'$.verify_status')) -- 首页-verifyimei校验
        when sd.spm_value='a4.p32.m66' then concat(sd.spm_value,'_',get_json_object(sd.other,'$.verify_status')) -- 首页-办理资格校验
        when sd.spm_value='a4.p32.m67' then concat(sd.spm_value,'_',get_json_object(sd.other,'$.verify_status')) -- 首页-一次性支付收银台组件
        when sd.spm_value='a4.p32.m68' then concat(sd.spm_value,'_',get_json_object(sd.other,'$.verify_status')) -- 首页-资金授信收银台组件
        when sd.spm_value='a4.p32.m69.b58' then concat(sd.spm_value,'_',get_json_object(sd.other,'$.click_type')) -- 首页-取消支付弹框点击
        when sd.spm_value='a4.p32.m70.b59' then concat(sd.spm_value,'_',get_json_object(sd.other,'$.click_type')) -- 首页-办理成功弹框点击
        when sd.spm_value='a4.p33.m73' then concat(sd.spm_value,'_',get_json_object(sd.other,'$.result_type')) -- IMEI页-图片智能识别
        when sd.spm_value='a4.p33.m74' then concat(sd.spm_value,'_',get_json_object(sd.other,'$.input_type'),'_',get_json_object(sd.other,'$.result_type')) -- IMEI页-IMEI有效性校验
        when sd.spm_value='a4.p34.m76.b69' then concat(sd.spm_value,'_',get_json_object(sd.other,'$.banner_index')) -- 在保期落地页-Banner区
        else sd.spm_value end) joint_spm_value,
        sd.action action,
        count(*) action_num
  from txfs_ods.spm_data sd
 where from_unixtime(cast(cast(sd.spm_time as bigint)/1000 as bigint),'yyyy-MM-dd') between '${week_start_day}' and '${week_end_day}'
   and sd.app_id='2019112569449509'
 group by sd.app_id,
          sd.uid,
          sd.channel,
          (case when sd.spm_value='a4.p32' then concat(sd.spm_value,'_',get_json_object(sd.other,'$.recommend_type'))-- 首页
           when sd.spm_value='a4.p32.m59' then concat(sd.spm_value,'_',get_json_object(sd.other,'$.coupon_type')) -- 首页-优惠券弹框访问
           when sd.spm_value='a4.p32.m59.b52' then concat(sd.spm_value,'_',get_json_object(sd.other,'$.coupon_type'),'_',get_json_object(sd.other,'$.click_param')) -- 首页-优惠券弹框点击
           when sd.spm_value='a4.p32.m60.b53' then concat(sd.spm_value,'_',get_json_object(sd.other,'$.top_picture_index')) -- 首页-首屏头图区
           when sd.spm_value='a4.p32.m61.b54' then concat(sd.spm_value,'_',get_json_object(sd.other,'$.phone_authorize')) -- 首页-授权获取手机号组件点击
           when sd.spm_value='a4.p32.m62.b55' then concat(sd.spm_value,'_',get_json_object(sd.other,'$.banner_index')) -- 首页-Banner区
           when sd.spm_value='a4.p32.m64' then concat(sd.spm_value,'_',get_json_object(sd.other,'$.verify_status')) -- 首页-营销反作弊校验
           when sd.spm_value='a4.p32.m65' then concat(sd.spm_value,'_',get_json_object(sd.other,'$.verify_status')) -- 首页-verifyimei校验
           when sd.spm_value='a4.p32.m66' then concat(sd.spm_value,'_',get_json_object(sd.other,'$.verify_status')) -- 首页-办理资格校验
           when sd.spm_value='a4.p32.m67' then concat(sd.spm_value,'_',get_json_object(sd.other,'$.verify_status')) -- 首页-一次性支付收银台组件
           when sd.spm_value='a4.p32.m68' then concat(sd.spm_value,'_',get_json_object(sd.other,'$.verify_status')) -- 首页-资金授信收银台组件
           when sd.spm_value='a4.p32.m69.b58' then concat(sd.spm_value,'_',get_json_object(sd.other,'$.click_type')) -- 首页-取消支付弹框点击
           when sd.spm_value='a4.p32.m70.b59' then concat(sd.spm_value,'_',get_json_object(sd.other,'$.click_type')) -- 首页-办理成功弹框点击
           when sd.spm_value='a4.p33.m73' then concat(sd.spm_value,'_',get_json_object(sd.other,'$.result_type')) -- IMEI页-图片智能识别
           when sd.spm_value='a4.p33.m74' then concat(sd.spm_value,'_',get_json_object(sd.other,'$.input_type'),'_',get_json_object(sd.other,'$.result_type')) -- IMEI页-IMEI有效性校验
           when sd.spm_value='a4.p34.m76.b69' then concat(sd.spm_value,'_',get_json_object(sd.other,'$.banner_index')) -- 在保期落地页-Banner区
           else sd.spm_value end),
           sd.action
;
" || error_report_and_exit $script_name $? $LINENO


echo "=======================$script_name:Hive Data Process Script End======================================"