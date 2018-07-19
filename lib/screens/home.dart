import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crpapp/screens/question.dart';
import 'package:crpapp/screens/final.dart';
import 'package:crpapp/questionData.dart' as myQuestions;
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:date_format/date_format.dart';

class Home extends StatefulWidget{


  @override
  _State createState() => new _State();

}



class _State extends State<Home>{


  String _myPatientID = myQuestions.patientID;

  final GlobalKey<ScaffoldState> _scaffoldstate = new  GlobalKey<ScaffoldState>();

  final Connectivity _connectivity = new Connectivity();

  final fileController = TextEditingController();
  final idController = TextEditingController();
  final dateVisitController = TextEditingController();
  final typeVisitController = TextEditingController();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final dischargeController = TextEditingController();
  final priorityController = TextEditingController();
  final familyController = TextEditingController();
  final earningController = TextEditingController();



  void nextPage(){

    Navigator.of(context).pushNamed('/Question');

  }



  void onChangedID(String value){

    print (value);

    myQuestions.patientID = value.trim();

    myQuestions.thePatientID[1]=value.trim();

    print(myQuestions.thePatientID[0]+' '+myQuestions.thePatientID[1]);

  }


  void onChangedFile(String value){

    myQuestions.fileNO[1]=value.trim();


  }



  void onChangedDate(String value){

    myQuestions.dateOfVisit[1]=value;


  }

  void onChangedTypeVisit(String value){

    myQuestions.typeOfVisit[1]=value;


  }

  void onChangedPatientName(String value){

    myQuestions.patientName[1]=value;


  }

  void onChangedPatientAge(String value){

    myQuestions.patientAge[1]=value;


  }

  void onChangedPatientAddress(String value){

    myQuestions.patientAddress[1]=value;


  }

  void onChangedPatientPhone(String value){

    myQuestions.phoneNumber[1]=value;


  }

  void onChangedDischargePriority(String value){

    myQuestions.dischargePriority[1]=value;


  }


  void onChangedVisitPriority(String value){

    myQuestions.visitPriority[1]=value;


  }

  void onChangedFamilyMember(String value){

    myQuestions.familyMembers[1]=value;


  }


  void onChangedEarningMembers(String value){

    myQuestions.earningMembers[1]=value;


  }

  @override
  void initState() {
    super.initState();
    setAllText();

   // _myPatientID = _myQuestions.patientID;

  }

void setAllText(){

  var timeNow = new DateTime.now();
  String gotDate = (formatDate(timeNow, [dd, '-', mm, '-', yyyy]));

  myQuestions.dateOfVisit[1] = gotDate;

  idController.text = myQuestions.thePatientID[1];
  fileController.text = myQuestions.fileNO[1];
  dateVisitController.text = myQuestions.dateOfVisit[1];
  typeVisitController.text = myQuestions.typeOfVisit[1];
  nameController.text = myQuestions.patientName[1];
  ageController.text = myQuestions.patientAge[1];
  addressController.text = myQuestions.patientAddress[1];
  phoneController.text = myQuestions.phoneNumber[1];
  dischargeController.text = myQuestions.dischargePriority[1];
  priorityController.text = myQuestions.visitPriority[1];
  familyController.text = myQuestions.familyMembers[1];
  earningController.text = myQuestions.earningMembers[1];

}

  Future<String> get initConnectivity async {
    String connectionStatus;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      connectionStatus = (await _connectivity.checkConnectivity()).toString();
    }  catch (e) {
      print(e.toString());
      connectionStatus = 'Failed to get connectivity.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.




    return connectionStatus;

  }


  Future<Null> _patientData(String myID) async {

    String connection = await initConnectivity;

    if (connection =='ConnectivityResult.wifi' || connection == 'ConnectivityResult.mobile') {
      bool found = false;


      QuerySnapshot querySnapshot = await Firestore.instance.collection(
          "CRP-Patients").getDocuments();
      var list = querySnapshot.documents;

      if (list.length > 0) {
        list.forEach((doc) {
          debugPrint(doc.documentID);

          if (doc.documentID == myID) {
            found = true;
            myQuestions.fileNO[1] = doc.data['File NO'];
            myQuestions.dateOfVisit[1] = doc.data['Date of Visit'];
            // myQuestions.typeOfVisit[1]=doc.data['Type of Visit'];
            myQuestions.patientName[1] = doc.data['Patient Name'];
            myQuestions.patientAge[1] = doc.data['Patient Age'];
            myQuestions.patientAddress[1] = doc.data['Patient Address'];
            myQuestions.phoneNumber[1] = doc.data['Phone Number'];
            myQuestions.dischargePriority[1] = doc.data['Discharge Priority'];
            // myQuestions.visitPriority[1]=doc.data['Visit Priority'];
            myQuestions.familyMembers[1] = doc.data['Family Members'];
            myQuestions.earningMembers[1] = doc.data['Earning Family Members'];
          }
        });
        //data.toString()));

        setAllText();
      } else {
        _scaffoldstate.currentState.showSnackBar(new SnackBar(
          content: new Text('NO PATIENT FOUND'),
        ),);
      }

      if (!found) {
        _scaffoldstate.currentState.showSnackBar(new SnackBar(
          content: new Text('NO PATIENT FOUND'),
        ),);
      }
    }else{

      _scaffoldstate.currentState.showSnackBar(new SnackBar(
        content: new Text('NO INTERNET CONNECTION'),
      ),);

    }

  }




  @override



  Widget build(BuildContext context) {

    WidgetsBinding.instance
        .addPostFrameCallback((_) => setAllText());

    double height = MediaQuery.of(context).size.width;

    double setHeight = height * .70;

    // TODO: implement build
    return new Scaffold(
      key:_scaffoldstate,
      appBar: AppBar(
          title: const Text('Basic AppBar'),
          actions: <Widget>[
      // action button
      IconButton(
      icon:  new Icon(Icons.arrow_forward, size: 40.0),

      onPressed: () {
        nextPage();
      },
      ),

      ],
    ),



        body: new Container(

          height: setHeight,

          child: new

        ListView(

          children: <Widget>[

            new ListTile(
              leading: const Icon(Icons.person),
              trailing:  IconButton(
                icon:  new Icon(Icons.cloud_download, size: 35.0),
                onPressed: () {
                  _patientData(myQuestions.thePatientID[1]);
                },
              ),
              title: new TextField(
                autofocus: true,
                controller: idController,
                onChanged: (String value) {
                  onChangedID(value);
                },
                maxLines: 1,
                autocorrect: false,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(

                  hintText: '',
                  labelText: 'Patient ID',

                ),

              ),
            ),

            new ListTile(
              leading: const Icon(Icons.person),
              title: new TextField(
                autofocus: true,
                controller: fileController,
                onChanged: (String value) {
                  onChangedFile(value);
                },
                maxLines: 1,
                autocorrect: false,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(

                  hintText: '',
                  labelText: 'File NO',

                ),

              ),
            ),

            new ListTile(
              leading: const Icon(Icons.person),
              title: new TextField(
                autofocus: true,
                  controller: dateVisitController,
                onChanged: (String value) {
                  onChangedDate(value);
                },
                maxLines: 1,
                autocorrect: false,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(

                  hintText: '',
                  labelText: 'Date of visit',

                ),

              ),
            ),

            new ListTile(
              leading: const Icon(Icons.person),
              title: new TextField(
                autofocus: true,
                onChanged: (String value) {
                  onChangedTypeVisit(value);
                },
                maxLines: 1,
                autocorrect: false,
                controller: typeVisitController,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(

                  hintText: '',
                  labelText: 'Type of Visit:',

                ),

              ),
            ),

            new ListTile(
              leading: const Icon(Icons.person),
              title: new TextField(
                autofocus: true,
                controller: priorityController,
                onChanged: (String value) {
                  onChangedVisitPriority(value);
                },
                maxLines: 1,
                autocorrect: false,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(

                  hintText: '',
                  labelText: 'Visit Priority',

                ),

              ),
            ),

            new ListTile(
              leading: const Icon(Icons.person),
              title: new TextField(
                autofocus: true,
                  controller: nameController,
                onChanged: (String value) {
                  onChangedPatientName(value);
                },
                maxLines: 1,
                autocorrect: false,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(

                  hintText: '',
                  labelText: 'Patient Name',

                ),

              ),
            ),

            new ListTile(
              leading: const Icon(Icons.person),
              title: new TextField(
                autofocus: true,
                  controller: ageController,
                onChanged: (String value) {
                  onChangedPatientAge(value);
                },
                maxLines: 1,
                autocorrect: false,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(

                  hintText: '',
                  labelText: 'Patient Age',

                ),

              ),
            ),

            new ListTile(
              leading: const Icon(Icons.person),
              title: new TextField(
                autofocus: true,
                  controller: addressController,
                onChanged: (String value) {
                  onChangedPatientAddress(value);
                },
                maxLines: 1,
                autocorrect: false,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(

                  hintText: '',
                  labelText: 'Patient Address',

                ),

              ),
            ),

            new ListTile(
              leading: const Icon(Icons.person),
              title: new TextField(
                autofocus: true,
                controller: phoneController,
                onChanged: (String value) {
                  onChangedPatientPhone(value);
                },
                maxLines: 1,
                autocorrect: false,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(

                  hintText: '',
                  labelText: 'Patient Phone No',

                ),

              ),
            ),

            new ListTile(
              leading: const Icon(Icons.person),
              title: new TextField(
                autofocus: true,
                  controller: dischargeController,
                onChanged: (String value) {
                  onChangedDischargePriority(value);
                },
                maxLines: 1,
                autocorrect: false,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(

                  hintText: '',
                  labelText: 'Discharge Priority',

                ),

              ),
            ),



            new ListTile(
              leading: const Icon(Icons.person),
              title: new TextField(
                autofocus: true,
                  controller: familyController,
                onChanged: (String value) {
                  onChangedFamilyMember(value);
                },
                maxLines: 1,
                autocorrect: false,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(

                  hintText: '',
                  labelText: 'No of family members',

                ),

              ),
            ),

            new ListTile(
              leading: const Icon(Icons.person),
              title: new TextField(
                autofocus: true,
                controller: earningController,
                onChanged: (String value) {
                  onChangedEarningMembers(value);
                },
                maxLines: 1,
                autocorrect: false,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(

                  hintText: '',
                  labelText: 'Earning family members',

                ),

              ),
            ),


          ],

        ),



        )

    );


  }


}