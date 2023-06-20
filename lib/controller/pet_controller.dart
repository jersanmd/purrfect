import 'dart:ui';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PetController extends RxController {
  var genderIndex = 0.obs;
  RxString dateSelected = 'Select Date'.obs;

  RxInt ownerId = 0.obs;
  RxString selectedOwnerName = 'Tom Cruise'.obs;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }
}
