package com.gaoyang.util;

import org.springframework.stereotype.Component;

import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Component("systemCons")
public class SystemCons {


    public static SimpleDateFormat dateFormat;

    public static Map<String,String>  responseData;

    static {

        responseData = new HashMap<>();
        responseData.put("code","10000");
        responseData.put("msg","success");

        dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    }


}
