import 'package:flutter_app/models/MClist.dart';
import 'package:flutter_app/models/api_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MClistService {
  final requestURL = "https://data.gov.sg/api/action/datastore_search?resource_id=aeb8dce2-93b8-4227-afdd-a0c70d3c0079";

  Future<APIResponse<List<Records>>> getMCList() {
    return http.get(requestURL).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final jsondatabody = jsonData['result']['records'];
        final mclistdata = <Records>[];
        for (var item in jsondatabody) {
            final MCData = Records(
            hybridPrice: item['hybrid_price'],
            trainPrice: item['train_price'] != "na" ? item['train_price'] : null,
            iId: item['_id'],
            cardholders: item['cardholders'],
            busPrice: item['bus_price'] != "na" ? item['bus_price'] : null,
          );
          mclistdata.add(MCData);
        }
        return APIResponse<List<Records>>(data: mclistdata);
      }
      return APIResponse<List<Records>>(error: true, errorMessage: 'An error occurred');
    })
        .catchError((_) => APIResponse<List<Records>>(error: true, errorMessage: 'An error occurred'));
  }
}

