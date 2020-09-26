import 'package:flutter/material.dart';
import 'package:flutter_app/db/database_helper.dart';

class SearchBus extends StatefulWidget {
  @override
  _SearchBusState createState() => _SearchBusState();
}

class _SearchBusState extends State<SearchBus> {
  final busNoController = TextEditingController();
  final fromTextController = TextEditingController();
  final toTextController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    busNoController.dispose();
    fromTextController.dispose();
    toTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: const EdgeInsets.only(right: 15, left: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                //child: Text('Hello World!'),
              ),
              TextFormField(
                controller: busNoController,
                decoration: const InputDecoration(
                  hintText: 'Search for Bus Service no.',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                //child: Text('Hello World!'),
              ),
              TextFormField(
                controller: fromTextController,
                decoration: const InputDecoration(
                  labelText: 'From',
                  hintText: 'Search Bus Stop',
                  border: OutlineInputBorder(),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                //child: Text('Hello World!'),
              ),
              TextFormField(
                controller: toTextController,
                decoration: const InputDecoration(
                  labelText: 'To',
                  hintText: 'Search Bus Stop',
                  border: OutlineInputBorder(),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                //child: Text('Hello World!'),
              ),
              Divider(
                color: Colors.black26,
                thickness: 1.5,
              )
            ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            // return showDialog(
            //   context: context,
            //   builder: (context){
            //     return AlertDialog(
            //         content: Text('Values:\n' + busNoController.text + '\n' + toTextController.text + '\n' + toTextController.text),
            //
            //     );
            //   },
            // );
            testObject();
          },
        tooltip: 'Show me the Values',
        child: Icon(Icons.add),
      ),
    );
  }

  void testObject() async{
    int i = await DatabaseHelper.instance.insert({
      DatabaseHelper.busNo : busNoController.text,
      DatabaseHelper.fromStop: fromTextController.text,
      DatabaseHelper.toStop: toTextController.text,
      DatabaseHelper.fare: 5.0, //hard-coded for now
      DatabaseHelper.tripID: 1 //hard-coded for now
    });
    print('the inserted id is $i');

    List<Map<String,dynamic>> queryRows = await DatabaseHelper.instance.queryAll();
    print(queryRows);
  }
}
