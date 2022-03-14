class Retry {
  ///有错误时是否重试请求 ,默认不重试
  bool isRetry;

  ///重试请求次数，默认三次
  int retryTime;

  ///重试请求的间隔，以毫秒为计量，默认间隔1000毫秒，即1秒
  int retryDelay;

  Retry({this.isRetry = true, this.retryTime = 3, this.retryDelay = 1000});
}
