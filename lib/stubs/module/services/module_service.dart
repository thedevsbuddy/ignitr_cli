const String stub = """
import 'package:get/get.dart';

import '../../../../config/config.dart';
import '../../../shared/shared.dart';
import 'remote_{SNAKE_MODULE}_service.dart';
import 'local_{SNAKE_MODULE}_service.dart';

abstract class {MODULE}Service extends BaseService {
  /// Define if this is in dev mode
  static bool devMode = Config.devMode;

  /// Create and get the instance of [{MODULE}Service]
  static {MODULE}Service get instance {
    InternetService internetService = InternetService.instance;

    if (!Get.isRegistered<{MODULE}Service>()) {
      Get.lazyPut<{MODULE}Service>(() {
        if (devMode) return Local{MODULE}Service();
        if (!internetService.isConnected) return Local{MODULE}Service();
        return Remote{MODULE}Service();
      });
    }

    return Get.find<{MODULE}Service>();
  }
  
  Future<ApiResponse> index({required String client});
  Future<ApiResponse> show({required String client, required int id});
  Future<ApiResponse> store({required String client, required Map<String, dynamic> data});
  Future<ApiResponse> patch({required String client, required int id, required Map<String, dynamic> data});
  Future<ApiResponse> destroy({required String client, required int id});
}
""";
