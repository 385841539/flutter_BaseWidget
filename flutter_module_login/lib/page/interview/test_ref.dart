void main() {
  testRef();
}

void testRef() {
  TestChannel testChannel = TestChannel();
  testChannel.name = "初始name";
  print(" 测试 自定义对象是值传递还是引用传递---------");
  print("改变前的值:${testChannel.name}");
  changeName(testChannel);
  print("改变后的值:${testChannel.name}");
  print("\r\n\r\n\r\n");

  print(" 测试 int对象是值传递还是引用传递---------");
  int a = 10;
  int b = a;
  // b.
  print("改变前的值:${a}---hashCode:${a.hashCode}---${a.toString()}");
  changeIntValue(a);
  print("改变后的值:${a}---hashCode:${a.hashCode}---${a.toString()}");
}

void changeIntValue(int a) {
  a = 11;
  String text="1";
  int.parse(text);
}

void changeName(TestChannel testChannel) {
  testChannel.name = "改变后的name";
  // testChannel = TestChannel(name: "改变后的name");
}

class TestChannel {
  TestChannel({this.name});

  String name;
  String path;
}

//
// class myInt implements int{
//
//
// }

abstract class A {
  code();
}

abstract class B {
  code();
}

mixin C {
  code();
}

abstract class D {
  code();
}

mixin F implements A {}
mixin G implements A {}

mixin H on B {}
//
// class D extends C {}D

abstract class E extends B with G, H implements A, C {}
