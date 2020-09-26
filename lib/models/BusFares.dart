/*class BusFares {
  String distance;
  String personsWithDisabilities;
  String adult;
  String seniorCitizen;
  String student;
  String workfareTransportConcession;
  int iId;


  BusFares ({
   this.distance,
    this.personsWithDisabilities,
    this.adult,
    this.seniorCitizen,
    this.student,
    this.workfareTransportConcession,
    this.iId});



  factory BusFares.fromJson(Map<String, dynamic> item) {
    return BusFares(
        distance: item['distance'],
        personsWithDisabilities: item['persons_with_disabilities_card_fare_per_ride'],
        adult: item['adult_card_fare_per_ride'],
        seniorCitizen: item['senior_citizen_card_fare_per_ride'],
        student: item['student_card_fare_per_ride'],
        workfareTransportConcession: item['workfare_transport_concession_card_fare_per_ride'],
        iId: item['_id'],
    );
  }
}*/



class BusFares {
  List BusFarePrice;

  BusFares({
    this.BusFarePrice
  });

  factory BusFares.fromJson(Map<String, dynamic> item) {
    List busfareprice = [];
    for (var i in item.values) {
      busfareprice.add(i['adult_card_fare_per_ride']);
    }
      return BusFares(
        BusFarePrice: busfareprice,
      );

  }
}