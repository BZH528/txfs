use txfs_dw;

-- 每日埋点清洗表
drop table if exists dw_m_spm_action_daily;
create table dw_m_spm_action_daily(
        statis_day          string,
        app_id              string,
        uid                 string,
        channel             string,
        joint_spm_value     string,
        action              string,
        action_num	         bigint
)
row format delimited
fields terminated by '\t'
stored as parquet;

/**
        statis_day          统计日期：yyyy-MM-dd 天维度
        app_id              应用id,爱机护卫appid:2019112569449509
        uid                 用户id
        channel             渠道
        joint_spm_value     拼接埋点值:如果埋点值有返回值，就拼接到spm_value之后，否则原样输出
        action              动作类型
        action_num          行为次数
 */

-- 每周埋点清洗表
drop table if exists dw_m_spm_action_weekly;
create table dw_m_spm_action_weekly(
        statis_week         string,
        app_id              string,
        uid                 string,
        channel             string,
        joint_spm_value     string,
        action              string,
        action_num	         bigint
)
row format delimited
fields terminated by '\t'
stored as parquet;

/**
        statis_week         统计当周：形如'2020.4.6-2020.4.12' 周维度
        app_id              应用id,爱机护卫appid:2019112569449509
        uid                 用户id
        channel             渠道
        joint_spm_value     拼接埋点值:如果埋点值有返回值，就拼接到spm_value之后，否则原样输出
        action              动作类型
        action_num          行为次数
 */

-- 每月埋点清洗表
drop table if exists dw_m_spm_action_monthly;
create table dw_m_spm_action_monthly(
        statis_month        string,
        app_id              string,
        uid                 string,
        channel             string,
        joint_spm_value     string,
        action              string,
        action_num	         bigint
)
row format delimited
fields terminated by '\t'
stored as parquet;

/**
        statis_month        统计当月：形如'2020年4月' 月维度
        app_id              应用id,爱机护卫appid:2019112569449509
        uid                 用户id
        channel             渠道
        joint_spm_value     拼接埋点值:如果埋点值有返回值，就拼接到spm_value之后，否则原样输出
        action              动作类型
        action_num          行为次数
 */