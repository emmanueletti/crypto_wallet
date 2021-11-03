// Util functions for api calls

import 'package:http/http.dart' as http;
import 'dart:convert';

Future<double> getPrice(String id) async {
  try {
    Uri uri = Uri.parse('https://api.coingecko.com/api/v3/coins/$id');
    var response = await http.get(uri);
    // Darts version of JSON.parse
    var data = jsonDecode(response.body);
    var currentPriceInUSD =
        (data as Map)['market_data']['current_price']['usd'].toString();
    return double.parse(currentPriceInUSD);
  } catch (e) {
    print(e.toString());
    return 0.0;
  }
}
