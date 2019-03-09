# flutter_base_widget

BaseWidget


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
| onCreate()				| int y 			|可见文本数，默认为5|
| onResume()	| float y      	    |被选中文字大小|
| onPause()				|Color color    	|被选中文字颜色|
| onDestory()			|  float y | 未被选中文字大小|
| setTopBarVisible|Color color | 未被选中文字颜色|
| setTopBarBackColor|Color color | 未被选中文字颜色|

| setAppBarVisible|Color color | 未被选中文字颜色|

| setAppBarContentColor|Color color | 未被选中文字颜色|

| setAppBarBackColor|Color color | 未被选中文字颜色|

| setErrorContent|Color color | 未被选中文字颜色|

| setErrorWidgetVisible|Color color | 未被选中文字颜色|
| setEmptyWidgetVisible|Color color | 未被选中文字颜色|

| setLoadingWidgetVisible|Color color | 未被选中文字颜色|

| setEmptyWidgetContent|Color color | 未被选中文字颜色|
| setErrorImage|Color color | 未被选中文字颜色|
| setEmptyImage|Color color | 未被选中文字颜色|
| setEmptyWidgetContent|Color color | 未被选中文字颜色|






用到的动态方法
```java

    hsMain.setData(strings);//设置数据源
   
    hsMain.setAnLeftOffset();//向左移动一个单元
    
    hsMain.setAnRightOffset();//向右移动一个单元
    
    hsMain.getSelectedString();//获得被选中的文本
    
    
```

## Tips
  很简单的使用方法，不熟悉自定义View的小伙伴可以跟着敲一遍，巩固自定义View。
