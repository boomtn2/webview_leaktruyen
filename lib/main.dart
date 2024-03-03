import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android features.

import 'webview_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final WVController _webViewController = WVController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _webViewController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                _webViewController.loadJS();
                _webViewController.loadChapter();
              },
              icon: Icon(Icons.javascript))
        ],
      ),
      body: Obx(
        () => ListView(
          children: [
            ButtonIndexing(
              wvController: _webViewController,
            ),
            _webViewController.loading.value
                ? CircularProgressIndicator()
                : SizedBox.shrink(),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: _webViewController.listChuong.entries
                  .map((e) => ListTile(
                        title: Text(e.value),
                      ))
                  .toList(),
            ),
            ButtonIndexing(
              wvController: _webViewController,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _webViewController.loadRequest();
        },
        tooltip: 'loadrequest',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ButtonIndexing extends StatelessWidget {
  const ButtonIndexing({
    super.key,
    required this.wvController,
  });
  final WVController wvController;
  @override
  Widget build(BuildContext context) {
    return Obx(() => Wrap(
        children: wvController.chiMuc.entries
            .map((e) => ElevatedButton(
                onPressed: () {
                  print(e.value);
                  wvController.selectChiMuc(stChimuc: e.key);
                },
                child: Text(
                  e.key,
                  style: TextStyle(
                      color: e.value.compareTo('active') == 0
                          ? Colors.red
                          : Colors.black),
                )))
            .toList()));
  }
}
