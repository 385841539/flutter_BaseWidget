import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common_plugin/base_lib.dart';

class RadiusSelectedWidget extends StatefulWidget {
  ///展示的内容
  final List<dynamic> contents;

  ///默认选中的 选项
  final Set<int> selectedIndex;

  ///全选下标
  final int allSelectedIndex;

  ///全选文案
  final String allSelectedText;

  ///全不选文案
  final String allUnSelectedText;

  ///全选按钮是 点击是否转为非全选
  final bool boolAllSelectedIndexReverse;

  ///是否单选
  final bool singleChoice;
  final double width;

  ///选中的 item 样式构造
  final Widget Function(int, String) selectedBuilder;

  ///未选中的 item 样式构造
  final Widget Function(int, String) unSelectedBuilder;

  ///点击 选中的 item回调
  final Function(int, String) selected;

  ///点击未选中的 item 回调
  final Function(int, String) unSelected;

  ///选中某个item 的回调
  final Function(int) selectedCallback;

  ///取消选中某个item 的回调
  final Function(int) unSelectedCallback;

  ///头部 widget，可有可无
  final Widget topWidget;

  final RadiusSelectedControl radiusSelectedControl;

  ///子控件在主轴上的对齐方式
  final WrapAlignment alignment;

  ///主轴上子控件中间的间距
  final double spacing;

  ///子控件在交叉轴上的对齐方式
  final WrapAlignment runAlignment;

  ///交叉轴上子控件之间的间距
  final double runSpacing;

  ///交叉轴上子控件的对齐方式
  final WrapCrossAlignment crossAxisAlignment;

  /// 左右边距
  final double leftPadding;
  final double rightPadding;

  ///一行几个 ， 用于 默认 item 宽度的计算
  final int itemCount;
  final double itemHeight;

  const RadiusSelectedWidget(
    this.contents, {
    Key key,
    this.singleChoice = true,
    this.selectedBuilder,
    this.unSelectedBuilder,
    this.selectedCallback,
    this.unSelectedCallback,
    this.topWidget,
    this.radiusSelectedControl,
    this.alignment = WrapAlignment.start,
    this.spacing = 10,
    this.runAlignment = WrapAlignment.center,
    this.runSpacing = 20,
    this.crossAxisAlignment = WrapCrossAlignment.center,
    this.selectedIndex,
    this.allSelectedIndex,
    this.boolAllSelectedIndexReverse,
    this.allSelectedText,
    this.allUnSelectedText,
    this.width,
    this.selected,
    this.unSelected,
    this.leftPadding = 0,
    this.rightPadding = 0,
    this.itemCount = 4,
    this.itemHeight = 32,
  }) : super(key: key);

  @override
  _RadiusSelectedWidgetState createState() => _RadiusSelectedWidgetState();
}

class _RadiusSelectedWidgetState extends State<RadiusSelectedWidget> {
  Set<int> selectedIndex = {};
  List<dynamic> contents = [];

  Widget _getWrap() {
    return Container(
        // color: Colors.red,
        width: _getWidth(),
        padding: EdgeInsets.only(
            left: widget.leftPadding ?? 0, right: widget.rightPadding ?? 0),
        child: Container(
          color: Colors.white,
          child: Wrap(
            runSpacing: widget.runSpacing,
            spacing: widget.spacing,
            runAlignment: widget.runAlignment,
            alignment: widget.alignment,
            crossAxisAlignment: widget.crossAxisAlignment,
            children: [...generateChildren()],
          ),
        ));
  }

  @override
  void initState() {
    super.initState();

    if (widget.singleChoice ?? false) {
      ///如果是单选的话 则 selectedIndex 不能大于1

      if ((widget?.selectedIndex?.length ?? 0) > 1) {
        throw Exception(
            "单选模式下，选中长度 selectedIndex 长度不能大于1 ， 现在为${widget.selectedIndex.length}");
      }
    }

    contents = widget.contents;

    if (widget.selectedIndex != null && widget.selectedIndex.isNotEmpty) {
      selectedIndex.addAll(widget.selectedIndex);
    }

    ///把 选中 、未选中的赋值给control ，方便拿回调
    changeControlSelected();
    _addControlLis();
  }

  @override
  Widget build(BuildContext context) {
    return widget.topWidget == null
        ? _getWrap()
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [widget.topWidget, _getWrap()],
          );
  }

  List<Widget> generateChildren() {
    List<Widget> list = [];

    if (contents == null || contents.isEmpty) return [];

    for (int i = 0; i < contents.length; i++) {
      ///构造widget逻辑

      if (haveAllSelectTag() && widget.allSelectedIndex == i) {
        contents[i] =
            widget.allSelectedText ?? widget.contents[widget.allSelectedIndex];

        //处理 全选和全不选逻辑

        if (selectedIndex.contains(i)) {
          ///如果 全选被选中了 , 考虑是否存在 没有选中的， 如果有 直接取消 全选
          if (selectedIndex.length < contents.length) {
            selectedIndex.remove(i);
            contents[i] = widget.allSelectedText ??
                widget.contents[widget.allSelectedIndex];
          } else if (widget.boolAllSelectedIndexReverse ?? false) {
            contents[i] = widget.allUnSelectedText ??
                widget.contents[widget.allSelectedIndex];
          }
        } else {
          ///如果全选没有被选中 ，但是其余的都被选中了, 则 把 全选按钮也加进去
          if (contents.length == selectedIndex.length + 1) {
            selectedIndex.add(i);
            contents[i] = widget.allSelectedText ??
                widget.contents[widget.allSelectedIndex];
          }
        }
      }

      if (selectedIndex.contains(i)) {
        ///说明是选中的，去构造
        list.add(Container(
          // color: Colors.red,
          child: InkWell(
            child: _getSelectChild(i, _getContentString(contents[i])),
            onTap: () {
              _changeSelected(i, true);
              widget.unSelected?.call(i, _getContentString(widget.contents[i]));
            },
          ),
        ));
      } else {
        list.add(InkWell(
          onTap: () {
            _changeSelected(i, false);
            widget.selected?.call(i, _getContentString(widget.contents[i]));
          },
          child: _getUnSelectChild(i, _getContentString(contents[i])),
        ));
      }
    }

    return list;
  }

  double _getDefaultItemWidth() {
    return (_getWidth() -
            (widget.leftPadding ?? 0) -
            (widget.rightPadding ?? 0) -
            (widget.spacing ?? 0) * ((widget.itemCount ?? 4) - 1)) /
        (widget.itemCount ?? 4);
  }

  getDefaultSelectedWidget(int i, String string) {
    return Container(
      alignment: Alignment.center,
      width: _getDefaultItemWidth(),
      height: 32,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(45)),
          border: Border.all(width: 1, color: _getSelectedColor()),
          color: Colors.white),
      child: Text(
        "$string",
        style: TextStyle(
            color: _getSelectedColor(),
            fontSize: "${string}".length > 3 ? 14 : 16),
      ),
    );
  }

  getDefaultUnSelectedWidget(int i, String string) {
    return Container(
      alignment: Alignment.center,
      width: _getDefaultItemWidth(),
      height: 32,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(45)),
          border: Border.all(width: 1, color: _getUnSelectedColor()),
          color: Colors.white),
      child: Text(
        "$string",
        style: TextStyle(
            color: _getUnSelectedColor(),
            fontSize: "$string".length > 3 ? 14 : 16),
      ),
    );
  }

  ///未选中部分
  Widget _getSelectChild(int i, String string) {
    if (widget.selectedBuilder == null) {
      return getDefaultSelectedWidget(i, _getContentString(contents[i]));
    } else {
      return widget.selectedBuilder.call(i, _getContentString(contents[i]));
    }
  }

  bool haveAllSelectTag() {
    return widget.allSelectedIndex != null;
  }

  bool isReserveAllSelectTag() {
    return widget.allSelectedIndex != null &&
        widget.boolAllSelectedIndexReverse != null &&
        widget.boolAllSelectedIndexReverse;
  }

  ///构造未选中部分
  Widget _getUnSelectChild(int i, String string) {
    if (widget.unSelectedBuilder == null) {
      return getDefaultUnSelectedWidget(i, _getContentString(contents[i]));
    } else {
      return widget.unSelectedBuilder.call(i, _getContentString(contents[i]));
    }
  }

  void _changeSelected(int index, bool isSelectToUnselected) {
    /// 取消选中
    if (isSelectToUnselected) {
      ///做选中到取消处理逻辑

      if (haveAllSelectTag() && index == widget.allSelectedIndex) {
        if (isReserveAllSelectTag()) {
          ///如果是取消 全部选中，则清空即可
          selectedIndex.clear();
        } else {
          ///这里不需要 转换， 此处是 全选选中了 ， 但是没有反选 机制
          return;
        }
      } else {
        selectedIndex.remove(index);
        if (haveAllSelectTag() &&
            selectedIndex.contains(widget.allSelectedIndex)) {
          //全选按钮 取消选中状态
          selectedIndex.remove(widget.allSelectedIndex);
        }
      }
    } else {
      ///做未选中处理逻辑
      if (haveAllSelectTag() && widget.allSelectedIndex == index) {
        ///是全选的话
        selectedIndex.clear();

        for (int i = 0; i < contents.length; i++) {
          selectedIndex.add(i);
        }
      } else {
        if (widget.singleChoice ?? false) {
          selectedIndex.clear();
        }
        selectedIndex.add(index);
        if (haveAllSelectTag() && selectedIndex.length >= contents.length - 1) {
          if (!selectedIndex.contains(widget.allSelectedIndex)) {
            selectedIndex.add(widget.allSelectedIndex);
          }
        }
      }
    }

    changeControlSelected();
    setState(() {});
  }

  void changeControlSelected() {
    if (widget.radiusSelectedControl != null) {
      widget.radiusSelectedControl._selectedIndex.clear();
      widget.radiusSelectedControl._unSelectedIndex.clear();
      for (int i = 0; i < contents.length; i++) {
        if (selectedIndex.contains(i)) {
          widget.radiusSelectedControl._selectedIndex.add(i);
        } else {
          widget.radiusSelectedControl._unSelectedIndex.add(i);
        }
      }
    }
  }

  _getSelectedColor() {
    return Color(0XFF2878FF);
  }

  _getUnSelectedColor() {
    return Color(0XFF656B7E);
  }

  void _addControlLis() {
    if (widget.radiusSelectedControl != null) {
      widget.radiusSelectedControl._select = (int index) {
        ///去选中

        if (!selectedIndex.contains(selectedIndex)) {
          selectedIndex.add(index);
        }
        changeControlSelected();

        setState(() {});
      };

      widget.radiusSelectedControl._unSelect = (int index) {
        ///取消选中
        if (selectedIndex.contains(selectedIndex)) {
          selectedIndex.remove(index);
        }
        changeControlSelected();
        setState(() {});
      };

      widget.radiusSelectedControl._dispose = () {
        ///取消选中
        selectedIndex?.clear();
        contents?.clear();
      };

      widget.radiusSelectedControl._selectAll = () {
        ///全选

        for (int i = 0; i < contents.length; i++) {
          selectedIndex.add(i);
        }
        changeControlSelected();

        setState(() {});
      };

      widget.radiusSelectedControl._unSelectAll = () {
        ///全不选
        selectedIndex.clear();
        changeControlSelected();
        setState(() {});
      };
    }
  }

  _getWidth() {
    return widget.width ?? MediaQuery.of(context).size.width;
  }

  String _getContentString(content) {
    if (content == null) {
      return "";
    }
    if (content is String || content is num || content is bool) {
      return "$content";
    }
    return "${content.toString()}";
  }
}

class RadiusSelectedControl {
  Set<int> _selectedIndex = {};

  Set<int> _unSelectedIndex = {};

  ///获取选中数据下标
  Set<int> get selectedIndex => _selectedIndex;

  ///获取未选中数据下标
  Set<int> get unSelectedIndex => _unSelectedIndex;

  ///选择某一个
  void select(int index) {
    _select?.call(index);
  }

  ///全选
  void selectAll() {
    _selectAll?.call();
  }

  ///全不选
  void unSelectAll() {
    _unSelectAll?.call();
  }

  ///取消选择某一个
  void unSelect(int index) {
    _unSelect?.call(index);
  }

  void dispose() {
    _dispose?.call();
    _selectedIndex?.clear();
    _selectedIndex?.clear();
  }

  Function(int) _select;

  Function(int) _unSelect;

  Function() _selectAll;

  Function() _unSelectAll;
  Function() _dispose;

  ///选择某个集合
  void selectSet(Set<int> set) {
    if (set != null) {
      set.forEach((element) {
        _select?.call(element);
      });
    }
  }
}
