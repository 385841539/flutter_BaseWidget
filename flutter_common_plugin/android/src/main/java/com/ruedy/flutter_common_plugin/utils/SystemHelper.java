package com.ruedy.flutter_common_plugin.utils;


import android.app.ActivityManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.util.Log;

import java.util.List;

import static android.content.Context.ACTIVITY_SERVICE;

/**
 * 系统帮助类
 */
public class SystemHelper {
    /**
     * 判断本地是否已经安装好了指定的应用程序包
     *
     * @param packageNameTarget ：待判断的 App 包名，如 微博 com.sina.weibo
     * @return 已安装时返回 true,不存在时返回 false
     */
    public static boolean appIsExist(Context context, String packageNameTarget) {
        if (!"".equals(packageNameTarget.trim())) {
            PackageManager packageManager = context.getPackageManager();
            List<PackageInfo> packageInfoList = packageManager.getInstalledPackages(PackageManager.MATCH_UNINSTALLED_PACKAGES);
            for (PackageInfo packageInfo : packageInfoList) {
                String packageNameSource = packageInfo.packageName;
                if (packageNameSource.equals(packageNameTarget)) {
                    return true;
                }
            }
        }
        return false;
    }

    /**
     * 将本应用置顶到最前端
     * 当本应用位于后台时，则将它切换到最前端
     *
     * @param context
     */
    public static void setTopApp(Context context) {

//                 * (1)在manifest配置文件中配置了scheme参数
//                * (2)网络端获取url
//                * (3)跳转
//                */
        String url = "common_plugin://mtime";
//        String url = "common_plugin://mtime/goodsDetail?goodsId=10011002";

        Intent intent = new Intent(Intent.ACTION_VIEW,
                Uri.parse(url));
        context.startActivity(intent);

//        if (!isRunningForeground(context)) {}
        /**获取ActivityManager*/
//            ActivityManager activityManager = (ActivityManager) context.getSystemService(ACTIVITY_SERVICE);
//
//            /**获得当前运行的task(任务)*/
//            List<ActivityManager.RunningTaskInfo> taskInfoList = activityManager.getRunningTasks(100);
//            for (ActivityManager.RunningTaskInfo taskInfo : taskInfoList) {
//                /**找到本应用的 task，并将它切换到前台*/
//                if (taskInfo.topActivity.getPackageName().equals(context.getPackageName())) {
//                    activityManager.moveTaskToFront(taskInfo.id, 0);
//                    break;
//                }
//            }
//        }
    }

    /**
     * 判断本应用是否已经位于最前端
     *
     * @param context
     * @return 本应用已经位于最前端时，返回 true；否则返回 false
     */
    public static boolean isRunningForeground(Context context) {
        ActivityManager activityManager = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
        List<ActivityManager.RunningAppProcessInfo> appProcessInfoList = activityManager.getRunningAppProcesses();
        /**枚举进程*/
        for (ActivityManager.RunningAppProcessInfo appProcessInfo : appProcessInfoList) {
            if (appProcessInfo.importance == ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND) {
                if (appProcessInfo.processName.equals(context.getApplicationInfo().processName)) {
                    return true;
                }
            }
        }
        return false;
    }
}