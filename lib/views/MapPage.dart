import 'package:flutter/material.dart';
import 'package:flutter_app/services/CallAPIServices.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:recase/recase.dart';


class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  CallAPIServices get service => GetIt.I<CallAPIServices>();
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  GoogleMapController mapController;

  Position _currentPosition;
  Position _BusStopPosition;
  String _currentAddress;

  final searchController = TextEditingController();
  double lat;
  double long;

  Set<Marker> markers = {};

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _textField({
    TextEditingController controller,
    String label,
    String hint,
    double width,
    Icon prefixIcon,
    Widget suffixIcon,
    Function(String) locationCallback,
  }) {
    return Container(
      width: width * 0.8,
      child: TextField(
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        decoration: new InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey[400],
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue[300],
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }

  // Method for retrieving the current location
  _getCurrentLocation() async {
    await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
      //await _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

  // Method for retrieving the address
  // _getAddress() async {
  //   try {
  //     List<Placemark> p = await placemarkFromCoordinates(
  //         _currentPosition.latitude, _currentPosition.longitude);
  //
  //     Placemark place = p[0];
  //
  //     setState(() {
  //       _currentAddress =
  //       "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
  //       startAddressController.text = _currentAddress;
  //       _startAddress = _currentAddress;
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<bool> getBusStopMarkers() async {
    for (int i = 0; i < service.busStops.length; i++) {
      List<dynamic> temp = [];
      for (int j = 0; j < service.busStops[i].busNo.length; j++) {
        temp.add(service.busStops[i].busNo[j].serviceNo);
      }
        Marker busStopMarker = Marker(
          markerId: MarkerId(service.busStops[i].busStopCode),
          position: LatLng(
            service.busStops[i].latitude,
            service.busStops[i].longitude,
          ),
          infoWindow: InfoWindow(
              title: service.busStops[i].description,
              snippet: 'Bus No ' + temp.toString()
          ),
          icon: BitmapDescriptor.defaultMarker,
        );
        markers.add(busStopMarker);
      }
    return true;
  }

  @override
  void initState() {
    _getCurrentLocation();
    getBusStopMarkers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("UnFare SG"),
        ),
        body: Stack(
          children: <Widget>[
            // Map View
            GoogleMap(
              markers: markers != null ? Set<Marker>.from(markers) : null,
              initialCameraPosition: _initialLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
            // Show zoom buttons
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: Material(
                        color: Colors.blue[100], // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.add),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomIn(),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ClipOval(
                      child: Material(
                        color: Colors.blue[100], // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.remove),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomOut(),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    width: width * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          // Text(
                          //   'Bus Stop',
                          //   style: TextStyle(fontSize: 20.0),
                          // ),
                          SizedBox(height: 10),
                          TypeAheadFormField(
                            textFieldConfiguration: TextFieldConfiguration(
                                controller: searchController,
                                decoration: const InputDecoration(
                                  labelText: 'Bus Stop.',
                                  hintText: 'Search for Bus Stop.',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.search),
                                ),
                            ),
                            suggestionsCallback: (pattern) async{ //pattern is user input
                              return await getBusStopSuggestions(pattern); // to activate autocomplete list
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text(suggestion),
                              );
                            },
                            onSuggestionSelected: (suggestion) {
                              searchController.text = suggestion;
                              setState((){
                                _getBusStopLocation(searchController.text);
                                mapController.animateCamera(
                                  CameraUpdate.newCameraPosition(
                                    CameraPosition(
                                      target: LatLng(lat, long),
                                      zoom: 18.0,
                                    ),
                                  ),
                                );
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Show current location button
            SafeArea(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                  child: ClipOval(
                    child: Material(
                      color: Colors.orange[100], // button color
                      child: InkWell(
                        splashColor: Colors.orange, // inkwell color
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: Icon(Icons.my_location),
                        ),
                        onTap: () {
                          _getCurrentLocation();
                          mapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(
                                  _currentPosition.latitude,
                                  _currentPosition.longitude,
                                ),
                                zoom: 18.0,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List> getBusStopSuggestions(String userinput) async
  {
    List<String> description = List();
    for (int i = 0; i<service.busStops.length; i++) {
          description.add(service.busStops[i].description);
    }
    //matches.addAll(listforbustopcode); // Swap the list busStopDescList(to display description) or filterbusStopList (to display bus stop code)
    description.removeWhere((element) => element == ""); // remove the ""
    description.retainWhere((s) => s.contains((userinput.toLowerCase().titleCase))); // added .toLowerCase() then convert .titleCase for auto caps after every space

    // if SearchInput is clear
    if(description == "") // Swap the list busStopDescList(to display description) or filterbusStopList (to display bus stop code)
        {
      // clear the matching list
      description.clear();
    }
    //print(description.length);
    return description;
  }

  _getBusStopLocation(String userinput) async {
    String findBusStopCode = '';
    for(int i = 0; i < service.busStops.length; i++){
      if (userinput == service.busStops[i].description) {
        findBusStopCode = service.busStops[i].busStopCode;
        lat = service.busStops[i].latitude;
        long = service.busStops[i].longitude;
        break;
      }
    }
    print("Got come to this method");
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


