import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:loggy/loggy.dart';
import 'package:flutter_loggy/flutter_loggy.dart';

import 'package:tarot/manifest.dart';

class TarotHomePage extends StatefulWidget with GetItStatefulWidgetMixin, UiLoggy {
  TarotHomePage({super.key, required this.title});

  final String title;

  @override
  State<TarotHomePage> createState() => _TarotHomePageState();
}

class _TarotHomePageState extends State<TarotHomePage> with GetItStateMixin, UiLoggy {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    // this exists specifically for debugging the Manifest class. Once that's done,
    // this can be removed.
    final m = Manifest(DefaultAssetBundle.of(context).loadString("AssetManifest.json"));
    m.addListener(changeUpdate);
  }

  void changeUpdate() {
    loggy.debug("changeUpdate called.");
    loggy.debug("  fetching manifest from GetIt.");

    final man = GetIt.I<Manifest>();

    loggy.debug("  manifest.rawAssets is ${man.assetMap}");
    // loggy.debug("  manifest.spreads is ${man.spreads}");
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}