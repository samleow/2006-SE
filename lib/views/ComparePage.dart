import 'package:flutter/material.dart';
import 'package:flutter_app/models/BusFares.dart';
import 'package:flutter_app/models/BusRoutes.dart';
import 'package:flutter_app/models/MClist.dart';
import 'package:flutter_app/models/api_response.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_app/services/CallAPIServices.dart';

class ComparePage extends StatefulWidget {
  _ComparePageState createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
  CallAPIServices get service => GetIt.I<CallAPIServices>();
  APIResponse<List<BusRoutes>> _apiResponse;
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

    _apiResponse = await service.getBusRoutes();

    setState(() {
      _isLoading = false;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
       appBar: new AppBar(
         title:new Text("AppName (TBC)"),
       ),
      body: Builder(
        builder: (_)
    {
      if (_isLoading) {
        return Center(child: CircularProgressIndicator());
      }
      if (_apiResponse.error) {
        return Center(child: Text(_apiResponse.errorMessage));
      }
      return ListView.separated(
        separatorBuilder: (_, __) => Divider(height: 1, color: Colors.green),
        itemBuilder: (_, index) {
          return ListTile(
            title: Text(
              "Bus Stop Code " + _apiResponse.data[index].busStopCode,
              style: TextStyle(color: Theme
                  .of(context)
                  .primaryColor),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Service No: " + _apiResponse.data[index].serviceNo ?? 'Null'),
                Text("Bus Stop Sequence " + _apiResponse.data[index].stopSequence.toString() ?? 'Null'),
                Text("Bus Distance Travelled " + _apiResponse.data[index].distance.toString() ?? 'Null'),
              ],
            ),
              isThreeLine: true,
          );
        },
        itemCount: _apiResponse.data.length,
      );
  },
      )
    );
  }
}

