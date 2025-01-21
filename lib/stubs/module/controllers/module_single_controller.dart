const String stub = r"""
import 'package:get/get.dart';

import '../../../shared/shared.dart';
// import '../services/{SNAKE_MODULE}_service.dart';

class {CONTROLLER}Controller extends AppController {
  /// Create and get the instance of the controller
  static {CONTROLLER}Controller get instance {
    if (!Get.isRegistered<{CONTROLLER}Controller>()) Get.put({CONTROLLER}Controller());
    return Get.find<{CONTROLLER}Controller>();
  }

  /// Initialise [{MODULE}Module] service
  // final {MODULE}Service _{CAMEL_MODULE}Service = {MODULE}Service.instance;

  /// Props
  
  Future<void> index({bool refresh = false}) async {
    
  }
}
""";
