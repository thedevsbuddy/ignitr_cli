import 'package:dcli/dcli.dart';

import '../../stubs/module/services/api_module_service.dart' as modulr_api_service;
import '../../stubs/module/services/local_module_service.dart' as modulr_local_service;
import '../../stubs/module/services/module_service.dart' as modulr_service;
import 'base_generator.dart';
import '../utilities/utils.dart';

class ServiceGenerator extends BaseGenerator {
  ServiceGenerator(super.args);

  Future<void> generate() async {
    /// Generate Controller
    Utils.makeDir(servicePath);

    /// Replace slots with actual value
    String serviceFile = parseStub(modulr_service.stub);
    String serviceLocalFile = parseStub(modulr_local_service.stub);
    String serviceApiFile = parseStub(modulr_api_service.stub);

    /// Write File
    Utils.writeFile("$servicePath/${moduleName.snakeCase}_service.dart", serviceFile);
    Utils.writeFile("$servicePath/local_${moduleName.snakeCase}_service.dart", serviceLocalFile);
    Utils.writeFile("$servicePath/api_${moduleName.snakeCase}_service.dart", serviceApiFile);

    /// Show Success message
    print(green('"$servicePath/${moduleName.snakeCase}_service.dart" generated successfully.'));
    print(green('"$servicePath/local_${moduleName.snakeCase}_service.dart" generated successfully.'));
    print(green('"$servicePath/api_${moduleName.snakeCase}_service.dart" generated successfully.'));
  }
}
