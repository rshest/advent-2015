import 'dart:io';
import 'dart:convert';

class Summator {
  final List<String> filter;

  Summator({this.filter = null});

  int sum(dynamic json) {
    int res = 0;
    if (json is List) {
      res = json.map(sum).fold(0, (a, b) => a + sum(b));
    } else if (json is Map) {
      bool skip = filter?.any(json.containsValue) ?? false;
      res = skip ? 0 : sum(json.keys.toList()) + sum(json.values.toList());
    } else if (json is int) {
      res = json;
    } else if (json is String){
      res = int.parse(json, onError:(_) => 0);
    }
    return res;
  }
}

main(List<String> args) {
  String file = "test.txt";
  if (args.length > 0) file = args[0];

  final text = (new File(file)).readAsStringSync();
  final json = JSON.decode(text);
  final sum1 = (new Summator()).sum(json);
  print("Sum of all numbers in JSON: $sum1");
  final sum2 = (new Summator(filter: ['red'])).sum(json);
  print("Sum of all numbers in JSON without 'red': $sum2");
}
