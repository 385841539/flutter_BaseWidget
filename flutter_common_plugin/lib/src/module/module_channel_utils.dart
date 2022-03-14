import 'dart:async';

import 'package:flutter_common_plugin/base_lib.dart';

///组件间通信工具
class FBChannelUtils {
  static Future requestChannel(String path, {Map<String, dynamic> params}) {
    Completer completer = Completer();
    _generatorChannelFuture(path, params, completer);
    return completer.future;
  }

  ///组件间通信
  static void _generatorChannelFuture(
      String path, Map<String, dynamic> params, Completer<dynamic> completer) {
    if (StringUtils.isEmpty(path)) {
      completer?.completeError(FBError(400, "传入的path为空"));
    } else {
      if (!_channels.containsKey(path)) {
        completer?.completeError(FBError(404, "没找到$path 相关通信路由"));
      } else {
        FBModuleChannel moduleChannel = _channels[path];
        moduleChannel.invoke(params, completer);
      }
    }
  }

  static final Map<String, FBModuleChannel> _channels = {};

  ///[registerChannel] 批量注册事件
  static void registerChannels(List<FBModuleChannel> channels) {
    if (channels != null) {
      channels.forEach((moduleChannel) {
        registerChannel(moduleChannel);
      });
    }
  }

  ///[channel] 注册 channel 所对应的事件
  static void registerChannel(FBModuleChannel channel) {
    if (channel != null && StringUtils.isNotEmpty(channel.route)) {
      ///此处为了规范， 做了 命名规范，
      /// 路由必须以 flutter_function://开头，

      if (channel.route.startsWith("flutter_function://")) {
        _channels[channel.route] = channel;
      } else {
        throw Exception("${channel.route}不符合协议规范，必须以 'flutter_function://'开头");
      }
    }
  }

  ///[channel] 移除 channel 所对应的 监听事件
  static void removeChannel(FBModuleChannel channel) {
    if (channel != null &&
        StringUtils.isNotEmpty(channel.route) &&
        _channels.containsKey(channel.route)) {
      _channels.remove(channel.route);
    }
  }

  ///[route] 移除 channel 所对应的 监听事件
  static void removeChannelByPath(String route) {
    if (StringUtils.isNotEmpty(route) && _channels.containsKey(route)) {
      _channels.remove(route);
    }
  }
}
