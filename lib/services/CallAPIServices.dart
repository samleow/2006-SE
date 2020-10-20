import 'dart:async';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/models/BusFares.dart';
import 'package:flutter_app/models/BusRoutes.dart';
import 'package:flutter_app/models/BusNo.dart';
import 'package:flutter_app/models/BusStops.dart';
import 'package:flutter_app/models/MRTFares.dart';
import 'package:flutter_app/models/MRTRoute.dart';
import 'package:flutter_app/models/MonthlyConcession.dart';
import 'package:http/http.dart' as http;

class CallAPIServices {
  static const GovDataAPI = 'https://data.gov.sg/api/action/datastore_search?resource_id=';
  static const DataMallAPI = 'http://datamall2.mytransport.sg/ltaodataservice';
  static const accountkey = 'ms77YJ/1TlCm5H79vhT6fA=='; // for DataMall

  // List of data stored in class
  List<BusFares> busFares = [];
  List<BusNo> busNo = [];
  List<BusRoutes> busRoutes = [];
  List<BusStops> busStops = [];
  List<MonthlyConcession> mcList = [];
  List<MRTFares> mrtFares = [];
  List<MRTRoute> mrtRoutes = [];


  // NOTE :
  // Future methods below returns bool for simple error check
  // May want to return template class containing bool and string for proper debugging purposes
  // Similar to api_response template class
  // Eg. class response<T> { bool error; String error_message; response({this.error = false, this.error_message}); }


  //one list is to check the user type
  // we do if else statement and if usertype == adult,
  // usertype = adult_card_fare_per_ride which will put inside the API field
  //Calling Gov Data API to retrieve Bus Fares Data
  Future<bool> callBusFaresAPI() {
    return http.get(GovDataAPI +
        '7a5c22f0-71da-4c24-b419-84322b54ce17&fields=adult_card_fare_per_ride')
        .then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final jsondatabody = jsonData['result']['records'];
        for (var item in jsondatabody) {
          busFares.add(BusFares.fromJson(item));
        }
        return true; //APIResponse<List<BusFares>>(data: BusFareData);
      }
      return false; //APIResponse<List<BusFares>>(error: true, errorMessage: 'An error occurred');
    })
        .catchError((
        _) => false); //APIResponse<List<BusFares>>(error: true, errorMessage: 'An error occurred, never return API data'));
  }

  //Calling DataMall API to retrieve Bus Routes
  /*Future<bool> callBusRoutesAPI() {
    return http.get('http://datamall2.mytransport.sg/ltaodataservice/BusRoutes',
        headers: {'AccountKey': accountkey}).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final jsondatabody = jsonData['value'];
        for (var item in jsondatabody) {
          busRoutes.add(BusRoutes.fromJson(item));
        }
        return true;//APIResponse<List<BusRoutes>>(data: BusRoutesData);
      }
      return false;//APIResponse<List<BusRoutes>>(error: true, errorMessage: 'An error occurred');
    })
        .catchError((_) => false);//APIResponse<List<BusRoutes>>(error: true, errorMessage: 'An error occurred, never return API data'));
  }*/


  /*Future<bool> callBusRoutesAPI() {
    int i = 0;
    bool stopwhileloop = true;
    while (stopwhileloop) {
      return http.get('http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?\$skip=' + i.toString(), headers: {'AccountKey': accountkey}).then((data) {
        if (data.statusCode == 200 && data.body.length >= 500) {
          final jsonData = json.decode(data.body);
          final jsondatabody = jsonData['value'];
          for (var item in jsondatabody) {
            busRoutes.add(BusRoutes.fromJson(item));
          }
          return true; //APIResponse<List<BusRoutes>>(data: BusRoutesData);
        } else stopwhileloop = false;
        return false; //APIResponse<List<BusRoutes>>(error: true, errorMessage: 'An error occurred');
      }).catchError((_) => false); //APIResponse<List<BusRoutes>>(error: true, errorMessage: 'An error occurred, never return API data'));
    }
  }*/

  Future<bool> callBusRoutesAPI() async {
    int i = 0;
    var array = [];
    while (true) {
      final requestURL = "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?\$skip=" +
          i.toString();
      final response = await http.get(
          requestURL, headers: {'AccountKey': accountkey});
      if (response.statusCode == 200) {
        if (response.body.length >= 500) {
          final responseJson = json.decode(response.body);
          final jsondatabody = responseJson['value'];
          array.addAll(jsondatabody);
        } else
          break;
      }
      else
        print("Error Datamall: " + response.statusCode.toString());
      i += 500;
    }
    //remove the invalid bus stop code
    for (int i = 0; i < array.length; i++) {
      //Checking if string is numeric in dart
      if (double.parse(array[i]['BusStopCode'], (e) => null) == null) {
        array.removeAt(i);
      }
    }
    for (int i = 0; i < array.length; i++) {
      busRoutes.add(BusRoutes.fromJson(array[i]));
      for (int j = 0; j < busStops
          .length; j++) { // need to run the busStop API first to get data then can compare
        if (array[i]['BusStopCode'] == busStops[j].busStopCode) { //comparison of the bus stop code with the bus stop class
          //store the bus Stop inside the busRoutes class
          busRoutes[busRoutes.length - 1].busStop = busStops[j];
          break;
        }
      }
    }
    //Store the bus routes into the BusNo List<BusNo>
    for (int i = 0; i < busNo.length; i++) {
      busNo[i].busRoutes = [];
      for (int j = 0; j < array
          .length; j++) { //add in the bus route into the busNo List<busRoute>
        if (array[j]['ServiceNo'] == busNo[i].serviceNo) {
          busNo[i].busRoutes.add(busRoutes[j]);
        }
      }
    }
    //Store the busNo into the Bus Stop List<BusNo>
    for (int i = 0; i < busStops.length; i++) {
      busStops[i].busNo = [];
      for (int j = 0; j < busNo.length; j++) {
        for (int k = 0; k < busNo[j].busRoutes.length; k++) {
          if (busStops[i].busStopCode == busNo[j].busRoutes[k].busStop.busStopCode) {
            busStops[i].busNo.add(busNo[j]);
            break;
          }
        }
      }
    }
    return true;
  }

  Future<bool> callBusStopsAPI() async {
    int i = 0;
    while (true) {
      final requestURL = "http://datamall2.mytransport.sg/ltaodataservice/BusStops?\$skip=" +
          i.toString();
      final response = await http.get(
          requestURL, headers: {'AccountKey': accountkey});
      if (response.statusCode == 200) {
        if (response.body.length >= 500) {
          final responseJson = json.decode(response.body);
          final jsondatabody = responseJson['value'];
          for (var item in jsondatabody) {
            busStops.add(BusStops.fromJson(item));
          }
        } else
          break;
      } else {
        print("Error Datamall: " + response.statusCode.toString());
      }
      i += 500;
    }
    return true;
  }

  Future<bool> callBusServicesAPI() async {
    int i = 0;
    while (true) {
      final requestURL = "http://datamall2.mytransport.sg/ltaodataservice/BusServices?\$skip=" +
          i.toString();
      final response = await http.get(
          requestURL, headers: {'AccountKey': accountkey});
      if (response.statusCode == 200) {
        if (response.body.length >= 500) {
          final responseJson = json.decode(response.body);
          final jsondatabody = responseJson['value'];
          for (var item in jsondatabody) {
            if (item['Direction'] == 1) { // to remove duplicates
              //busServices.add(BusServices.fromJson(item));
              busNo.add(BusNo.fromJson(item));
            }
          }
        } else
          break;
      } else {
        print("Error Datamall: " + response.statusCode.toString());
      }
      i += 500;
    }
    return true;
  }


  //Calling Gov Data API to retrieve Monthly Concession Data
  Future<bool> callMCListAPI() {
    return http.get(GovDataAPI + 'aeb8dce2-93b8-4227-afdd-a0c70d3c0079').then((
        data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final jsondatabody = jsonData['result']['records'];
        for (var item in jsondatabody) {
          mcList.add(MonthlyConcession.fromJson(item));
        }
        return true; //APIResponse<List<MonthlyConcession>>(data: mclistdata);
      }
      return false; //APIResponse<List<MonthlyConcession>>(error: true, errorMessage: 'An error occurred');
    })
        .catchError((
        _) => false); //APIResponse<List<MonthlyConcession>>(error: true, errorMessage: 'An error occurred, never return API data'));
  }

  //one list is to check the user type
  // we do if else statement and if usertype == adult,
  // usertype = adult_card_fare_per_ride which will put inside the API field
  //Calling Gov Data API to retrieve MRT Fares Data (For now adult only)
  Future<bool> callMRTFaresAPI() {
    return http.get(
        GovDataAPI + 'e496ae38-989e-4eac-977d-e64c9e91a20f&limit=10000').then((
        data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final jsondatabody = jsonData['result']['records'];
        //BusFareData.add(BusFares.fromJson(jsondatabody['records']));
        for (var item in jsondatabody) {
          if (item['fare_type'] == 'Adult card fare' &&
              item['applicable_time'] == 'All other timings') {
            mrtFares.add(MRTFares.fromJson(item));
          }
        }
        return true; // APIResponse<List<MRTFares>>(data: MRTFareData);
      }
      return false; //APIResponse<List<MRTFares>>(error: true, errorMessage: 'An error occurred');
    })
        .catchError((
        _) => false); //APIResponse<List<MRTFares>>(error: true, errorMessage: 'An error occurred, never return API data'));
  }

  //List<String> MRTDataset = [];
  Future<bool> retrieveMRTRoutes() async {
    var myData = await rootBundle.loadString("assets/MRTDataset.csv");
    List<List<dynamic>> csvTable = CsvToListConverter().convert(myData);
    csvTable.removeAt(0); // remove column heading
    csvTable.forEach((value) {
      String value1 = value.toString().substring(1, value
          .toString()
          .length - 1); // remove the first and last bracklets
      mrtRoutes.add(MRTRoute.fromList(value1.split(',')));
    });
    return true;
  }
}



  /*bool BusNoContainsBusRoute() {
    for (int i = 0; i < busNo.length; i++) {
      busNo[i].busRoutes = [];
      for (int j = 0; j < busRoutes.length; j++) { //add in the bus route into the busNo List<busRoute>
        if (busNo[i].serviceNo == busRoutes[j].serviceNo) {
          busNo[i].busRoutes.add(busRoutes[j]);
        }
      }
      //busNo = busNo[0].busRoutes.toSet().toList();
      //[10,[[9123,1,1,serviceno], 123123 ,123123], 67 [123123, 123123, 12312]]
      //print(busNo.length);
    }
    return true;
  }*/





