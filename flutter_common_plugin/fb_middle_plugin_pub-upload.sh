#!/bin/bash


versionCode=`cat pubspec.yaml  | egrep "version" | awk -F '[:,]+' '{print $2}'| sed -n '1p'`

echo ------------------------------------------------------
echo ------------------------------------------------------
echo 上传的版本号是:    $versionCode
echo ------------------------------------------------------
echo ------------------------------------------------------



 function upLoad() {


    flutter  packages pub publish --server=http://106.14.226.59:8081
#


}


 function checkIsReleaseVersion( ) {

  if  echo $versionCode |grep -q [A-Za-z_+=\~@#%^] ;then
        echo "fail!!!!release版本号$versionCode 含有无效字符,请检查后重新上传"
  else
        echo "$versionCode release版本校验通过，准备上传~"
        upLoad true
  fi


}

 checkIsDebugVersion() {

  if  echo $versionCode |grep -q [A-Za-z] ;then
         echo "$versionCode debug版本校验通过，准备上传~"
         upLoad false
  else
        echo "fail!!!!debug版本号 $versionCode 必须要含有 SNAPSHOT 类似的字符串"
  fi


}

read -p "请输入上传的是release还是debug: " result  #提示用户输入数字
if [ -z $result ];then             #判断用户是否输入，如果未输入则打印error
  echo "未输入相关信息"
  exit
else
  if [ $result == "release" ]; then
     checkIsReleaseVersion
  elif [ $result == "debug" ]; then
      checkIsDebugVersion
  else echo "输入不正确只能输入release或debug"
  fi
fi


