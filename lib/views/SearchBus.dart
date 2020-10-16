import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/db/dbhelper.dart';
import 'package:flutter_app/services/CallAPIServices.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SearchBus extends StatefulWidget {
  @override
  _SearchBusState createState() => _SearchBusState();
}

class _SearchBusState extends State<SearchBus> {
  CallAPIServices get service => GetIt.I<CallAPIServices>();

  @override
  void initState() {
    super.initState();
  }

  final busNoController = TextEditingController();
  final fromTextController = TextEditingController();
  final toTextController = TextEditingController();

  final fromDisplayTextController = TextEditingController();
  final toDisplayTextController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    busNoController.dispose();
    fromTextController.dispose();
    toTextController.dispose();

    fromDisplayTextController.dispose();
    toDisplayTextController.dispose();
    super.dispose();
  }

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  //Routes route = new Routes("", "", "", 0,0);
  String busNo;
  String fromStop;
  String toStop;
  double fare;
  int tripID;

  bool enableText = false;

  int dropdownValue = 1;
  String _dist = "0.0";

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
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: busNoController,
                      decoration: const InputDecoration(
                        labelText: 'Bus Service no.',
                        hintText: 'Search for Bus Service no.',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                  ),
                  validator: (String value){
                    // validate text field
                    if(value.isEmpty)
                      {
                        return "Please Enter Bus Number";
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
                    busNoController.text = suggestion;
                  },

                  //onSaved: (v)=>setState((){_dist=distanceTravelled().toString();}),


                ),
                // TextFormField(
                //   controller: busNoController,
                //   decoration: const InputDecoration(
                //     hintText: 'Search for Bus Service no.',
                //     border: OutlineInputBorder(),
                //     prefixIcon: Icon(Icons.search),
                //   ),
                //   onChanged: (v)=>setState((){_dist=distanceTravelled().toString();}),
                // ),

                Padding(
                  padding: EdgeInsets.all(10.0),
                  //child: Text('Hello World!'),
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
                    //maxLength: 5,
                    //keyboardType: TextInputType.number,
                  ),
                  validator: (String value){
                    // validate text field
                    if(value.isEmpty)
                    {
                      return "Please Enter Boarding Location";
                    }
                    return null;
                  },
                  suggestionsCallback: (pattern) async{ //pattern is user input
                    return await getBoardingSuggestions(pattern, busNoController.text); // to activate autocomplete list
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                      subtitle: Text(getBusStopCode(suggestion)),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    fromDisplayTextController.text = suggestion;
                    fromTextController.text = getBusStopCode(suggestion);

                    //setState() run the calculation
                    setState((){_dist=distanceTravelled().toStringAsFixed(2);});
                  },

                  //onSaved: (v)=>setState((){_dist=distanceTravelled().toString();}),

                ),
                // TextFormField(
                //   controller: fromTextController,
                //   decoration: const InputDecoration(
                //     labelText: 'Boarding at',
                //     hintText: 'Enter Bus Stop code',
                //     border: OutlineInputBorder(),
                //   ),
                //   maxLength: 5,
                //   keyboardType: TextInputType.number,
                //   onChanged: (v)=>setState((){_dist=distanceTravelled().toString();}),
                // ),
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
                    //maxLength: 5,
                    //keyboardType: TextInputType.number,
                  ),
                  validator: (String value){
                    // validate text field
                    if(value.isEmpty)
                    {
                      return "Please Enter Aligthting Location";
                    }
                    return null;
                  },
                  suggestionsCallback: (pattern) async{ //pattern is user input
                    return await getBoardingSuggestions(pattern, busNoController.text); // to activate autocomplete list
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                      subtitle: Text(getBusStopCode(suggestion)),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    toDisplayTextController.text = suggestion;
                    toTextController.text = getBusStopCode(suggestion);
                    //setState() run the calculation
                    setState((){_dist=distanceTravelled().toStringAsFixed(2);});

                  },

                  //onSaved: (v)=>setState((){_dist=distanceTravelled().toString();}),

                ),
                // TextFormField(
                //   controller: toTextController,
                //   decoration: const InputDecoration(
                //     labelText: 'Alighting at',
                //     hintText: 'Enter Bus Stop code',
                //     border: OutlineInputBorder(),
                //   ),
                //   maxLength: 5,
                //   keyboardType: TextInputType.number,
                //   onChanged: (v)=>setState((){_dist=distanceTravelled().toString();}),
                // ),

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
                          fontSize: 20)
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
                              fontSize: 20)
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
                              fontSize: 20)
                      ),
                      Expanded(
                          child: Text(
                              '\$${calculateFares(_dist)}',
                              textDirection: TextDirection.ltr,
                              textAlign: TextAlign.right,
                              style:TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  fontSize: 20)
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
                                  //fontWeight: FontWeight.bold,
                                  //decoration: TextDecoration.underline,
                                  fontSize: 20)
                          ),

                      // DropdownButton<int>(
                      //   value: dropdownValue,
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
                      //   items: <int>[1,2,3,4]
                      //       .map<DropdownMenuItem<int>>((int value) {
                      //     return DropdownMenuItem<int>(
                      //         value: value,
                      //         child: SizedBox(
                      //           width:100,
                      //           child: Text(value.toString(), textAlign: TextAlign.center,
                      //               style: TextStyle(
                      //                 fontSize:20,
                      //                 color: Colors.deepPurple,
                      //               )),
                      //         ));
                      //   }).toList(),
                      // ),

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
                    ]
                ),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // if all typeahead text field is not empty
          if(_formKey.currentState.validate())
            {
              testObject();
            }

        },
        tooltip: 'Show me the Values',
        child: Icon(Icons.add),
      ),
    );
  }

  //Get the distance travelled
  double distanceTravelled() {
    busNo = busNoController.text;
    fromStop = fromTextController.text;
    toStop = toTextController.text;

    //Check for nulls
    if (busNo == '' || fromStop == '' || toStop == '') {
      //print(0);
      return 0;
    }

    String fromDistance = "-1";
    String toDistance = "-1";
    bool checkFromDistance = false;
    bool checkToDistance = false;

    //Get the distance travelled based on the user input
    for (int i = 0; i < service.busRoutes.length; i++) {
      if (service.busRoutes[i].direction == 1 || service.busRoutes[i].direction == 2) { // Added direction == 2
        if (service.busRoutes[i].serviceNo == busNo &&
            service.busRoutes[i].busStopCode == fromStop) {
          checkFromDistance = true;
          fromDistance = service.busRoutes[i].distance.toString();
        }
        if (service.busRoutes[i].serviceNo == busNo &&
            service.busRoutes[i].busStopCode == toStop) {
          checkToDistance = true;
          toDistance = service.busRoutes[i].distance.toString();
        }
      }
      //Once got both distance, for loop break
      if(checkFromDistance&&checkToDistance){
        break;
      }
    }

    // to check if from or to distance is not found
    if(double.parse(fromDistance) == -1 || double.parse(toDistance) == -1 ) return 0;

    //Get the distance travelled between the two location
    return double.parse(toDistance) - double.parse(fromDistance);
  }

  //Find the bus fare prices based on the distance travelled
  double calculateFares(String distanceTravelled) {
    
    if (distanceTravelled == '0.0'){
      return 0;
    }
    // loops through the busFare list to get the distance range
    int j=0;
    for (int i = 0; i < service.busFares.length; i++)
    {
      if(double.parse(distanceTravelled) <= i+3.2)
      {
        j=i;
        break;
      }
    }

    return double.parse(service.busFares[j].BusFarePrice)/100;
  }

  void testObject() async{
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
    //fare = '5';
    //tripID = '1';

    //var route = Routes(1,busNo,fromStop,toStop,5,1);
    var dbHelper = DBHelper();
    int i = await dbHelper.saveRoute({
      DBHelper.busNo : busNoController.text,
      DBHelper.fromStop: fromTextController.text,
      DBHelper.toStop: toTextController.text,
      //Edited into not hard-coded anymore
      DBHelper.fare: calculateFares(distanceTravelled().toString()), //hard-coded for now
      DBHelper.tripID: dropdownValue //hard-coded for now
    });

    _showSnackBar("Data saved successfully");
    //var route = Routes(i,busNo,fromStop,toStop,fare,dropdownValue);
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

  // Get Bus Numbers
  Future<List> getBusServicesSuggestions(String searchInput) async
  {
    // get all BusServices to a List, .toSet() help to remove duplicates in a list
    Set<String> busServicesList = service.busServices.map((e) => e.serviceNo).toSet();

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

  // Get the list of Bus Stop Names
  Future<List> getBoardingSuggestions(String boardingLocation, String busNo) async
  {

    //Filter the correct list according to the bus number
    Set<String> filterbusStopList = service.busRoutes.map((e) // inside here is actually a loop
    {
      if(e.serviceNo == busNo)
        {
          return e.busStopCode;
        }
      else
        {
          return "";
        }
    }).toSet();

    // Filter the description
    Set<String> busStopDescList = service.busStops.map((e)
    {
      for(int i = 0; i< filterbusStopList.length; i++)
        {
          if(filterbusStopList.contains(e.busStopCode))
            {
              return e.description.toLowerCase(); // need convert all value to lowercase
            }
          else
            {
              return "";
            }
        }
    }).toSet();

    // validate the List to match the boardingLocation
    List<String> matches = List();
    matches.addAll(busStopDescList); // Swap the list busStopDescList(to display description) or filterbusStopList (to display bus stop code)
    matches.removeWhere((element) => element == ""); // remove the ""
    matches.retainWhere((s) => s.contains((boardingLocation)));

    // if SearchInput is clear
    if(busStopDescList == "") // Swap the list busStopDescList(to display description) or filterbusStopList (to display bus stop code)
    {
      // clear the matching list
      matches.clear();
    }
    return matches;
  }

  // Get Bus Stop Code
  String getBusStopCode(String busStopDescription)
  {
    int lengthOfBusStop = service.busStops.length;
    //Filter the correct list according to the bus number
    // The Set will have lots of null and "" but with 1 correct value
    Set<String> filterbusStopCode = service.busStops.map((e) // inside here is actually a loop
    {
      for(int i = 0; i<lengthOfBusStop; i++) {
        if (e.description.toLowerCase() == busStopDescription) {
          return e.busStopCode;
        }
        if(i == lengthOfBusStop)
          {
            return "";
          }
      }
    }).toSet();

    filterbusStopCode.removeWhere((element) => element == ""); // remove ""
    filterbusStopCode.removeWhere((element) => element == null); // remove null ""

    // to capture the only list value to a string ------- .toString() will not work becos it display {}
    String busStopCode = filterbusStopCode.reduce((value, element) => element);

    return busStopCode;
    
  }

}
