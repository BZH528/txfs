use txfs_ods;

CREATE TABLE spm_data (
    app_id          string,
    uid             string,
    spm_value       string,
    action          string,
    spm_time        string,
    resource_spm    string,
    mobile          string,
    browser         string,
    channel         string,
    other           string
) partitioned by (static_day string)
row format delimited
fields terminated by '\t';
/**
    app_id          app_id
    uid             用户id
    spm_value       埋点值
    action          动作类型，如1,2,3,4 1 表示clicked 2 表示pageMonitor3 表示exposure4 表示other
    spm_time        触发时间
    resource_spm    访问来源spm
    mobile          客户端机型信息
    browser         客户端浏览器信息
    channel         渠道
    other           其他数据
 */
