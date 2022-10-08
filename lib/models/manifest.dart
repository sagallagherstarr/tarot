import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get_it/get_it.dart';
// import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:loggy/loggy.dart';
// import 'package:flutter_loggy/flutter_loggy.dart';
import 'package:fpdart/fpdart.dart';
// import 'package:g_json/g_json.dart';

// typedef JSON = Map<String, dynamic>;

String spreadKey = "assets/spreads";

String errorAsString(String msg) => '{ "error": "$msg" }';
Map<String, dynamic> errorAsJSON(String msg) => jsonDecode(errorAsString(msg));

// creating this class as a ChangeNotifier makes it inherently asynchronous
// for the Widget tree, and GetIt's watch method.
// this could also be implemented with assetMap as a ValueNotifier, rather than the
// whole class as a change notifier

class SpreadAsset with UiLoggy {
  final String name;
  final List<String> assets;

  SpreadAsset(this.name, this.assets) {
    loggy.debug("new SpreadAsset, name is $name and assets is this.assets");
  }
}

typedef SpreadAssets = List<SpreadAsset>;

class Manifest with UiLoggy {
  // final Future<String> loadAddress;
  final String assetString;
  Map<String, dynamic> assetMap = Map<String, dynamic>();

  SpreadAssets spreadAssets = [];

  Future<Manifest> loadAssetMap() async {
    dynamic res;

    try {
      res = jsonDecode(assetString);
    } catch(e) {
      res = jsonDecode('{"error": "error decoding json: \'$e\'"');
    }

    assetMap = res;
    loggy.debug("  assetMap is $assetMap");

    spreadAssets = assetMap.keys
      .where((e) { loggy.debug("  e is $e"); return (e as String).startsWith(spreadKey); })
      .map((e) {
        loggy.debug("  map e is $e, map[e] is ${assetMap[e]}");

        return SpreadAsset(e, assetMap[e] as List<String>);
      }).toList();

    loggy.debug("  list of spreadAssets is $spreadAssets");

    return this;
  }

  Manifest(this.assetString) {
    loggy.debug("Manifest");
    loggy.debug("  assetString is '$assetString'");
  }

  static Future<Manifest> getManifest() async {
    logDebug("getManifest");

    String manifestStr = "";

    try {
      final sd = await rootBundle.loadStructuredData("AssetManifest.json", (str) => jsonDecode(str));
      logDebug("  sd is runtimeType ${sd.runtimeType}");

      logDebug(" sd is $sd");

    } catch (error) {
      manifestStr = '{ "error": "$error" }';
    }

    return await Manifest(manifestStr).loadAssetMap();
  }
}