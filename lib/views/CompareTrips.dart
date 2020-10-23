import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/db/dbhelper.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_app/controllers/CompareFareController.dart';

class CompareTrips extends StatefulWidget {
  // _CompareTrips createState() => _CompareTrips();

  @override
  _CompareTripsState createState() => _CompareTripsState();
}


class _CompareTripsState extends State<CompareTrips> {
  CompareFareController get _compareFareController => GetIt.I<CompareFareController>();

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final List<int> numCompare = [1, 2]; //<-- hardcode the number of compare boxes

  List<int> tripsList = [1, 2, 3, 4]; //<-- must get from Database number of trips
  List<double> _originalDBPrice = [2.10, 4.00, 5.00, 1.00]; // <-- the number of list must be followed buy the number of trips from DB

  var list = new List<int>.generate(10, (i) => i + 1);
  int _currentDaySelected =1; // <-- the number of list must be followed by the number of trips
  int _currentTripSelected =1; // <-- the number of list must be followed by the number of trips

  List <double> selectedPrice =[1, 1]; //<-- temp storage to save the dropdown selected Price
  List<int> selectedTrip = [1, 1]; //<-- this is temp storage for dropdownlist to separate onchange
  double totalFares;
  int dropdownValue;

  Future<double> fetchRoutesByTripIdFromDatabase(int id) async {
    var dbHelper = DBHelper();
    List<Map> list = await dbHelper.getFaresByTripsID(id);
    totalFares = list[0]['SUM(fare)'];
    print(totalFares);
    return totalFares;
  }

  Future<String> fetchBothRoutesByTripIdFromDatabase(int id1, int id2) async {
    var dbHelper = DBHelper();
    List<Map> list = await dbHelper.getBothFaresByTripsID(id1,id2);
    var listOfFares1 = list[0]['SUM(fare)'];
    if(listOfFares1 == null){
      listOfFares1 = 0.0;
    }
    var listOfFares2 = list[1]['SUM(fare)'];
    if(listOfFares2 == null){
      listOfFares2 = 0.0;
    }
    //print('list of fares is ' + listOfFares1.toString() + ' ' + listOfFares2.toString());
    return _compareFareController.comparePrice(listOfFares1, listOfFares2,
        _currentDaySelected, _currentTripSelected);;
  }

  void updateValues(int index,double totalFare){
    selectedPrice[index] = totalFare;

  }

  Widget buildTripCard(BuildContext context, int index) {
    final trip = numCompare[index];
    return new Container(
        margin: EdgeInsets.only(top: 24),
        child: Form(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text('Select Trip : ',
                            style: TextStyle(
                              fontSize: 20,
                            )),
                      ),
                    ),
                    // DropdownButton<int>(
                    //   items: tripsList.map((int dropDownTripItem) {
                    //     return DropdownMenuItem<int>(
                    //       value: dropDownTripItem,
                    //       child: SizedBox(
                    //         width:20,
                    //         child: Text("${dropDownTripItem}",
                    //         textAlign: TextAlign.center,
                    //         style: TextStyle(
                    //           fontSize: 20,
                    //           color: Colors.blueAccent,
                    //         ),
                    //         ),
                    //     ));
                    //   }
                    //   ).toList(),
                    //   onChanged: (int newValue) {
                    //     setState(() {
                    //       selectedTrip[index] = newValue;
                    //       //selectedPrice[index] = _originalDBPrice[newValue - 1]; // update the selected price
                    //     });
                    //   },
                    //   value: selectedTrip[index],
                    // ),
                    FutureBuilder(
                      future: getAllTripsID(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return DropdownButton<dynamic>(
                            value: selectedTrip[index],
                            elevation: 12,
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                            onChanged: (newValue) {
                              setState(() {
                                selectedTrip[index] = newValue;
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
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 70)),
                    // Text('SGD ${_originalDBPrice[getindex(selectedTrip[index])]}',
                    //     style: TextStyle(
                    //       fontSize: 20,)),
                    //Text('Hello'),
                    FutureBuilder(
                      future: fetchRoutesByTripIdFromDatabase(selectedTrip[index]),
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          updateValues(index,snapshot.data);
                          return Text("\$" + snapshot.data.toStringAsFixed(2),
                          style: TextStyle(fontSize: 20));
                        }else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        } else if(snapshot.data == null){
                          updateValues(index,0);
                          return Text("No route in trip");
                        }
                          return CircularProgressIndicator();
                        }
                    ),
                  ],
                ),
                Divider(
                  color: Colors.blueAccent,
                  thickness: 1,),
              ]),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (_) {
          return new Container(
            //margin: EdgeInsets.all(24),
            child: Form(
              child: Container(
                margin: const EdgeInsets.only(right: 15, left: 15),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 250,
                        child: AnimatedList(
                          key: _listKey,
                          initialItemCount: numCompare.length,
                          itemBuilder: (context, index, animation) {
                            return buildTripCard(context, index);
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Number of Days per Month : ',
                              style: TextStyle(
                                fontSize: 20,)
                          ),
                          DropdownButton<int>(
                            elevation: 12,
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            items: list.map((int dropDownIntItem) {
                              return DropdownMenuItem<int>(
                                value: dropDownIntItem,
                                child: SizedBox(
                                  width: 30,
                                  child: Text("${dropDownIntItem}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ),
                              );
                            }
                            ).toList(),
                            onChanged: (int newValue) {
                              setState(() {
                                //this._currentDaySelected = newValue;
                                _currentDaySelected = newValue;
                              });
                            },
                            //value: _currentDaySelected,
                            value: _currentDaySelected,
                          ),
                          // SizedBox(
                          //   height: 20.0,
                          // ),
                          //Padding(padding: EdgeInsets.only(bottom: 70)),
                        ],
                      ),

                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Number of Trips per Day : ',
                                style: TextStyle(
                                  fontSize: 20,
                                )),
                            DropdownButton<int>(
                              elevation: 12,
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              items: list.map((int dropDownIntItem) {
                                return DropdownMenuItem<int>(
                                  value: dropDownIntItem,
                                  child: SizedBox(
                                    width: 30,
                                    child: Text("${dropDownIntItem}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.deepPurple,
                                        )
                                    ),
                                  ),
                                );
                              }
                              ).toList(),
                              onChanged: (int newValue) {
                                setState(() {
                                  //this._currentTripSelected = newValue;
                                  _currentTripSelected = newValue;
                                });
                              },

                              //value: _currentTripSelected,
                              value: _currentTripSelected,

                            ),
                          ]),
                      Padding(padding: EdgeInsets.only(bottom: 30)),
                      FutureBuilder(
                        future: fetchBothRoutesByTripIdFromDatabase(selectedTrip[0], selectedTrip[1]),
                        builder:(context, snapshot){
                          if(snapshot.hasData){
                            return Expanded(
                              child: Align(
                                alignment: FractionalOffset.bottomCenter,
                                child: MaterialButton(
                                    onPressed: () => {},
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 10.0, right: 10, bottom: 30),
                                      padding: const EdgeInsets.all(20.0),
                                      decoration: myBoxDecoration(), //
                                      child: Text(snapshot.data.toString(),
                                          style: TextStyle(
                                          color: Colors.deepPurpleAccent,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                    )
                                ),
                              ),
                            );
                          }else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          } else if(snapshot.data == null){
                            return Text("No comparison");
                          }
                          return CircularProgressIndicator();
                          }
                      )
                      // Expanded(
                      //   child: Align(
                      //     alignment: FractionalOffset.bottomCenter,
                      //     child: MaterialButton(
                      //         onPressed: () => {},
                      //         child: Container(
                      //           margin: const EdgeInsets.all(30.0),
                      //           padding: const EdgeInsets.all(20.0),
                      //           decoration: myBoxDecoration(), //
                      //           child: getTextWidget(),
                      //         )
                      //     ),
                      //   ),
                      // ),
                    ]),
              ),

            ),
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     return showDialog(
      //         context: context,
      //         builder: (context) {
      //           return AlertDialog(
      //             title: Text("Message"),
      //             content: Column(
      //               mainAxisSize: MainAxisSize.min,
      //               children: <Widget>[
      //                 Text(_compareFareController.comparePrice(
      //                     selectedPrice[0], selectedPrice[1],
      //                     _currentDaySelected, _currentTripSelected)),
      //               ],
      //             ),
      //           );
      //         }
      //     );
      //   },
      //   child: Icon(Icons.navigate_next),
      // ),
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(
          width: 1.0,
        color: Colors.blueAccent,
      ),
      borderRadius: BorderRadius.all(
          Radius.circular(10.0) //
      ),
    );
  }

  Future<List<dynamic>> getAllTripsID() async {
    var dbHelper = DBHelper();
    List<Map> list = await dbHelper.getAllTripsID();
    List<dynamic> newList = list.map((m)=>m['tripID']).toList();
    return(newList);
  }

  // get index to know the actual price from list
  int getindex(int selectTrip)
  {
    int index = 0;
    for(int i = 0; i<tripsList.length; i++)
      {
        if(selectTrip == tripsList[i])
          {
            index = i;
            break;
          }
      }
    return index;
  }

}


