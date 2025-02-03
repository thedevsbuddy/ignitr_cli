import 'package:dcli/dcli.dart';

import '../models/stub.dart';
import 'base_generator.dart';
import '../utilities/utils.dart';

class ModelGenerator extends BaseGenerator {
  ModelGenerator(super.args);

  Future<void> generate() async {
    await generateModel();
    await updateModelsExport();
  }

  Future<void> generateModel() async {
    /// Check and create directory
    Utils.makeDir(modelPath);

    /// Replace slots with actual value
    String modelFile = parseStub(stubs.firstWhere((item) => item.type == StubType.model).content);

    /// Write File
    Utils.writeFile("$modelPath/${moduleName.snakeCase}_model.dart", modelFile);

    /// Show Success message
    print(green('"$modelPath/${moduleName.snakeCase}_model.dart" generated successfully!'));
  }

  Future<void> updateModelsExport() async {
    String exportFile = "${moduleName.snakeCase}_model.dart";
    String modelsFilePath = "$modelPath/models.dart";
    String modelsFileContent = await Utils.readFile(modelsFilePath);
    if (modelsFileContent.contains(exportFile)) {
      /// Show Success message
      print(green('export "${moduleName.snakeCase}_model.dart" already exists in $modelsFilePath'));
      return;
    }
    modelsFileContent = """
      $modelsFileContent
      export '$exportFile';
    """;

    /// Write File
    Utils.writeFile(modelsFilePath, modelsFileContent);

    /// Show Success message
    print(green('export "${moduleName.snakeCase}_model.dart" added to $modelsFilePath'));
  }
}
