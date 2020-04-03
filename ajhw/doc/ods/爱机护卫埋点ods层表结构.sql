use txfs_ods;

- 数据埋点表
DROP TABLE IF EXISTS txfs_ods.spm_data;
CREATE TABLE txfs_ods.spm_data (
    app_id string comment 'app_id',
    uid string comment '用户Id',
    channel string comment '渠道',
    user_ip string comment '客户端ip',
    upstream_ip string comment '服务端ip',
    browser string  comment '客户端浏览器信息',
    mobile  string  comment '客户端机型信息',
    request_status  string  comment '请求状态',
    request_time string  comment '请求的总时长',
    upstream_status string  comment '服务端响应状态',
    upstream_time string  comment '服务端响应时间',
    body_bytes_sent string  comment '响应主体内容大小',
    resource_spm string  comment 'spm来源',
    spm_value string  comment 'spm埋点值',
    action string  comment '用户行为',
    spm_time string  comment '埋点时间',
    other string comment '其他数据',
    gmt_create String comment '数据清洗时间'
) partitioned by (static_day string)
row format delimited
fields terminated by '\t';

 /**
  app_id          app_id
  uid             用户Id
  channel         渠道
  user_ip         客户端ip
  upstream_ip     服务端ip
  browser         客户端浏览器信息
  mobile          客户端机型信息
  request_status  请求状态
  request_time    请求的总时长
  upstream_status 服务端响应状态
  upstream_time   服务端响应时间
  body_bytes_sent 响应主体内容大小
  resource_spm    spm来源
  spm_value       spm埋点值
  action          用户行为,如1,2,3,4 1 表示clicked 2 表示pageMonitor3 表示exposure4 表示other
  spm_time        埋点时间
  other           其他数据
  gmt_create      数据清洗时间
 */

-- 错误日志表
DROP TABLE IF EXISTS txfs_ods.burydata_error;
CREATE TABLE txfs_ods.burydata_error (
    error_type string comment '错误类型',
    error_msg string comment '错误详情',
    log string comment '原始日志',
    gmt_create string comment '数据生成时间'
)row format delimited
fields terminated by '\t';
