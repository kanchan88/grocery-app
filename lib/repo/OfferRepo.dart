import 'package:http/http.dart' as http;
import '../model/OfferModel.dart';
import 'dart:convert';
import '../screen/HomeBloc.dart';


Future<List<Offer>> fetchOffers () async {
  final data = await http.get(Uri.parse('$apiBaseUrl/api/offer'));
  var jsonData = json.decode(data.body);
  List<Offer> allOffers = [];

  for (var p in jsonData) {
    Offer ofr = Offer(
      description: p['offer_text'],
      imageUrl: p['offer_image'],
    );
    allOffers.add(ofr);
  }

  return allOffers;
}