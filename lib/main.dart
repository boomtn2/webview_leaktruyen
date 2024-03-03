import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      home: const PageHome(),
    );
  }
}

class PageHome extends StatelessWidget {
  const PageHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
          onPressed: () {
            Get.to(() => const MyHomePage(title: 'Flutter Demo Home Page'));
          },
          child: const Text('Next')),
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
            Text(
              _webViewController.moTa.value,
              maxLines: 2,
            ),
            Wrap(
              children: _webViewController.theLoai.entries
                  .map((e) => Text(e.value))
                  .toList(),
            ),
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
            .map((e) => SizedBox(
                  height: 40,
                  child: ElevatedButton(
                      onPressed: () {
                        wvController.selectChiMuc(stChimuc: e.key);
                      },
                      child: Text(
                        e.key,
                        style: TextStyle(
                            color: 'active'.compareTo(e.value.trim()) == 0
                                ? Colors.red
                                : Colors.black),
                      )),
                ))
            .toList()));
  }
}
