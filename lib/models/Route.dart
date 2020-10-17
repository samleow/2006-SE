class Routes {
  int routeID;
  String transportID;
  String fromStop;
  String toStop;
  double fare;
  int tripID;
  String BUSorMRT;

  Routes(
      this.routeID,
      this.transportID,
      this.fromStop,
      this.toStop,
      this.fare,
      this.tripID,
      this.BUSorMRT
   );

  // Map<String,dynamic> toMap() {
  //   return {
  //     '_routeID' : routeID,
  //     'busNo' : busNo,
  //     'fromStop' : fromStop,
  //     'toStop' : toStop,
  //     'fare' : fare,
  //     'tripID' : tripID,
  //   };
  // }

  Routes.fromMap(Map map){
    routeID = map["_routeID"];
    transportID = map["transportID"];
    fromStop = map["fromStop"];
    toStop = map["toStop"];
    fare = map["fare"];
    tripID = map["tripID"];
    BUSorMRT = map["BUSorMRT"];
  }
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