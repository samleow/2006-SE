import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/db/dbhelper.dart';
import 'package:nice_button/nice_button.dart';
import 'package:flutter_app/views/Homepage.dart';

class TypeSelectionPage extends StatefulWidget {
  @override
  _TypeSelectionPageState createState() => _TypeSelectionPageState();
}

class _TypeSelectionPageState extends State<TypeSelectionPage> {

  String _currentFareType;

  @override
  Widget build(BuildContext context) {
    var firstColor = Color(0xff5b86e5), secondColor = Color(0xff36d1dc);

    return Scaffold(
      body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
          Container(
          decoration: BoxDecoration(color: Colors.white24),
          ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Select your Fare Type",
                    style: TextStyle(
                      fontSize:35,
                    )),
                Padding(padding: EdgeInsets.all(10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Current Fare Type: ',
                    style: TextStyle(
                      fontSize: 20,
                    ),),
                    FutureBuilder(
                      future: getFareTypeFromDB(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          _currentFareType = snapshot.data;
                          return Text(snapshot.data,
                              style: TextStyle(
                                fontSize: 20,
                                //color: Colors.deepPurpleAccent,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ));
                        } else if (snapshot.hasError) {
                          return Text("Loading...",
                            style: TextStyle(
                              fontSize: 20,
                            ),);
                        }
                        return new Container(alignment: AlignmentDirectional.center,
                          child: new CircularProgressIndicator(),
                        );
                      },
                    ),
                  ],
                ),

                Padding(
                    padding: EdgeInsets.all(80)
                ),
                NiceButton(
                  radius: 40,
                  padding: const EdgeInsets.all(15),
                  text: "Adult",
                  icon: Icons.work,
                  gradientColors: [secondColor, firstColor],
                  onPressed: () {
                    showAlertDialog(context,1);
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(10)
                ),
                NiceButton(
                  radius: 40,
                  padding: const EdgeInsets.all(15),
                  text: "Senior Citizen",
                  icon: Icons.accessible,
                  gradientColors: [secondColor, firstColor],
                  onPressed: () {
                    showAlertDialog(context,2);
                  },
                ),
                Padding(
                    padding: EdgeInsets.all(10)
                ),
                NiceButton(
                  radius: 40,
                  padding: const EdgeInsets.all(15),
                  text: "Student",
                  icon: Icons.school,
                  gradientColors: [secondColor, firstColor],
                  onPressed: () {
                    showAlertDialog(context,3);
                  },
                ),
               ],
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: MaterialButton(
                onPressed: () => {
                  Future.delayed(Duration(milliseconds: 100), () async {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Homepage()),
                    );
                  }
                  )
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 10, bottom: 30),
                  padding: const EdgeInsets.all(10.0),
                  decoration: myBoxDecoration(), //
                  child: Text('I can change later. \n- Skip for now -',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.deepPurpleAccent,
                          fontSize: 20,)),
                ),
              ),
            ),
          ]
      )
    );
  }

  void UpdateFareTypeDatabase(int i) async {
    var dbHelper = DBHelper();
    await dbHelper.updateFareType(i);
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(
        width: 1.0,
        color: Colors.blueAccent,
      ),
      borderRadius: BorderRadius.all(
          Radius.circular(10.0) //
      ),
    );
  }

  showAlertDialog(BuildContext context, int i) {
    Widget yesButton = FlatButton(
      child: Text("Yes"),
      onPressed:  () {
        UpdateFareTypeDatabase(i);
        Future.delayed(Duration(milliseconds: 100), () async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Homepage()),
          );
        }
        );
        //Navigator.of(context).pop();
        setState(() {});
      },
    );
    Widget noButton = FlatButton(
      child: Text("No"),
      onPressed:  () {
        Navigator.of(context).pop();
        setState(() {});
      },
    );

    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed:  () {
        Navigator.of(context).pop();
        Future.delayed(Duration(milliseconds: 100), () async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Homepage()),
          );
        }
        );
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Warning"),
      content: Text("Are you sure you want to select this Fare Type?\n\n"+
          "*Choosing a new Fare Type will result in losing of all currently saved Trips"),
      actions: [
        yesButton,
        noButton,
      ],
    );

    AlertDialog sameTypeAlert = AlertDialog(
      title: Text("Warning"),
      content: Text("You have selected your current Fare Type\n\n"+
          "*Currently saved Trips will not be deleted"),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        if((_currentFareType == 'Adult' && i == 1) || (_currentFareType == 'Senior Citizen' && i == 2)
        || (_currentFareType == 'Student' && i == 3)){
          return sameTypeAlert;
        } else
          return alert;
      },
    );
  }

  Future<String> getFareTypeFromDB() async {
    var dbHelper = DBHelper();
    List<Map> list = await dbHelper.getFareType();
    String fareTypeDB = list[0]['fareType'];
    return(fareTypeDB);
  }
}
