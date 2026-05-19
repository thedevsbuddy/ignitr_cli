import "package:dcli/dcli.dart";

import "../models/stub.dart";
import "base_generator.dart";
import "../utilities/utils.dart";

class ModelGenerator extends BaseGenerator {
  ModelGenerator(super.commandInfo);

  Future<void> generate() async {
    await generateModel();
    await updateModelsExport();
  }

  Future<void> generateModel() async {
    /// Check and create directory
    Utils.makeDir(commandInfo.modelPath);

    /// Replace slots with actual value
    String modelFile = parseStub(stubs.firstWhere((item) => item.type == StubType.model).content);

    /// Write File
    Utils.writeFile("${commandInfo.modelPath}/${commandInfo.modelSnake}.dart", modelFile);

    /// Show Success message
    print(green('"${commandInfo.modelPath}/${commandInfo.modelSnake}.dart" generated successfully!'));
  }

  Future<void> updateModelsExport() async {
    String exportFile = "${commandInfo.modelSnake}.dart";
    String modelsFilePath = "${commandInfo.modelPath}/models.dart";
    String modelsFileContent = await Utils.readFile(modelsFilePath);

    if (modelsFileContent.contains(exportFile)) {
      /// Show Success message
      print(green('part "${commandInfo.modelSnake}.dart" already exists in $modelsFilePath'));
      return;
    }
    modelsFileContent = "$modelsFileContent\npart \"$exportFile\";\n";

    /// Write File
    Utils.writeFile(modelsFilePath, modelsFileContent);

    /// Show Success message
    print(green('part "${commandInfo.modelSnake}.dart" added to $modelsFilePath'));
  }
}
