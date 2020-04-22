use txfs;

-- 每天各渠道（包含不分区渠道）行为次数和人数
drop table if exists st_m_spm_flow_result_daily;
create table st_m_spm_flow_result_daily(
      statis_day            varchar(20) not null comment '统计日期',
      app_id                varchar(20) not null comment '应用id',
      indicator_name        varchar(32) not null comment '指标名称',
      channel               varchar(32) not null comment '渠道 （全部渠道的用all代表）',
      uv                    int         not null comment '人数',
      pv                    int         not null comment '次数',
      primary key (`statis_day`,`app_id`,`indicator_name`,`channel`),
      key `indx_all`(`statis_day`,`indicator_name`,`channel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='爱机护卫埋点每天各渠道（包含不分区渠道）行为次数和人数';

-- 每周各渠道（包含不分区渠道）行为次数和人数
drop table if exists st_m_spm_flow_result_weekly;
create table st_m_spm_flow_result_weekly(
      statis_week           varchar(32) not null comment '统计周',
      app_id                varchar(20) not null comment '应用id',
      indicator_name        varchar(32) not null comment '指标名称',
      channel               varchar(32) not null comment '渠道 （全部渠道的用all代表）',
      uv                    int         not null comment '人数',
      pv                    int         not null comment '次数',
      primary key (`statis_week`,`app_id`,`indicator_name`,`channel`),
      key `indx_all`(`statis_week`,`indicator_name`,`channel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='爱机护卫埋点每周各渠道（包含不分区渠道）行为次数和人数';

-- 每月各渠道（包含不分区渠道）行为次数和人数
drop table if exists st_m_spm_flow_result_monthly;
create table st_m_spm_flow_result_monthly(
      statis_month          varchar(32) not null comment '统计月份',
      app_id                varchar(20) not null comment '应用id',
      indicator_name        varchar(32) not null comment '指标名称',
      channel               varchar(32) not null comment '渠道 （全部渠道的用all代表）',
      uv                    int         not null comment '人数',
      pv                    int         not null comment '次数',
      primary key (`statis_month`,`app_id`,`indicator_name`,`channel`),
      key `indx_all`(`statis_month`,`indicator_name`,`channel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='爱机护卫埋点每月各渠道（包含不分区渠道）行为次数和人数';