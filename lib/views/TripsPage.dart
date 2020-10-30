import 'package:flutter/material.dart';
import 'package:flutter_app/models/Route.dart';
import 'package:flutter_app/db/dbhelper.dart';
import 'package:flutter_app/views/RouteDelete.dart';
import 'package:flutter_app/views/TypeSelectionPage.dart';


class TripsPage extends StatefulWidget {
  @override
  _TripsPageState createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  int dropdownValue = 1;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        title: new Text("UnFare SG"),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (content) => [
              PopupMenuItem(
                value: 1,
                child: Text("Help"),
              ),
              PopupMenuItem(
                value: 2,
                child: Text("Select Fare Type"),
              ),
            ],
            onSelected: (int menu){
              if (menu == 1){
                showAlertDialogHELP(context);
              } else if(menu == 2){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TypeSelectionPage()),
                );
              }
            },
          )
        ],
      ),
      body: Container(
        child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(left: 0)),
                  Text('Select trip : ',
                    style: TextStyle(
                      fontSize:19,
                    )),
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
                                        fontSize: 19,
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
          //Divider(),
        ],
      );
    } else {
      String longForm;
        if(snapshot.data[index].transportID == "NS"){
          longForm =  "North South Line";
        } else if (snapshot.data[index].transportID == "EW") {
          longForm = "East West Line";
        } else if (snapshot.data[index].transportID == "CG") {
          longForm = "Changi Airport Branch Line";
        } else if (snapshot.data[index].transportID == "NE") {
          longForm = "North East Line";
        } else if (snapshot.data[index].transportID == "CC") {
          longForm = "Circle Line";
        } else if (snapshot.data[index].transportID == "CE") {
          longForm = "Circle Line Extension";
        } else {
          longForm =  "Downtown Line";
        }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.all(3.0),),
          Text('MRT Line: ' + longForm),
          Text('From : ' + snapshot.data[index].fromStop),
          Text('To : ' + snapshot.data[index].toStop),
          Text('Trip : ' + snapshot.data[index].tripID.toString()),
          Text('Fare: \$' + snapshot.data[index].fare.toString()),
          Text('Fare Type: ' + snapshot.data[index].fareType.toString()),
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
    return list;
  }

  Future<List<Routes>> fetchRoutesByTripIdFromDatabase(int id) async {
    var dbHelper = DBHelper();
    Future<List<Routes>> route = dbHelper.getRouteByTripID(id);
    return route;
  }

  void deleteRouteFromDatabase(int id) async {
    var dbHelper = DBHelper();
    int i = await dbHelper.deleteRoute(id);
    setState(() {
    });
  }

  void addTripId() async {
    var dbHelper = DBHelper();
    List<Map> list = await dbHelper.getFareType();
    String fareTypeDB = list[0]['fareType'];
    int i = await dbHelper.saveTrip({
      DBHelper.fareType: fareTypeDB,
    });
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
    child: Text("Close"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("Trips"),
    //content: Text("To view the added routes information from the saved trips. Tap onto the blue '+' icon to add trips and the red '-' icon to delete selected trips."),
    content: Text("View various Routes saved in each Trip" +
        "\n\n--Manage Trips--" +
            "\n\n- Tap onto the '+' icon to create a new Trip"
            "\n\n- Tap onto the 'x' icon to delete current Trip and its Routes"+
        "\n\n\n"
        "\n\n--Manage Routes--" +
            "\n\n- Swipe on the Route you wish to delete"),
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