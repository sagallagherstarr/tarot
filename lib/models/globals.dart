import 'dart:convert';
import 'dart:collection';

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import 'package:get_it/get_it.dart';
// import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:loggy/loggy.dart';

class Globals with UiLoggy {
  ValueNotifier<int> _chosenSpread = ValueNotifier<int>(-1);
  int get chosenSpread => _chosenSpread.value;
  set chosenSpread(int newValue) { _chosenSpread.value = newValue; }

  Globals._internal();

  factory Globals() {
    if (GetIt.I.isRegistered<Globals>()) {
      return GetIt.I<Globals>();
    }

    Globals g = Globals._internal();
    GetIt.I.registerSingleton<Globals>(g);

    return g;
  }

  void report() {
    loggy.debug("Globals:");
    loggy.debug("  chosenSpread is $chosenSpread");
  }
}