// gets called by get_it
class CompareFareController
{
  // compare Price
  String comparePrice(double fprice, double sprice, int numDay, int numTrips) {
    if(fprice == 0){
      return "First trip is empty";
    }
    if(sprice == 0){
      return "Second trip is empty";
    }
    if (fprice < sprice) {
      double diffprice = sprice - fprice;
      diffprice = diffprice * numDay * numTrips;
      return "First Trip is cheaper, you saved \$${diffprice.toStringAsFixed(2)}";
    }
    if (fprice > sprice){
      double diffprices = fprice - sprice;
      diffprices = diffprices * numDay * numTrips;
      return "Second Trip is cheaper, difference is \$${diffprices.toStringAsFixed(2)}";
    }
    else{
      return "Both trip is the same price";
    }
  }
}