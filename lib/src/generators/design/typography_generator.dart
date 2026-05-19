import "dart:io";

import "../../utilities/utils.dart";
import "../base_generator.dart";
import "package:yaml/yaml.dart";

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
    _writeSupportClasses(buffer);

    Utils.writeFile(outputPath, buffer.toString());
  }

  void _writeHeader(StringBuffer buffer) {
    buffer.writeln("// GENERATED CODE - DO NOT MODIFY BY HAND");
    buffer.writeln();
    buffer.writeln("part of \"package:core/core.dart\";");
    buffer.writeln();
  }

  void _writeTextStylClass(StringBuffer buffer, dynamic yaml) {
    final styles = yaml["styles"];
    final weights = yaml["weights"];

    buffer.writeln("class TextStyl {");

    for (final styleEntry in styles.entries) {
      final styleName = styleEntry.key;
      final styleConfig = styleEntry.value;

      final base = styleConfig["base"];
      final sizes = styleConfig["sizes"];

      buffer.writeln(
        "static Typography $styleName(BuildContext context) {",
      );

      buffer.writeln(
        "TextStyle? base = Theme.of(context).textTheme.$base;",
      );

      buffer.writeln("return Typography(");

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
    }

    buffer.writeln("}");
  }

  void _writeSupportClasses(StringBuffer buffer) {
    buffer.writeln("""
      class Typography {
        final TypographyWeight xs;
        final TypographyWeight sm;
        final TypographyWeight md;
        final TypographyWeight lg;
        final TypographyWeight xl;

        Typography({
          required this.xs,
          required this.sm,
          required this.md,
          required this.lg,
          required this.xl,
        });
      }

      class TypographyWeight {
        final TextStyle? regular;
        final TextStyle? medium;
        final TextStyle? semibold;
        final TextStyle? bold;

        TypographyWeight({
          this.regular,
          this.medium,
          this.semibold,
          this.bold,
        });
      }
    """);
  }
}
