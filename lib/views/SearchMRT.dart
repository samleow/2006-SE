import 'package:flutter/material.dart';

class SearchMRT extends StatefulWidget {
  @override
  _SearchMRTState createState() => _SearchMRTState();
}

class _SearchMRTState extends State<SearchMRT> {

  final fromTextController = TextEditingController();
  final toTextController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          return showDialog(
            context: context,
            builder: (context){
              return AlertDialog(
                content: Text('Values:\n' + toTextController.text + '\n' + toTextController.text),
              );
            },
          );
        },
        tooltip: 'Show me the Values',
        child: Icon(Icons.add),
      ),
    );
  }
}
