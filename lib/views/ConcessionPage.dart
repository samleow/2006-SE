import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/db/dbhelper.dart';
import 'package:flutter_app/models/BusFares.dart';
import 'package:flutter_app/models/BusRoutes.dart';
import 'package:flutter_app/models/MonthlyConcession.dart';
import 'package:flutter_app/models/api_response.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_app/services/CallAPIServices.dart';

class ConcessionPage extends StatefulWidget {
  _ComparePageState createState() => _ComparePageState();
}

class _ComparePageState extends State<ConcessionPage> {
  CallAPIServices get service => GetIt.I<CallAPIServices>();
  APIResponse<List<MonthlyConcession>> _apiResponse;
  bool _isLoading = false;

  final List<String> tripsList = ["one", "two"];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  double totalFares;

  @override
  void initState() {
    _fetchNotes();
    super.initState();
  }

  _fetchNotes() async {
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await service.getMCList();

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

  List<int> _currentDaySelected =[1,1]; // <-- the number of list must be followed by the number of trips
  List<int> _currentTripSelected =[1,1]; // <-- the number of list must be followed by the number of trips
  List<double> _price = [0,0]; // <-- the number of list must be followed by the number of trips
  List<bool> _checkbox = [false, false];
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
  String calculatedTotalPrice(List<double> price, List<int> numDay, List<int> numTrip) {
    double temp = 0;
    totalPrice = 0;
    for (int i = 0; i< tripsList.length; i++)
      {
        temp = price[i] * numDay[i] * numTrip[i];
        //print(temp);
        totalPrice += temp;
        //print(totalPrice);
      }
    return totalPrice.toStringAsFixed(2);
  }

  // method to get the selected concession hybridPrice
  String getConcessionPrice(String cardholder,
      APIResponse<List<MonthlyConcession>> apiList) {
    String price = "";
    for (int i = 0; i < apiList.data.length; i++) {
      if (cardholder == apiList.data[i].cardholders) {
        price = apiList.data[i]
            .hybridPrice; // change hybridPrice to get other price list in the api
        break;
      }
    }
    return price;
  }

  // compare Price
  String comparePrice(String concessionPrice, double totalPrice) {
    double dConcessionPrice = double.parse(concessionPrice);
    if (totalPrice < dConcessionPrice) {
      return "Your current Trip is cheaper.";
    }
    else {
      double differentPrice = totalPrice - dConcessionPrice;
      return "You can save \$${differentPrice.toStringAsFixed(2)}";
    }
  }

  Widget buildTripCard(BuildContext context, int index) {
    final trip = tripsList[index];
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
                                            //this._currentDaySelected = newValue;
                                            _currentDaySelected[index] = newValue;
                                          });
                                        },


                                        //value: _currentDaySelected,
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
                                            //this._currentTripSelected = newValue;

                                            _currentTripSelected[index] = newValue;
                                          });
                                        },

                                        //value: _currentTripSelected,
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



              ],
            )
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: new AppBar(
        title: new Text('Total Price: \$ ${calculatedTotalPrice(
            _price, _currentDaySelected, _currentTripSelected)}'),
      ),
      body: Builder(
        builder: (_) {
          if (_isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (_apiResponse.error) {
            return Center(child: Text(_apiResponse.errorMessage));
          }

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
                        initialItemCount: tripsList.length,
                        itemBuilder: (context, index, animation) {
                          return buildTripCard(context, index);
                        },
                      ),
                    ),
                    SizedBox(height: 20.0,),
                    DropdownButton<String>(
                      // get api data to display on drop down list
                      items: _apiResponse.data.map((item) {
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
                if (_isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (_apiResponse.error) {
                  return Center(child: Text(_apiResponse.errorMessage));
                }
                return AlertDialog(
                  title: Text("Message"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Total Fares:\$ ${totalPrice.toStringAsFixed(2)}'),
                      Text('${_currentCardholder}: \$ ${getConcessionPrice(
                          _currentCardholder, _apiResponse)}'),
                      Text(comparePrice(
                          getConcessionPrice(_currentCardholder, _apiResponse),
                          totalPrice)),
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