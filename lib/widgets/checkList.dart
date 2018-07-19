import 'package:flutter/material.dart';
import 'package:crpapp/questionData.dart' as myQuestions;
import 'package:crpapp/screens/question.dart' as questionState;




class CheckList {

  List<Widget> ListMyWidgets() {

    bool _isChecked=false;

    void onChanged(bool value){
      _isChecked = value;



    }

    List<String> mySet = myQuestions.allAnswersSets[myQuestions.currentQuestion];

    List<Widget> list = new List();
    for (int i = 0; i<mySet.length; i++) {
      print (mySet[i]);
      list.add(new CheckboxListTile(
          title: new Text(mySet[i]),
          activeColor: Colors.red,
          secondary: const Icon (Icons.home),
          value: _isChecked,
          onChanged: (bool value) {
            onChanged(value);
          }
      )
      );
    }

    return list;
  }

/*  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      padding: new EdgeInsets.all(45.0),
      child: new Column(
        children: <Widget>[



        ],
      )
    );
  }*/

}