use txfs_st;

-- 每天各渠道（包含不分区渠道）行为次数和人数
drop table if exists st_m_spm_flow_result_daily;
create table st_m_spm_flow_result_daily(
    statis_day          string,
    app_id              string,
    indicator_name      string,
    channel             string,
    uv                  bigint,
    pv                  bigint
)
row format delimited
fields terminated by '\t'
stored as parquet;

/**
    statis_day          统计日期
    app_id              应用id
    indicator_name      指标名称
    channel             渠道（不区分渠的用‘all’代表）
    uv                  人数
    pv                  次数
 */

-- 每周各渠道（包含不分区渠道）行为次数和人数
drop table if exists st_m_spm_flow_result_weekly;
create table st_m_spm_flow_result_weekly(
    statis_week         string,
    app_id              string,
    indicator_name      string,
    channel             string,
    uv                  bigint,
    pv                  bigint
)
row format delimited
fields terminated by '\t'
stored as parquet;

/**
    statis_week         统计当周：形如'2020.4.6-2020.4.12' 周维度
    app_id              应用id
    indicator_name      指标名称
    channel             渠道（不区分渠的用‘all’代表）
    uv                  人数
    pv                  次数
 */

-- 每月各渠道（包含不分区渠道）行为次数和人数
drop table if exists st_m_spm_flow_result_monthly;
create table st_m_spm_flow_result_monthly(
    statis_month        string,
    app_id              string,
    indicator_name      string,
    channel             string,
    uv                  bigint,
    pv                  bigint
)
row format delimited
fields terminated by '\t'
stored as parquet;

/**
    statis_month        统计当月：形如'2020-04' 月维度
    app_id              应用id
    indicator_name      指标名称
    channel             渠道（不区分渠的用‘all’代表）
    uv                  人数
    pv                  次数
 */