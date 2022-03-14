import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common_plugin/src/network/debug_request/custom_request_model.dart';

class HttpRequestParamsWidget extends StatefulWidget {
  final CustomRequestModel model;

  HttpRequestParamsWidget(this.model);

  @override
  _HttpRequestParamsWidgetState createState() =>
      _HttpRequestParamsWidgetState();
}

class _HttpRequestParamsWidgetState extends State<HttpRequestParamsWidget> {
  TextEditingController _urlControl = new TextEditingController();
  TextEditingController _paramsControl = new TextEditingController();
  TextEditingController _responseControl = new TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.model?.responseControl = _responseControl;
  }

  @override
  void dispose() {
    _urlControl?.dispose();
    _paramsControl?.dispose();
    _responseControl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _getAttention(),
              _urlFiled(),
              _paramsFiled(),
              _getMethod(),
              RaisedButton(
                onPressed: () {
                  widget?.model?.request();
                },
                child: Text("发起请求"),
              ),
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                // color: Colors.red,
                child: Text("响应数据:"),
                width: double.infinity,
              ),
              _getResponseWidget()
            ],
          ),
        ));
  }

  _urlFiled() {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4), color: Colors.grey),
      child: TextField(
        maxLines: null,
        // maxLines: 100,
        keyboardType: TextInputType.multiline,
        controller: _urlControl,
        decoration: InputDecoration(
//                    focusedBorder: OutlineInputBorder(
//                      borderSide: BorderSide(width:1.0,style: BorderStyle.solid,color: Colors.grey)),
          border: OutlineInputBorder(
              borderSide: BorderSide(width: .0, style: BorderStyle.none)),
          hintText: "输入url如:http://192.168.1.0:8080/nani",
        ),
        onChanged: (content) {
          widget?.model?.requestUrl = content;
        },
        autofocus: false,
      ),
    );
  }

  _paramsFiled() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.only(top: 20, bottom: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4), color: Colors.grey),
      child: TextField(
        maxLines: null,
        // maxLines: 100,
        keyboardType: TextInputType.multiline,
        controller: _paramsControl,
        decoration: InputDecoration(
//                    focusedBorder: OutlineInputBorder(
//                      borderSide: BorderSide(width:1.0,style: BorderStyle.solid,color: Colors.grey)),
            border: OutlineInputBorder(
                borderSide: BorderSide(width: .0, style: BorderStyle.none)),
            hintText: "输入json格式入参"),
        onChanged: (content) {
          widget?.model?.requestParams = content;
        },
        autofocus: false,
      ),
    );
  }

  Widget _getMethod() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("请求方式:  GET"),
        Radio(
          value: 1,
          groupValue: widget?.model?.requestMethod,
          onChanged: (value) {
            setState(() {
              widget?.model?.requestMethod = 1;
            });
          },
        ),
        SizedBox(width: 20),
        Text("POST"),
        Radio(
          value: 2,
          groupValue: widget?.model?.requestMethod,
          onChanged: (value) {
            setState(() {
              widget?.model?.requestMethod = 2;
            });
          },
        )
      ],
    );
  }

  _getResponseWidget() {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4), color: Colors.grey),
      child: TextField(
        maxLines: null,
        // maxLines: 100,
        // enabled: false,
        keyboardType: TextInputType.multiline,
        controller: _responseControl,
        decoration: InputDecoration(
//                    focusedBorder: OutlineInputBorder(
//                      borderSide: BorderSide(width:1.0,style: BorderStyle.solid,color: Colors.grey)),
            border: OutlineInputBorder(
                borderSide: BorderSide(width: .0, style: BorderStyle.none)),
            hintText: "Hi man"),
        onChanged: (content) {},
        autofocus: false,
      ),
    );
  }

  _getAttention() {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Text(
        "注: 发起请求时，客户端会默认拼接上所有基本参数，然后签名发送",
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
