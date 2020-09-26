class Records {
  String hybridPrice;
  String trainPrice;
  int iId;
  String cardholders;
  String busPrice;

  Records(
      {
        this.hybridPrice,
        this.trainPrice,
        this.iId,
        this.cardholders,
        this.busPrice
      });

  Records.fromJson(Map<String, dynamic> json) {
    hybridPrice = json['hybrid_price'];
    trainPrice = json['train_price'];
    iId = json['_id'];
    cardholders = json['cardholders'];
    busPrice = json['bus_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hybrid_price'] = this.hybridPrice;
    data['train_price'] = this.trainPrice;
    data['_id'] = this.iId;
    data['cardholders'] = this.cardholders;
    data['bus_price'] = this.busPrice;
    return data;
  }
}


