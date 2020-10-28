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


/*
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

  }*/

// factory BusFares.fromJson(Map<String, dynamic> item) {
// BusFares disabilities = new BusFares();
// BusFares adult = new BusFares();
// BusFares seniorCitizen = new BusFares();
// BusFares student = new BusFares();
// BusFares workfare = new BusFares();
// List<dynamic> listBusFares = [];
//
// for(int i = 0; i < item.length; i++){
// disabilities.BusFarePrice.add(item[i]['persons_with_disabilities_card_fare_per_ride']);
// adult.BusFarePrice.add(item[i]['adult_card_fare_per_ride']);
// seniorCitizen.BusFarePrice.add(item[i]['senior_citizen_card_fare_per_ride']);
// student.BusFarePrice.add(item[i]['student_card_fare_per_ride']);
// workfare.BusFarePrice.add(item[i]['workfare_transport_concession_card_fare_per_ride']);
// }


class BusFares {
  String fareType;
  //String BusFarePrice;
  List busFare;

  BusFares(
    this.fareType
  );

  // factory BusFares.fromJson(Map<String, dynamic> item) {
  //   return BusFares(
  //     BusFarePrice: item['adult_card_fare_per_ride'],
  //   );
  // }
}