import 'package:flutter/material.dart';
import 'package:flutter_app/db/database_helper.dart';
import 'package:flutter_app/models/Route.dart';
import 'package:flutter_app/models/Trips.dart';
import 'package:flutter_app/db/dbhelper.dart';
import 'package:flutter_app/views/RouteDelete.dart';

class TripsPage extends StatefulWidget {
  @override
  _TripsPageState createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  int dropdownValue = 1;
  //double totalFares = 1.1;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text("AppName (TBC)"),
      ),
      body: Container(
        //width: 280,
        //padding: EdgeInsets.only(top: 10.0),
        child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(left: 0)),
                  Text('Select trip : ',
                    style: TextStyle(
                      fontSize:20,
                    )),
                  // DropdownButton<int>(
                  //   value: dropdownValue,
                  //   //hint: Text('Her'),
                  //   elevation: 12,
                  //   underline: Container(
                  //     height: 2,
                  //     color: Colors.deepPurpleAccent,
                  //   ),
                  //   onChanged: (int newValue) {
                  //     setState(() {
                  //       dropdownValue = newValue;
                  //     });
                  //   },
                  //   // hint: Text(
                  //   //   "Please select a trip!",
                  //   //   style: TextStyle(
                  //   //     color: Colors.black,
                  //   //   ),),
                  //   items: <int>[1,2,3,4].map<DropdownMenuItem<int>>((int value) {
                  //     return DropdownMenuItem<int>(
                  //         value: value,
                  //         child: SizedBox(
                  //           width:100,
                  //           child: Text(value.toString(), textAlign: TextAlign.center,
                  //           style: TextStyle(
                  //             fontSize:20,
                  //               color: Colors.deepPurple,
                  //           )),
                  //     ));
                  //   }).toList(),
                  // ), //DROPDOWN
                  FutureBuilder(
                    future: getAllTripsID(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return DropdownButton<dynamic>(
                          value: dropdownValue,
                          //elevation: 12,
                          //   underline: Container(
                          //     height: 2,
                          //     color: Colors.deepPurpleAccent,
                          //   ),
                          onChanged: (newValue) {
                            setState(() {
                              dropdownValue = newValue;
                            });
                          },
                          items: snapshot.data.map<DropdownMenuItem<dynamic>>((
                              value) {
                            return DropdownMenuItem<dynamic>(
                                value: value,
                                child: SizedBox(
                                  width: 100,
                                  child: Text(value.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.deepPurple,
                                      )),
                                ));
                          })?.toList() ?? [],
                        );
                      } else if (snapshot.hasError) {
                          return new Text("${snapshot.error}");
                      }
                      return new Container(alignment: AlignmentDirectional.center,
                        child: new CircularProgressIndicator(),
                      );
                    },
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 100)),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    iconSize: 35.0,
                    onPressed: () {
                      addTripId();
                    },
                  ),
                ],
              ),
        Divider(
          color: Colors.black26,
          thickness: 1.5,),
        Expanded(
          child: FutureBuilder<List<Routes>>(
                future: fetchRoutesByTripIdFromDatabase(dropdownValue),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return new ListView.separated(
                        //scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        separatorBuilder: (context, index) =>
                            Divider(
                              color: Colors.black26,
                              thickness: 1.5,
                            ),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          final item = snapshot.data;
                          final itemID = snapshot.data[index].routeID;
                          final snackBar = SnackBar(
                            content: Text('Deleted Route ' + snapshot.data[index].routeID.toString()),
                          );
                          return Dismissible(
                            key: Key(itemID.toString()),
                            onDismissed: (direction) {
                              deleteRouteFromDatabase(snapshot.data[index].routeID);
                              item.removeAt(index);
                              Scaffold.of(context).showSnackBar(snackBar);
                            },
                            confirmDismiss: (direction) async {
                              final result = await showDialog(
                                  context: context,
                                  builder: (_) => RouteDelete()
                              );
                              //print(result);
                              return result;
                            },
                            child: ListTile(
                              title: Text('Route : ' + snapshot.data[index].routeID
                                  .toString()),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(padding: EdgeInsets.all(3.0),),
                                  Text('Bus No: ' + snapshot.data[index].busNo),
                                  Text('From : ' + snapshot.data[index].fromStop),
                                  Text('To : ' + snapshot.data[index].toStop),
                                  Text('Trip : ' + snapshot.data[index].tripID.toString()),
                                  Text('Fare: \$' + snapshot.data[index].fare.toString()),
                                  //Padding(padding: EdgeInsets.all(5.0),),
                                  //Divider(),
                                ],
                              ),
                              isThreeLine: true,
                            ),

                            background: Container(
                              color: Colors.red,
                              padding: EdgeInsets.only(left: 16),
                              child: Align(
                                child: Icon(Icons.delete, color: Colors.white),
                                alignment: Alignment.centerLeft,
                              ),
                            ),
                          );
                        }
                    );
                  }
                  else if (snapshot.hasError) {
                    return new Text("${snapshot.error}");
                  }
                  return new Container(alignment: AlignmentDirectional.center,
                    child: new CircularProgressIndicator(),);
                }
            ),
        ),
              ]
        )
      ),
    );
  }

  Future<List<Map>> fetchAllRoutes() async{
    var dbHelper = DBHelper();
    List<Map> list = await dbHelper.getAllTripsID();
    print(list);
    return list;
  }

  Future<List<Routes>> fetchRoutesByTripIdFromDatabase(int id) async {
    var dbHelper = DBHelper();
    Future<List<Routes>> route = dbHelper.getRouteByTripID(id);

    // List<Map> list = await dbHelper.getFaresByTripsID(id);
    // totalFares = list[0]['SUM(fare)'];
    // print('total fares are: ' + totalFares.toString());
    return route;
  }

  void deleteRouteFromDatabase(int id) async {
    var dbHelper = DBHelper();
    int i = await dbHelper.deleteRoute(id);
    print(i.toString() + ' record is deleted');
    setState(() {});
  }

  void addTripId() async {
    var dbHelper = DBHelper();
    int i = await dbHelper.saveTrip({
      DBHelper.totalFare: 0,
    });
    print("TripID created: " + i.toString());

    // List<Map> list = await dbHelper.getAllTripsID();
    // List<dynamic> newList = list.map((m)=>m['tripID']).toList();
    // print(newList);
    setState(() {});
    _showSnackBar("Trip " + i.toString() + " created!");
  }

  Future<List<dynamic>> getAllTripsID() async {
    var dbHelper = DBHelper();
    List<Map> list = await dbHelper.getAllTripsID();
    List<dynamic> newList = list.map((m)=>m['tripID']).toList();
    return(newList);
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }
}
