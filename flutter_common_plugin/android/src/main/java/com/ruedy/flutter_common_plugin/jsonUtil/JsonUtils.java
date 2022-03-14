package com.ruedy.flutter_common_plugin.jsonUtil;


import android.text.TextUtils;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.reflect.TypeToken;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Copyright (C), 2011-2018 {company}
 * FileName: com.mina.utils.JsonUtils.java
 * Author: xxx
 * Email: xxx
 * Date: 2018/6/15 22:50
 * Description: Json工具类
 * History:
 * <Author>      <Time>    <version>    <desc>
 * {xxx}   22:50    1.0          Create
 */
public class JsonUtils {
    /**
     * Gson - 将bean转换成json字符串
     *
     * @param object
     * @return
     * @throws Exception
     */
    public static String beanToJson(Object object) throws Exception {
        if (object == null) {
            return null;
        }
        Gson gson = new Gson();
        return gson.toJson(object);
    }

    /**
     * Gson - 将Map转成json
     *
     * @param map
     * @return
     */
    public static String mapToJson(Map<String, Object> map) {
        Gson gson = new Gson();
        return gson.toJson(map, Map.class);
    }

    /**
     * Gson - 根据list生成json字符串
     *
     * @param list
     * @return
     */
    public static <T> String fromListByGson(List<T> list) {
        Gson gson = new GsonBuilder().disableHtmlEscaping().create();
        String json = gson.toJson(list);
        return json;
    }

    /**
     * Gson - 将json字符串转换成bean
     *
     * @param json
     * @param clazz
     * @param <T>
     * @return
     * @throws Exception
     */
    public static <T> Object jsonToBean(String json, Class<T> clazz) throws Exception {
        if (json == null || TextUtils.isEmpty(json) || clazz == null) {
            return null;
        }
        Gson gson = new Gson();
        return gson.fromJson(json, clazz);
    }

    /**
     * Gson - 根据json字符串和class返回List<T>
     *
     * @param json
     * @param clazz
     * @return
     */
    public static <T> List<T> toListByGson(String json, Class<T> clazz) {
        Gson g = new GsonBuilder().setPrettyPrinting().disableHtmlEscaping().create();
        List<JsonObject> jsonObjs = g.fromJson(json, new TypeToken<List<JsonObject>>() {
        }.getType());
        ArrayList<T> listOfT = new ArrayList<T>();
        for (JsonObject jsonObj : jsonObjs) {
            listOfT.add((T) new Gson().fromJson(jsonObj, clazz));
        }
        return listOfT;
    }


    public static <T> String fromListByFastJson(List<T> list) {
        // 使用 SerializerFeature.DisableCircularReferenceDetect
        // 禁止循环使用，如果不添加，会出现"$ref"这种东西
        String json = JSON.toJSONString(list,
                SerializerFeature.DisableCircularReferenceDetect);
        return json;
    }

    public static <T> String fromObjectByFastJson(Object o) {
        String json = JSON.toJSONString(o,
                SerializerFeature.DisableCircularReferenceDetect);
        return json;
    }

    /**
     * FastJson - 根据json字符串和class返回List<T>
     *
     * @param json
     * @param classOfT
     * @return
     */
    public static <T> List<T> toListByFastJson(String json, Class<T> classOfT) {
        return JSON.parseArray(json, classOfT);
    }

    /**
     * FastJson - 根据json字符串和class返回Object
     *
     * @param json
     * @param classOfT
     * @return
     */
    public static <T> Object toObjectByFastJson(String json, Class<T> classOfT) {
        return JSON.parseObject(json, classOfT);
    }
}
