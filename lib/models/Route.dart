class Routes {
  int routeID;
  String transportID;
  String fromStop;
  String toStop;
  double fare;
  int tripID;
  String BUSorMRT;
  String fareType;

  Routes(
      this.routeID,
      this.transportID,
      this.fromStop,
      this.toStop,
      this.fare,
      this.tripID,
      this.BUSorMRT,
      this.fareType
   );

  Routes.fromMap(Map map){
    routeID = map["_routeID"];
    transportID = map["transportID"];
    fromStop = map["fromStop"];
    toStop = map["toStop"];
    fare = map["fare"];
    tripID = map["tripID"];
    BUSorMRT = map["BUSorMRT"];
    fareType = map["fareType"];
  }
}