import 'package:flutter/material.dart';
import 'package:flutter_app/models/api_response.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_app/models/MClist.dart';
import 'package:flutter_app/services/MClist_service.dart';

class ComparePage extends StatefulWidget {
  _ComparePageState createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
  MClistService get service => GetIt.I<MClistService>();
  APIResponse<List<Records>> _apiResponse;
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

    _apiResponse = await service.getMCList();

    setState(() {
      _isLoading = false;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: new AppBar(
      //   title:new Text("Compare Page"),
      // ),
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
              _apiResponse.data[index].cardholders,
              style: TextStyle(color: Theme
                  .of(context)
                  .primaryColor),
            ),
            subtitle: Text(_apiResponse.data[index].busPrice ?? 'Null'),
          );
        },
        itemCount: _apiResponse.data.length,
      );
  },
      )
    );
  }
}

