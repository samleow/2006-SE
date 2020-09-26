class MonthlyConcession {
  String hybridPrice;
  String trainPrice;
  int iId;
  String cardholders;
  String busPrice;

  MonthlyConcession({this.hybridPrice,
    this.trainPrice,
    this.iId,
    this.cardholders,
    this.busPrice});

  factory MonthlyConcession.fromJson(Map<String, dynamic> item) {
    return MonthlyConcession(
      hybridPrice: item['hybrid_price'],
      trainPrice: item['train_price'],
      iId: item['_id'],
      cardholders: item['cardholders'],
      busPrice: item['bus_price'],
    );
  }
}


