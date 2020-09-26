class Route {
  int routeID;
  String busNo;
  String fromStop;
  String toStop;
  double fare;
  String tripID;

  Route(
      this.routeID,
      this.busNo,
      this.fromStop,
      this.toStop,
      this.fare,
      this.tripID
   );

  Map<String,dynamic> toMap() {
    return {
      '_routeID' : routeID,
      'busNo' : busNo,
      'fromStop' : fromStop,
      'toStop' : toStop,
      'fare' : fare,
      'tripID' : tripID,
    };
  }

  // Route.fromMap(dynamic obj){
  //   this.routeID = obj["_routeID"];
  //   this.busNo = obj["busNo"];
  //   this.fromStop = obj["fromStop"];
  //   this.toStop = obj["toStop"];
  //   this.fare = obj["fare"];
  //   this.tripID = obj["tripID"];
  // }
  //
  // Map<String,dynamic> toMap(){
  //   var map = new Map<String, dynamic>();
  //
  //   map["_routeID"] = routeID;
  //   map["busNo"] = busNo;
  //   map["fromStop"] = fromStop;
  //   map["toStop"] = toStop;
  //   map["fare"] = fare;
  //   map["tripID"] = tripID;
  //
  //   return map;
  // }
  //
  // int get getRouteID => routeID;
  // String get getBusNo=> busNo;
  // String get getFromStop =>fromStop;
  // String get getToStop => toStop;
  // double get getFare => fare;
  // String get getTripID => tripID;
}