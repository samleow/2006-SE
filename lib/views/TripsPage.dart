import 'package:flutter/material.dart';
import 'package:flutter_app/db/database_helper.dart';
import 'package:flutter_app/models/Route.dart';
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
        title: new Text("UnFare SG"),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (content) => [
              PopupMenuItem(
                value: 1,
                child: Text("Help"),
              ),
            ],
            onSelected: (int menu){
              if (menu == 1){
                showAlertDialogHELP(context);
              }
            },
          )
        ],
      ),
      body: Container(
        //width: 280,
        //padding: EdgeInsets.only(left: 20.0),
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
                          elevation: 12,
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
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
                                  width: 50,
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
                    icon: Icon(Icons.add_circle,color: Colors.blue,),
                    iconSize: 35.0,
                    onPressed: () {
                      addTripId();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_forever, color: Colors.red,),
                    iconSize: 35.0,
                    onPressed: () {
                      showAlertDialog(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.only(right:0)),
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
                              subtitle: displayTripColumn(snapshot, index),
                              isThreeLine: true,
                              contentPadding: EdgeInsets.only(bottom: 5, left: 20),
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

  Widget displayTripColumn(snapshot, index){
    if(snapshot.data[index].BUSorMRT == 'Bus') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.all(5.0),),
          Text('Bus No. :' + snapshot.data[index].transportID),
          Padding(padding: EdgeInsets.all(1.0),),
          Text('From : ' + snapshot.data[index].fromStop),
          Padding(padding: EdgeInsets.all(1.0),),
          Text('To : ' + snapshot.data[index].toStop),
          Padding(padding: EdgeInsets.all(1.0),),
          Text('Trip : ' + snapshot.data[index].tripID.toString()),
          Padding(padding: EdgeInsets.all(1.0),),
          Text('Fare: \$' + snapshot.data[index].fare.toString()),
          Padding(padding: EdgeInsets.all(1.0),),
          Text('Fare Type: ' + snapshot.data[index].fareType.toString()),
          //Padding(padding: EdgeInsets.all(5.0),),
          //Divider(),
        ],
      );
    } else {
      //inefficient coding
      String something;
        if(snapshot.data[index].transportID == "NS"){
          something =  "North South Line";
        } else if (snapshot.data[index].transportID == "EW") {
          something = "East West Line";
        } else if (snapshot.data[index].transportID == "CG") {
          something = "Changi Airport Branch Line";
        } else if (snapshot.data[index].transportID == "NE") {
          something = "North East Line";
        } else if (snapshot.data[index].transportID == "CC") {
          something = "Circle Line";
        } else if (snapshot.data[index].transportID == "CE") {
          something = "Circle Line Extension";
        } else {
          something =  "Downtown Line";
        }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.all(3.0),),
          Text('MRT Line: ' + something),
          Text('From : ' + snapshot.data[index].fromStop),
          Text('To : ' + snapshot.data[index].toStop),
          Text('Trip : ' + snapshot.data[index].tripID.toString()),
          Text('Fare: \$' + snapshot.data[index].fare.toString()),
          Text('Fare Type: ' + snapshot.data[index].fareType.toString()),
          //Padding(padding: EdgeInsets.all(5.0),),
          //Divider(),
        ],
      );
    }
  }

  showAlertDialog(BuildContext context) {
    Widget yesButton = FlatButton(
      child: Text("Yes"),
      onPressed:  () {
        deleteTrip(dropdownValue);
        dropdownValue = 1;
        Navigator.of(context).pop();
        _showSnackBar("Trip successfully deleted!");
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

    AlertDialog alert = AlertDialog(
      title: Text("Warning"),
      content: Text("Are you sure you want to delete this trip and all its routes?"),
      actions: [
        yesButton,
        noButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
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
    setState(() {
    });
    print(i.toString() + ' record is deleted');
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

  void deleteTrip(int id) async {
    var dbHelper = DBHelper();
    int i = await dbHelper.deleteTrip(id);
    setState(() {});
    print(i.toString() + ' record is deleted');
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }
}


class Mrtmap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Mrt Map"),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/mrt_map.png')
              )
          ),
        )
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
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/Concession.png')
              )
          ),
        )
    );
  }
}

showAlertDialogHELP(BuildContext context) {
  Widget yesButton = FlatButton(
    child: Text("OK"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("Trips"),
    content: Text("To view the added routes information from the saved trips. Tap onto the blue '+' icon to add trips and the red '-' icon to delete selected trips."),
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