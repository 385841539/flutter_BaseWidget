package com.ruedy.flutter_base_lib;

public class TestRef {

    public static void main(String[] args) {

        TestDemo testDemo1 = new TestDemo("testDemo1");
        TestDemo testDemo2 = testDemo1;


        System.out.println("改变前：");
        System.out.println("testDemo1的name:"+testDemo1.name);
        System.out.println("testDemo2的name:"+testDemo2.name);
        changeTestDemo(testDemo2);

        System.out.println("改变后：");
        System.out.println("testDemo1的name:"+testDemo1.name);
        System.out.println("testDemo2的name:"+testDemo2.name);



    }

    private static void changeTestDemo(TestDemo testDemo2) {

        testDemo2 = null;
    }
}


class TestDemo {

    String name;

    public TestDemo(String name) {
        this.name = name;
    }
}