import 'package:flutter/material.dart';

class FBProgressText extends StatefulWidget {
  final String text;

  final ValueNotifier<String> progressChange;

  FBProgressText({this.text, this.progressChange});

  @override
  _FBProgressTextState createState() =>
      _FBProgressTextState(text, progressChange: progressChange);
}

class _FBProgressTextState extends State<FBProgressText> {
  String content;
  final ValueNotifier<String> progressChange;

  _FBProgressTextState(this.content, {this.progressChange});

  @override
  void initState() {
    super.initState();
    progressChange?.addListener(() {
      if (mounted) {
        setState(() {
          content = progressChange.value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(content);
  }
}
