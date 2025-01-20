#! /usr/bin/env dcli

import 'dart:io';
import 'package:dcli/dcli.dart';
import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

void main(List<String> args) async {
  print('Welcome to Flutter Project Starter');

  // Prompt the user for the project name
  String projectName = args.first;
  if (projectName.isEmpty) {
    projectName = ask('Enter the name of the new Flutter project:');
  }

  final repoUrl = 'https://github.com/thedevsbuddy/flutter_fusion.git'; // Replace with your GitHub repo URL
  final destinationPath = projectName; // Replace with your desired local path

  await downloadAndExtractRepo(repoUrl, destinationPath, projectName);
}

Future<void> downloadAndExtractRepo(String repoUrl, String destinationPath, String projectName) async {
  try {
    Directory("$destinationPath/temp").createSync(recursive: true);
    // Convert GitHub URL to ZIP download URL
    final zipUrl = '${repoUrl.replaceAll('.git', '')}/archive/refs/heads/main.zip'; // FIXME: tags/<tag>.zip

    // Download the ZIP file
    print('Downloading ZIP from $zipUrl...');
    final response = await http.get(Uri.parse(zipUrl));

    if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
      print('Repository downloaded as ZIP.');

      // Write ZIP to a temporary file
      final zipFile = File('$destinationPath/temp/repo.zip');
      await zipFile.writeAsBytes(response.bodyBytes);

      // Validate and extract the ZIP file
      try {
        final archive = ZipDecoder().decodeBytes(zipFile.readAsBytesSync());
        print('ZIP file is valid.');

        // Extract ZIP contents, stripping the root directory
        final rootDir = archive.firstWhere((file) => file.isFile).name.split('/')[0];
        print('Root directory found: $rootDir');

        for (var file in archive) {
          // Remove the root directory prefix
          final filePath = file.name.startsWith(rootDir) ? file.name.substring(rootDir.length + 1) : file.name;

          if (filePath.isEmpty) continue; // Skip the root directory itself

          final targetPath = '$destinationPath/temp/$filePath';
          if (file.isFile) {
            File(targetPath)
              ..createSync(recursive: true)
              ..writeAsBytesSync(file.content as List<int>);
          } else {
            Directory(targetPath).createSync(recursive: true);
          }
        }

        print('Repository extracted to $destinationPath without wrapping directory.');
      } catch (e) {
        throw Exception('Invalid ZIP file: $e');
      } finally {
        final projectDir = Directory(projectName);
        final fromTemp = Directory("$destinationPath/temp");
        await copyDirectory(fromTemp, projectDir, projectName);
        fromTemp.deleteSync(recursive: true);
        // zipFile.deleteSync();
      }
    } else {
      throw Exception('Failed to download ZIP: ${response.statusCode}');
    }
  } catch (e) {
    print('An error occurred: $e');
  }
}

// Copy method
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

        // Define placeholders and their replacements
        final replacements = {
          'flutter_fusion': projectName,
          'Flutter Fusion': projectName.replaceAll('_', ' ').toUpperCase(), // FIXME: Update it to use the title case
        };
        for (var entry in replacements.entries) {
          content = content.replaceAll(entry.key, entry.value);
        }
        await File(newPath).writeAsString(content);
      } else {
        entity.copySync(newPath);
      }
    }
  }
}
