import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:loggy/loggy.dart';
import 'package:flutter_loggy/flutter_loggy.dart';

import 'package:flutter_json_view/flutter_json_view.dart';

import 'package:tarot/models/manifest.dart';

class ManifestView extends StatelessWidget with GetItMixin, UiLoggy {
  ManifestView({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    final assets = watchX((Manifest m) => m.assetString);

    return JsonView.string(assets);
  }
}

class ManifestPage extends StatelessWidget with GetItMixin, UiLoggy {
  ManifestPage({super.key});

  Widget build(BuildContext context) {
    return ManifestView();
  }
}