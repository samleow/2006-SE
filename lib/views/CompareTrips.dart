import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/db/dbhelper.dart';

class CompareTrips extends StatefulWidget {
  // _CompareTrips createState() => _CompareTrips();

  @override
  _CompareTripsState createState() => _CompareTripsState();
}

class _CompareTripsState extends State<CompareTrips> {

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final List<int> numCompare = [1, 2]; //<-- hardcode the number of compare boxes

  List<int> tripsList = [1, 2, 3, 4]; //<-- must get from Database number of trips
  List<double> _originalDBPrice = [2.10, 4.00, 5.00, 1.00]; // <-- the number of list must be followed buy the number of trips from DB

  List <double> selectedPrice =[2.10, 4.00]; //<-- temp storage to save the dropdown selected Price
  List<int> selectedTrip = [1, 1]; //<-- this is temp storage for dropdownlist to separate onchange
  double totalFares;

  Future<double> fetchRoutesByTripIdFromDatabase(int id) async {
    var dbHelper = DBHelper();
    List<Map> list = await dbHelper.getFaresByTripsID(id);
    totalFares = list[0]['SUM(fare)'];
    print(totalFares);
    return totalFares;
  }

  void updateValues(int index,double totalFare){
    selectedPrice[index] = totalFare;
  }

  Widget buildTripCard(BuildContext context, int index) {
    final trip = numCompare[index];
    return new Container(
        margin: EdgeInsets.all(24),
        child: Form(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    DropdownButton<int>(
                      items: tripsList.map((int dropDownTripItem) {
                        return DropdownMenuItem<int>(
                          value: dropDownTripItem,
                          child: SizedBox(
                            width:20,
                            child: Text("${dropDownTripItem}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.blueAccent,
                            ),
                            ),
                        ));
                      }
                      ).toList(),
                      onChanged: (int newValue) {
                        setState(() {
                          selectedTrip[index] = newValue;
                          //selectedPrice[index] = _originalDBPrice[newValue - 1]; // update the selected price
                        });
                      },
                      value: selectedTrip[index],
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
                          return Text(snapshot.data.toStringAsFixed(2),
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
              child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 300,
                      child: AnimatedList(
                        key: _listKey,
                        initialItemCount: numCompare.length,
                        itemBuilder: (context, index, animation) {
                          return buildTripCard(context, index);
                        },
                      ),
                    ),
                  ]),
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
                        Text(comparePrice(selectedPrice[0],selectedPrice[1])),
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

  // compare Price
  String comparePrice(double fprice, double sprice) {
    if(fprice == 0){
      return "First trip is empty";
    }
    if(sprice == 0){
      return "Second trip is empty";
    }
    if (fprice < sprice) {
      double diffprice = sprice - fprice;
      return "First Trip is cheaper, you saved \$${diffprice.toStringAsFixed(2)}";
    }
    if (fprice > sprice){
      double diffprices = fprice - sprice;
      return "Second Trip is cheaper, difference is \$${diffprices.toStringAsFixed(2)}";
    }
    else{
      return "Both trip is the same price";
    }
  }
}


