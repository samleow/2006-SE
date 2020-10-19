import 'BusStops.dart';

class BusRoutes {
  String serviceNo;
  int stopSequence;
  var distance;  // need var for the double
  int direction;
  BusStops busStop;
  String busStopCode;
  String description;


  BusRoutes({
        this.serviceNo,
        this.stopSequence,
        this.busStopCode,
        this.distance,
        this.direction,
        this.description,
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

class BusNo {
  String serviceNo;
  List<BusRoutes> busRoutes;

  BusNo({
  this.serviceNo, this.busRoutes
  });

  factory BusNo.fromJson(Map<String, dynamic> json) {
    return BusNo(
      serviceNo: json['ServiceNo'],
    );
  }
}

//One Bus Stop contains all of its bus number. Each bus number has one bus route.
// Serviceno, [List<BusRoutes>]
//{10, [ [serviceno, direction, stopseq, bus stop code, distance] , [serviceno, direction, stopseq, bus stop code, distance] ], 24 [....]


// Bus Stop (5000)
// bus stop code, description, List<BusNo> (9)
// [serviceNo,direction, stopseq, bus stop code, distance] (9)



//[123123, 123123, 12312]]
//[12123123123123123123]


//[10,[[9123,1,1,serviceno], 123123 ,123123], 67 [123123, 123123, 12312]]




/*class BusRoutes {
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
}*/