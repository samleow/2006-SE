import 'BusRoutes.dart';

class BusNo {
  String serviceNo;
  List<BusRoutes> busRoutes;

  BusNo({
    this.serviceNo,
    this.busRoutes,
  });

  factory BusNo.fromJson(Map<String, dynamic> json) {
    return BusNo(
      serviceNo: json['ServiceNo'],
    );
  }
}