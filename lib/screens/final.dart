import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:date_format/date_format.dart';
import 'package:device_info/device_info.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:crpapp/questionData.dart' as myQuestions;

import 'package:connectivity/connectivity.dart';



class Final extends StatefulWidget{


  @override
  _State createState() => new _State();

}


Future<int> get _androidVersion async{

  final DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();

  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

  int myVersion = androidInfo.version.sdkInt;

  return myVersion;


}








Future<String> get _localPath async {

  final int _myAndroidVersion = await _androidVersion;

  print ('here i check sdk is $_myAndroidVersion');

  bool res = false;

  if (_myAndroidVersion >= 23) {
    res = await SimplePermissions.requestPermission(Permission.WriteExternalStorage);

  }else {

    res = true;

  }

  if (res) {
    final directory = await getExternalStorageDirectory();

    return directory.path;
  }else{
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

}

Future<File> get _localFile async {
  final path = await _localPath;

   var timeNow = new DateTime.now();

  //var timeNow = new DateTime.utc(2020, 11, 11);

  String gotDate = (formatDate(timeNow, [dd, '-', mm, '-', yyyy]));



  if (FileSystemEntity.typeSync(path+'/crp') == FileSystemEntityType.notFound){

    final makeCRP = await new Directory(path+'/crp').create(recursive: false);

    print ('i made crp folder');

  }


  if (FileSystemEntity.typeSync(path+'/crp/'+myQuestions.patientID) != FileSystemEntityType.notFound){

    print (' dir exists already '+myQuestions.patientID);

    return File('$path/crp/'+myQuestions.patientID+'/'+myQuestions.patientID+'_'+gotDate+'.csv');


  }else {

    final madeDir = await new Directory(path+'/crp/'+myQuestions.patientID).create(recursive: false);

    print ('i made dir '+myQuestions.patientID);

    return File('$path/crp/'+myQuestions.patientID+'/'+myQuestions.patientID+'_'+gotDate+'.csv');

  }
}

Future<File> saveForm(String theList) async {
  final file = await _localFile;




  // Write the file


  return file.writeAsString(theList)  ;




}




Future<Null> uploadFile() async {

  String _path;
  File _cachedFile;

  final path = await _localPath;


/*  final ByteData bytes = await load(filepath);
  final Directory tempDir = Directory.systemTemp;*/

  final String fileName = "crtData.csv";
  final File file = File('$path/crp/crplist3.csv');


  final StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
  final StorageUploadTask task = ref.putFile(file);
  final Uri downloadUrl = (await task.future).downloadUrl;
  _path = downloadUrl.toString();

  print(_path);



  print("file uploaded");


}


class _State extends State<Final>{


  bool toShow=false ;

  Future<List<String>> fileRecursion (Directory mainCRP) async{

    List<String> _idList = new List<String>();




    List<FileSystemEntity> myFilesList =  mainCRP.listSync(recursive: false, followLinks: false);


    for (int i=0; i < myFilesList.length; i++){

      _idList.add(basename(myFilesList[i].path));

      print ('for loop file name is '+basename(myFilesList[i].path));

    }




    return _idList;
  }


  Future<Null> _uploadAFile() async {

    String connection = await initConnectivity;

    print ('connection status '+connection);

    if (connection =='ConnectivityResult.wifi' || connection == 'ConnectivityResult.mobile') {
      final path = await _localPath;


      print('my path is $path');

      StorageUploadTask uploadTask;

      //  final Directory systemTempDir = Directory.systemTemp;
      Directory mainCRP = Directory('$path/crp/');

      print('********************' + mainCRP.path);

      //final File file =  File('$path/Documents/crp/crplist3.csv');

      List <String> pIDList = new List<String>();

      pIDList = await fileRecursion(mainCRP);


      List<String> fileToUpload = new List<String>();

      List<File> filesForUploading = new List<File>();

      print('patien id list is ' + pIDList[0]);

      int fileUploadCount = 0;

      for (int i = 0; i < pIDList.length; i++) {
        Directory piDir = Directory('$path/crp/' + pIDList[i]);

        List<FileSystemEntity> grabFiles = piDir.listSync(
            recursive: false, followLinks: false);

        for (int i = 0; i < grabFiles.length; i++) {
          filesForUploading.add(grabFiles[i]);

          print('** **  *** ***  ***  my dir name is ${basename(
              grabFiles[i].path)}');
        }


      }

      print('length is ' + filesForUploading.length.toString());

      for (int u = 0; u < filesForUploading.length; u++) {
        String dirName = basename(filesForUploading[u].path);

        StorageReference ref = FirebaseStorage.instance.ref()
            .child(pIDList[u])
            .child(dirName);

        uploadTask = ref.putFile(
          filesForUploading[u],
          new StorageMetadata(
            contentLanguage: 'en',
            customMetadata: <String, String>{'activity': 'test'},
          ),
        );

        final Uri downloadUrl = (await uploadTask.future).downloadUrl;
        if (downloadUrl != null) {
          fileUploadCount++;
          if (fileUploadCount == filesForUploading.length) {
            print(
                '************************** DONE *****************************************');
            setState(() {
              toShow = false;
            });
          }
        }
      }
    }else{
      print ('NOT ONLINE');
      setState(() {
        toShow = false;
      });

      _scaffoldstate.currentState.showSnackBar(new SnackBar(
        content: new Text('NO INTERNET CONNECTION'),
      ),);

    }
  }

  List<List<dynamic>> _allQuestions = new List<List<dynamic>>();


  List<String> _personal = new List<String>();
  List<String> _question1 = new List<String>();

  List<List<dynamic>> _fullList = new List<List<dynamic>>();

  String _csv1 = '';
  String _csv2 = '';
  String _csv = '';

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = new Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final GlobalKey<ScaffoldState> _scaffoldstate = new  GlobalKey<ScaffoldState>();

  @override
  void initState() {

    final csvCodec = new CsvCodec();

 /*   String connection = initConnectivity;



    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          setState(() => _connectionStatus = result.toString());
        });*/


    for (int i=0; i<myQuestions.allPersonal.length; i++)
    {
      _allQuestions.add(myQuestions.allPersonal[i]);


    }

    for (int k=1; k<myQuestions.theFinalQuestion; k++){
      _allQuestions.add([myQuestions.allQuestions[k], myQuestions.allResponses[k]]);
    }



    _csv1 = const ListToCsvConverter().convert(_allQuestions);

     _csv2 = _csv1.replaceAll("[", "");

    _csv = _csv2.replaceAll("]", "");

print ('ths is csv '+_csv);



  }

/*  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }*/

  // Platform messages are asynchronous, so we initialize in an async method.

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


    setState(() {
      _connectionStatus = connectionStatus;
    });

    return connectionStatus;

  }


  void _doSave(){

    saveForm(_csv);
    print ('writing');

    //reset here



  }

  void _restart(BuildContext context){

    myQuestions.currentQuestion=1;
    myQuestions.patientID='';

    for (int i=0; i < myQuestions.allResponses.length; i++){
      myQuestions.allResponses[i].length=0;
    }
    for (int j=0; j < myQuestions.allPersonal.length; j++){
      myQuestions.allPersonal[j].length=0;
    }


    myQuestions.thePatientID.addAll(['ID No','']);
    myQuestions.fileNO.addAll(['File No:','']);
    myQuestions.dateOfVisit.addAll(['Date of Visit:','']);
    myQuestions.typeOfVisit.addAll(['Type of Visit:','']);
    myQuestions.patientName.addAll(['Patient Name:','']);
    myQuestions.patientAge.addAll(['Patient Age:','']);
    myQuestions.patientAddress.addAll(['Patient Address:','']);
    myQuestions.phoneNumber.addAll(['Phone Number:','']);
    myQuestions.dischargePriority.addAll(['Discharge Priority','']);
    myQuestions.visitPriority.addAll(['Visit Priority','']);
    myQuestions.familyMembers.addAll(['No of family members','']);
    myQuestions.earningMembers.addAll(['No of earning family members','']);



    Navigator.pushNamedAndRemoveUntil(context, '/Home', (_) => false);

  }



Widget showSpinner(BuildContext context){

  Widget child;
  if (toShow) {
    child =  new Image.asset("images/spinner.gif");
  } else {
  child = null;
  }
  return new Container(child: child);

}


  @override
  Widget build (BuildContext context){
    return new Scaffold(
      key: _scaffoldstate,
      appBar: new AppBar(
        title: new Text('Switch Demo'),
      ),
      body: new Container(
        padding: new EdgeInsets.all(45.0),
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Text(_csv),

              new RaisedButton(child: new Text('local'),onPressed: (){_doSave();}),
              new RaisedButton(child: new Text('web'), onPressed: (){
                setState(() {
                  toShow=true;
                });
                _uploadAFile();}),
              new RaisedButton(child: new Text('new patient'), onPressed: (){_restart(context);}),

              showSpinner(context),

            ],
          ),
        ),
      ),
    );
  }

}