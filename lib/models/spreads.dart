import 'dart:convert';
import 'dart:collection';
import 'dart:math' as math;

import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import 'package:get_it/get_it.dart';
// import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:loggy/loggy.dart';

import 'package:tarot/models/manifest.dart';

class Spread {
  final bool fromManifest;
  final String name;
  final String layout; // is json data
  final String description;

  Spread(this.name, this.layout, this.description, {this.fromManifest = true});
}

final testSpreadList = <Spread>[
  Spread("Past, Present, Future", "layout", "description"),
  Spread("Yes / No", "layout", "description"),
  Spread("3-card", "layout", "description"),
];

class Spreads extends DelegatingList<Spread> with ChangeNotifier, UiLoggy {
  Spreads() : super(<Spread>[]) {

    addAll(testSpreadList);
    notifyListeners();
  }

  @override
  void operator []=(int index, Spread value) {
    super[index] = value;
    notifyListeners();
  }

  @override
  List<Spread> operator +(List<Spread> other) {
    final m = super + other;
    notifyListeners();
    return m;
  }

  @override
  void add(Spread value) {
    super.add(value);
    notifyListeners();
  }

  @override
  void addAll(Iterable<Spread> iterable) {
    super.addAll(iterable);
    notifyListeners();
  }

  @override
  void clear() {
    super.clear();
    notifyListeners();
  }

  @override
  void fillRange(int start, int end, [Spread? fillValue]) {
    super.fillRange(start, end, fillValue);
    notifyListeners();
  }

  @override
  set first(Spread value) {
    if (super.isEmpty) throw RangeError.index(0, this);
    this[0] = value;
    notifyListeners();
  }

  @override
  void insert(int index, Spread element) {
    super.insert(index, element);
    notifyListeners();
  }

  @override
  void insertAll(int index, Iterable<Spread> iterable) {
    super.insertAll(index, iterable);
    notifyListeners();
  }

  @override
  set last(Spread value) {
    if (super.isEmpty) throw RangeError.index(0, this);
    this[length - 1] = value;
    notifyListeners();
  }

  @override
  set length(int newLength) {
    super.length = newLength;
    notifyListeners();
  }

  @override
  bool remove(Object? value) {
    final b = super.remove(value);
    notifyListeners();

    return b;
  }

  @override
  Spread removeAt(int index) {
    final b = super.removeAt(index);
    notifyListeners();
    return b;
  }

  @override
  Spread removeLast() {
    final b = super.removeLast();
    notifyListeners();
    return b;
  }

  @override
  void removeRange(int start, int end) {
    super.removeRange(start, end);
    notifyListeners();
  }

  @override
  void removeWhere(bool Function(Spread) test) {
    super.removeWhere(test);
    notifyListeners();
  }

  @override
  void replaceRange(int start, int end, Iterable<Spread> iterable) {
    super.replaceRange(start, end, iterable);
    notifyListeners();
  }

  @override
  void retainWhere(bool Function(Spread) test) {
    super.retainWhere(test);
    notifyListeners();
  }

  @override
  void setAll(int index, Iterable<Spread> iterable) {
    super.setAll(index, iterable);
    notifyListeners();
  }

  @override
  void setRange(int start, int end, Iterable<Spread> iterable, [int skipCount = 0]) {
    super.setRange(start, end, iterable, skipCount);
    notifyListeners();
  }

  @override
  void shuffle([math.Random? random]) {
    super.shuffle(random);
    notifyListeners();
  }

  @override
  void sort([int Function(Spread, Spread)? compare]) {
    super.sort(compare);
    notifyListeners();
  }
}