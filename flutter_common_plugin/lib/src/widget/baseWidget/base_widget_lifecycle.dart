///页面生命周期相关方法
abstract class BaseWidgetLifeCycle {
  ///页面是否在 最前面的标识
  bool isInFront = true;

  void logePageCycle(String cycle) {
    print("页面-${toString()}--${this.toString()}-$cycle");
  }

  ///页面消失时调取
  void onPause() {
    logePageCycle("onPause");
  }

  ///页面创建时调取
  void onCreate() {
    logePageCycle("onCreate");
  }

  ///页面销毁时调取
  void onDestroy() {
    logePageCycle("onDestory");
  }

  ///页面重现时调取
  void onResume() {
    logePageCycle("onResume");
  }

  bool isListenLifeCycle() {
    return true;
  }
}
