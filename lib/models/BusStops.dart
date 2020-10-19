class BusStops {
  String busStopCode;
  String roadName;
  String description;

  BusStops(
      {this.busStopCode,
        this.roadName,
        this.description,
      });

  factory BusStops.fromJson(Map<String, dynamic> json) {
    return BusStops (
      busStopCode : json['BusStopCode'],
      roadName : json['RoadName'],
      description : json['Description'],

    );
  }
}