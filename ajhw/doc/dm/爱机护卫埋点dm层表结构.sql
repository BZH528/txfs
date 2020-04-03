use txfs_dm;

-- 每天各渠道各行为次数和人数
drop table if exist dm_m_spm_channel_flow_daily;
create table dm_m_spm_channel_flow_daily(
      statis_day          string,
      app_id              string,
      channel             string,
      joint_spm_value     string,
      uv                  bigint,
      pv                  bigint
)
row format delimited
fields terminated by '\t'
stored as parquet;

/**
      statis_day          统计日期：yyyy-MM-dd 天维度
      app_id              应用id
      channel             渠道
      joint_spm_value     拼接埋点值:需要统计的各种页面操作事件类型
      uv                  人数
      pv                  次数
 */

-- 每天所有渠道各行为次数和人数
drop table if exist dm_m_spm_flow_daily;
create table dm_m_spm_flow_daily(
      statis_day          string,
      app_id              string,
      joint_spm_value     string,
      uv                  bigint,
      pv                  bigint
)
row format delimited
fields terminated by '\t'
stored as parquet;

/**
      statis_day          统计日期：yyyy-MM-dd 天维度
      app_id              应用id
      joint_spm_value     拼接埋点值:需要统计的各种页面操作事件类型
      uv                  人数
      pv                  次数
 */