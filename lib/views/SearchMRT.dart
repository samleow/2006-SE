import 'package:flutter/material.dart';
import 'package:flutter_app/db/dbhelper.dart';
import 'package:flutter_app/models/Route.dart';

class SearchMRT extends StatefulWidget {
  @override
  _SearchMRTState createState() => _SearchMRTState();

}

class _SearchMRTState extends State<SearchMRT> {
  final fromTextController = TextEditingController();
  final toTextController = TextEditingController();
  int dropdownValue = 1;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    fromTextController.dispose();
    toTextController.dispose();
    super.dispose();
  }

  final scaffoldKey = new GlobalKey<ScaffoldState>();

  //Routes route = new Routes("", "", "", 0,0);
  String busNo;
  String fromStop;
  String toStop;
  double fare;
  int tripID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        margin: const EdgeInsets.only(right: 15, left: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              //child: Text('Hello World!'),
            ),
            TextFormField(
              controller: fromTextController,
              decoration: const InputDecoration(
                labelText: 'From',
                hintText: 'Search Bus Stop',
                border: OutlineInputBorder(),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              //child: Text('Hello World!'),
            ),
            TextFormField(
              controller: toTextController,
              decoration: const InputDecoration(
                labelText: 'To',
                hintText: 'Search Bus Stop',
                border: OutlineInputBorder(),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              //child: Text('Hello World!'),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Save under trip : ',
                      style: TextStyle(
                        fontSize:20,
                      )),

                  DropdownButton<int>(
                    value: dropdownValue,
                    elevation: 12,
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (int newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items: <int>[1,2,3,4]
                        .map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                          value: value,
                          child: SizedBox(
                            width:100,
                            child: Text(value.toString(), textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize:20,
                                  color: Colors.deepPurple,

                                )),
                          ));
                    }).toList(),
                  ),
                ]
            ),
            Divider(
              color: Colors.black26,
              thickness: 1.5,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveMrtRouteToDatabase();
        },
        tooltip: 'Show me the Values',
        child: Icon(Icons.add),
      ),
    );
  }

  void saveMrtRouteToDatabase() async{
    fromStop = fromTextController.text;
    toStop = toTextController.text;

    var dbHelper = DBHelper();
    int i = await dbHelper.saveRoute({
      DBHelper.busNo : 'MRT',
      DBHelper.fromStop: fromTextController.text,
      DBHelper.toStop: toTextController.text,
      DBHelper.fare: 5.0, //hard-coded for now
      DBHelper.tripID: dropdownValue //hard-coded for now
    });
    _showSnackBar("Data saved successfully");
    //var route = Routes(i,busNo,fromStop,toStop,5,1);
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }
}
