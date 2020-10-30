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
      return 0.0;
    }

    String fromDistance = "-1";
    String toDistance = "-1";
    bool checkFromDistance = false;
    bool checkToDistance = false;

    for (int i = 0; i < service.busNo.length; i++) {
      if (service.busRoutes[i].direction == 1 || service.busRoutes[i].direction == 2) { // Added direction == 2

        if (service.busNo[i].serviceNo == busNo) {

          for (int j = 0; j < service.busNo[i].busRoutes.length; j++) {
            if (service.busNo[i].busRoutes[j].busStop.busStopCode == fromStop) {
              checkFromDistance = true;
              fromDistance = service.busNo[i].busRoutes[j].distance.toString();
            }
            if (service.busNo[i].busRoutes[j].busStop.busStopCode == toStop) {
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
  double calculateFaresBus(String distanceTravelled, String fareType) {
    if (double.parse(distanceTravelled) == 0){
      return 0;
    }
    // loops through the busFare list to get the distance range
    int fareTypeindex = 0;
    int index=0;
    for (int i = 0; i < service.busFares.length; i++) {
      if (service.busFares[i].fareType == fareType) {
        fareTypeindex = i;
        for (int j = 0; j < service.busFares[i].busFare.length; j++) {
          if (double.parse(distanceTravelled) <= j + 3.2) {
            index = j;
            break;
          }
        }
      }
    }
    return double.parse(service.busFares[fareTypeindex].busFare[index])/100;
  }

  double distanceTravelledMRT(String MRTLine, String fromStop, String toStop) {
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

  double calculateFaresMRT(String distanceTravelled, String fareType) {
    if (distanceTravelled == '0.0'){
      return 0;
    }
    // loops through the busFare list to get the distance range
    int fareTypeindex = 0;
    int index=0;
    for (int i = 0; i < service.mrtFares.length; i++) {
      if (service.mrtFares[i].fareType == fareType) {
        fareTypeindex = i;
        for (int j = 0; j < service.mrtFares[i].MRTfare.length; j++) {
          if (double.parse(distanceTravelled) <= j + 3.2) {
            index = j;
            break;
          }
        }
      }
    }
    return double.parse(service.mrtFares[fareTypeindex].MRTfare[index])/100;
  }

  // save route to database
  void saveRouteToDB(String transportID, String fromStop, String toStop, int dropdownValue, bool isMRT, String fareType) async{
    double _fare = isMRT ? calculateFaresMRT(distanceTravelledMRT(transportID, fromStop, toStop).toString(), fareType) :
      calculateFaresBus(distanceTravelledBus(transportID, fromStop, toStop).toString(), fareType);

    //var route = Routes(1,transportID,fromStop,toStop,5,1);
    var dbHelper = DBHelper();
    int i = await dbHelper.saveRoute({
      DBHelper.transportID : transportID,
      DBHelper.fromStop: fromStop,
      DBHelper.toStop: toStop,
      //Edited into not hard-coded anymore
      DBHelper.fare: _fare,
      DBHelper.tripID: dropdownValue,
      DBHelper.BUSorMRT: isMRT ? "MRT" : "Bus",
      DBHelper.fareType: fareType,
    });
  }
}