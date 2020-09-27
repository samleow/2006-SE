import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/CompareFareController.dart';
import 'package:flutter_app/models/BusFares.dart';
import 'package:flutter_app/models/BusRoutes.dart';
import 'package:flutter_app/models/MonthlyConcession.dart';
import 'package:flutter_app/models/api_response.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_app/services/CallAPIServices.dart';

class ComparePage extends StatefulWidget {
  _ComparePageState createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
  CallAPIServices get service => GetIt.I<CallAPIServices>();
  APIResponse<List<MonthlyConcession>> _apiResponse;
  bool _isLoading = false;

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


  var list = new List<int>.generate(10, (i) => i +1 );
  int _currentDaySelected = 1, _currentTripSelected = 1;
  double price = 2.10;
  double totalPrice = 0;

  String _currentCardholder = "Primary Student";
  int _cardholderIndex = 0;
  


  Widget build(BuildContext context) {
    //print(_apiResponse.data);
    return Scaffold(
      appBar: new AppBar(
        title:new Text("AppName (TBC)"),
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
              margin: EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text("Trip 1: S" + price.toString()),
                    Text("Number of Day"),
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
                          this._currentDaySelected = newValue;
                        });
                      },

                      value: _currentDaySelected,

                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text("Number of Trip"),
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
                          this._currentTripSelected = newValue;
                        });
                      },

                      value: _currentTripSelected,

                    ),
                    SizedBox(height: 20.0,),
                    Text('Total Price: ${calculatedTotalPrice(price, _currentDaySelected, _currentTripSelected)}'),
                    DropdownButton<String>(
                      // get api data to display on drop down list
                      items: _apiResponse.data.map((item) {
                        return DropdownMenuItem<String>(
                          child: Text(item.cardholders),
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
                    SizedBox(height: 20.0,),
                  ],
                ),
              )

          );
        },
      ),

        floatingActionButton : FloatingActionButton(
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
                        children: <Widget>[
                          Text('Total Fares:\$ ${totalPrice.toStringAsFixed(2)}'),
                          Text('${_currentCardholder}: \$ ${getConcessionPrice(_currentCardholder, _apiResponse)}'),
                          Text(comparePrice(getConcessionPrice(_currentCardholder, _apiResponse), totalPrice)),
                        ],
                      ),
                    );
                  }
              );
            },
          )

    );
  }
  // calculate Total Price
  String calculatedTotalPrice(double price, int numDay, int numTrip)
  {
    totalPrice = price * numDay * numTrip;
    return totalPrice.toStringAsFixed(2);
  }

  // method to get the selected concession hybridPrice
  String getConcessionPrice(String cardholder, APIResponse<List<MonthlyConcession>> apiList )
  {
    String price = "";
    for(int i = 0; i<apiList.data.length; i++)
      {
        if(cardholder == apiList.data[i].cardholders)
          {
              price = apiList.data[i].hybridPrice; // change hybridPrice to get other price list in the api
              break;
          }
      }

    return price;
  }

  // compare Price
  String comparePrice(String concessionPrice, double totalPrice)
  {

    double dConcessionPrice = double.parse(concessionPrice);
    if(totalPrice < dConcessionPrice)
      {
        return "Your current Trip is cheaper.";
      }
    else
      {
        double differentPrice = totalPrice - dConcessionPrice;
        return "You can save \$${differentPrice.toStringAsFixed(2)}";
      }
  }

}

