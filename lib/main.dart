import 'package:flutter/material.dart';
import 'package:crpapp/screens/question.dart';
import 'package:crpapp/screens/final.dart';
import 'package:crpapp/screens/home.dart';
import 'package:firebase_storage/firebase_storage.dart';


// new version now
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget{

  @override
  Widget build (BuildContext context){
    return new MaterialApp(
      title: 'Navigation',
      routes: <String, WidgetBuilder>{
        '/Home':(BuildContext context) => new Home(),
        '/Question':(BuildContext context) => new Question(),
        '/Final':(BuildContext context) => new Final(),


      },
      home: new Home(),
    );
  }

}