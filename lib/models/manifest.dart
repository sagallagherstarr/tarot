import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import 'package:get_it/get_it.dart';
// import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:loggy/loggy.dart';
// import 'package:flutter_loggy/flutter_loggy.dart';
// import 'package:fpdart/fpdart.dart';
// import 'package:g_json/g_json.dart';

// typedef JSON = Map<String, dynamic>;

String errorAsString(String msg) => '{ "error": "$msg" }';
Map<String, dynamic> errorAsJSON(String msg) => jsonDecode(errorAsString(msg));

// creating this class as a ChangeNotifier makes it inherently asynchronous
// for the Widget tree, and GetIt's watch method.
// this could also be implemented with assetMap as a ValueNotifier, rather than the
// whole class as a change notifier
class Manifest with UiLoggy {
  ValueNotifier<String> assetString = ValueNotifier<String>("{}");
  ValueNotifier<dynamic> assetMap = ValueNotifier<dynamic>(jsonDecode("{}"));

  Manifest._internal() : super();

  Future<String> logRawAssetString(Future<String> rawAssetString) =>
    rawAssetString.then((rawAssetJSONString) {
      assetString.value = rawAssetJSONString;

      return rawAssetJSONString;
    }).catchError((e) {
      final msg = "fetching from manifest bundle produced error $e";
      loggy.debug("  $msg");
      assetString.value = msg;

      return errorAsString(msg);
    });

  Future<dynamic> convertToJSON(Future<String> rawAssetString) =>
    rawAssetString.then((s) {
      loggy.debug("  attempting to parse to JSON");

      final j = jsonDecode(s);
      // if (j is Map<String, dynamic>) { return j as Map<String, dynamic>}; };

      loggy.debug("  success; JSON.parse returned $j");
      assetMap.value = j;

      return j;
    }).catchError((e) {
    // if we fail at parsing the manifest, we have failed the whole thing.

      final msg = "parsing manifest produced error $e";
      loggy.debug(msg);
      assetMap.value = errorAsJSON(msg);
    });

  factory Manifest(Future<String> future) {
    if (GetIt.I.isRegistered<Manifest>()) {
      return GetIt.I<Manifest>();
    }

    Manifest m = Manifest._internal();
    GetIt.I.registerSingleton<Manifest>(m);

    Future<String> ras = m.logRawAssetString(future);
    // Future<JSON> asm = m.convertToJSON(ras); // The side effects do the work here

/*
    future.then((rawAssetJSONString) {
      // this step exists in order to log the result
      // after this class has been debugged, simplify the chain considerably
      m.loggy.debug("  raw is $rawAssetJSONString");
      return rawAssetJSONString;
    }).catchError((e) {
      final msg = "fetching from manifest bundle produced error $e";
      m.loggy.debug("  $msg");
      return '{ "error": "$msg" }';
    }).then((s) {
      m.loggy.debug("  attempting to parse to JSON");

      final j = JSON.parse(s);
      m.loggy.debug("  success; JSON.parse returned $j");

      // JSON.parse may? fail on the manifest - it should not fail on the
      // error message emitted above
      return JSON.parse(s);
    }).catchError((e) {
      // if we fail at parsing the manifest, we have failed the whole thing.
      // Notify our listeners so they can behold our failure!

      final msg = "parsing manifest produced error $e";
      m.loggy.debug(msg);
      m.assetMap = JSON.parse('{ "error": "$msg" }');
    }).then((j) {
      const matcher = "assets/spreads";
      // The asset manifest is always a JSON object, with a formal structure
      final interm = j.mapValue.keys // what all is in here?
        .filter((t) {
          loggy.debug("  applying filter to j.mapValue.keys");
          m.loggy.debug("  t is $t");
          m.loggy
          m.loggy.debug("  t.startsWith(matcher) returns ${t.startsWith(matcher)}");

          return t.startsWith(matcher);
      }).map((t) {
        // this piece - need to create a separate class for
        // spread objects, which will involve loading more assets from the
        // asset bundle.  For now, just add the value for each asset to
        // the list, though
        m.loggy.debug("  mapping t.  t is $t");
        m.loggy.debug("  j.mapValue[t][0] is ${j.mapValue[t]?.listValue[0]}");
        return j.mapValue[t]?.listValue[0];
      });
      m.loggy.debug("  interm is $interm; type is ${interm.runtimeType}");
      m.loggy.debug("  interm has length ${interm.length}");

      final pink = interm.toList();
      m.loggy.debug("  pink is $pink");
      // .toList() as List<JSON>;
      // m.loggy.debug("spreads found, list is $m.spreads");
      m.notifyListeners(); // success!

      return pink;
    }).catchError((e) {
      m.loggy.debug("converting to spreads list didn't work. error $e");
      m.notifyListeners(); // empty list, but the JSON object is still ready
      // at this point.
    });
*/
    return m;
  }
}
