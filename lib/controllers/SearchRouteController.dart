import 'package:get_it/get_it.dart';
import 'package:flutter_app/services/CallAPIServices.dart';
import 'package:flutter_app/db/dbhelper.dart';

import '../db/dbhelper.dart';

// gets called by get_it
class SearchRouteController
{
  CallAPIServices get service => GetIt.I<CallAPIServices>();

  //Get the distance travelled
  double distanceTravelledBus(String busNo, String fromStop, String toStop) {
    //Check for nulls
    if (busNo == '' || fromStop == '' || toStop == '') {
      //print(0);
      return 0.0;
    }
    print(busNo);
    print(fromStop);
    print(toStop);

    String fromDistance = "-1";
    String toDistance = "-1";
    bool checkFromDistance = false;
    bool checkToDistance = false;

    //Get the distance travelled based on the user input
   /* for (int i = 0; i < service.busRoutes.length; i++) {
      if (service.busRoutes[i].direction == 1 ||
          service.busRoutes[i].direction == 2) { // Added direction == 2
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
      if (checkFromDistance && checkToDistance) {
        break;
      }*/



    for (int i = 0; i < service.busNo.length; i++) {
      if (service.busRoutes[i].direction == 1 || service.busRoutes[i].direction == 2) { // Added direction == 2
        if (service.busNo[i].serviceNo == busNo) {
          for (int j = 0; j < service.busNo[i].busRoutes.length; j++) {
            if (service.busNo[i].busRoutes[j].busStop.busStopCode == fromStop) {
              print(service.busNo[i].busRoutes[j].busStop.busStopCode);
              checkFromDistance = true;
              fromDistance = service.busNo[i].busRoutes[j].distance.toString();
            }
            if (service.busNo[i].busRoutes[j].busStop.busStopCode == toStop) {
              print(service.busNo[i].busRoutes[j].busStop.busStopCode);
              checkToDistance = true;
              toDistance = service.busNo[i].busRoutes[j].distance.toString();
            }
          }
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
    double distance = double.parse(toDistance) - double.parse(fromDistance);
    if(distance < 0){
      distance*=-1;
    }
    return distance;
  }

  //Find the bus fare prices based on the distance travelled
  double calculateFaresBus(String distanceTravelled) {
    if (double.parse(distanceTravelled) == 0){
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

  double distanceTravelledMRT(String MRTLine, String fromStop, String toStop) {
    //MRTLine = convertLineNamesToCodes();
    //fromStop = fromTextController.text;
    //toStop = toTextController.text;

    //Check for nulls
    if (MRTLine == '' || fromStop == '' || toStop == '') {
      return 0;
    }
    String fromDistance = "-1";
    String toDistance = "-1";
    bool checkFromDistance = false;
    bool checkToDistance = false;

    //Get the distance travelled based on the user input
    for (int i = 0; i < service.mrtRoutes.length; i++) {
      if (service.mrtRoutes[i].StationCode == MRTLine &&
          service.mrtRoutes[i].MRTStation == fromStop) {
        checkFromDistance = true;
        fromDistance = service.mrtRoutes[i].Distance.toString();
      }
      if (service.mrtRoutes[i].StationCode == MRTLine &&
          service.mrtRoutes[i].MRTStation == toStop) {
        checkToDistance = true;
        toDistance = service.mrtRoutes[i].Distance.toString();
      }
      //Once got both distance, for loop break
      if(checkFromDistance&&checkToDistance){
        break;
      }
    }
    // to check if from or to distance is not found
    if(double.parse(fromDistance) == -1 || double.parse(toDistance) == -1 ) return 0;

    //Get the distance travelled between the two location
    double distance = double.parse(toDistance) - double.parse(fromDistance);
    if(distance < 0){
      distance*=-1;
    }
    return distance;
  }

  double calculateFaresMRT(String distanceTravelled) {
    if (distanceTravelled == '0.0'){
      return 0;
    }
    // loops through the busFare list to get the distance range
    int j=0;
    for (int i = 0; i < service.mrtFares.length; i++)
    {
      if(double.parse(distanceTravelled) <= i+3.2)
      {
        j=i;
        break;
      }
    }
    return double.parse(service.mrtFares[j].MRTFarePrice)/100;
  }

  // save route to database
  void saveRouteToDB(String transportID, String fromStop, String toStop, int dropdownValue, bool isMRT) async{
    // int i = await DatabaseHelper.instance.insert({
    //   DatabaseHelper.transportID : transportID.text,
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

    double _fare = isMRT ? calculateFaresMRT(distanceTravelledMRT(transportID, fromStop, toStop).toString()) :
      calculateFaresBus(distanceTravelledBus(transportID, fromStop, toStop).toString());

    //var route = Routes(1,transportID,fromStop,toStop,5,1);
    var dbHelper = DBHelper();
    int i = await dbHelper.saveRoute({
      DBHelper.transportID : transportID,
      DBHelper.fromStop: fromStop,
      DBHelper.toStop: toStop,
      //Edited into not hard-coded anymore
      DBHelper.fare: _fare,
      DBHelper.tripID: dropdownValue,
      DBHelper.BUSorMRT: isMRT ? "MRT" : "Bus"
    });

    //_showSnackBar("Data saved successfully");
    //var route = Routes(i,transportID,fromStop,toStop,fare,dropdownValue);
  }


}