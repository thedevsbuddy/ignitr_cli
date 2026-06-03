import "dart:io";

import "package:yaml/yaml.dart";

import "../../utilities/utils.dart";
import "../base_generator.dart";

class TypographyGenerator extends BaseGenerator {
  TypographyGenerator(super.commandInfo);

  String inputPath = "configs/typography.yaml";
  String outputPath = "core/lib/design/typography/text_styl.dart";

  Future<void> generate() async {
    final file = File(inputPath);

    if (!file.existsSync()) {
      throw Exception("Typography config not found: $inputPath");
    }

    final yamlString = await file.readAsString();
    final yaml = loadYaml(yamlString);

    final buffer = StringBuffer();

    _writeHeader(buffer);
    _writeTextStylClass(buffer, yaml);
    _writeSupportClasses(buffer, yaml);

    Utils.writeFile(outputPath, buffer.toString());
  }

  void _writeHeader(StringBuffer buffer) {
    buffer.writeln("// GENERATED CODE - DO NOT MODIFY BY HAND");
    buffer.writeln();
    buffer.writeln('part of "package:core/core.dart";');
    buffer.writeln();
  }

  void _writeTextStylClass(StringBuffer buffer, dynamic yaml) {
    final styles = yaml["styles"];
    final weights = yaml["weights"];

    final classMap = _buildTypographyClassMap(styles);

    buffer.writeln("class TextStyl {");

    for (final styleEntry in styles.entries) {
      final styleName = styleEntry.key;
      final styleConfig = styleEntry.value;

      final base = styleConfig["base"];
      final sizes = styleConfig["sizes"];

      final sizeNames = sizes.keys.cast<String>().toList();

      final className = classMap[sizeNames.join("|")]!;

      buffer.writeln(
        "static $className $styleName(BuildContext context) {",
      );

      buffer.writeln(
        "final TextStyle? base = Theme.of(context).textTheme.$base;",
      );

      buffer.writeln("return $className(");

      for (final sizeEntry in sizes.entries) {
        final sizeName = sizeEntry.key;
        final sizeConfig = sizeEntry.value;

        final fontSize = sizeConfig["fontSize"];
        final height = sizeConfig["height"];

        buffer.writeln("$sizeName: TypographyWeight(");

        for (final weightEntry in weights.entries) {
          final weightName = weightEntry.key;
          final fontWeight = weightEntry.value;

          buffer.writeln("""
            $weightName: base?.copyWith(
              fontSize: ${fontSize.toDouble()},
              height: ${height.toDouble()},
              fontWeight: FontWeight.$fontWeight,
            ),
          """);
        }

        buffer.writeln("),");
      }

      buffer.writeln(");");
      buffer.writeln("}");
      buffer.writeln();
    }

    buffer.writeln("}");
    buffer.writeln();
  }

  void _writeSupportClasses(
    StringBuffer buffer,
    dynamic yaml,
  ) {
    final styles = yaml["styles"];
    final weights = yaml["weights"];

    final generatedClasses = <String>{};

    for (final styleEntry in styles.entries) {
      final sizes = styleEntry.value["sizes"];

      final sizeNames = sizes.keys.cast<String>().toList();

      final className = "TypographySize${sizeNames.map(_capitalize).join()}";

      if (!generatedClasses.add(className)) {
        continue;
      }

      buffer.writeln("class $className {");

      for (final sizeName in sizeNames) {
        buffer.writeln(
          "final TypographyWeight $sizeName;",
        );
      }

      buffer.writeln();

      buffer.writeln("$className({");

      for (final sizeName in sizeNames) {
        buffer.writeln(
          "required this.$sizeName,",
        );
      }

      buffer.writeln("});");

      buffer.writeln("}");
      buffer.writeln();
    }

    buffer.writeln("class TypographyWeight {");

    for (final weightName in weights.keys) {
      buffer.writeln(
        "final TextStyle? $weightName;",
      );
    }

    buffer.writeln();

    buffer.writeln("TypographyWeight({");

    for (final weightName in weights.keys) {
      buffer.writeln(
        "this.$weightName,",
      );
    }

    buffer.writeln("});");

    buffer.writeln("}");
  }

  Map<String, String> _buildTypographyClassMap(
    dynamic styles,
  ) {
    final map = <String, String>{};

    for (final styleEntry in styles.entries) {
      final sizes = styleEntry.value["sizes"];

      final sizeNames = sizes.keys.cast<String>().toList();

      final signature = sizeNames.join("|");

      map.putIfAbsent(
        signature,
        () => "TypographySize${sizeNames.map(_capitalize).join()}",
      );
    }

    return map;
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;

    return value[0].toUpperCase() + value.substring(1);
  }
}
