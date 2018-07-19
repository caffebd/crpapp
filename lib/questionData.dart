String patientID = '';
int currentQuestion = 1;

List<String> thePatientID = ['ID No:',''];
List<String> fileNO = ['File No:',''];
List<String> dateOfVisit = ['Date of Visit:',''];
List<String> typeOfVisit = ['Type of Visit:',''];
List<String> patientName = ['Patient Name:',''];
List<String> patientAge = ['Patient Age:',''];
List<String> patientAddress = ['Patient Address:',''];
List<String> phoneNumber = ['Phone Number:',''];
List<String> dischargePriority = ['Discharge Priority',''];
List<String> visitPriority = ['Visit Priority',''];
List<String> familyMembers = ['No of family members',''];
List<String> earningMembers = ['No of earning family members',''];

List<List<dynamic>>  allPersonal = [thePatientID, fileNO, dateOfVisit, typeOfVisit, patientName, patientAge, patientAddress,
phoneNumber, dischargePriority, visitPriority, familyMembers, earningMembers];



List<String> question0 = [''];
List<String> question1 = ['Patient Status: Alive/Dead'];
List<String> question2 = ['Monthly income'];
List<String> question3 = ['Distress Type'];
List<String> question4 = ['Did you receive computer training?'];
List<String> question5 = ['Is your door accessible?'];
List<String> question6 = ['Occupation before injury'];
List<String> question7 = ['Do you use assistive device?'];

List<List<dynamic>>  allQuestions = [question0, question1, question2, question3, question4, question5, question6, question7];
int theFinalQuestion = allQuestions.length;

List<String> answer0Type = [''];


List<String> answer1Type = ['choice','Alive','Deceased','0','0','0','8'];

List<String> answer2Type = ['text'];

List<String> answer3Type = ['list'];

List<String> answer4Type = ['choice', 'Yes', 'No', '0','8','0','0'];

List<String> answer5Type = ['choice', 'Yes', 'No', '0','0','0','0'];

List<String> answer6Type = ['list'];

List<String> answer7Type = ['choice', 'Yes', 'No', '0','4','4','7'];

List<List<dynamic>> answerTypes = [answer0Type, answer1Type, answer2Type, answer3Type, answer4Type,
answer5Type, answer6Type, answer7Type];

List<String> answer0 = [''];

List<String> answer1 = ['Pressure Ulcer', 'Urinary Infection', 'Senile Cause', 'Stroke', 'Heart Failure', 'Suicide', 'Accident', 'Other'];

List<String> answer2 = [''];

List<String> answer3 = ['No Problem','Catheter','burning sensation','pain','dysreflexia','no control','fever','fistula','swelling'];

List<String> answer4 = ['1 month', '2 months', '3 months', '4 months', '6 months', 'CRP', 'Government', 'Non-government'];

List<String> answer5 = [''];

List<String> answer6 = ['unemployed', 'student', 'other',' business', 'farming', 'other'];

List<String> answer7 = ['wheel chair', 'frame', 'crutch',' seat', 'do not need', 'unable to use', 'having pain'];

List<List<dynamic>>  allAnswersSets = [answer0, answer1, answer2, answer3, answer4, answer5, answer6, answer7];


List<String> response0 = [];
List<String> response1 = [];
List<String> response2 = [];
List<String> response3 = [];
List<String> response4 = [];
List<String> response5 = [];
List<String> response6 = [];
List<String> response7 = [];


List<List<dynamic>>  allResponses = [response0, response1, response2, response3,
response4, response5, response6, response7];



/*

class QuestionData {
   int currentQuestion = 0;
   String patientID = 'none';

   List<String> question1 = new List<String>();
   List<String> question2 = new List<String>();
   List<String> question3 = new List<String>();
   List<String> question4 = new List<String>();

   String answer1Type = 'type';

   String answer2Type = 'type';

   String answer3Type = 'tree';


   List<String> answer3a = new List<String>();

   List<String> answer3b = new List<String>();

   String question4Type = 'list';
   List<String> answer4 = new List<String>();

void setQuestions() {



  question1.add('Patient priority during this visit');


  question2.add('Number of family members');


  question3.add('Patient Status: Alive/Dead');


  question4.add('Distress Type');

}


void setAnswerFormat(){


  answer3a.add('Yes');


  answer3b.addAll(['No', 'Pressure Ulcer', 'Urinary Infection', 'Senile Cause', 'Stroke', 'Heart Failure', 'Suicide', 'Accident', 'Other']);


  answer4.addAll(['No Problem','Catheter','burning sensation','pain','dysreflexia','no control','fever','fistula','swelling']);

}




}*/
