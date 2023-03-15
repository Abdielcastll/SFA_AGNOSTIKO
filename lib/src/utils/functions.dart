double exchangeAmount(String coin, double amount) {
  if (coin!.contains('USD')) {
    return double.parse((amount.toStringAsFixed(2)));
  } else if (coin.contains('VED')) {
    return double.parse((amount / 4.58).toStringAsFixed(2));
  } else if (coin.contains('EUR')) {
    return double.parse((amount / 0.89).toStringAsFixed(2));
  } else if (coin.contains('MXN')) {
    return double.parse((amount / 19.43).toStringAsFixed(2));
  } else if (coin.contains('BTC')) {
    return double.parse((amount / 0.00011).toStringAsFixed(2));
  } else {
    return double.parse((amount / 4.58).toStringAsFixed(2));
  }
  // if (coin.contains('VED')) {
  //   return amount / 4.58;
  // }
  // if (coin.contains('EUR')) {
  //   return amount / 0.89;
  // }
  // if (coin.contains('MXN')) {
  //   return amount / 19.43;
  // }
  // return double.parse(amount.toStringAsFixed(2));
}

priceToCurrencySelected(productPrice, coin) {
  double correctAmount = double.parse(productPrice.toStringAsFixed(2));
  if (coin!.contains('USD')) {
    return correctAmount;
  } else if (coin.contains('VED')) {
    return correctAmount * 4.58;
  } else if (coin.contains('EUR')) {
    return correctAmount * 0.89;
  } else if (coin.contains('MXN')) {
    return correctAmount * 19.43;
  } else if (coin.contains('BTC')) {
    return correctAmount * 0.00011;
  } else {
    return correctAmount * 4.58;
  }
}
