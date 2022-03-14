import 'package:flutter/cupertino.dart';

class MainRoute extends NavigatorObserver{

  @override
  void didPush(Route route, Route previousRoute) {
    // TODO: implement didPush
    super.didPush(route, previousRoute);
    print("--MainRoute--1-didPush"+route.toString()+"---"+previousRoute.toString());
  }

  @override
  void didPop(Route route, Route previousRoute) {
    // TODO: implement didPop
    super.didPop(route, previousRoute);
    print("--MainRoute--1-didPop"+route.toString()+"---"+previousRoute.toString());

  }


  @override
  void didRemove(Route route, Route previousRoute) {
    // TODO: implement didRemove
    super.didRemove(route, previousRoute);
    print("--MainRoute---didRemove"+route.toString()+"---"+previousRoute.toString());

  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    // TODO: implement didReplace
    print("--MainRoute---didReplace"+newRoute.toString()+"---"+oldRoute.toString());

  }

  @override
  void didStopUserGesture() {
    // TODO: implement didStopUserGesture
    super.didStopUserGesture();
    print("--MainRoute---didStopUserGesture");

  }

  @override
  void didStartUserGesture(Route route, Route previousRoute) {
    // TODO: implement didStartUserGesture
    super.didStartUserGesture(route, previousRoute);
    print("--MainRoute---didStartUserGesture"+route.toString()+"---"+previousRoute.toString());

  }
}