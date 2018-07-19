import 'package:flutter/material.dart';
import 'package:crpapp/main.dart';
import 'package:crpapp/widgets/checkList.dart';
import 'package:flutter/services.dart';

import 'package:crpapp/questionData.dart' as myQuestions;




class Question extends StatefulWidget{


  @override
  _State createState() => new _State();

}


void checkSetText(BuildContext context, TextEditingController _controller){

  if (myQuestions.answerTypes[myQuestions.currentQuestion][0] == 'text') {
    _controller.text = myQuestions.allResponses[myQuestions.currentQuestion][0];
  }

}


class _State extends State<Question>{



  List<String> mySet = [];

List<String> _thisQuestion;

int _currentQuestion;

List<bool> _isChecked = new List<bool>();

bool buildSublist=false;

bool skipToEnd = false;

  String _otherText1='';
  String _otherText2='';

  List<String> _toRemove = [];

final TextEditingController _controller = new TextEditingController();
  final TextEditingController _controllerA = new TextEditingController();
  final TextEditingController _controllerB = new TextEditingController();

@override
void initState() {
  super.initState();

  _currentQuestion = myQuestions.currentQuestion;
  _thisQuestion = myQuestions.allQuestions[_currentQuestion];

  List<String> mySet = myQuestions.allAnswersSets[myQuestions.currentQuestion];
  _isChecked.length=0;
  for (int j=0; j<mySet.length+1; j++){
    _isChecked.add(false);
  }



    buildSublist = false;
    _thisQuestion = myQuestions.allQuestions[_currentQuestion];






}

/*_State(){


  _myQuestions.setQuestions();
  _myQuestions.setAnswerFormat();


}*/

void _nextQuestion(BuildContext context){

  print(myQuestions.allResponses[myQuestions.currentQuestion]);

  if (_toRemove.length>0){
    for (int i=0; i<_toRemove.length; i++){
      myQuestions.allResponses[myQuestions.currentQuestion].remove(_toRemove[i]);
    }
  }

  if (_otherText1 !=''){
    print ('other 1 is '+_otherText1);
    myQuestions.allResponses[myQuestions.currentQuestion].add('Other: '+_otherText1);
  }
  if (_otherText2 !=''){
    myQuestions.allResponses[myQuestions.currentQuestion].add('Other: '+_otherText2);
  }

  _otherText1 ='';
  _otherText2 ='';
  _toRemove=[];

  if (skipToEnd == false && myQuestions.currentQuestion < myQuestions.allQuestions.length-1) {


    _controller.clear();
    _controllerA.clear();
    _controllerB.clear();

    myQuestions.currentQuestion++;
    _currentQuestion = myQuestions.currentQuestion;

    List<String> mySet = myQuestions.allAnswersSets[myQuestions.currentQuestion];
   _isChecked.length=0;
    for (int j=0; j<mySet.length+1; j++){
      _isChecked.add(false);
    }

    setState(() {
      FocusScope.of(context).requestFocus(new FocusNode());
      buildSublist = false;
      _thisQuestion = myQuestions.allQuestions[_currentQuestion];
    });
  }else{
    print ('about to end');
    myQuestions.theFinalQuestion = myQuestions.currentQuestion+1;
    Navigator.of(context).pushNamed('/Final');

  }



}

  void _previousQuestion(BuildContext context){

  if (myQuestions.currentQuestion >= 1) {




    if (_toRemove.length>0){
      for (int i=0; i<_toRemove.length; i++){
        myQuestions.allResponses[myQuestions.currentQuestion].remove(_toRemove[i]);
      }
    }

    if (_otherText1 !=''){
      myQuestions.allResponses[myQuestions.currentQuestion].add('Other: '+_otherText1);
    }
   if (_otherText2 !=''){
      myQuestions.allResponses[myQuestions.currentQuestion].add('Other: '+_otherText2);
    }

    _otherText1 ='';
    _otherText2 ='';
    _toRemove=[];



    _controller.clear();
    _controllerA.clear();
    _controllerB.clear();

    if (buildSublist==false) {

      myQuestions.currentQuestion--;

    }else{
      buildSublist=false;
    }


    _currentQuestion = myQuestions.currentQuestion;

    _isChecked.length=0;
    List<String> mySet = myQuestions.allAnswersSets[myQuestions.currentQuestion];
    for (int j=0; j<mySet.length+1; j++){
      _isChecked.add(false);
    }


    setState(() {
      FocusScope.of(context).requestFocus(new FocusNode());
      buildSublist = false;
      _thisQuestion = myQuestions.allQuestions[_currentQuestion];
    });
  }

  }



  List<Widget> ListMyWidgets() {

    List<String> _currentAnswer=[];
    List<String> _otherAnswers=['none','none'];




    void onChanged(bool value, int index){

      print ('in on changed');

      setState(() {
        _isChecked[index] = value;
        if (value){
          myQuestions.allResponses[myQuestions.currentQuestion].add(
              mySet[index]);
        }else{
          myQuestions.allResponses[myQuestions.currentQuestion].remove(
              mySet[index]);
        }
        print ('answer list is '+myQuestions.allResponses[myQuestions.currentQuestion].toString());
      });

    }


int _otherCount=0;

    print (myQuestions.allResponses[myQuestions.currentQuestion]);

    List<Widget> list = new List();
    for (int i = 0; i<mySet.length; i++) {

      print ('check list '+mySet[i]);


      if (myQuestions.allResponses[myQuestions.currentQuestion].contains(mySet[i])) {
        _isChecked[i] = true;
      }else{
        _isChecked[i] = false;
      }

      //// make question type using other to add other input files

      if (mySet[i]=='other'){

        int putCount=0;

        if (myQuestions.allResponses[myQuestions.currentQuestion].length>0) {
          for (int i = 0; i <
              myQuestions.allResponses[myQuestions.currentQuestion].length;
          i++) {
            if (myQuestions.allResponses[myQuestions.currentQuestion][i]
                .contains('Other: ')) {
              _otherAnswers[putCount] =
              (myQuestions.allResponses[myQuestions.currentQuestion][i]);
              String tempHolder = myQuestions.allResponses[myQuestions.currentQuestion][i];
              if (putCount==0){_otherText1=tempHolder.replaceAll("Other: ","");}
              if (putCount==1){_otherText2=tempHolder.replaceAll("Other: ","");}

              print ('other one when made is '+_otherText1);

              putCount++;
             _toRemove.add(myQuestions.allResponses[myQuestions.currentQuestion][i]);

            }
          }
        }

        if (_otherCount==0) {
          list.add(new ListTile(
            leading: const Icon(Icons.person),
            title: new TextField(
              autofocus: true,
              controller: _controllerA,
              onChanged: (String value) {
                _otherText1 = value;
              },
              maxLines: 1,
              autocorrect: false,
              keyboardType: TextInputType.text,
              decoration: new InputDecoration(

                hintText: '',
                labelText: 'Other - Type here:',

              ),

            ),
          ),
          );
        }

        _controllerA.text=_otherAnswers[0].replaceAll("Other: ","");

        if (_otherCount==1) {
          list.add(new ListTile(
            leading: const Icon(Icons.person),
            title: new TextField(
              autofocus: true,
              controller: _controllerB,
              onChanged: (String value) {
                _otherText2 = value;
              },
              maxLines: 1,
              autocorrect: false,
              keyboardType: TextInputType.text,
              decoration: new InputDecoration(

                hintText: '',
                labelText: 'Other - Type here:',

              ),

            ),
          ),
          );
        }

        _controllerB.text=_otherAnswers[1].replaceAll("Other: ","");

        _otherCount++;

      }else {
        list.add(new CheckboxListTile(
            title: new Text(mySet[i]),
            activeColor: Colors.red,
            secondary: const Icon (Icons.home),
            value: _isChecked[i],
            onChanged: (bool value) {
              onChanged(value, i);
            }
        )
        );
      }
    }

    return list;
  }


  void onOtherTextChanged(String value, int index){

    value = 'Other: '+value;
    myQuestions.allResponses[myQuestions.currentQuestion].length=0;
    myQuestions.allResponses[myQuestions.currentQuestion].add(value);

  }


  void onTextChanged(String value, int index){


    myQuestions.allResponses[myQuestions.currentQuestion].length=0;
    myQuestions.allResponses[myQuestions.currentQuestion].add(value);

  }


  void _myChoice(String response, String start, String end){

    if (response=='Deceased') {
      skipToEnd = true;
    }


    int _checkboxStart = int.parse(start);
    int _checkboxEnd = int.parse(end);

    if (_checkboxStart == _checkboxEnd) {
      myQuestions.allResponses[myQuestions.currentQuestion].length = 0;
      myQuestions.allResponses[myQuestions.currentQuestion].add(response);
      _nextQuestion(context);
    }
    else {

      if (myQuestions.allResponses[myQuestions.currentQuestion].contains(response)){
        //no action
      }else {
        myQuestions.allResponses[myQuestions.currentQuestion].length = 0;
        myQuestions.allResponses[myQuestions.currentQuestion].add(response);
      }

      mySet = [];

      for (int i = _checkboxStart; i < _checkboxEnd; i++) {
        mySet.add(myQuestions.allAnswersSets[myQuestions.currentQuestion][i]);
      }

      setState(() {
        print ('in choice set state');
        buildSublist = true;
      });
    }

  }


  @override
  Widget build (BuildContext context){


    if (buildSublist==false && myQuestions.answerTypes[myQuestions.currentQuestion][0] == 'choice'){

      if (myQuestions.currentQuestion>1) {
        return new Scaffold(
          appBar: new AppBar(
            title: new Text('Patient ' + myQuestions.patientID),
          ),
          body: new Container(
            padding: new EdgeInsets.all(45.0),
            child: new Center(
              child: new Column(
                children: <Widget>[
                  new Text(_thisQuestion[0]),
                  new Row(
                    children: <Widget>[
                      new RaisedButton(
                          child: new Text(myQuestions.answerTypes[myQuestions
                              .currentQuestion][1]),
                          onPressed: () {
                            _myChoice(myQuestions.answerTypes[myQuestions
                                .currentQuestion][1],
                                myQuestions.answerTypes[myQuestions
                                    .currentQuestion][3],
                                myQuestions.answerTypes[myQuestions
                                    .currentQuestion][4]);
                          }
                      ),
                      new RaisedButton(
                          child: new Text(myQuestions.answerTypes[myQuestions
                              .currentQuestion][2]),
                          onPressed: () {
                            _myChoice(myQuestions.answerTypes[myQuestions
                                .currentQuestion][2],
                                myQuestions.answerTypes[myQuestions
                                    .currentQuestion][5],
                                myQuestions.answerTypes[myQuestions
                                    .currentQuestion][6]);
                          }
                      ),
                    ],
                  ),

                  new Row(
                    children: <Widget>[
                      new RaisedButton(
                          child: new Text('Previous'),
                          onPressed: () {
                            _previousQuestion(context);
                          }
                      ),
                      new RaisedButton(
                          child: new Text('Next'),
                          onPressed: () {
                            _nextQuestion(context);
                          }
                      ),
                    ],
                  ),


                ],


              ),
            ),
          ),
        );
      }else{

        skipToEnd = false;

        return new Scaffold(
          appBar: new AppBar(
            title: new Text('Patient ' + myQuestions.patientID),
          ),
          body: new Container(
            padding: new EdgeInsets.all(45.0),
            child: new Center(
              child: new Column(
                children: <Widget>[
                  new Text(_thisQuestion[0]),
                  new Row(
                    children: <Widget>[
                      new RaisedButton(
                          child: new Text(myQuestions.answerTypes[myQuestions
                              .currentQuestion][1]),
                          onPressed: () {
                            _myChoice(myQuestions.answerTypes[myQuestions
                                .currentQuestion][1],
                                myQuestions.answerTypes[myQuestions
                                    .currentQuestion][3],
                                myQuestions.answerTypes[myQuestions
                                    .currentQuestion][4]);
                          }
                      ),
                      new RaisedButton(
                          child: new Text(myQuestions.answerTypes[myQuestions
                              .currentQuestion][2]),
                          onPressed: () {
                            _myChoice(myQuestions.answerTypes[myQuestions
                                .currentQuestion][2],
                                myQuestions.answerTypes[myQuestions
                                    .currentQuestion][5],
                                myQuestions.answerTypes[myQuestions
                                    .currentQuestion][6]);
                          }
                      ),
                    ],
                  ),

                  new Row(
                    children: <Widget>[
/*                      new RaisedButton(
                          child: new Text('Next'),
                          onPressed: () {
                            _nextQuestion(context);
                          }
                      ),*/

                    ],
                  ),


                ],


              ),
            ),
          ),
        );



      }
    }



    if (myQuestions.answerTypes[myQuestions.currentQuestion][0] == 'text'){

      print('text');

      WidgetsBinding.instance
          .addPostFrameCallback((_) => checkSetText(context, _controller));


      String currentAnswer = '';

      if (myQuestions.allResponses[myQuestions.currentQuestion].length>0){
        currentAnswer = myQuestions.allResponses[myQuestions.currentQuestion][0];
      }else{
        currentAnswer='none';
      }



      return new Scaffold(
        appBar: new AppBar(
          title: new Text('Patient '+myQuestions.patientID),
        ),
        body: new Container(
          padding: new EdgeInsets.all(45.0),
          child: new Center(
            child: new Column(
              children: <Widget>[
                new Text(_thisQuestion[0]),
                new Column(
                  children: <Widget>[

                    new ListTile(
                      leading: const Icon(Icons.person),
                      title:  new TextField(
                        autofocus: true,
                        controller: _controller,
                        onChanged: (String value){onTextChanged(value, 0);},
                        maxLines: 1,
                        autocorrect: false,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(


                          hintText: '',
                          labelText: 'Type your answer',

                        ),

                      ),
                    ),


                  ],
                ),

                new Row(
                  children: <Widget>[
                    new RaisedButton(
                        child: new Text('Previous'),
                        onPressed: (){_previousQuestion(context);}
                    ),
                    new RaisedButton(
                        child: new Text('Next'),
                        onPressed: (){_nextQuestion(context);}
                    ),
                  ],
                ),



              ],



            ),
          ),
        ),
      );



    }


    if (myQuestions.answerTypes[myQuestions.currentQuestion][0] == 'number'){

      print('number');

      String currentAnswer = '';

      if (myQuestions.allResponses[myQuestions.currentQuestion].length>0){
        currentAnswer = myQuestions.allResponses[myQuestions.currentQuestion][0];
      }else{
        currentAnswer='none';
      }



      return new Scaffold(
        appBar: new AppBar(
          title: new Text('Patient '+myQuestions.patientID),
        ),
        body: new Container(
          padding: new EdgeInsets.all(45.0),
          child: new Center(
            child: new Column(
              children: <Widget>[
                new Text(_thisQuestion[0]),
                new Column(
                  children: <Widget>[

                    new ListTile(
                      leading: const Icon(Icons.person),
                      title:  new TextField(
                        autofocus: true,
                        controller: _controller,
                        onChanged: (String value){onTextChanged(value, 0);},
                        maxLines: 1,
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(


                          hintText: currentAnswer,
                          labelText: 'Type your answer',

                        ),

                      ),
                    ),


                  ],
                ),

                new Row(
                  children: <Widget>[
                    new RaisedButton(
                        child: new Text('Previous'),
                        onPressed: (){_previousQuestion(context);}
                    ),
                    new RaisedButton(
                        child: new Text('Next'),
                        onPressed: (){_nextQuestion(context);}
                    ),
                  ],
                ),



              ],



            ),
          ),
        ),
      );

    }

    if (buildSublist==true){

print ('build as sublist');

      return new Scaffold(
        appBar: new AppBar(
          title: new Text('Patient '+myQuestions.patientID),
        ),
        body: new Container(
          padding: new EdgeInsets.all(45.0),
          child: new Center(
            child: new Column(
              children: <Widget>[
                new Text(_thisQuestion[0]),
                new Column(
                  children:  ListMyWidgets(),
                ),

                new Row(
                  children: <Widget>[
                    new RaisedButton(
                        child: new Text('Previous'),
                        onPressed: (){_previousQuestion(context);}
                    ),
                    new RaisedButton(
                        child: new Text('Next'),
                        onPressed: (){_nextQuestion(context);}
                    ),
                  ],
                ),



              ],



            ),
          ),
        ),
      );

    }else {
      if (myQuestions.answerTypes[myQuestions.currentQuestion][0] == 'list') {
        mySet = myQuestions.allAnswersSets[myQuestions.currentQuestion];

        print ('build as list');

        return new Scaffold(
          appBar: new AppBar(
            title: new Text('Patient ' + myQuestions.patientID),
          ),
          body: new Container(
            padding: new EdgeInsets.all(45.0),
            child: new Center(
              child: new Column(
                children: <Widget>[
                  new Text(_thisQuestion[0]),
                  new Column(
                    children: ListMyWidgets(),
                  ),

                  new Row(
                    children: <Widget>[
                      new RaisedButton(
                          child: new Text('Previous'),
                          onPressed: () {
                            _previousQuestion(context);
                          }
                      ),
                      new RaisedButton(
                          child: new Text('Next'),
                          onPressed: () {
                            _nextQuestion(context);
                          }
                      ),
                    ],
                  ),


                ],


              ),
            ),
          ),
        );
      }
    }
  }


}

