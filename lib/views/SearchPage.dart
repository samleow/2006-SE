import 'package:flutter/material.dart';
import 'package:flutter_app/views/SearchBus.dart';
import 'package:flutter_app/views/SearchMRT.dart';


class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('AppName (TBC)'),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.map),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Mrtmap()),
                    );
                  }
              ),
              IconButton(
                  icon: Icon(Icons.card_membership),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ConcessionPrice()),
                    );
                  }
              )
            ],
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.directions_bus),
                text: 'BUS',
              ),
              Tab(
                icon: Icon(Icons.train),
                text: 'MRT',
              ),
            ]
          )
        ),
        body: TabBarView(
          children: <Widget>[
            SearchBus(),
            SearchMRT(),
          ],
        ),
      )
      );
  }
}

class Mrtmap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Mrt Map"),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/mrt_map.png')
              )
          ),
        )
    );
  }
}

class ConcessionPrice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Concession Prices"),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/Concession.png')
              )
          ),
        )
    );
  }
}