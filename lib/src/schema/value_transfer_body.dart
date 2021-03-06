import 'dart:convert' show json;
import 'dart:typed_data' show Uint8List;

import 'input.dart' show Input;
import 'value_transfer_output.dart' show ValueTransferOutput;

import 'package:witnet/constants.dart' show INPUT_SIZE, OUTPUT_SIZE, GAMMA;
import 'package:witnet/crypto.dart' show sha256;
import 'package:witnet/protobuf.dart' show pbField, LENGTH_DELIMITED;
import 'package:witnet/utils.dart' show concatBytes;

class VTTransactionBody {
  VTTransactionBody({
    required this.inputs,
    required this.outputs,
  });

  List<Input> inputs;
  List<ValueTransferOutput> outputs;

  factory VTTransactionBody.fromRawJson(String str) =>
      VTTransactionBody.fromJson(json.decode(str));

  factory VTTransactionBody.fromJson(Map<String, dynamic> json) =>
      VTTransactionBody(
        inputs: List<Input>.from(json["inputs"].map((x) => Input.fromJson(x))),
        outputs: List<ValueTransferOutput>.from(
            json["outputs"].map((x) => ValueTransferOutput.fromJson(x))),
      );

  String toRawJson() => json.encode(jsonMap());

  Map<String, dynamic> jsonMap() => {
        "inputs": List<dynamic>.from(inputs.map((x) => x.jsonMap())),
        "outputs": List<dynamic>.from(outputs.map((x) => x.jsonMap())),
      };

  Uint8List get pbBytes {
    final inputBytes = concatBytes(List<Uint8List>.from(inputs.map((e) =>  pbField(1, LENGTH_DELIMITED, e.pbBytes))));
    final outputBytes = concatBytes(List<Uint8List>.from(outputs.map((e) => pbField(2, LENGTH_DELIMITED, e.pbBytes))));
    return concatBytes([inputBytes, outputBytes]);
  }

  Uint8List get hash => sha256(data: pbBytes);

  // VT_weight = N*INPUT_SIZE + M*OUTPUT_SIZE*gamma
  int get weight => (inputs.length * INPUT_SIZE) + (outputs.length * OUTPUT_SIZE * GAMMA);

}
