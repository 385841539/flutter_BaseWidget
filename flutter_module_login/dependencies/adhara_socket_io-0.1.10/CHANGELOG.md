## 0.1.10 - 26th February, 2019

* `clearInstance` BugFix on iOS

## 0.1.9 - 21st January, 2019

* BugFix for iOS running on iPhone 6

## 0.1.8 - 17th January, 2019

* Optimized serialization code for Android
* Bug fix for Map representation characters/reserved characters for map representation as a string (`=` and `/`)

## 0.1.7 - 17th January, 2019

* Disabling unnecessary logging of events in platform implementations in both Android and iOS,
can enable if required by passing `enableLogging: true` to `createInstance`

## 0.1.6 - 28th November, 2018

* Android and iOS data serialization handled properly to send objects and arrays

## 0.1.4 - 28th November, 2018

* Android query bug: Extra ? is being sent. fixed

## 0.1.3 - 21st November, 2018

* Added support for socket.io handshake query params for both iOS and Android

## 0.1.2 - 20th November, 2018

* Fully working version of basic Socket.io connection for both Android and iOS
