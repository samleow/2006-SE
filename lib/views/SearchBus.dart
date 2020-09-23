import 'package:flutter/material.dart';

class SearchBus extends StatefulWidget {
  @override
  _SearchBusState createState() => _SearchBusState();
}

class _SearchBusState extends State<SearchBus> {
  
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
                decoration: const InputDecoration(
                  hintText: 'Search for Bus no.',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                //child: Text('Hello World!'),
              ),
              TextFormField(
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
    );
  }
}
