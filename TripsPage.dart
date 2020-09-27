import 'package:flutter/material.dart';
import 'package:flutter_app/db/database_helper.dart';
import 'package:flutter_app/models/Route.dart';
import 'package:flutter_app/db/dbhelper.dart';

Future<List<Routes>> fetchRoutesFromDatabase() async {
  var dbHelper = DBHelper();
  Future<List<Routes>> route = dbHelper.getRoute();
  return route;
}

class TripsPage extends StatefulWidget {
  @override
  _TripsPageState createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
         title:new Text("AppName (TBC)"),
       ),
        body: Container(
          padding: new EdgeInsets.all(16.0),
          child: FutureBuilder<List<Routes>>(
            future: fetchRoutesFromDatabase(),
            builder: (context, snapshot){
              if(snapshot.hasData){
                return new ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text('Trips ID: ' + snapshot.data[index].tripID.toString(),
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0)),
                          new Text('Bus No: ' + snapshot.data[index].busNo,
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14.0)),
                          new Text('From: ' +snapshot.data[index].fromStop,
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14.0)),
                          new Text('To: ' +snapshot.data[index].toStop,
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14.0)),
                          new Text('Fare: \$' +snapshot.data[index].fare.toString(),
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14.0)),
                          new Text('Route ID: ' +snapshot.data[index].routeID.toString(),
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14.0)),
                          new Divider()
                        ]
                    );
                  }
                );
              }
              else if (snapshot.hasError){
                return new Text("${snapshot.error}");
              }
              return new Container(alignment: AlignmentDirectional.center,child: new CircularProgressIndicator(),);
            }
          )
        )
    );
  }
}
