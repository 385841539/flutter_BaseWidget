# flutter_base_widget

[App下载地址，点击下载](https://raw.githubusercontent.com/385841539/flutter_BaseWidget/master/apk/base_widget.apk)
或者扫描下方二维码安装：
<img src="https://img-blog.csdnimg.cn/20190329151153581.jpg"/>

BaseWidget使用效果图
<img  src="https://img-blog.csdnimg.cn/20190309103700606.gif" />

# 博客介绍
 
CSDN:[https://blog.csdn.net/iamdingruihaha/article/details/88319883](https://blog.csdn.net/iamdingruihaha/article/details/88319883)

# 功能介绍
1.  开发的时候，写一个类继承BaseWidget，就会让我们实现必要的抽象方法，俗称模**板模式**，当然，内嵌页面需要继承BaseInnerWidget，要做的事**一目了然**
2. 从一个页面A跳转到B的时候，A会调用onPause方法，B会调用onCreate和onResume方法，从B回到A的时候，A会调用onResume方法，B会调用onPause和onDestory方法 ，onCreate中放一些数据初始化，onResume中就放一下网络请求，每次回到页面都会发起请求，onPause和onDestory分别是离开页面和销毁页面，可以自己根据需求来完善方法。
3. 状态栏TopBar可以轻松隐藏和设置颜色以及**以图片作为背景**，
4. 导航栏AppBar同样可以轻松隐藏和设置背景颜色(图片)，其中导航栏中的左边返回键、中间的大标题、右面的小标题，可以随意设置隐藏和现实，当然可以重写他们的方法，随意设置自己的Widget，实现高度定制。
5. 内置了一个 错误加载页面 ，网络加载出错的时候 ，可以调个方法就显示，不用每个页面都写错误页面，避免需求变更时束手无策。
6. 内置一个无数据页面，和错误页面 使用方法和功能差不多
7. 内置了loading加载 页面 ，功能同上，觉得这个没必要的，可以自己用dialog替代~
8. 监听app退到后台和从后台返回到前台，要做什么功能在BaseWidget的方法里面直接写就好了
9. 重中之重，有了一个基类，拓展性就很高很高了~


# Usage
| 方法      	 		|    参数         	| 说明  					|
| ------------------------- |------------------ | --------------------- |
| onCreate()				| 无			|页面创建会走到的方法|
| onResume()	| 无     	    |页面只要来到用户视野就会走到的方法|
| onPause()				| 无     	    |页面只要离开用户视野就会走到的方法|
| onDestory()			|  无| 页面销毁走到的方法|
| setTopBarVisible|bool isVisible | 显示或者隐藏状态栏|
| setTopBarBackColor|Color color | 状态栏背景颜色|
| setAppBarVisible|bool isVisible | 显示或者隐藏导航栏|
| setAppBarBackColor|Color color | 导航栏背景颜色|
| setAppBarContentColor|Color color | 导航栏文字颜色|
|setAppBarTitle|String title|设置导航栏中间大标题|
|setAppBarRightTitle|String title|设置导航栏右边小标题|
|setBackIconHinde|bool|导航栏中隐藏返回键|
| setErrorWidgetVisible|bool isVisible |设置错误布局是否显示|
| setErrorContent|String content | 设置错误布局的内容提示|
| setErrorImage|String path|设置错误布局的占位图|
| setEmptyWidgetContent|String content|设置空布局的内容提示|
| setEmptyWidgetVisible|bool isVisible |设置空布局是否显示|
| setEmptyImage|String path|设置空布局的占位图|
| setLoadingWidgetVisible|bool isVisible |设置loading布局是否显示|
|showToast|String content|弹出吐司，参数还有可选的字体颜色，大小等|
|showToastDialog|String conetne|弹出对话框|

<b>当然如果觉得这些内置布局不是很符合需求，都可以重写对应的方法，让子类自己完善方法。</br>

### --------------2019年3月28更新网络请求封装--------------
网络请求封装结合BaseWidget使用，实现了
1. 自动加载loading，统一的请求错误处理，也可以单独处理请求结果
2. 页面销毁，网络请求可以自动取消，也可以不取消
3. 请求结果转化为实体类，方便使用
4. 调用很简单，在第三个tab页和二级页面中给出了模拟请求 ， 朋友可自行观看
5. 网络请求 封装步骤 可以查看HttpManger类，原理很简单，只是一些简单的封装调用，不过把rxDart揉进去了
6. 由于语法不是很熟，可能达不到 Android 网络请求rxJava 那种爽歪歪，但是调用确实很简洁。有建议的朋友欢迎提出~


## Tips
  实现思路和方法很简单，作为入门级的封装还是可以的，献丑了！
