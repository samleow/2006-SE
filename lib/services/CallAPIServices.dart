import 'dart:async';
import 'dart:convert';
import 'package:csv/csv.dart';
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

  //Calling Gov Data API to retrieve Bus Fares Data
  Future<bool> callBusFaresAPI() {
    return http.get(GovDataAPI +
        '7a5c22f0-71da-4c24-b419-84322b54ce17')
        .then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final jsondatabody = jsonData['result']['records'];
        //BusFares disabilities = new BusFares('Disabilities');
        BusFares adult = new BusFares('Adult');
        BusFares seniorCitizen = new BusFares('Senior Citizen');
        BusFares student = new BusFares('Student');
        adult.busFare = [];
        seniorCitizen.busFare = [];
        student.busFare = [];
        for (int i = 0; i<jsondatabody.length; i++) {
          adult.busFare.add(jsondatabody[i]['adult_card_fare_per_ride']);
          seniorCitizen.busFare.add(jsondatabody[i]['senior_citizen_card_fare_per_ride']);
          student.busFare.add(jsondatabody[i]['student_card_fare_per_ride']);
        }
        busFares.add(adult);
        busFares.add(seniorCitizen);
        busFares.add(student);
        return true;
      }
      return false;
    })
        .catchError((
        _) => false);
  }

  Future<bool> callBusRoutesAPI() async {
    int i = 0;
    var array = [];
    while (true) {
      final requestURL = DataMallAPI + "/BusRoutes?\$skip=" +
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
      final requestURL = DataMallAPI + "/BusStops?\$skip=" +
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
      final requestURL = DataMallAPI + "/BusServices?\$skip=" +
          i.toString();
      final response = await http.get(
          requestURL, headers: {'AccountKey': accountkey});
      if (response.statusCode == 200) {
        if (response.body.length >= 500) {
          final responseJson = json.decode(response.body);
          final jsondatabody = responseJson['value'];
          for (var item in jsondatabody) {
            if (item['Direction'] == 1) { // to remove duplicates
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
        return true;
      }
      return false;
    })
        .catchError((
        _) => false);
  }

  //Calling Gov Data API to retrieve MRT Fares Data (For now adult only)
  Future<bool> callMRTFaresAPI() {
    return http.get(
        GovDataAPI + 'e496ae38-989e-4eac-977d-e64c9e91a20f&limit=10000').then((
        data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final jsondatabody = jsonData['result']['records'];
        MRTFares adult = new MRTFares('Adult');
        MRTFares seniorCitizen = new MRTFares('Senior Citizen');
        MRTFares student = new MRTFares('Student');
        adult.MRTfare = [];
        seniorCitizen.MRTfare = [];
        student.MRTfare = [];

        for (int i = 0; i<jsondatabody.length; i++) {
          if (jsondatabody[i]['applicable_time'] == 'All other timings') {
            if(jsondatabody[i]['fare_type'] == 'Adult card fare') {
              adult.MRTfare.add(jsondatabody[i]['fare_per_ride']);
            } else if (jsondatabody[i]['fare_type'] == 'Senior citizen card fare') {
              seniorCitizen.MRTfare.add(jsondatabody[i]['fare_per_ride']);
            }
            else if (jsondatabody[i]['fare_type'] == 'Student card fare') {
              student.MRTfare.add(jsondatabody[i]['fare_per_ride']);
            }
          }
        }
        mrtFares.add(adult);
        mrtFares.add(seniorCitizen);
        mrtFares.add(student);
        return true;
      }
      return false;
    })
        .catchError((
        _) => false);
  }

  Future<bool> retrieveMRTRoutes() async {
    var myData = await rootBundle.loadString("assets/MRTDataset.csv");
    List<List<dynamic>> csvTable = CsvToListConverter().convert(myData);
    csvTable.removeAt(0); // remove column heading
    csvTable.forEach((value) {
      String value1 = value.toString().substring(1, value
          .toString()
          .length - 1); // remove the first and last brackets
      mrtRoutes.add(MRTRoute.fromList(value1.split(',')));
    });
    return true;
  }
}




