import 'dart:convert';
import 'dart:collection';

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import 'package:get_it/get_it.dart';
// import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:loggy/loggy.dart';

import 'package:tarot/models/manifest.dart';
import 'package:tarot/models/spreads.dart';

class Globals with UiLoggy {
  ValueNotifier<int> _chosenSpread = ValueNotifier<int>(-1);
  int get chosenSpread => _chosenSpread.value;
  set chosenSpread(int newValue) { _chosenSpread.value = newValue; }

  final ValueNotifier<int> _counter = ValueNotifier<int>(0);
  int get counter => _counter.value;
  set counter(int newValue) { _counter.value = newValue; }

  Globals._internal();

  static void createGlobals() {
    GetIt.I.registerSingletonAsync<Manifest>(Manifest.getManifest);
    GetIt.I.registerSingletonWithDependencies<Spreads>(Spreads.new, dependsOn: [ Manifest ]);

    GetIt.I.registerSingletonWithDependencies<Globals>(Globals._internal, dependsOn: [ Manifest, Spreads ]);

    GetIt.I.getAsync<Globals>().then((result) { logDebug("Globals.create: globals fetched: $result"); });
  }

/*
  factory Globals() {
    if (GetIt.I.isRegistered<Globals>()) {
      return GetIt.I<Globals>();
    }

    Globals g = Globals._internal();

    return g;
  }
*/

  static Future<Globals> _initAsync() async {
    final g = Globals._internal();

    return await g;
  }

  void report() {
    loggy.debug("Globals:");
    loggy.debug("  chosenSpread is $chosenSpread");
  }
}