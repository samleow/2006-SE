import 'package:flutter_app/models/BusFares.dart';
import 'package:flutter_app/models/MClist.dart';
import 'package:flutter_app/models/api_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CallAPIServices {
  static const API = 'https://data.gov.sg/api/action/datastore_search?resource_id=';
  //static const headers = {'apiKey': '3cb84578-bad8-47f3-a348-51d5982000b7'};


  //Calling Gov Data API to retrieve Monthly Concession Data
  Future<APIResponse<List<MonthlyConcession>>> getMCList() {
    return http.get(API + 'aeb8dce2-93b8-4227-afdd-a0c70d3c0079').then((data) {
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
        .catchError((_) => APIResponse<List<MonthlyConcession>>(error: true, errorMessage: 'An error occurred'));
  }

  //one list is to check the user type
  // we do if else ==adult,
  // usertype = adult_card_fare_per_ride
  //Calling Gov Data API to retrieve Bus Fares Data
  Future<APIResponse<List<BusFares>>> getBusFares() {
    return http.get(API + '7a5c22f0-71da-4c24-b419-84322b54ce17&fields=adult_card_fare_per_ride').then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final jsondatabody = jsonData['result'];
        final BusFareData = <BusFares>[];
        //List BusFareData = [];
        BusFareData.add(BusFares.fromJson(jsondatabody['records']));

        return APIResponse<List<BusFares>>(data: BusFareData);
      }
      return APIResponse<List<BusFares>>(error: true, errorMessage: 'An error occurred');
    })
        .catchError((_) => APIResponse<List<BusFares>>(error: true, errorMessage: 'An error occurred, never return API data'));
  }

}

