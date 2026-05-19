import "dart:io";

import "package:dcli/dcli.dart";
import "package:pluralize/pluralize.dart";

class Utils {
  static void makeDir(String path) {
    if (!exists(path)) {
      createDir(path, recursive: true);
    }
  }

  static Future<String> readFile(String path) async {
    return File(path).readAsString();
  }

  static void writeFile(String file, String content) {
    file.write(content);
  }

  /// Convert Hex Color To Dart [int] Color
  static String hexToColor(String code) {
    if (code.startsWith("0x")) {
      return "0x${code.substring(2, 10).toUpperCase()}";
    } else if (code.startsWith("#")) {
      return "0xFF${code.substring(1, 7).toUpperCase()}";
    }
    return "0xFF${code.toUpperCase()}";
  }

  /// Get Color in [int]
  static int getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    hexColor = hexColor.replaceAll("0X", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  /// Convert String to have first letter in caps
  static String ucFirst(String text, {bool preserveAfter = false}) {
    if (preserveAfter) {
      return text.trim()[0].toUpperCase() + text.substring(1);
    }
    return text.trim()[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Convert String to each word's first letter caps
  static String ucWords(String text) {
    return text.trim().split(" ").map((e) => ucFirst(e)).join(" ");
  }

  /// Convert String to [snake_case]
  static String snake(String text) {
    return text.split(" ").map((element) => element.toLowerCase()).join("_");
  }

  /// Convert String to [kebab-case]
  static String kebab(String text) {
    return text.trim().split(" ").map((element) => element.toLowerCase()).join("-");
  }

  /// Convert String to [snake_case]
  static String camel(String text) {
    return text.split(" ").map((element) => ucFirst(element)).join("");
  }

  /// Check if string contains provided character or word
  static String replaceAll(String text, dynamic needle) {
    return text.replaceAll(".", needle);
  }

  static Future<void> formatGeneratedCode() async {
    print(blue("Formatting Generated Code...."));
    try {
      for (final target in ["lib/app", "lib/routes", "core/lib"]) {
        final result = await Process.run("dart", ["format", target]);
        if (result.exitCode == 0) {
          print(blue(result.stdout));
        } else {
          print(red("Command failed with error code ${result.exitCode}: ${result.stderr}"));
        }
      }
    } catch (e) {
      print(red("Error running command: $e"));
    }
  }

  static String pluralize(String text) {
    final pr = Pluralize();
    return pr.plural(text);
  }

  static String singularize(String text) {
    final pr = Pluralize();
    return pr.singular(text);
  }
}
