import "dart:io";

import "../../utilities/utils.dart";
import "../base_generator.dart";
import "package:yaml/yaml.dart";

class SpacingGenerator extends BaseGenerator {
  SpacingGenerator(super.commandInfo);

  String inputPath = "configs/spacing.yaml";
  String outputPath = "core/lib/design/spacing/sizes.dart";

  Future<void> generate() async {
    final file = File(inputPath);

    if (!file.existsSync()) {
      throw Exception("Typography config not found: $inputPath");
    }

    final yamlString = await file.readAsString();
    final yaml = loadYaml(yamlString);

    final buffer = StringBuffer();

    _writeHeader(buffer);
    _writeSizes(buffer, yaml);

    Utils.writeFile(outputPath, buffer.toString());
  }

  void _writeHeader(StringBuffer buffer) {
    buffer.writeln("// GENERATED CODE - DO NOT MODIFY BY HAND");
    buffer.writeln();
    buffer.writeln("part of \"package:core/core.dart\";");
    buffer.writeln();
  }

  void _writeSizes(StringBuffer buffer, dynamic yaml) {
    final base = yaml["base"];
    final scale = yaml["scale"];

    buffer.writeln(
      "/// Returns Base Value (double): ${base * 1.0}",
    );
    buffer.writeln(
      "const double _base = $base;",
    );
    buffer.writeln(
      "/// Returns Base Value (double): ${base * 1.0}",
    );
    buffer.writeln(
      "const double kSpacer = _base;",
    );
    buffer.writeln();

    for (final scaleEntry in scale.entries) {
      String scaleName = scaleEntry.key.toString();
      final scaleValue = scaleEntry.value;

      if (scaleName.toString().contains(".")) {
        scaleName = scaleName.replaceAll(".", "Dot");
      }

      buffer.writeln(
        "/// Returns (double): ${base * scaleValue * 1.0}",
      );
      buffer.writeln(
        "const double kSpacer$scaleName = _base * $scaleValue;",
      );
      buffer.writeln();
    }
  }
}
