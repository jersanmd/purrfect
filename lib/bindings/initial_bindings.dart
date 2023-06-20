import 'package:get/get.dart';
import 'package:purrfect/controller/home_screen_controller.dart';
import 'package:purrfect/controller/pet_controller.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(HomeScreenController());
    Get.put(PetController());
  }
}
