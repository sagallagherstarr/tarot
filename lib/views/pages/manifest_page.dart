import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:loggy/loggy.dart';
import 'package:flutter_loggy/flutter_loggy.dart';

import 'package:flutter_json_view/flutter_json_view.dart';

import 'package:tarot/models/manifest.dart';

class ManifestView extends StatelessWidget with GetItMixin, UiLoggy {
  ManifestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final assets = watchOnly((Manifest x) => x);

    return JsonView.string(assets.assetString);
  }
}

class ManifestPage extends StatelessWidget with GetItMixin, UiLoggy {
  ManifestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ManifestView();
  }
}