class BusServices {
  String serviceNo;


  BusServices(
      {this.serviceNo,

      });

  factory BusServices.fromJson(Map<String, dynamic> json) {
    return BusServices (
      serviceNo : json['ServiceNo'],
    );
  }
}