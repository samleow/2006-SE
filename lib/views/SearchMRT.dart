import 'package:flutter/material.dart';
import 'package:flutter_app/db/dbhelper.dart';
import 'package:flutter_app/services/CallAPIServices.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_app/controllers/SearchRouteController.dart';
import 'package:recase/recase.dart';

class SearchMRT extends StatefulWidget {
  @override
  _SearchMRTState createState() => _SearchMRTState();

}

class _SearchMRTState extends State<SearchMRT> {
  CallAPIServices get service => GetIt.I<CallAPIServices>();
  SearchRouteController get _searchRouteController => GetIt.I<SearchRouteController>();

  @override
  void initState() {
    super.initState();
  }

  final MRTLineTextController = TextEditingController();
  final fromTextController = TextEditingController();
  final toTextController = TextEditingController();
  final fromDisplayTextController = TextEditingController();
  final toDisplayTextController = TextEditingController();

  int dropdownValue = 1;
  String _dist = "0.0";
  List<String> mrtstationline = ["North South Line", "East West Line", "Changi Airport Branch Line", "North East Line", "Circle Line Extension", "Circle Line", "Downtown Line"]; //hard coded for now
  String _currentSelectedValue = "North South Line";

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    MRTLineTextController.dispose();
    fromTextController.dispose();
    toTextController.dispose();
    fromDisplayTextController.dispose();
    toDisplayTextController.dispose();
    super.dispose();
  }

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  String MRTLine;
  String fromStop;
  String toStop;
  double fare;
  int tripID;
  String _currentFareType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Form(
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
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Text('MRT Line : ',
                                style: TextStyle(
                                  fontSize: 19,
                                )),
                          ),
                        ),
                      DropdownButton<String>(
                        elevation: 12,
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        // get api data to display on drop down list
                        items: mrtstationline.map((item) {
                          return DropdownMenuItem<String>(
                            child: Text(item.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 19,
                                  color: Colors.deepPurple,
                                )),
                            value: item.toString(),
                          );
                        }).toList(),
                        onChanged: (String stncode) {
                          setState(() {
                            // update the selected value on UI
                            this._currentSelectedValue = stncode;
                            fromTextController.clear();
                            toTextController.clear();
                            fromDisplayTextController.clear();
                            toDisplayTextController.clear();
                          });
                        },
                        // display the selected value on UI
                        value: _currentSelectedValue,
                      ),
                    ],
                    ),

                    Padding(
                      padding: EdgeInsets.all(10.0),
                    ),
                      TypeAheadFormField(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: fromDisplayTextController,
                          decoration: const InputDecoration(
                            labelText: 'Boarding at',
                            hintText: 'Enter Station Name',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.train),
                          ),
                          onChanged: (text) {
                            fromTextController.text = text.toString().toLowerCase().titleCase;
                            //setState() run the calculation
                            setState((){_dist=_searchRouteController.distanceTravelledMRT(convertLineNamesToCodes(),
                                fromTextController.text,toTextController.text).toStringAsFixed(2);});
                          },

                        ),
                        validator: (String value){
                          // validate text field
                          if(value.isEmpty || InputCheck(value) == false)
                          {
                            return "Please Enter Valid MRT Station";
                          }
                          else if (checksame(fromTextController.text, toTextController.text))
                          {
                            return "Please Enter Different Boarding Location";
                          }
                          return null;
                        },
                        suggestionsCallback: (userinput) async{
                          return await getBoardingSuggestions(userinput, _currentSelectedValue, toTextController.text); // to activate autocomplete list
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          fromDisplayTextController.text = suggestion;
                          fromTextController.text = suggestion;
                          //setState() run the calculation
                          setState((){_dist=_searchRouteController.distanceTravelledMRT(convertLineNamesToCodes(),
                              fromTextController.text,toTextController.text).toStringAsFixed(2);});
                        },
                      ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                    ),
                      TypeAheadFormField(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: toDisplayTextController,
                          decoration: const InputDecoration(
                            labelText: 'Alighting at',
                            hintText: 'Enter Station Name',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.train),
                          ),
                          onChanged: (text) {
                            toTextController.text = text.toString().toLowerCase().titleCase;
                            //setState() run the calculation
                            setState((){_dist=_searchRouteController.distanceTravelledMRT(convertLineNamesToCodes(),
                                fromTextController.text,toTextController.text).toStringAsFixed(2);});
                          },
                        ),
                        validator: (String value){
                          // validate text field
                          if(value.isEmpty || InputCheck(value) == false)
                          {
                            return "Please Enter Valid MRT Station";
                          }
                          else if (checksame(fromTextController.text, toTextController.text))
                          {
                            return "Please Enter Different Alighting Location";
                          }
                          return null;
                        },
                        suggestionsCallback: (userinput) async{
                          return await getBoardingSuggestions(userinput, _currentSelectedValue, fromTextController.text); // to activate autocomplete list
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          toDisplayTextController.text = suggestion;
                          toTextController.text = suggestion;
                          //setState() run the calculation
                          setState((){_dist=_searchRouteController.distanceTravelledMRT(convertLineNamesToCodes(),
                              fromTextController.text,toTextController.text).toStringAsFixed(2);});
                        },
                      ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      //child: Text('Hello World!'),
                    ),

                    Padding(
                      padding: EdgeInsets.all(10.0),
                      //child: Text('Hello World!'),
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
                    //calculate fares
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text("MRT Fare Price: ",
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 19)
                          ),
                          Expanded(
                              child: Text(
                                  '\$${_searchRouteController.calculateFaresMRT(_dist, _currentFareType)}',
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
                      }
                      )

                        ]
                    ),
                        ],
                      ),
                  ),
                ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(_formKey.currentState.validate())
          {
            _searchRouteController.saveRouteToDB(convertLineNamesToCodes(),
                fromTextController.text, toTextController.text, dropdownValue, true, _currentFareType);
            _showSnackBar("Route saved successfully");
          }
        },
        tooltip: 'Add Route to Trip',
        child: Icon(Icons.add),
      ),
    );
  }

  //inefficient coding
  String convertLineNamesToCodes() {
    if(_currentSelectedValue == "North South Line"){
      return "NS";
    } else if (_currentSelectedValue == "East West Line") {
      return "EW";
    } else if (_currentSelectedValue == "Changi Airport Branch Line") {
      return "CG";
    } else if (_currentSelectedValue == "North East Line") {
      return "NE";
    } else if (_currentSelectedValue == "Circle Line") {
      return "CC";
    } else if (_currentSelectedValue == "Circle Line Extension") {
      return "CE";
    } else {
      return "DT";
    }
  }

  bool checksame(String fromInput, String toInput)
  {
    bool check = false;

    if(fromInput.toLowerCase() == toInput.toLowerCase()) {
      check = true;
    }
    return check;
  }

  Future<List> getBoardingSuggestions(String boardingLocation, String mrtLine, String input) async
  {
    //Filter the correct list according to the bus number
    mrtLine = convertLineNamesToCodes();
    Set<String> filterMRTStationList = service.mrtRoutes.map((e) // inside here is actually a loop
    {
      if(e.StationCode == mrtLine)
      {
        if(e.MRTStation == input) {
          return "";
        }
        return e.MRTStation;
      }
      else
      {
        return "";
      }
    }).toSet();

    // validate the List to match the boardingLocation
    List<String> matches = List();
    matches.addAll(filterMRTStationList);
    matches.removeWhere((element) => element == ""); // remove the ""
    matches.retainWhere((s) => s.contains((boardingLocation.toLowerCase().titleCase))); // added .toLowerCase() then convert .titleCase for auto caps after every space

    // if SearchInput is clear
    if(filterMRTStationList == "")
        {
      // clear the matching list
      matches.clear();
    }
    return matches;
  }

  // check individual from input
  bool InputCheck(String Input) {
    bool InputCheck = false;
    for (int i = 0; i<service.mrtRoutes.length; i++) {
      if (service.mrtRoutes[i].StationCode == convertLineNamesToCodes()) {
          if(Input.toLowerCase() == service.mrtRoutes[i].MRTStation.toLowerCase())
          {
            InputCheck = true;
          }
        }
      }
    return InputCheck;
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

  Future<String> getFareTypeFromDB() async {
    var dbHelper = DBHelper();
    List<Map> list = await dbHelper.getFareType();
    String fareTypeDB = list[0]['fareType'];
    return(fareTypeDB);
  }
}
