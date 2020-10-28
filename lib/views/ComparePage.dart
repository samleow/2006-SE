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
                    child: Text("Help for Concession Pass"),
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
    child: Text("Close"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("Concession Pass"),
    content: Text("Compare selected trips against Monthly Concession"
        "\n\n1) Select your relevant Concession information"
        "\n\n2) Tick on the Trips you wish to be included in the comparison"
        "\n\n3) Our app will display how much you save by taking the cheaper option"),
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
    child: Text("Close"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("Trips"),
    content: Text("Compare the monthly price of 2 Trips"
        "\n\n1) Select 2 Trips to compare"
        "\n\n2) Enter how frequently you go on that trip"
        "\n\n3) Our app will display how much you can save by taking the cheaper option!"),
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