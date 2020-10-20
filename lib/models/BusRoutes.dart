import 'BusStops.dart';

class BusRoutes {
  int stopSequence;
  var distance;  // need var for the double
  int direction;
  BusStops busStop;


  BusRoutes({
        this.stopSequence,
        this.distance,
        this.direction,
      });


  factory BusRoutes.fromJson(Map<String, dynamic> json) {
    return BusRoutes (
      stopSequence : json['StopSequence'],
      distance : json['Distance'],
      direction : json['Direction'],
    );
  }
}