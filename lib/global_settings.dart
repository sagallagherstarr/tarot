import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:loggy/loggy.dart';
import 'package:flutter_loggy/flutter_loggy.dart';
import 'package:fpdart/fpdart.dart';
import 'package:g_json/g_json.dart';


// ValueNotifier adds too much type complexity, let's simplify
/*
typedef VNOption<T> = ValueNotifier<Option<T>>;
typedef Toption<T> = TaskOption<T>;
typedef VNT<T> = ValueNotifier<TaskOption<T>>;
*/

// This class allows for a kind of union type to be constructed.
// a Box holds a value of type T; create a new immutable value by
// calling the constructor with a type, like so: final q = Box<int>(2);
// get the value out of the box using a call on the variable:
// if (isEven(q()) { ... }

// the union-ish part happens when you construct sub-classes of particular types.
// see below for the examples used in this project
/*

@immutable
class BoxType<T> {
  final T? _value;

  const BoxType(this._value)

  T? call() => _value; // if _value is null, it will return null.
}

typedef BoxInt = BoxType<int>;
typedef BoxDouble = BoxType<double>;
typedef BoxNum = BoxType<num>;
typedef BoxBool = BoxType<bool>;
typedef BoxString = BoxType<String>;
typedef BoxNull = BoxType<Null>;
typedef BoxMap = BoxType<Map<String, BoxType>>;
typedef BoxList = BoxType<List<BoxType>>;

class JSONType extends BoxType {
  JSONType(value) : assert(value.runtimeType is int
    || value.runtimeType is double
    || value.runtimeType is num
    || value.runtimeType is bool
    || value == null
    || value.runtimeType is Map<String, JSONType>
    || value.runtimeType is List<JSONType>),
  super(value);
}
*/

class ErrorMsg {
  final String value;

  ErrorMsg(this.value);
}

typedef FO<T> = Future<Option<T>>;

/*
abstract class AsyncLoader<T> with UiLoggy {
  static bool isRegistered = false;

  // needs to be overridden to actually do something
  // not a pure function
  Unit initAsync();

  static T create<T extends AsyncLoader>(FactoryFunc<T> constructor) {
    if (!isRegistered) {
      T newbie = constructor();
      GetIt.I.registerSingleton<T>(newbie);
      isRegistered = true;

      // as a part of creating a singleton of this sort, fire off any async
      // functions that might be needed.
      newbie.initAsync();
    }

    final object = GetIt.I<T>();

    return object;
  }
}
*/


// creating this class as a ChangeNotifier makes it inherently asynchronous
// for the Widget tree, and GetIt's watch method.
class Manifest extends ChangeNotifier with UiLoggy {
  late final JSON rawAssets;

  late final List<JSON> spreads;

  Manifest({
    String rawJson = "",
    Future<String>? future
  }) : super() {
    loggy.debug("Manifest constructor");
    loggy.debug("rawJson is $rawJson");

    // we're set up to handle futures; if we were handed a bare string, convert
    // that to a future and then proceed.
    future ??= Future.value(rawJson);

    future.then((raw) { // this step exists in order to log the result
      // after this class has been debugged, simplify the chain considerably
      loggy.debug("  raw is $raw");
      return raw;
    })
        .catchError((e) {
      final msg = "fetching from manifest bundle produced error $e";
      loggy.debug("  $msg");
      return '{ "error": "$msg" }';
    })
        .then((s) {
      loggy.debug("  attempting to parse to JSON");

      // JSON.parse may? fail on the manifest - it should not fail on the
      // error message emitted above
      return JSON.parse(s);
    })
        .catchError((e) {
      // if we fail at parsing the manifest, we have failed the whole thing.
      // Notify our listeners so they can behold our failure!

      final msg = "parsing manifest produced error $e";
      loggy.debug(msg);
      rawAssets = JSON.parse('{ "error": "$msg" }');
      spreads = <JSON>[];
      notifyListeners();
    })
        .then((j) {
      const matcher = "assets/spreads";
      // The asset manifest is always a JSON object, with a formal structure
      spreads = j.mapValue.keys // what all is in here?
          .filter((t) => t.startsWith(matcher)) // which parts are assets?
          .map((t) { // this piece - need to create a separate class for
        // spread objects, which will involve loading more assets from the
        // asset bundle.  For now, just add the value for each asset to
        // the list, though
        j.mapValue[t];
      })
          .toList() as List<JSON>;
      loggy.debug("spreads found, list is $spreads");
      notifyListeners(); // success!
    })
        .catchError((e) {
      loggy.debug("converting to spreads list didn't work. error $e");
      notifyListeners(); // empty list, but the JSON object is still ready
      // at this point.
    });
  }
}