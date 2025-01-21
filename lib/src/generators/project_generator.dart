import 'dart:io';

import 'package:archive/archive.dart';
import 'package:dcli/dcli.dart';
import 'package:path/path.dart';
import 'package:recase/recase.dart';
import 'package:http/http.dart' as http;

import '../ignitr.config.dart';
import 'base_generator.dart';

class ProjectGenerator extends BaseGenerator {
  ReCase projectName = ReCase("");
  String templateUrl = "";
  String projectTempPath = "";
  String projectPath = "";
  String projectVersion = "";

  Map<String, String> _replacements = {};

  ProjectGenerator(super.args) {
    projectName = ReCase(args.project ?? "");
    projectPath = projectName.snakeCase;
    projectTempPath = join(projectPath, "temp");
    projectVersion = args.projectVersion == null
        ? "heads/${Config.projectTemplateVersion}"
        : args.projectVersion == "latest"
            ? "heads/${Config.projectTemplateVersion}"
            : "tags/${args.projectVersion}";

    templateUrl = "${Config.projectTemplateUrl}/$projectVersion.zip";

    _replacements = {
      'com.devsbuddy.ignitr_template': "com.devsbuddy.${projectName.snakeCase}",
      'ignitr_template': projectName.snakeCase, // FIXME: Update the template files to use the ignitr_template
      'Ignitr': projectName.titleCase, // FIXME: Update the template files to use the Ignitr Template
    };
  }

  Future<void> generate() async {
    print(blue('Creating project: ${projectName.snakeCase}'));
    await _downloadAndExtractRepo();
  }

  Future<void> _downloadAndExtractRepo() async {
    try {
      Directory(projectTempPath).createSync(recursive: true);
      // Download the ZIP file
      final response = await http.get(Uri.parse(templateUrl));

      if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
        // Write ZIP to a temporary file
        final templateFile = File('$projectTempPath/repo.zip');
        await templateFile.writeAsBytes(response.bodyBytes);

        // Validate and extract the ZIP file
        try {
          final archive = ZipDecoder().decodeBytes(templateFile.readAsBytesSync());

          // Extract ZIP contents, stripping the root directory
          final rootDir = archive.firstWhere((file) => file.isFile).name.split('/')[0];

          for (ArchiveFile file in archive) {
            // Remove the root directory prefix
            final filePath = file.name.startsWith(rootDir) ? file.name.substring(rootDir.length + 1) : file.name;

            if (filePath.isEmpty) continue; // Skip the root directory itself

            final targetPath = '$projectTempPath/$filePath';
            if (file.isFile) {
              File(targetPath)
                ..createSync(recursive: true)
                ..writeAsBytesSync(file.content as List<int>);
            } else {
              Directory(targetPath).createSync(recursive: true);
            }
          }
        } catch (e) {
          throw Exception('Invalid ZIP file: $e');
        } finally {
          final projectDir = Directory(projectPath);
          final fromTemp = Directory(projectTempPath);
          await copyDirectory(fromTemp, projectDir, projectName.snakeCase);
          fromTemp.deleteSync(recursive: true);
          print(green('Project created successfully!'));
          print(blue('Create something awesome!'));
          // zipFile.deleteSync();
        }
      } else {
        throw Exception('Failed to download ZIP: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> copyDirectory(Directory source, Directory destination, String projectName) async {
    if (!source.existsSync()) {
      throw Exception('Source directory does not exist: ${source.path}');
    }

    // Create the destination directory if it doesn't exist
    if (!destination.existsSync()) {
      destination.createSync(recursive: true);
    }

    // Iterate through the contents of the source directory
    for (var entity in source.listSync(recursive: false)) {
      final newPath = join(destination.path, basename(entity.path));

      if (entity is Directory) {
        // Recursively copy subdirectory
        await copyDirectory(entity, Directory(newPath), projectName);
      } else if (entity is File) {
        if (entity.path.endsWith('.zip')) {
          continue;
        }

        if (entity.path.endsWith('.dart') ||
            entity.path.endsWith('.yml') ||
            entity.path.endsWith('.yaml') ||
            entity.path.endsWith('.xml') ||
            entity.path.endsWith('.kt') ||
            entity.path.endsWith('.plist') ||
            entity.path.endsWith('.gradle')) {
          String content = await entity.readAsString();

          for (var entry in _replacements.entries) {
            content = content.replaceAll(entry.key, entry.value);
          }
          await File(newPath).writeAsString(content);
        } else {
          entity.copySync(newPath);
        }
      }
    }
  }
}
