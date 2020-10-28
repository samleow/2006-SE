class MonthlyConcession {
  String hybridPrice;
  String trainPrice;
  String cardholders;
  String busPrice;

  MonthlyConcession({
    this.hybridPrice,
    this.trainPrice,
    this.cardholders,
    this.busPrice
  });

  factory MonthlyConcession.fromJson(Map<String, dynamic> item) {
    return MonthlyConcession(
      hybridPrice: item['hybrid_price'],
      trainPrice: item['train_price'],
      cardholders: item['cardholders'],
      busPrice: item['bus_price'],
    );
  }
}