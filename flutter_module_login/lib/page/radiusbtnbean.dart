class RadiusTestBean {
  String name;

  int age;

  bool isSelected;

  RadiusTestBean(this.name, this.age, this.isSelected);

  @override
  String toString() {
    // TODO: implement toString
    return name ?? "";
  }
}
