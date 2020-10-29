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

  var listMonth = new List<int>.generate(31, (i) => i + 1);
  var list = new List<int>.generate(10, (i) => i + 1);
  // int _currentDaySelected = 1,
  //     _currentTripSelected = 1;

  List<int> _currentDaySelected =[]; // <-- the number of list must be followed by the number of trips
  List<int> _currentTripSelected =[]; // <-- the number of list must be followed by the number of trips
  List<double> _price = []; // <-- the number of list must be followed by the number of trips
  List<bool> _checkbox = [];
  //double price = 2.10;
  double totalPrice = 0;
  String _currentFareType;
  String _currentCardholder;

  List<String> _concessionType = ['Bus', 'Mrt', 'Hybrid'];
  String _concessionTypeValue = 'Bus';
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
                                  title: Text("Trip " + (index+1).toString() + ":  \$" +snapshot.data.toStringAsFixed(2), //+snapshot.data.toString(),
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.blueAccent
                                    ),),
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
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text("Number of Days per Month : ",
                                            style: TextStyle(
                                            fontSize: 15,
                                            //color: Colors.deepPurple,
                                            )
                                          ),
                                          DropdownButton<int>(
                                            elevation: 12,
                                            underline: Container(
                                              height: 2,
                                              color: Colors.deepPurpleAccent,
                                            ),
                                            items: listMonth.map((int dropDownIntItem) {
                                              return DropdownMenuItem<int>(
                                                value: dropDownIntItem,
                                                child: Text(dropDownIntItem.toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.deepPurple,
                                                    )),
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
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text("Number of Times per Day : ",
                                              style: TextStyle(
                                                fontSize: 15,
                                                //color: Colors.deepPurple,
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
                                                child: Text(dropDownIntItem.toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.deepPurple,
                                                    )),
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
                                        ],
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
            margin: EdgeInsets.only(left: 24, right: 24),
            child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Text('Concession Type: ',
                                style: TextStyle(
                                  fontSize: 15,
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
                          items: _concessionType.map((item) {
                            return DropdownMenuItem<String>(
                              child: Text(item,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.deepPurple,)),
                              value: item,
                            );
                          }).toList(),
                          onChanged: (String concessionType) {
                            setState(() {
                              // update the selected value on UI
                              this._concessionTypeValue = concessionType;
                            });
                          },
                          // display the selected value on UI
                          value: _concessionTypeValue,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(0.0),
                    ),

                    FutureBuilder(
                      future: getFareTypeFromDB(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          _currentFareType = snapshot.data;
                          return DropdownButton<String>(
                            elevation: 12,
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            hint: Text('Select Concession Type here',
                              style: TextStyle(
                              fontSize: 20,
                              color: Colors.deepPurple,)),
                            items: getConcessionType(snapshot.data).map((item) {
                              //print('snapshot data is :' + snapshot.data);
                              return DropdownMenuItem<String>(
                                child: Text(item,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.deepPurple,)),
                                value: item,
                              );
                            }).toList(),
                            onChanged: (String fareType) {
                              setState(() {
                                // update the selected value on UI
                                _currentCardholder = fareType;
                              });
                            },
                            // display the selected value on UI
                            value: _currentCardholder,
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
                      height: 300,
                      child: AnimatedList(
                        key: _listKey,
                        initialItemCount: tripListLength,
                        itemBuilder: (context, index, animation) {
                          return buildTripCard(context, index);
                        },
                      ),
                    ),
                    Expanded(
                      child: Align(
                        //alignment: FractionalOffset.bottomCenter,
                        child: MaterialButton(
                            onPressed: () => {},
                            child: Container(
                              // margin: const EdgeInsets.only(
                              //     left: 10.0, right: 10, bottom: 0),
                              width: double.infinity,
                              padding: const EdgeInsets.all(20.0),
                              decoration: myBoxDecoration(), //
                              child: FutureBuilder(
                                future: getFareTypeFromDB(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    _currentFareType = snapshot.data;
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text('Total Fares:\$ ${_calculateFareController.calculatedTotalPrice(
                                            _price, _currentDaySelected, _currentTripSelected, tripListLength)}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.deepPurpleAccent,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        Text('${_currentFareType}: \$ ${_calculateFareController.getConcessionPrice(_concessionTypeValue,
                                            _currentCardholder)}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.deepPurpleAccent,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        Text(_calculateFareController.comparePrice(
                                            _calculateFareController.getConcessionPrice(_concessionTypeValue, _currentCardholder),
                                            double.parse(_calculateFareController.calculatedTotalPrice(
                                                _price, _currentDaySelected, _currentTripSelected, tripListLength))),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.deepPurpleAccent,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold))
                                      ],
                                    );
                                  } else if (snapshot.hasError) {
                                    return new Text("${snapshot.error}");
                                  }
                                  return new Container(alignment: AlignmentDirectional.center,
                                    child: new CircularProgressIndicator(),
                                  );
                                },
                              ),
                              ),
                            )
                        ),
                      ),
                  ],
                )
            )
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
      //                 Text('Total Fares:\$ ${_calculateFareController.calculatedTotalPrice(
      //                     _price, _currentDaySelected, _currentTripSelected, tripListLength)}'),
      //                 Text('${_currentCardholder}: \$ ${_calculateFareController.getConcessionPrice(
      //                     _currentCardholder)}'),
      //                 Text(_calculateFareController.comparePrice(
      //                     _calculateFareController.getConcessionPrice(_currentCardholder),
      //                     double.parse(_calculateFareController.calculatedTotalPrice(
      //                         _price, _currentDaySelected, _currentTripSelected, tripListLength)))),
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

  Future<String> getFareTypeFromDB() async {
    var dbHelper = DBHelper();
    List<Map> list = await dbHelper.getFareType();
    String fareTypeDB = list[0]['fareType'];
    print('this sis sjionasiudnhwuidnh' + fareTypeDB.toString());
    return(fareTypeDB);
  }

  List getConcessionType(String fareType) {
    //print('hello ' + fareType);
    List<String> concessionType = [];
    for(int i = 0; i < service.mcList.length; i++) {
      if (fareType == 'Adult') {
        //print("Testing1" + service.mcList[i].cardholders);
        if (service.mcList[i].cardholders == 'Full-time National Serviceman' || service.mcList[i].cardholders == 'Adult (Monthly Travel Pass)') {
          //print("Testing2" + service.mcList[i].cardholders);
          concessionType.add(service.mcList[i].cardholders);

        }
      } else if (fareType == 'Senior Citizen') {
        if (service.mcList[i].cardholders == 'Senior Citizen') {
          //print(service.mcList[i].cardholders);
          concessionType.add(service.mcList[i].cardholders);

        }
      } else {
        if (service.mcList[i].cardholders.contains('Student')) {
          concessionType.add(service.mcList[i].cardholders);
        }
      }
    }
    print("Length " + concessionType.toString());
    return concessionType;
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
}