import "package:dcli/dcli.dart";
import "../models/stub.dart";

import "base_generator.dart";
import "../utilities/utils.dart";

class ClientGenerator extends BaseGenerator {
  ClientGenerator(super.commandInfo);

  Future<void> generate() async {
    Utils.makeDir(commandInfo.clientPath);

    /// Replace slots with actual value
    String clientFile = parseStub(stubs.firstWhere((item) => item.type == StubType.client).content);
    String apiClientFile = parseStub(stubs.firstWhere((item) => item.type == StubType.apiClient).content);

    /// Write File
    Utils.writeFile("${commandInfo.clientPath}/${commandInfo.moduleSnake}_client.dart", clientFile);
    Utils.writeFile("${commandInfo.clientPath}/api_${commandInfo.moduleSnake}_client.dart", apiClientFile);

    /// Show Success message
    print(green('"${commandInfo.clientPath}/${commandInfo.moduleSnake}_service.dart" generated successfully.'));
    print(green('"${commandInfo.clientPath}/remote_${commandInfo.moduleSnake}_service.dart" generated successfully.'));
  }
}
