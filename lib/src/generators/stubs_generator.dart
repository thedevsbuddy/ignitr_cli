import 'dart:io';

import 'package:archive/archive.dart';
import 'package:dcli/dcli.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import 'base_generator.dart';

class StubsGenerator extends BaseGenerator {
  StubsGenerator(super.args);

  Future<void> generate() async {
    await _downloadStubs();
  }

  Future<void> _downloadStubs() async {
    try {
      String stubsTempPath = '$projectPath/.ignitr/stubs/temp';
      Directory(stubsTempPath).createSync(recursive: true);
      // Download the ZIP file
      final response = await http.get(Uri.parse(args.stubsUrl!));

      if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
        // Write ZIP to a temporary file
        final stubArchiveFile = File('$stubsTempPath/stubs.zip');
        await stubArchiveFile.writeAsBytes(response.bodyBytes);

        // Validate and extract the ZIP file
        try {
          final archive = ZipDecoder().decodeBytes(stubArchiveFile.readAsBytesSync());

          // Extract ZIP contents, stripping the root directory
          final rootDir = archive.firstWhere((file) => file.isFile).name.split('/')[0];

          for (ArchiveFile file in archive) {
            // Remove the root directory prefix
            final filePath = file.name.startsWith(rootDir) ? file.name.substring(rootDir.length + 1) : file.name;

            if (filePath.isEmpty) continue; // Skip the root directory itself

            final targetPath = '$stubsTempPath/$filePath';
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
          final stubsDir = Directory("$projectPath/.ignitr/stubs");
          final fromTemp = Directory(stubsTempPath);
          await _copyDownloadedStubs(fromTemp, stubsDir);
          await Future.delayed(Duration(milliseconds: 1500), () => fromTemp.deleteSync(recursive: true));
          print(green('Project created successfully!'));
          print(blue('Create something awesome!'));
        }
      } else {
        throw Exception('Failed to download ZIP: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> _copyDownloadedStubs(Directory source, Directory destination) async {
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
        await _copyDownloadedStubs(entity, Directory(newPath));
      } else if (entity is File) {
        if (entity.path.endsWith('.zip')) {
          continue;
        }
        entity.copySync(newPath);
      }
    }
  }
}
