import 'package:get_it/get_it.dart';
import 'package:flutter_app/services/CallAPIServices.dart';
import 'package:flutter_app/db/dbhelper.dart';

// gets called by get_it
class SearchRouteController
{
  CallAPIServices get service => GetIt.I<CallAPIServices>();

  //Get the distance travelled
  double distanceTravelled(String busNo, String fromStop, String toStop) {

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


  // save route to database
  void saveRouteToDB(String busNo, String fromStop, String toStop, int dropdownValue) async{
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
    //fare = '5';
    //tripID = '1';

    //var route = Routes(1,busNo,fromStop,toStop,5,1);
    var dbHelper = DBHelper();
    int i = await dbHelper.saveRoute({
      DBHelper.busNo : busNo,
      DBHelper.fromStop: fromStop,
      DBHelper.toStop: toStop,
      //Edited into not hard-coded anymore
      DBHelper.fare: calculateFares(distanceTravelled(busNo, fromStop, toStop).toString()), //hard-coded for now
      DBHelper.tripID: dropdownValue //hard-coded for now
    });

    //_showSnackBar("Data saved successfully");
    //var route = Routes(i,busNo,fromStop,toStop,fare,dropdownValue);
  }


}