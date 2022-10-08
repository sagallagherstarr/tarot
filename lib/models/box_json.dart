import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:loggy/loggy.dart';
import 'package:tarot/models/box_json.dart';

abstract class BoxType {
  String get json;
}

class AbstractBox<T> implements BoxType {
  // AbstractBoxes are immutable once created.
  late final T _value;
  T get value => _value;

  @override
  String get json => jsonEncode(value); // convert itself to json

  static BoxType boxIt(dynamic inElement) {
    // take inElement, determine its runtimeType,
    // and convert it to the appropriate BoxType, if necessary
    if (inElement == null) { return boxNull; }

    if (inElement is BoxType) {
      return inElement;
    }

    switch (inElement.runtimeType) {
      case int:
        return BoxInt(inElement);
        break;

      case double:
        return BoxDouble(inElement);
        break;

      case bool:
        return BoxBool(inElement);
        break;

      case String:
        return BoxString(inElement);
        break;

      case List:
        return BoxList(inElement);
        break;

      case Map:
        return BoxMap(inElement);
        break;

      default:
        return boxNull;
    }
  }
}

class BoxSimple<T extends Object> extends AbstractBox implements BoxType {
  BoxSimple(T value) : assert(value is int || value is double ||
      value is String || value is bool) {
    super._value = value;
  }

  @override
  String get json => value.toString();
}

class BoxCompound<T extends Object> extends AbstractBox<T> implements BoxType {
  BoxCompound(T value) : assert(value is List<dynamic> || value is Map<String, dynamic>);

  void writeList(StringBuffer buffer, List<String> items) {
    // StringBuffer is modified in place, not returned
    for (var idx=0; idx < items.length - 1; idx++) {
      buffer.write(items[idx]);
      buffer.writeln(",");
    }

    buffer.writeln(items[items.length - 1]);
  }
}

class BoxInt extends BoxSimple<int> implements BoxType {
  BoxInt(super.value);
}

class BoxDouble extends BoxSimple<double> implements BoxType {
  BoxDouble(super.value);
}

class BoxNum extends BoxSimple<num> implements BoxType {
  BoxNum(super.value);
}

class BoxString extends BoxSimple<String> implements BoxType {
  BoxString(super.value);

  @override
  String get json => '"$value"';
}

class BoxBool extends BoxSimple<bool> implements BoxType {
  BoxBool(super.value);
}

// not list of int, but BoxList of BoxInt, e.g.
class BoxList<T extends BoxType> extends BoxCompound<List<dynamic>> implements BoxType {

  BoxList(List<dynamic> inList) : super(inList) {
    _value = inList.map((element) => AbstractBox.boxIt(element)).toList();
  }

  String get json {
    StringBuffer retval = StringBuffer();
    retval.writeln("[");

    writeList(retval, _value.map((e) => e.json as String).toList());

    retval.writeln("]");

    return retval.toString();
  }
}

class BoxMap extends BoxCompound<Map<String, BoxType>> implements BoxType {
  BoxMap(Map<String, dynamic> inMap) : super() {
    _value = Map<String, BoxType>();
    inMap.forEach((k, v) { value[k] = AbstractBox.boxIt(v); });
  }

  @override
  String get json {
    StringBuffer retval = StringBuffer()

    retval.writeln("{");


    value.keys
    .map((key) => '"$e": ${value[e]?.json ?? "null"}')
    .toList()
    .forEach((e) => retval.writeln('"$e": ${value[e]?.json ?? "null"}'));

    retval.writeln(" }");

    return retval.toString();
  }

}

class BoxNull implements BoxType {
  BoxNull() : super();

  @override
  Object? get value => null;

  @override
  get json => null;

  @override
  BoxNull boxit(dynamic ignore) {
    return boxNull;
  }
}

final boxNull = BoxNull(); // the only one of its kind
