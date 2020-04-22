package com.gaoyang.controller;

import com.gaoyang.util.SystemCons;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;
import java.util.Map;

@RestController
public class Controller {

    @PostMapping("/spm/burydata")
    public Map<String,String> burydata(@RequestBody String buryData){
        System.out.println(new Date() + ":" +buryData);
        return SystemCons.responseData;
    }
}