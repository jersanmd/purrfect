import 'package:get/get.dart';
import 'package:purrfect/details/pet_details_screen.dart';
import 'package:purrfect/home/home_screen.dart';

class AppRoutes {
  static List<GetPage> routes() =>
      [GetPage(name: '/', page: () => const HomeScreen())];
}
