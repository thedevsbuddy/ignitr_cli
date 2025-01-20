const String stub = """
import 'package:get/get.dart';

import '../{SNAKE_MODULE}_module.dart';

/// Defines the routes for the [{MODULE}] module.
/// This class contains the route paths and other route-related properties
/// that are used by the GetX routing system to manage the navigation
/// within the dashboard module.
class {MODULE}Routes {
  static String get {MODULE_URL_CAMEL} => '/{MODULE_URL}';
}

/// Defines the routes for the [{MODULE}] module. This list of [GetPage] instances
/// specifies the routes and corresponding pages
/// in the [{MODULE}] module.
List<GetPage> {CAMEL_MODULE}Routes = [
  GetPage(name: '/{MODULE_URL}', page: () => {MODULE}Page()),
];
""";
