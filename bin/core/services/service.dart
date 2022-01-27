import 'dart:io';
import '../../models/podo.dart';
import '../resources/constants.dart';
import '../console.dart';
import "package:yaml/yaml.dart";

abstract class UltronService {
  /// Check if a file exist by passing in a [path].
  Future<bool> hasFile(path) async {
    return await File(path).exists();
  }

  /// Creates a new file from a [path] and [value].
  Future<void> createNewFile(String path, String value) async {
    final File file = File(path);
    await file.writeAsString(value);
  }

  /// Creates a new directory from a [path] if it doesn't exist.
  Future<void> makeDirectory(String path) async {
    Directory directory = Directory(path);
    if (!(await directory.exists())) {
      await directory.create();
    }
  }

  /// Checks if a file exists from a [path].
  /// Use [shouldForceCreate] to override check.
  Future<void> checkIfFileExists(path, {bool shouldForceCreate = false}) async {
    if (await File(path).exists() && shouldForceCreate == false) {
      UltronConsole.writeInRed('$path already exists');
      exit(1);
    }
  }

  /// Capitalize a String value.
  /// Accepts an [input] and returns a [String].
  String capitalize(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }
}
