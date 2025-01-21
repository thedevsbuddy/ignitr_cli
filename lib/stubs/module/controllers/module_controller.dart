const String stub = r"""
import 'package:get/get.dart';

import '../../../../helpers/helpers.dart';
import '../../../models/models.dart';
import '../../../shared/shared.dart';
import '../services/{SNAKE_MODULE}_service.dart';

class {CONTROLLER}Controller extends AppController {
  /// Create and get the instance of the controller
  static {CONTROLLER}Controller get instance {
    if (!Get.isRegistered<{CONTROLLER}Controller>()) Get.put({CONTROLLER}Controller());
    return Get.find<{CONTROLLER}Controller>();
  }

  /// Initialise [{MODULE}Module] service
  final {MODULE}Service _{CAMEL_MODULE}Service = {MODULE}Service.instance;
  
  /// Props
  List<{MODULE}Model> {PLURAL_MODULE} = [];

  Future<void> index({bool refresh = false}) async {
    try {
      /// Define API Client For This Method
      String _client = '{PLURAL_MODULE}-index';

      /// Start loading state
      if(!refresh) setBusy(true);

      /// Initialise the service
      _{CAMEL_MODULE}Service.init(_client);

      /// Call the API
      ApiResponse response = await _{CAMEL_MODULE}Service.index(client: _client);

      /// Check if the response has error
      if (response.hasError()) {
        /// Show error message
        Toastr.error(message: "${response.message}");

        /// Close the client
        _{CAMEL_MODULE}Service.close(_client);

        /// Stop loading state
        setBusy(false);
        return;
      }

      /// Set value to [articles]
      {PLURAL_MODULE} = List<ArticleModel>.from(response.data.map((x) => ArticleModel.fromJson(x)));

      /// Stop loading state
      setBusy(false);

      /// Update UI
      update();

      /// Close the client
      _{CAMEL_MODULE}Service.close(_client);
    } catch (e) {
      print(e);
      Toastr.error(message: "Something went wrong.");
    }
  }

  Future<void> destroy({required int id}) async {
    try {
      /// Define API Client For This Method
      String _client = '{PLURAL_MODULE}-delete';

      /// Initialise the service
      _{CAMEL_MODULE}Service.init(_client);

      /// Call the API
      ApiResponse response = await _{CAMEL_MODULE}Service.destroy(client: _client, id: id);

      /// Check if the response has error
      if (response.hasError()) {
        /// Show error message
        Toastr.error(message: "${response.message}");

        /// Close the client
        _{CAMEL_MODULE}Service.close(_client);
        return;
      }

      /// Reload the data
      await index(refresh: true);

      /// Close the client
      _{CAMEL_MODULE}Service.close(_client);
    } catch (e) {
      print(e);
      Toastr.error(message: "Something went wrong.");
    }
  }
}
""";
