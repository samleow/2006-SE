import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/db/dbhelper.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_app/services/CallAPIServices.dart';
import 'package:flutter_app/controllers/CalculateFareController.dart';

class ConcessionPage extends StatefulWidget {
  _ComparePageState createState() => _ComparePageState();
}

class _ComparePageState extends State<ConcessionPage> {
  CallAPIServices get service => GetIt.I<CallAPIServices>();
  CalculateFareController get _calculateFareController => GetIt.I<CalculateFareController>();

  int tripListLength = -1;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  double totalFares;

  static bool _isLoading = true;

  @override
  void initState() {
    getTripListLength();
    super.initState();
  }

  getTripListLength() async {
    setState(() {
      _isLoading = true;
    });
    var dbHelper = DBHelper();
    List<Map> list = await dbHelper.getAllTripsID();
    tripListLength = list.length;
    for(int i=0; i<tripListLength; i++)
    {
      _currentDaySelected.add(1);
      _currentTripSelected.add(1);
      _price.add(0.0);
      _checkbox.add(false);
    }
    print(_currentDaySelected.length);
    print(_currentTripSelected.length);
    setState(() {
      _isLoading = false;
    });
  }

  Future<double> fetchRoutesByTripIdFromDatabase(int id) async {
    var dbHelper = DBHelper();
    List<Map> list = await dbHelper.getFaresByTripsID(id);
    totalFares = list[0]['SUM(fare)'];
    print(totalFares);
    return totalFares;
  }

  var list = new List<int>.generate(10, (i) => i + 1);
  // int _currentDaySelected = 1,
  //     _currentTripSelected = 1;

  List<int> _currentDaySelected =[]; // <-- the number of list must be followed by the number of trips
  List<int> _currentTripSelected =[]; // <-- the number of list must be followed by the number of trips
  List<double> _price = []; // <-- the number of list must be followed by the number of trips
  List<bool> _checkbox = [];
  //double price = 2.10;
  double totalPrice = 0;

  String _currentCardholder = "Primary Student";
  //int _cardholderIndex = 0;

  // Widget buildlist(BuildContext context, int index) {
  //
  //   return Scaffold(
  //
  //     body: Builder(
  //       builder: (_) {
  //         if (_isLoading) {
  //           return Center(child: CircularProgressIndicator());
  //         }
  //         if (_apiResponse.error) {
  //           return Center(child: Text(_apiResponse.errorMessage));
  //         }
  //
  //         return new Container(
  //             margin: EdgeInsets.all(20.0),
  //             child: Center(
  //               child: Column(
  //                 children: <Widget>[
  //                   Text("Trip 1: S" + price.toString()),
  //                   Text("Number of Day"),
  //                   DropdownButton<int>(
  //                     items: list.map((int dropDownIntItem) {
  //                       return DropdownMenuItem<int>(
  //                         value: dropDownIntItem,
  //                         child: Text(dropDownIntItem.toString()),
  //                       );
  //                     }
  //                     ).toList(),
  //                     onChanged: (int newValue) {
  //                       setState(() {
  //
  //                         _currentDaySelected = newValue;
  //                       });
  //                     },
  //
  //                     value: _currentDaySelected,
  //
  //                   ),
  //                   SizedBox(
  //                     height: 20.0,
  //                   ),
  //                   Text("Number of Trip"),
  //                   DropdownButton<int>(
  //                     items: list.map((int dropDownIntItem) {
  //                       return DropdownMenuItem<int>(
  //                         value: dropDownIntItem,
  //                         child: Text(dropDownIntItem.toString()),
  //                       );
  //                     }
  //                     ).toList(),
  //                     onChanged: (int newValue) {
  //                       setState(() {
  //                         this._currentTripSelected = newValue;
  //                       });
  //                     },
  //
  //                     value: _currentTripSelected,
  //
  //                   ),
  //                 ],
  //               ),
  //             )
  //
  //         );
  //       },
  //     ),

        // floatingActionButton : FloatingActionButton(
        //     onPressed: () {
        //       return showDialog(
        //           context: context,
        //           builder: (context) {
        //             if (_isLoading) {
        //               return Center(child: CircularProgressIndicator());
        //             }
        //             if (_apiResponse.error) {
        //               return Center(child: Text(_apiResponse.errorMessage));
        //             }
        //             return AlertDialog(
        //               title: Text("Message"),
        //               content: Column(
        //                 children: <Widget>[
        //                   Text('Total Fares:\$ ${totalPrice.toStringAsFixed(2)}'),
        //                   Text('${_currentCardholder}: \$ ${getConcessionPrice(_currentCardholder, _apiResponse)}'),
        //                   Text(comparePrice(getConcessionPrice(_currentCardholder, _apiResponse), totalPrice)),
        //                 ],
        //               ),
        //             );
        //           }
        //       );
        //     },
        //   child: Icon(Icons.navigate_next),
  //       );
  // }
  // calculate Total Price
  // String calculatedTotalPrice(double price, int numDay, int numTrip) {
  //   totalPrice = price * numDay * numTrip;
  //   return totalPrice.toStringAsFixed(2);
  // }

  Widget buildTripCard(BuildContext context, int index) {
    return new Container(
      child: Card(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                FutureBuilder(
                    future: fetchRoutesByTripIdFromDatabase(index+1),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        return Column(
                            children: <Widget>[
                              CheckboxListTile(
                              value: _checkbox[index],
                                  title: Text("Trip " + (index+1).toString() + "  \$" +snapshot.data.toString(), //+snapshot.data.toString(),
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.blue),),
                                  onChanged: (bool value) {
                                    setState(() {
                                      _checkbox[index] = value;
                                      if (value == false) {
                                        _price[index] = 0;
                                      }
                                      else {
                                        _price[index] = snapshot.data; // <-- _originalDBPrice[index] must be from database value
                                      }
                                    });
                                  }
                              ),
                              if(_checkbox[index]) // if statement is to control the Column according to the checkbox
                                Column(
                                    children: <Widget>[
                                      // Text("Trip " + tripsList[index].toString() + ": SGD" +
                                      //     _price[index].toString(),
                                      //     style: TextStyle(
                                      //         fontSize: 20.0,
                                      //         color: Colors.blue)),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Text("Number of days per month"),
                                      DropdownButton<int>(
                                        items: list.map((int dropDownIntItem) {
                                          return DropdownMenuItem<int>(
                                            value: dropDownIntItem,
                                            child: Text(dropDownIntItem.toString()),
                                          );
                                        }
                                        ).toList(),
                                        onChanged: (int newValue) {
                                          setState(() {
                                            _currentDaySelected[index] = newValue;
                                          });
                                        },

                                        value: _currentDaySelected[index],

                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Text("Number of Trips per day"),
                                      DropdownButton<int>(
                                        items: list.map((int dropDownIntItem) {
                                          return DropdownMenuItem<int>(
                                            value: dropDownIntItem,
                                            child: Text(dropDownIntItem.toString()),
                                          );
                                        }
                                        ).toList(),
                                        onChanged: (int newValue) {
                                          setState(() {
                                            _currentTripSelected[index] = newValue;
                                          });
                                        },
                                        value: _currentTripSelected[index],
                                      ),
                                    ]
                                )
                            ]
                        );
                      }
                      else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      } else if (snapshot.data == null){
                        return Text("No Trips");
                      }
                      // By default, show a loading spinner
                      return CircularProgressIndicator();
                    }
                ),

// FutureBuilder(
                //   future: fetchRoutesByTripIdFromDatabase(index+1),
                //   builder: (context, snapshot) {
                //     if(snapshot.hasData){
                //       return Text(snapshot.data.toString());
                //     }else if (snapshot.hasError) {
                //       return Text("${snapshot.error}");
                //     }
                //       return CircularProgressIndicator();
                //     }
                // ),

              ],
            )
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold (
      appBar: new AppBar(
        title: new Text('Total Price: \$ ${_calculateFareController.calculatedTotalPrice(
            _price, _currentDaySelected, _currentTripSelected, tripListLength)}'),
      ),
      body: Builder(
        builder: (_) {
          return new Container(
            margin: EdgeInsets.all(24),
            child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 300,
                      child: AnimatedList(
                        key: _listKey,
                        initialItemCount: tripListLength,
                        itemBuilder: (context, index, animation) {
                          return buildTripCard(context, index);
                        },
                      ),
                    ),
                    SizedBox(height: 20.0,),
                    DropdownButton<String>(
                      // get api data to display on drop down list
                      items: service.mcList.map((item) {
                        return DropdownMenuItem<String>(
                          child: Text(item.cardholders,
                              style: TextStyle(color: Colors.blue)),
                          value: item.cardholders,
                        );
                      }).toList(),
                      onChanged: (String cardholders) {
                        setState(() {
                          // update the selected value on UI
                          this._currentCardholder = cardholders;
                        });
                      },
                      // display the selected value on UI
                      value: _currentCardholder,

                    ),
                  ],
                )
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Message"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Total Fares:\$ ${_calculateFareController.calculatedTotalPrice(
                          _price, _currentDaySelected, _currentTripSelected, tripListLength)}'),
                      Text('${_currentCardholder}: \$ ${_calculateFareController.getConcessionPrice(
                          _currentCardholder)}'),
                      Text(_calculateFareController.comparePrice(
                          _calculateFareController.getConcessionPrice(_currentCardholder),
                          double.parse(_calculateFareController.calculatedTotalPrice(
                              _price, _currentDaySelected, _currentTripSelected, tripListLength)))),
                    ],
                  ),
                );
              }
          );
        },
        child: Icon(Icons.navigate_next),
      ),
    );
  }
}