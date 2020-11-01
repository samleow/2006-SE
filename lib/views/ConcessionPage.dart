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

  var listMonth = new List<int>.generate(31, (i) => i + 1);
  var list = new List<int>.generate(10, (i) => i + 1);

  List<int> _currentDaySelected =[]; // <-- the number of list must be followed by the number of trips
  List<int> _currentTripSelected =[]; // <-- the number of list must be followed by the number of trips
  List<double> _price = []; // <-- the number of list must be followed by the number of trips
  List<bool> _checkbox = [];
  double totalPrice = 0;
  String _currentFareType;
  String _currentCardholder;

  List<String> _concessionType = ['Hybrid', 'Bus', 'Mrt'];
  String _concessionTypeValue = 'Hybrid';

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
                                subtitle: Text((() {
                                  if(!(((snapshot.data[1] == 1 && _concessionTypeValue == 'Bus') || (snapshot.data[1] == 2 && _concessionTypeValue == 'Mrt')
                                      ||(_concessionTypeValue == 'Hybrid'))  && (snapshot.data[1] != 0))){
                                    if(snapshot.data[1] == 0){
                                      return "Trip is empty";
                                    }
                                    if(_concessionTypeValue == 'Bus')
                                      return "Trip contains MRT route";
                                    else if(_concessionTypeValue == 'Mrt')
                                      return "Trip contains Bus route";
                                  }

                                  return "";
                                })(),
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.red,
                                  ),),
                                title: Text((() {
                                    return "Trip " + (index+1).toString() + ":  \$" + snapshot.data[0].toStringAsFixed(2);}
                                  )(),
                                  style: TextStyle(
                                    fontSize: 19.0,
                                    color: Colors.blueAccent
                                ),),
                                    onChanged: (((snapshot.data[1] == 1 && _concessionTypeValue == 'Bus') || (snapshot.data[1] == 2 && _concessionTypeValue == 'Mrt')
                                    ||(_concessionTypeValue == 'Hybrid'))  && (snapshot.data[1] != 0))? (value){
                                    setState(() {
                                      _checkbox[index] = value;
                                      if (value == false) {
                                        _price[index] = 0;
                                      }
                                      else {
                                        _price[index] = snapshot.data[0]; // <-- _originalDBPrice[index] must be from database value
                                      }
                                    });
                                  } : null,
                              ),
                              if(_checkbox[index]) // if statement is to control the Column according to the checkbox
                                Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text("Number of Days per Month : ",
                                            style: TextStyle(
                                            fontSize: 15,
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
                                                      fontSize: 19,
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
                                                      fontSize: 19,
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
        automaticallyImplyLeading: false,
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
                                    fontSize: 19,
                                    color: Colors.deepPurple,)),
                              value: item,
                            );
                          }).toList(),
                          onChanged: (String concessionType) {
                            setState(() {
                              // update the selected value on UI
                              this._concessionTypeValue = concessionType;
                              for(int i = 0; i < _checkbox.length;i++){
                                _checkbox[i] = false;
                              }
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
                            hint: Text('Select Card-Holder type here',
                              style: TextStyle(
                              fontSize: 19,
                              color: Colors.deepPurple,)),
                            items: getConcessionType(snapshot.data).map((item) {
                              return DropdownMenuItem<String>(
                                child: Text(item,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 19,
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
                        child: MaterialButton(
                            onPressed: () => {},
                            child: Container(
                              // margin: const EdgeInsets.only(
                              //     left: 10.0, right: 10, bottom: 0),
                              width: double.infinity,
                              //padding: const EdgeInsets.all(20.0),
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
                                                fontSize: 19,
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
    );
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
    setState(() {
      _isLoading = false;
    });
  }

  double finalBusOrMRT;

  Future<List<double>> fetchRoutesByTripIdFromDatabase(int id) async {
    var dbHelper = DBHelper();
    List<Map> sumFare = await dbHelper.getFaresByTripsID(id);
    List<Map> busOrMrt = await dbHelper.getBusOrMRTByTripsID(id);

    totalFares = sumFare[0]['SUM(fare)'];
    //String stringBusOrMRT = busOrMrt[0]['BUSorMRT'];
    //print(busOrMrt);

    if(busOrMrt.length == 0){
      finalBusOrMRT = 0;
      totalFares = 0;
    } else if(busOrMrt.length > 1) {
      finalBusOrMRT = 3;
    } else if(busOrMrt[0]['BUSorMRT'] == 'Bus'){
      finalBusOrMRT = 1;
    } else if(busOrMrt[0]['BUSorMRT'] == 'MRT'){
      finalBusOrMRT = 2;
    }
    return [totalFares, finalBusOrMRT];
  }


  Future<String> getFareTypeFromDB() async {
    var dbHelper = DBHelper();
    List<Map> list = await dbHelper.getFareType();
    String fareTypeDB = list[0]['fareType'];
    return(fareTypeDB);
  }

  List getConcessionType(String fareType) {
    List<String> concessionType = [];
    for(int i = 0; i < service.mcList.length; i++) {
      if (fareType == 'Adult') {
        if (service.mcList[i].cardholders == 'Full-time National Serviceman' || service.mcList[i].cardholders == 'Adult (Monthly Travel Pass)'
            || service.mcList[i].cardholders == 'University Student') {
          concessionType.add(service.mcList[i].cardholders);
        }
      } else if (fareType == 'Senior Citizen') {
        if (service.mcList[i].cardholders == 'Senior Citizen') {
          concessionType.add(service.mcList[i].cardholders);
        }
      } else {
        if (service.mcList[i].cardholders.contains('Student') && service.mcList[i].cardholders != 'University Student') {
          concessionType.add(service.mcList[i].cardholders);
        }
      }
    }
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