import 'package:flutter/material.dart';
import 'package:flutter_app/views/SearchBus.dart';
import 'package:flutter_app/views/SearchMRT.dart';
import 'package:flutter_app/views/TypeSelectionPage.dart';
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
            automaticallyImplyLeading: false,
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
                  PopupMenuItem(
                    value: 3,
                    child: Text("Select Fare Type"),
                  ),
                ],
                onSelected: (int menu){
                  if (menu == 1){
                    showAlertDialogBUS(context);
                  }
                  else if (menu == 2){
                    showAlertDialogMRT(context);
                    }
                  else if (menu == 3){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => TypeSelectionPage()),
                      );
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
    child: Text("Close"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("Bus Page"),
    content: Text("Find your Bus Route's distance and Bus Fares" +
        "\n\n1) Enter your favourite Bus' information with the various options" +
        "\n\n2) Select a Trip number of your liking" +
        "\n\n3) Insert this route into your favourite Trip"),
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
    child: Text("Close"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("MRT Page"),
    //content: Text("To calculate the entered route distance and MRT fare. Tap onto the blue '+' button to add the entered route into the selected trip number."),
    content: Text("Find your MRT Route's distance and MRT Fares" +
        "\n\n1) Enter your favourite MRT' information with the various options" +
        "\n\n2) Select a Trip number of your liking" +
        "\n\n3) Insert this route into your favourite Trip"),
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