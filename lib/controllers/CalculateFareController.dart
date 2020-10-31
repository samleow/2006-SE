import 'package:get_it/get_it.dart';
import 'package:flutter_app/services/CallAPIServices.dart';

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
      totalPrice += temp;
    }
    return totalPrice.toStringAsFixed(2);
  }

  // method to get the selected concession hybridPrice
  String getConcessionPrice(String concessionType, String cardholder) {
    String price = "";
    if(cardholder == null){
      price = '0.00';
      return price;
    }
    if(concessionType == 'Bus') {
      for (int i = 0; i < service.mcList.length; i++) {
        if (cardholder == service.mcList[i].cardholders) {
          if(service.mcList[i].busPrice != 'na'){
            price = service.mcList[i].busPrice;
          } else {
            price = "N/A";
          }
          break;
        }
      }
    }
    if(concessionType == 'Mrt') {
      for (int i = 0; i < service.mcList.length; i++) {
        if (cardholder == service.mcList[i].cardholders) {
          if(service.mcList[i].trainPrice != 'na'){
            price = service.mcList[i].trainPrice;
          } else {
            price = "N/A";
          }
          break;
        }
      }
    }
    if(concessionType == 'Hybrid') {
      for (int i = 0; i < service.mcList.length; i++) {
        if (cardholder == service.mcList[i].cardholders) {
          if(service.mcList[i].hybridPrice != 'na'){
            price = service.mcList[i].hybridPrice;
          } else {
            price = "N/A";
          }
          break;
        }
      }
    }
    return price;
  }

  // compare Price
  String comparePrice(String concessionPrice, double totalPrice) {
    if (concessionPrice != 'N/A') {
      double dConcessionPrice = double.parse(concessionPrice);
      if(totalPrice == 0){
        return "No Trips selected";
      }
      if (totalPrice < dConcessionPrice) {
        double differentPrice = dConcessionPrice - totalPrice;
        return "Trip is Cheaper: \$${differentPrice.toStringAsFixed(2)}";
      }
      else {
        double differentPrice = totalPrice - dConcessionPrice;
        return "Concession is Cheaper: \$${differentPrice.toStringAsFixed(2)}";
      }
    }
    else {
      return "Not available to compare";
    }
  }
}