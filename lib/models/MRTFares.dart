class MRTFares {
  String MRTFarePrice;

  MRTFares({
    this.MRTFarePrice
  });

  factory MRTFares.fromJson(Map<String, dynamic> item) {
    return MRTFares(
      MRTFarePrice: item['fare_per_ride'],
    );
  }
}