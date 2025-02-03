import 'package:dcli/dcli.dart';
import 'package:ignitr_cli/src/models/stub.dart';

import 'base_generator.dart';
import '../utilities/utils.dart';

class ServiceGenerator extends BaseGenerator {
  ServiceGenerator(super.args);

  Future<void> generate() async {
    /// Generate Controller
    Utils.makeDir(servicePath);

    /// Replace slots with actual value
    String serviceFile = parseStub(stubs.firstWhere((item) => item.type == StubType.service).content);
    String serviceLocalFile = parseStub(stubs.firstWhere((item) => item.type == StubType.localService).content);
    String serviceApiFile = parseStub(stubs.firstWhere((item) => item.type == StubType.remoteService).content);

    /// Write File
    Utils.writeFile("$servicePath/${moduleName.snakeCase}_service.dart", serviceFile);
    Utils.writeFile("$servicePath/local_${moduleName.snakeCase}_service.dart", serviceLocalFile);
    Utils.writeFile("$servicePath/remote_${moduleName.snakeCase}_service.dart", serviceApiFile);

    /// Show Success message
    print(green('"$servicePath/${moduleName.snakeCase}_service.dart" generated successfully.'));
    print(green('"$servicePath/local_${moduleName.snakeCase}_service.dart" generated successfully.'));
    print(green('"$servicePath/remote_${moduleName.snakeCase}_service.dart" generated successfully.'));
  }
}
