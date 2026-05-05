import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:recase/recase.dart';

import '../models/command_info.dart';
import '../models/stub.dart';
import '../utilities/utils.dart';

class BaseGenerator {
  Map<String, String> stubReplacements = {};
  Map<String, String> nameReplacements = {};
  List<Stub> stubs = [];

  CommandInfo commandInfo;

  BaseGenerator(this.commandInfo) {
    File configFile = File('.ignitr/config.json');

    if (configFile.existsSync()) {
      Map<String, dynamic> ignitrConfig = jsonDecode(configFile.readAsStringSync());

      if (ignitrConfig['project'] != null && commandInfo.project.originalText.isEmpty) {
        commandInfo.project = ReCase(ignitrConfig['project']);
      }
    }

    nameReplacements = {
      'com.devsbuddy.ignitr_template': "${commandInfo.organization}.${commandInfo.projectSnake}",
      'ignitr_template': commandInfo.projectSnake,
      'Ignitr': commandInfo.projectTitle,
    };
  }

  Future<void> init() async {
    await _loadStubs();
  }

  String parseStub(String content) {
    stubReplacements = {
      '{MODULE}': Utils.singularize(commandInfo.modulePascal),
      '{CAMEL_MODULE}': commandInfo.moduleCamel,
      '{SNAKE_MODULE}': commandInfo.moduleSnake,
      '{PLURAL_MODULE}': Utils.pluralize(commandInfo.moduleSnake),
      '{MODULE_URL}': commandInfo.moduleParam,
      '{MODEL_CLASS}': commandInfo.modelClass,
      '{PAGE_CLASS}': commandInfo.pageClass,
      '{CONTROLLER_CLASS}': commandInfo.controllerClass,
    };

    for (String key in stubReplacements.keys) {
      content = content.replaceAll(key, stubReplacements[key]!);
    }
    return content;
  }

  Future<void> _loadStubs() async {
    Directory stubDirectory = Directory('.ignitr/stubs');
    if (!(await stubDirectory.exists())) {
      // throw Exception("Stubs directory not found, Please run 'ignitr publish:stubs' to");
    } else {
      await for (var entity in stubDirectory.list(recursive: true)) {
        if (entity is File) {
          final stubContent = await entity.readAsString();
          final stubName = basenameWithoutExtension(entity.path);
          Stub stub = Stub(
            name: stubName,
            type: StubType.values.firstWhere((element) => element.name == stubName),
            content: stubContent,
          );

          stubs.add(stub);
        }
      }
    }
  }
}
