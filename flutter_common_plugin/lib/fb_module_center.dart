import 'package:flutter/material.dart';
import 'package:flutter_common_plugin/src/module/module_channel_utils.dart';
import 'package:flutter_common_plugin/src/utils/string_util/string_utils.dart';
import 'package:flutter_common_plugin/src/utils/url_utils.dart';

import 'base_lib.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver();

/// 组件化中心
class FBModuleCenter {
  /// 模块缓存
  static Map<Type, FBBaseModule> _modules = {};

  /// 模块路由缓存
  static final Map<String, FBModulePage> _routes = {};

  /// 添加模块和模块路由
  static void registerModule(FBBaseModule module) {
    _modules[module.runtimeType] = module;
    addRoutes(module.registerRoutes());
    FBChannelUtils.registerChannels(module.registerModuleChannel());
  }

  /// 获取模块列表
  static List<FBBaseModule> getModules() {
    return _modules.values;
  }

  /// 批量注册路由
  static void addRoutes(List<FBModulePage> pages) {
    pages?.forEach((page) {
      addRoute(page);
    });
  }

  /// 注册单个路由
  static void addRoute(FBModulePage page) {
    page?.route?.forEach((route) {
      _routes[route] = page;
    });
  }

  static Map<String, dynamic> transformMap(Map params) {
    params = params ?? {};
    Map<String, dynamic> newParams = {};
    try {
      params.forEach((key, value) {
        if (value != null) {
          newParams['$key'] = value;
        }
      });
    } catch (e, s) {
      FBError.printError("参数错误，参数不是Map<String,String> 类型", s);
    }
    return newParams;
  }

  static Map<String, FBModulePage> getRoutes() {
    return _routes;
  }

  static PageRoute generatorByRouteSetting(RouteSettings routeSettings) {
    String route = routeSettings.name.replaceAll("flutter_page://", "");
    String newRoute = route.split("?")[0];

    if (routeSettings != null && routeSettings.arguments == null) {
      routeSettings = routeSettings.copyWith(
          name: routeSettings.name, arguments: Map<String, dynamic>());
    }
    Map<String, dynamic> allParams = UrlUtils.getParams(
        route,
        ((routeSettings?.arguments ?? "") is Map)
            ? routeSettings.arguments
            : Map<String, dynamic>());

    FBModulePage modulePage = _routes[newRoute];

    if (!allParams.containsKey("pageTitle")) {
      allParams["pageTitle"] = modulePage?.pageTitle ?? "";
    }
    return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) {
          return modulePage?.builder(allParams) ?? null;
        });
  }

  ///生成页面路由
  ///[route] 路由
  ///[params] 传入的参数
  static PageRoute generatorRouteByPath(
    String route, {
    Map<String, dynamic> params,
    String title,
  }) {
    String newRoute = route.split("?")[0];

    FBModulePage fbModulePage = FBModuleCenter.getRoutes()[newRoute];

    if (params == null) {
      params = {"pageTitle": title ?? fbModulePage?.pageTitle ?? ""};
    } else if (!params.containsKey("pageTitle")) {
      params["pageTitle"] = title ?? fbModulePage?.pageTitle ?? "";
    }
    RouteSettings routeSettings = RouteSettings(arguments: params, name: route);
    return generatorByRouteSetting(routeSettings);
  }

  ///[url] 用WebView 打开url
  static Route generatorWebPageByRoute(String url, String title,
      bool useDefaultConfigForH5, Map<String, dynamic> params) {
    if (UrlUtils.isHttpUrl(url)) {
      params = UrlUtils.getParams(url, params);
      url = UrlUtils.spellUrlWithMap(url, params);
      return MaterialPageRoute(
          settings: RouteSettings(name: url),
          builder: (context) {
            return WebPage(
              url,
              title,
              useDefaultConfigForH5,
              params: params,
            );
          });
    } else {
      return generatorRouteByPath(url);
    }
  }

  ///[route] 是否是Flutter本地页面路由
  static bool isFlutterRoute(String route) {
    if (StringUtils.isEmpty(route)) return false;
    String newRoute = route.split("?")[0];
    return _routes.containsKey(newRoute);
  }

  static FBModulePage getModulePageByPath(String path) {
    try {
      return getRoutes()[path];
    } catch (e) {}
    return null;
  }
}
