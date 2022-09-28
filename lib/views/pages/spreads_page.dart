import 'package:flutter/material.dart';

import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:loggy/loggy.dart';
import 'package:flutter_loggy/flutter_loggy.dart';

import 'package:flutter_json_view/flutter_json_view.dart';

import 'package:tarot/models/manifest.dart';

class SpreadsView extends StatelessWidget with GetItMixin, UiLoggy {
  SpreadsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Placeholder()
        ),
        Expanded(
          flex: 35,
          child: Placeholder()
        )
      ]
    );
  }
}
class SpreadsPage extends StatelessWidget with GetItMixin, UiLoggy {
  SpreadsPage({super.key});

  Widget build(BuildContext context) {
    return SpreadsView();
  }
}