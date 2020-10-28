import 'package:flutter/material.dart';
import 'package:flutter_app/views/SearchBus.dart';
import 'package:flutter_app/views/SearchMRT.dart';
import 'package:photo_view/photo_view.dart';


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
          title: Text('UnFare SG'),
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
              PopupMenuButton(
                itemBuilder: (content) => [
                  PopupMenuItem(
                    value: 1,
                    child: Text("Help for Bus"),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text("Help for MRT"),
                  ),
                ],
                onSelected: (int menu){
                  if (menu == 1){
                    showAlertDialogBUS(context);
                  }
                  else if (menu == 2){
                    showAlertDialogMRT(context);
                  }
                },
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
            child: PhotoView(
              imageProvider: AssetImage("assets/mrt_map.png"),
            )
        )
    );
  }
}



showAlertDialogBUS(BuildContext context) {
  Widget yesButton = FlatButton(
    child: Text("OK"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("Bus Page"),
    content: Text("To calculate the entered route distance and bus fare. Tap onto the blue '+' button to add the entered route into the selected trip number."),
    actions: [
      yesButton,
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialogMRT(BuildContext context) {
  Widget yesButton = FlatButton(
    child: Text("OK"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("MRT Page"),
    content: Text("To calculate the entered route distance and MRT fare. Tap onto the blue '+' button to add the entered route into the selected trip number."),
    actions: [
      yesButton,
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}