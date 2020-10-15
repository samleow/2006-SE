class MRTRoute {
  String StationCode;
  String MRTStation;
  var Distance;

  MRTRoute(this.StationCode,
    this.MRTStation,
    this.Distance,
  );

  MRTRoute.fromList(List<dynamic> items) : this(items[0], items[1].toString().trim(), items[2].toString().trim()); //.trim() remove leading whitespace

  @override
  String toString() {
    return 'MRTRoute{StationCode: $StationCode, MRTStation: $MRTStation, Distance: $Distance}';
  }
}

