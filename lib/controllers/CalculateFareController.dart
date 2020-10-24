
import 'package:get_it/get_it.dart';
import 'package:flutter_app/services/CallAPIServices.dart';

// combine with searchroutecontroller ?

// gets called by get_it
class CalculateFareController
{
  CallAPIServices get service => GetIt.I<CallAPIServices>();

  String calculatedTotalPrice(List<double> price, List<int> numDay, List<int> numTrip, int tripListLength) {
    if(tripListLength == -1)
      return "ERROR - calculatedTotalPrice tripListLength not initialised properly!";
    double temp = 0;
    double totalPrice = 0;
    for (int i = 0; i< tripListLength; i++)
    {
      temp = price[i] * numDay[i] * numTrip[i];
      //print(temp);
      totalPrice += temp;
      print(totalPrice);
    }
    return totalPrice.toStringAsFixed(2);
  }

  // method to get the selected concession hybridPrice
  String getConcessionPrice(String cardholder) {
    String price = "";
    for (int i = 0; i < service.mcList.length; i++) {
      if (cardholder == service.mcList[i].cardholders) {
        price = service.mcList[i]
            .hybridPrice; // change hybridPrice to get other price list in the api
        break;
      }
    }
    return price;
  }

  // compare Price
  String comparePrice(String concessionPrice, double totalPrice) {
    double dConcessionPrice = double.parse(concessionPrice);
    if (totalPrice < dConcessionPrice) {
      double differentPrice = dConcessionPrice - totalPrice;
      return "Trip is Cheaper: \$${differentPrice.toStringAsFixed(2)}";
    }
    else {
      double differentPrice = totalPrice - dConcessionPrice;
      return "Concession is Cheaper: \$${differentPrice.toStringAsFixed(2)}";
    }
  }
}