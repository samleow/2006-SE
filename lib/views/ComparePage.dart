import 'package:flutter/material.dart';
import 'package:flutter_app/views/CompareTrips.dart';
import 'package:flutter_app/views/ConcessionPage.dart';
import 'package:photo_view/photo_view.dart';
import 'ConcessionPage.dart';


class ComparePage extends StatefulWidget {
  _ComparePageState createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {

  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            title: Text('UnFare SG'),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.card_membership),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ConcessionPrice()),
                    );
                  }
              ),
              PopupMenuButton(
                itemBuilder: (content) => [
                  PopupMenuItem(
                    value: 1,
                    child: Text("Help for Trips"),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text("Help for Concession"),
                  )
                ],
                onSelected: (int menu){
                  if (menu == 1){
                    showAlertDialogTrips(context);
                  }
                  else if (menu == 2){
                    showAlertDialogConcession(context);
                  }
                },
              )
            ],
            bottom: TabBar(
            key: _formKey,
            tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.directions),
                    text: 'TRIPS',
                  ),
                  Tab(
                    icon: Icon(Icons.credit_card),
                    text: 'CONCESSION PASS',
                  ),
                ]
            )
        ),
        body: TabBarView(
          children: <Widget>[
            CompareTrips(),
            ConcessionPage()
    ],
        ),
      ),
    );
  }
}


class ConcessionPrice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Concession Prices"),
        ),
        body: Container(
            child: PhotoView(
              imageProvider: AssetImage("assets/Concession.png"),
            )
        )
    );
  }
}

showAlertDialogConcession(BuildContext context) {
  Widget yesButton = FlatButton(
    child: Text("OK"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("Concession Pass"),
    content: Text("To compare the selected trips against the selected concession pass. Tap onto the trips to be used for comparison."),
    actions: [
      yesButton,
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialogTrips(BuildContext context) {
  Widget yesButton = FlatButton(
    child: Text("OK"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("Trips"),
    content: Text("To compare 2 selected trips to find out which trip is cheaper."),
    actions: [
      yesButton,
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}