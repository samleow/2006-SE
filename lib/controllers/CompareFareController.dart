// gets called by get_it
class CompareFareController
{
  // compare Price
  String comparePrice(double fprice, double sprice, int numDay, int numTrips) {
    if(fprice == 0 && sprice == 0){
      return "Both Trips are Empty!";
    }
    if(fprice == 0){
      return "First Trip is Empty!";
    }
    if(sprice == 0){
      return "Second Trip is Empty!";
    }
    if (fprice < sprice) {
      double diffprice = sprice - fprice;
      diffprice = diffprice * numDay * numTrips;
      return "First Trip is Cheaper! \nYou will save: \$${diffprice.toStringAsFixed(2)}";
    }
    if (fprice > sprice){
      double diffprices = fprice - sprice;
      diffprices = diffprices * numDay * numTrips;
      return "Second Trip is Cheaper!\nYou will save: \$${diffprices.toStringAsFixed(2)}";
    }
    else{
      return "Both Trips have the same Price!";
    }
  }
}