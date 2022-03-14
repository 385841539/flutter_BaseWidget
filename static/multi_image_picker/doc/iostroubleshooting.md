## Objective-C Module not found

If you are getting error like this:

!> Underlying Objective-C module 'BSGridCollectionViewLayout' not found

Make sure you followed those steps:

1. **Create a Bridging Header.**

If you've created the project using `flutter create -i swift [projectName]` you are all set. If not, you can enable Swift support by opening the project with XCode, then choose `File -> New -> File -> Swift File`. XCode will ask you if you wish to create Bridging Header, click yes.

2. Make sure you have `!use_frameworks` in the Runner block, in `ios/Podfile`

3. Make sure you have Swift version 4.2 selected in you XCode -> Build Settings

4. Do `flutter clean`

5. Go to your `ios` folder, delete Podfile.lock and Pods folder and then execute `pod install --repo-update`