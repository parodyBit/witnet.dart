import 'dart:convert' show json;
import 'secp256k1_signature.dart';

class Signature {
  Signature({
    required this.secp256K1,
  });

  Secp256k1Signature secp256K1;

  factory Signature.fromRawJson(String str) =>
      Signature.fromJson(json.decode(str));

  String get rawJson => json.encode(jsonMap);

  factory Signature.fromJson(Map<String, dynamic> json) => Signature(
        secp256K1: Secp256k1Signature.fromJson(json["Secp256k1"]),
      );

  Map<String, dynamic> jsonMap({bool asHex = false}) => {
        "Secp256k1": secp256K1.jsonMap(asHex: asHex),
      };
}
