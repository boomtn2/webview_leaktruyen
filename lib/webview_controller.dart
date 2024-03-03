import 'dart:convert';

import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'js_test.dart';

class WVController extends GetxController {
  RxBool loading = false.obs;
  //key: chiMuc value: class
  Map<String, String> chiMuc = <String, String>{}.obs;
  // key: link value: text
  Map<String, String> listChuong = <String, String>{}.obs;
  // key: link value: text
  Map<String, String> theLoai = <String, String>{}.obs;
  final WebViewController controller = WebViewController();
  RxString moTa = ''.obs;
  void loadRequest() {
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            loading.value = true;
          },
          onPageFinished: (String url) {
            loading.value = false;
            loadChapter();
            loadJS();

            if (moTa.value.isEmpty) {
              moTaFCT();
              theLoaiFCT();
            }
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(
          'https://wikisach.net/truyen/xuyen-nhanh-nu-xung-binh-tinh-mot-chut-W7I2xlS4CBu2Iu43'));
  }

  void loadJS() async {
    try {
      final jsonString =
          await controller.runJavaScriptReturningResult(jsLeakChiMuc());

      final data = jsonDecode('$jsonString');
      List<dynamic> jsonList =
          jsonDecode(data); // Phân tích chuỗi JSON thành một danh sách Dart
      Map<String, String> mapData = {};
      // Lặp qua từng phần tử trong danh sách JSON và chuyển đổi thành Map<String, String>
      for (var element in jsonList) {
        String key = element['textContent'];
        String value = element['liClasses'];
        mapData.addAll({key: value});
      }

      chiMuc.clear();
      chiMuc.addAll(mapData);
      // In danh sách đã chuyển đổi
    } catch (e) {
      print(e);
    }
  }

  void loadChapter() async {
    try {
      final jsonString =
          await controller.runJavaScriptReturningResult(jsChapter);

      final data = jsonDecode('$jsonString');
      List<dynamic> jsonList =
          jsonDecode(data); // Phân tích chuỗi JSON thành một danh sách Dart
      Map<String, String> mapData = {};
      // Lặp qua từng phần tử trong danh sách JSON và chuyển đổi thành Map<String, String>
      for (var element in jsonList) {
        String key = element['href'];
        String value = element['textContent'];
        mapData.addAll({key: value});
      }
      listChuong.clear();
      listChuong.addAll(mapData);
    } catch (e) {
      print(e);
    }
  }

  void selectChiMuc({required String stChimuc}) async {
    try {
      String querry = actionNext.replaceAll('?', stChimuc);
      loading.value = true;
      await controller.runJavaScript(querry);
    } catch (e) {
      print(e);
    }
  }

  void moTaFCT() async {
    try {
      final jsonString =
          await controller.runJavaScriptReturningResult(textMoTa) as String;
      moTa.value = jsonString;
    } catch (e) {}
  }

  void theLoaiFCT() async {
    try {
      final jsonString =
          await controller.runJavaScriptReturningResult(theLoaiJS);

      final data = jsonDecode('$jsonString');
      List<dynamic> jsonList =
          jsonDecode(data); // Phân tích chuỗi JSON thành một danh sách Dart
      Map<String, String> mapData = {};
      // Lặp qua từng phần tử trong danh sách JSON và chuyển đổi thành Map<String, String>
      for (var element in jsonList) {
        String key = element['href'];
        String value = element['textContent'];
        mapData.addAll({key: value});
      }
      theLoai.clear();
      theLoai.addAll(mapData);
    } catch (e) {
      print(e);
    }
  }

  void close() {
    controller.clearCache();
    controller.clearLocalStorage();
  }
}

class Autogenerated {
  String? textContent;
  String? liClasses;

  Autogenerated({this.textContent, this.liClasses});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    textContent = json['textContent'];
    liClasses = json['liClasses'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['textContent'] = this.textContent;
    data['liClasses'] = this.liClasses;
    return data;
  }
}
