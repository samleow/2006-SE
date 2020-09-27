import 'package:flutter/material.dart';
import 'package:flutter_app/db/database_helper.dart';
import 'package:flutter_app/db/dbhelper.dart';
import 'package:flutter_app/models/Route.dart';

class SearchBus extends StatefulWidget {
  @override
  _SearchBusState createState() => _SearchBusState();
}

class _SearchBusState extends State<SearchBus> {
  final busNoController = TextEditingController();
  final fromTextController = TextEditingController();
  final toTextController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    busNoController.dispose();
    fromTextController.dispose();
    toTextController.dispose();
    super.dispose();
  }

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  int dropdownValue = 1;

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
                controller: busNoController,
                decoration: const InputDecoration(
                  hintText: 'Search for Bus Service no.',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
            saveBusRouteToDatabase();
          },
        tooltip: 'Show me the Values',
        child: Icon(Icons.add),
      ),
    );
  }

  void saveBusRouteToDatabase() async{
    // int i = await DatabaseHelper.instance.insert({
    //   DatabaseHelper.busNo : busNoController.text,
    //   DatabaseHelper.fromStop: fromTextController.text,
    //   DatabaseHelper.toStop: toTextController.text,
    //   DatabaseHelper.fare: 5.0, //hard-coded for now
    //   DatabaseHelper.tripID: 1 //hard-coded for now
    // });
    // print('the inserted id is $i');
    //
    // List<Map<String,dynamic>> queryRows = await DatabaseHelper.instance.queryAll();
    // print(queryRows);
    busNo = busNoController.text;
    fromStop = fromTextController.text;
    toStop = toTextController.text;

    //var route = Routes(1,busNo,fromStop,toStop,5,1);
    var dbHelper = DBHelper();
    int i = await dbHelper.saveRoute({
      DBHelper.busNo : busNoController.text,
      DBHelper.fromStop: fromTextController.text,
      DBHelper.toStop: toTextController.text,
      DBHelper.fare: 5.0, //hard-coded for now
      DBHelper.tripID: dropdownValue,
    });
    _showSnackBar("Data saved successfully");
    //var route = Routes(i,busNo,fromStop,toStop,5,1);
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }
}
