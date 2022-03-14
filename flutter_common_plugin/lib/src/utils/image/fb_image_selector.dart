import 'package:multi_image_picker/multi_image_picker.dart';

class FBImageSelector {
  static Future<List<Asset>> openImageSelector(
      {int maxSelect = 9,
      bool enableCamera,
      bool startInAllView,
      String allViewTitle,
      String actionBarColor,
      String textOnNothingSelected,
      String selectionLimitReachedText}) {
    return MultiImagePicker.pickImages(
      //最多选择几张照片
      maxImages: maxSelect ?? 9,
      //是否可以拍照
      enableCamera: enableCamera ?? true,
      materialOptions: MaterialOptions(
          startInAllView: startInAllView ?? true,
          allViewTitle: allViewTitle ?? '所有照片',
          actionBarColor: actionBarColor ?? '#2196F3',
          //未选择图片时提示
          textOnNothingSelected: textOnNothingSelected ?? '没有选择照片',
          //选择图片超过限制弹出提示
          selectionLimitReachedText:
              selectionLimitReachedText ?? "最多选择$maxSelect张照片"),
    );
    //
    // //最多选择几张照片
    // maxImages: 9,
    // //是否可以拍照
    // enableCamera: true,
    // selectedAssets: _img,
    // materialOptions: MaterialOptions(
    // startInAllView: true,
    // allViewTitle: '所有照片',
    // actionBarColor: '#2196F3',
    // //未选择图片时提示
    // textOnNothingSelected: '没有选择照片',
    // //选择图片超过限制弹出提示
    // selectionLimitReachedText: "最多选择9张照片"
    // ),
  }
}
