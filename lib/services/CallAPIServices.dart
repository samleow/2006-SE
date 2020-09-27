import 'package:flutter_app/models/BusFares.dart';
import 'package:flutter_app/models/BusRoutes.dart';
import 'package:flutter_app/models/MClist.dart';
import 'package:flutter_app/models/api_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CallAPIServices {
  static const GovDataAPI = 'https://data.gov.sg/api/action/datastore_search?resource_id=';
  static const DataMallAPI = 'http://datamall2.mytransport.sg/ltaodataservice';
  static const accountkey = 'ms77YJ/1TlCm5H79vhT6fA=='; // for DataMall


  //Calling Gov Data API to retrieve Monthly Concession Data
  Future<APIResponse<List<MonthlyConcession>>> getMCList() {
    return http.get(GovDataAPI + 'aeb8dce2-93b8-4227-afdd-a0c70d3c0079').then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final jsondatabody = jsonData['result']['records'];
        final mclistdata = <MonthlyConcession>[];
        for (var item in jsondatabody) {
          mclistdata.add(MonthlyConcession.fromJson(item));
        }
        return APIResponse<List<MonthlyConcession>>(data: mclistdata);
      }
      return APIResponse<List<MonthlyConcession>>(error: true, errorMessage: 'An error occurred');
    })
        .catchError((_) => APIResponse<List<MonthlyConcession>>(error: true, errorMessage: 'An error occurred, never return API data'));
  }


  //one list is to check the user type
  // we do if else statement and if usertype == adult,
  // usertype = adult_card_fare_per_ride which will put inside the API field
  //Calling Gov Data API to retrieve Bus Fares Data
  Future<APIResponse<List<BusFares>>> getBusFares() {
    return http.get(GovDataAPI +
        '7a5c22f0-71da-4c24-b419-84322b54ce17&fields=adult_card_fare_per_ride').then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final jsondatabody = jsonData['result']['records'];
        final BusFareData = <BusFares>[];

        //BusFareData.add(BusFares.fromJson(jsondatabody['records']));
        for (var item in jsondatabody) {
          BusFareData.add(BusFares.fromJson(item));
        }
        return APIResponse<List<BusFares>>(data: BusFareData);
      }
      return APIResponse<List<BusFares>>(error: true, errorMessage: 'An error occurred');
    })
        .catchError((_) => APIResponse<List<BusFares>>(error: true, errorMessage: 'An error occurred, never return API data'));
  }


  //Calling DataMall API to retrieve Bus Routes
  Future<APIResponse<List<BusRoutes>>> getBusRoutes() {
    return http.get('http://datamall2.mytransport.sg/ltaodataservice/BusRoutes', headers: {'AccountKey': accountkey}).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final jsondatabody = jsonData['value'];
        final BusRoutesData = <BusRoutes>[];
        for (var item in jsondatabody) {
          BusRoutesData.add(BusRoutes.fromJson(item));
        }
        return APIResponse<List<BusRoutes>>(data: BusRoutesData);
      }
      return APIResponse<List<BusRoutes>>(error: true, errorMessage: 'An error occurred');
    })
        .catchError((_) => APIResponse<List<BusRoutes>>(error: true, errorMessage: 'An error occurred, never return API data'));
  }
}







  //Testing
  /*Future<List> getBusRoutes() async {
    List BusRoutesData = [];
    final requestURL = "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes";

    final response = await http.get(requestURL, headers: {'AccountKey': accountkey});
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      for (var item in responseJson['value']) {
        BusRoutesData.add(BusRoutes.fromJson(item));
      }
    } else {
      print("Error Datamall: " + response.statusCode.toString());
    }
    return BusRoutesData;
  }*/


