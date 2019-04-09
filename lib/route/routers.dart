import 'package:fluro/fluro.dart';
import 'package:flutter_base_widget/route/router_handler.dart';

class Routes {
  static String root = "/";

  static void configureRoutes(Router router) {
//    router.notFoundHandler=Handler()

    router.define(root, handler: homeHandler);
  }
}
