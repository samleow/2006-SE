class Trips {
  double fare;
  int tripID;

  Trips(
      this.fare,
      this.tripID
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

  Trips.fromMap(Map map){
    fare = map["fare"];
    tripID = map["tripID"];
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