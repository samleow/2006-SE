class BusRoutes {
  String serviceNo;
  int stopSequence;
  String busStopCode;
  var distance;  // need var for the double
  int direction;

  BusRoutes(
      {this.serviceNo,
        this.stopSequence,
        this.busStopCode,
        this.distance,
        this.direction,
  });

  factory BusRoutes.fromJson(Map<String, dynamic> json) {
    return BusRoutes (
    serviceNo : json['ServiceNo'],
    stopSequence : json['StopSequence'],
    busStopCode : json['BusStopCode'],
    distance : json['Distance'],
    direction : json['Direction'],
    );
  }
}