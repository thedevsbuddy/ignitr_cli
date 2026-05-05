import 'dart:io';

import 'package:archive/archive.dart';
import 'package:dcli/dcli.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import 'base_generator.dart';

class ProjectGenerator extends BaseGenerator {
  ProjectGenerator(super.args);

  Future<void> generate() async {
    print(blue('Creating project: ${projectName.snakeCase}'));
    await _downloadProjectTemplate();
  }

  Future<void> _downloadProjectTemplate() async {
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
          final archive =
              ZipDecoder().decodeBytes(templateFile.readAsBytesSync());

          // Extract ZIP contents, stripping the root directory
          final rootDir =
              archive.firstWhere((file) => file.isFile).name.split('/')[0];

          for (ArchiveFile file in archive) {
            // Remove the root directory prefix
            final filePath = file.name.startsWith(rootDir)
                ? file.name.substring(rootDir.length + 1)
                : file.name;

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
          await _copyGeneratedProject(fromTemp, projectDir);
          await Future.delayed(
              Duration(seconds: 1), () => fromTemp.deleteSync(recursive: true));
        }
      } else {
        throw Exception('Failed to download ZIP: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> _copyGeneratedProject(
      Directory source, Directory destination) async {
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
        await _copyGeneratedProject(entity, Directory(newPath));
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

          for (var entry in nameReplacements.entries) {
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
