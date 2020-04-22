package com.gaoyang.bean;

import java.io.Serializable;

/**
 * 数据埋点responseBody值（前端传入）
 */
public class BuryData implements Serializable {

    private static final long serialVersionUID = -6388956529275458840L;

    private String app_id;

    /*
      用户ID (埋点传入)
     */
    private String uid;

    /*
      客户端ip
     */
    private String user_ip;

    /*
     * 渠道 (埋点传入)
     */
    private String channel;

    /*
     客户端浏览器信息 (埋点传入)
    */
    private String browser;

    /*
       客户端机型信息 (埋点传入)
     */
    private String mobile;

    /*
     访问来源spm (埋点传入)
    */
    private String resource_spm;

    /*
       spm埋点值(埋点传入)
     */
    private String spm_value;

    /*
      用户行为 (埋点传入)
     */
    private String action;

    /*
      埋点触发时间 (埋点传入)
     */
    private String spm_time;

    /*
      其他数据 (埋点传入)
     */
    private String other;

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getChannel() {
        return channel;
    }

    public void setChannel(String channel) {
        this.channel = channel;
    }

    public String getBrowser() {
        return browser;
    }

    public void setBrowser(String browser) {
        this.browser = browser;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getResource_spm() {
        return resource_spm;
    }

    public void setResource_spm(String resource_spm) {
        this.resource_spm = resource_spm;
    }

    public String getSpm_value() {
        return spm_value;
    }

    public void setSpm_value(String spm_value) {
        this.spm_value = spm_value;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getSpm_time() {
        return spm_time;
    }

    public void setSpm_time(String spm_time) {
        this.spm_time = spm_time;
    }

    public String getOther() {
        return other;
    }

    public void setOther(String other) {
        this.other = other;
    }

    public String getUser_ip() {
        return user_ip;
    }

    public void setUser_ip(String user_ip) {
        this.user_ip = user_ip;
    }

    public String getApp_id() {
        return app_id;
    }

    public void setApp_id(String app_id) {
        this.app_id = app_id;
    }

    @Override
    public String toString() {
        return "BuryData{" +
                "app_id='" + app_id + '\'' +
                ", uid='" + uid + '\'' +
                ", user_ip='" + user_ip + '\'' +
                ", channel='" + channel + '\'' +
                ", browser='" + browser + '\'' +
                ", mobile='" + mobile + '\'' +
                ", resource_spm='" + resource_spm + '\'' +
                ", spm_value='" + spm_value + '\'' +
                ", action='" + action + '\'' +
                ", spm_time='" + spm_time + '\'' +
                ", other='" + other + '\'' +
                '}';
    }
}
