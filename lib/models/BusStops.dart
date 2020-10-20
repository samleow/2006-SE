import 'BusNo.dart';

class BusStops {
  String busStopCode;
  String description;
  double latitude;
  double longitude;
  List<BusNo> busNo;

  BusStops(
      {this.busStopCode,
        this.description,
        this.latitude,
        this.longitude,
        this.busNo,
      });

  factory BusStops.fromJson(Map<String, dynamic> json) {
    return BusStops (
      busStopCode : json['BusStopCode'],
      description : json['Description'],
      latitude : json['Latitude'],
      longitude : json['Longitude'],
    );
  }
}