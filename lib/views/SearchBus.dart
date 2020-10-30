import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/db/dbhelper.dart';
import 'package:flutter_app/services/CallAPIServices.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_app/controllers/SearchRouteController.dart';
import 'package:recase/recase.dart';


class SearchBus extends StatefulWidget {
  @override
  _SearchBusState createState() => _SearchBusState();
}

class _SearchBusState extends State<SearchBus> {
  CallAPIServices get service => GetIt.I<CallAPIServices>();
  SearchRouteController get _searchRouteController => GetIt.I<SearchRouteController>();

  @override
  void initState() {
    super.initState();
  }

  final busNoController = TextEditingController();
  final busNoDisplayController = TextEditingController();
  final fromTextController = TextEditingController();
  final toTextController = TextEditingController();
  final fromDisplayTextController = TextEditingController();
  final toDisplayTextController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    busNoController.dispose();
    busNoDisplayController.dispose();
    fromTextController.dispose();
    toTextController.dispose();
    fromDisplayTextController.dispose();
    toDisplayTextController.dispose();
    super.dispose();
  }

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  String busNo;
  String fromStop;
  String toStop;
  double fare;
  int tripID;
  
  bool enableText = false;
  int radioID = 1;
  String radioButtonItem = '1';
  int dropdownValue = 1;
  String _dist = "0.0";
  bool _visible = false;
  String _currentFareType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Form( // change Container to Form
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.only(right: 15, left: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 10.0),),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text('Fare Type: ',
                            style: TextStyle(
                              fontSize: 19,

                            )),
                      ),
                    ),
                    FutureBuilder(
                      future: getFareTypeFromDB(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          _currentFareType = snapshot.data;

                          return Text(snapshot.data,
                              style: TextStyle(
                            fontSize: 22,
                            color: Colors.deepPurpleAccent,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                          ));
                        } else if (snapshot.hasError) {
                          return new Text("${snapshot.error}");
                        }
                        return new Container(alignment: AlignmentDirectional.center,
                          child: new CircularProgressIndicator(),
                        );
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: busNoDisplayController,
                      decoration: const InputDecoration(
                        labelText: 'Bus Service no.',
                        hintText: 'Search for Bus Service no.',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                    onChanged: (text){
                      busNoController.text = text;
                      setState((){_dist=_searchRouteController.distanceTravelledBus(busNoController.text
                          , fromTextController.text, toTextController.text).toStringAsFixed(2);});
                    }
                  ),
                  validator: (String value){
                    // validate text field
                    if(value.isEmpty || !busNoCheck(value))
                      {
                        return "Please Enter Valid Bus Number";
                      }
                    return null;
                  },
                  suggestionsCallback: (pattern) async{ //pattern is user input
                    return await getBusServicesSuggestions(pattern); // to activate autocomplete list
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    busNoDisplayController.text = suggestion;
                    busNoController.text = suggestion;
                    setState((){_dist=_searchRouteController.distanceTravelledBus(busNoController.text
                        , fromTextController.text, toTextController.text).toStringAsFixed(2);});
                  },


                  //onSaved: (v)=>setState((){_dist=distanceTravelled().toString();}),
                ),
                Visibility(
                  visible: _visible,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(top: 10.0),),
                        // put here
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text("Direction: ",
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 20)
                            ),
                            Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0),),
                            Radio(
                              value: 1,
                              groupValue: radioID,
                              onChanged: (val) {
                                setState(() {
                                  radioButtonItem = '1';
                                  radioID = 1;
                                });
                              },
                            ),
                            Text(
                              '1',
                              style: new TextStyle(fontSize: 17.0),
                            ),
                            Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0),),
                            Radio(
                              value: 2,
                              groupValue: radioID,
                              onChanged: (val) {
                                setState(() {
                                  radioButtonItem = '2';
                                  radioID = 2;
                                });
                              },
                            ),
                            Text(
                              '2',
                              style: new TextStyle(
                                fontSize: 17.0,
                              ),
                            ),
                          ],
                        ),
                      ]
                  )
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: fromDisplayTextController,
                    decoration: const InputDecoration(
                      labelText: 'Boarding at',
                      hintText: 'Enter Bus Stop Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.directions_bus),
                    ),
                    onChanged: (text){
                      fromTextController.text = text;
                       fromTextController.text = getBusStopCodeOnChange(text.toString().toLowerCase().titleCase, busNoController.text);
                       setState((){_dist=_searchRouteController.distanceTravelledBus(busNoController.text
                           , fromTextController.text, toTextController.text).toStringAsFixed(2);});
                    },
                    //maxLength: 5,
                    //keyboardType: TextInputType.number,
                  ),
                  validator: (String value){
                    // validate text field
                    if(value.isEmpty || fromInputCheck(busNoController.text, value) == false)
                    {
                      return "Please Enter Valid Boarding Location";
                    }
                    return null;
                  },
                  suggestionsCallback: (pattern) async{ //pattern is user input
                    return await getBoardingSuggestions(pattern, busNoController.text); // to activate autocomplete list
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                      subtitle: Text(getBusStopCode(suggestion, busNoController.text)),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    fromDisplayTextController.text = suggestion;
                    fromTextController.text = getBusStopCode(suggestion, busNoController.text);
                    //setState() run the calculation
                    setState((){
                      _dist=_searchRouteController.distanceTravelledBus(busNoController.text
                        , fromTextController.text, toTextController.text).toStringAsFixed(2);
                    });
                  },

                  //onSaved: (v)=>setState((){_dist=distanceTravelled().toString();}),

                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  //child: Text('Hello World!'),
                ),
                TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: toDisplayTextController,
                    decoration: const InputDecoration(
                      labelText: 'Alighting at',
                      hintText: 'Enter Bus Stop Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.directions_bus),
                    ),
                      onChanged: (text){
                        toTextController.text = text;
                        toTextController.text = getBusStopCodeOnChange(text.toString().toLowerCase().titleCase, busNoController.text);
                        setState((){_dist=_searchRouteController.distanceTravelledBus(busNoController.text
                            , fromTextController.text, toTextController.text).toStringAsFixed(2);});
                      },
                    //maxLength: 5,
                    //keyboardType: TextInputType.number,
                  ),
                  validator: (String value){
                    // validate text field
                    if(value.isEmpty|| fromInputCheck(busNoController.text, value) == false)
                    {
                      return "Please Enter Valid Alighting Location";
                    }
                    return null;
                  },
                  suggestionsCallback: (pattern) async{ //pattern is user input
                    return await getBoardingSuggestions(pattern, busNoController.text); // to activate autocomplete list
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                      subtitle: Text(getBusStopCode(suggestion, busNoController.text)),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    toDisplayTextController.text = suggestion;
                    toTextController.text = getBusStopCode(suggestion, busNoController.text);
                    //setState() run the calculation
                    setState((){_dist=_searchRouteController.distanceTravelledBus(busNoController.text
                        , fromTextController.text, toTextController.text).toStringAsFixed(2);});
                  },

                  //onSaved: (v)=>setState((){_dist=distanceTravelled().toString();}),

                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                Divider(
                  color: Colors.black26,
                  thickness: 1.5,
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text("Distance travelled: ",
                      style: TextStyle(
                          color: Colors.grey[800],
                          //fontWeight: FontWeight.bold,
                          fontSize: 19)
                  ),
                      Expanded(
                          child: Text(
                            _dist +"km",
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.right,
                            style:TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              fontSize: 19)
                          ))
                  ]
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text("Bus Fare Price: ",
                          style: TextStyle(
                              color: Colors.grey[800],
                              //fontWeight: FontWeight.bold,
                              fontSize: 19)
                      ),
                      Expanded(
                          child: Text(
                              '\$${_searchRouteController.calculateFaresBus(_dist,_currentFareType)}',
                              textDirection: TextDirection.ltr,
                              textAlign: TextAlign.right,
                              style:TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  fontSize: 19)
                          ))
                    ]
                ),

                Padding(
                  padding: EdgeInsets.all(10.0),
                ),

                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Save under trip : ',
                          style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 19)
                          ),
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
                    ]
                ),
                // Padding(
                //   padding: EdgeInsets.all(10.0),
                // ),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // if all typeahead text field is not empty
          if(_formKey.currentState.validate() && checkUserInput(busNoController.text, fromTextController.text, toTextController.text))
            {
              _searchRouteController.saveRouteToDB(busNoController.text,
                  fromTextController.text, toTextController.text, dropdownValue, false, _currentFareType);
              _showSnackBar("Data saved successfully");
            }
        },
        tooltip: 'Show me the Values',
        child: Icon(Icons.add),
      ),
    );
  }

  // get trips id for drop down list
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

  bool checkUserInput(String busNo, String fromInput, String toInput)
  {
    bool busCheck = false;
    bool fromInputCheck = false;
    bool toInputCheck = false;


    for (int i = 0; i<service.busNo.length; i++) {
      if (service.busNo[i].serviceNo.toLowerCase() == busNo.toLowerCase()) {
          busCheck = true;
          //return busCheck;
        for(int j = 0; j< service.busNo[i].busRoutes.length; j++)
          {
            if(fromInput == service.busNo[i].busRoutes[j].busStop.busStopCode)
              {
                fromInputCheck = true;
              }
            if(toInput == service.busNo[i].busRoutes[j].busStop.busStopCode)
              {
                toInputCheck = true;
              }
          }
      }
    }

    if(busCheck == true && fromInputCheck == true && toInputCheck == true)
      {
        return true;
      }
    else {
      return false;
    }
  }

  // check individual bus number
  bool busNoCheck(String busNo) {
    bool busCheck = false;


    for (int i = 0; i < service.busNo.length; i++) {
      if (service.busNo[i].serviceNo.toLowerCase() == busNo.toLowerCase()) {
        busCheck = true;
      }
    }
    return busCheck;
  }

  // check individual from input
  bool fromInputCheck(String busNo, String fromInput)
  {

    bool busCheck = false;
    bool fromInputCheck = false;

    for (int i = 0; i<service.busNo.length; i++) {
      if (service.busNo[i].serviceNo.toLowerCase() == busNo.toLowerCase()) {
        busCheck = true;

        for(int j = 0; j< service.busNo[i].busRoutes.length; j++)
        {
          if(fromInput.toLowerCase() == service.busNo[i].busRoutes[j].busStop.description.toLowerCase())
          {
            fromInputCheck = true;
          }
        }
      }
    }

    if(busCheck == true && fromInputCheck == true)
    {
      return true;
    }
    else {
      return false;
    }
  }

  // Get Bus Numbers
  Future<List> getBusServicesSuggestions(String searchInput) async
  {
    // get all BusServices to a List, .toSet() help to remove duplicates in a list
    Set<String> busServicesList = service.busNo.map((e) => e.serviceNo).toSet();

    // contract the List to match the searchInput
    List<String> matches = List();
    matches.addAll(busServicesList);
    matches.retainWhere((s) => s.contains((searchInput)));

    // if SearchInput is clear
    if(searchInput == "")
      {
        // clear the matching list
        matches.clear();
      }
    return matches;
  }

  Future<List> getBoardingSuggestions(String boardingLocation, String busNo) async
  {
    int direction = 1;
    List<String> description = List();
    for (int i = 0; i<service.busNo.length; i++) {
      if (service.busNo[i].serviceNo == busNo) {
        for (int j = 0; j < service.busNo[i].busRoutes.length; j++) {
          description.add(service.busNo[i].busRoutes[j].busStop.description);
        }
        break;
      }
    }

    description.removeWhere((element) => element == ""); // remove the ""
    description.retainWhere((s) => s.contains((boardingLocation.toLowerCase().titleCase))); // added .toLowerCase() then convert .titleCase for auto caps after every space

    // if SearchInput is clear
    if(description == "") // Swap the list busStopDescList(to display description) or filterbusStopList (to display bus stop code)
    {
      // clear the matching list
      description.clear();
    }
    return description;
  }

  // Get Bus Stop Code
  String getBusStopCode(String busStopDescription, String busNo)
  {
    List<String> listbusstopcode = [];
    for (int i = 0; i<service.busNo.length; i++) {
      if (service.busNo[i].serviceNo == busNo) {
        for (int j = 0; j < service.busNo[i].busRoutes.length; j++) {
          if (service.busNo[i].busRoutes[j].busStop.description == busStopDescription) {
            listbusstopcode.add(service.busNo[i].busRoutes[j].busStop.busStopCode);
          }
        }
        break;
      }
    }
    listbusstopcode.removeWhere((element) => element == ""); // remove ""
    listbusstopcode.removeWhere((element) => element == null); // remove null ""

    // to capture the only list value to a string ------- .toString() will not work becos it display {}
    String busStopCode = "";
    busStopCode = listbusstopcode.reduce((value, element) => element);
    return busStopCode;
  }


  // Get Bus Stop Code
  String getBusStopCodeOnChange(String busStopDescription, String busNo)
  {
    String busStopCode = "";

    List<String> listbusstopcode = [];
    for (int i = 0; i<service.busNo.length; i++) {
      if (service.busNo[i].serviceNo == busNo) {
        for (int j = 0; j < service.busNo[i].busRoutes.length; j++) {
          if (service.busNo[i].busRoutes[j].busStop.description == busStopDescription) {
            busStopCode = service.busNo[i].busRoutes[j].busStop.busStopCode;
          }
        }
        break;
      }
    }
    return busStopCode;
  }

  void UpdateFareTypeDatabase(int i) async {
    var dbHelper = DBHelper();
    await dbHelper.updateFareType(i);
  }

  Future<String> getFareTypeFromDB() async {
    var dbHelper = DBHelper();
    List<Map> list = await dbHelper.getFareType();
    String fareTypeDB = list[0]['fareType'];
    return(fareTypeDB);
  }
}
