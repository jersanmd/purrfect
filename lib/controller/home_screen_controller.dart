import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreenController extends RxController {
  var selectedIndex = 0.obs;
  final PageController pageController = PageController(initialPage: 0);

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }
}
