
void main(){




  try{

    List<TestModel> list= Test.fromJsonList([]);

  }catch(e){

    print(e.toString());

  }


  // print("--111---");


}


class Test{

  static List<TestModel> fromJsonList(dynamic jsonList) {
    if (jsonList is! List) return [];
    return (jsonList as List)
        .map((e) => TestModel.fromJson(e))
        .toList(growable: false).cast();
  }

}


class TestModel{

  String model;

  TestModel.fromJson(Map<String, dynamic> json) {

    model=json["model"];
  }



}