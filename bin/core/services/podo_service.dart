import 'dart:io';
import 'package:recase/recase.dart';
import 'package:yaml/yaml.dart';
import '../../models/podo.dart';
import '../console.dart';
import '../resources/constants.dart';
import '../stubs/podo/exports_stub.dart';
import '../stubs/podo/podo_stub.dart';
import 'service.dart';

class PodoService extends UltronService {
  /// Creates a new PODO.
  Future<void> makeSinglePODO(
      {required PODO podo, bool hasForceFlag = false}) async {
    ReCase rc = ReCase(podo.name);
    String modelName = rc.pascalCase;

    String stubPodo = podoStub(
        modelName: modelName,
        fields: podo.fields,
        iterable: podo.iterable,
        serializable: podo.serializable);

    await _createPODOFile(podo.name, stubPodo, forceCreate: hasForceFlag);

    UltronConsole.writeInGreen('CREATED ' + modelName.toLowerCase() + '.dart');
    UltronConsole.writeInBlack(smallLineSeparator);
  }

  Future<void> _createPODOFile(String className, String value,
      {String folderPath = podoFolder, bool forceCreate = false}) async {
    String filePath = '$folderPath/${className.toLowerCase()}.dart';

    await makeDirectory(folderPath);
    await checkIfFileExists(filePath, shouldForceCreate: forceCreate);
    await createNewFile(filePath, value);
  }

  List<String> listPodoFileNames(List<PODO> podos) {
    final List<String> fileNames = [];

    for (PODO podo in podos) {
      fileNames.add('${podo.name.toLowerCase()}.dart');
    }

    return fileNames;
  }

  Future<void> exportPODODependencies(
      {required List<String> dependencies}) async {
    String stubPodoExport = podoExportsStub(dependencies: dependencies);
    await _makePODOExportsFile(stubPodoExport);
  }

  Future<void> createPODOGeneratedFiles() async {
    UltronConsole.writeInGreen('UPDATED exports.dart \x1B[92m[√]\x1B[0m\n');
    UltronConsole.writeInGreen('STARTED GENERATING SERIALIZATION FILES....\n');
    final ProcessResult processResult = await _runPODOGeneratedFileCommand();
    if (processResult.exitCode == 0) {
      _printSuccess();
      return;
    }
    _printFailure(processResult.stdout);
  }

  Future<void> _makePODOExportsFile(String value,
      {String folderPath = podoFolder, bool forceCreate = false}) async {
    String filePath = '$folderPath/exports.dart';

    await makeDirectory(folderPath);
    await checkIfFileExists(filePath, shouldForceCreate: true);
    await createNewFile(filePath, value);
  }

  /// Reads a class fields and functions from target YAML file
  Future<List<PODO>> readParamsFromYaml({required String path}) async {
    final String data = await File(path).readAsString();
    final YamlList yamlList = loadYaml(data)[podoKey];
    final List<PODO> outputPodos = _parseYamlPODO(yamlList.value);

    return outputPodos;
  }

  Future<ProcessResult> _runPODOGeneratedFileCommand() async {
    ProcessResult processResult = await Process.run('flutter',
        ['pub', 'run', 'build_runner', 'build', '--delete-conflicting-outputs'],
        runInShell: true);
    return processResult;
  }

  List<PODO> _parseYamlPODO(List<dynamic> yamlList) {
    final List<YamlMap> podos = yamlList.cast<YamlMap>();

    final List<PODO> parsedPodos = [];

    for (YamlMap podo in podos) {
      final Map<String, YamlMap> podoMap = podo.cast<String, YamlMap>();

      _checkValidYaml(podoMap);

      PODO mPodo = PODO(
        name: podoMap.keys.first,
        iterable: podoMap.values.first[iterableKey] ?? false,
        serializable: podoMap.values.first[serializableKey] ?? true,
        fields: (podoMap.values.first[fieldsKey] as YamlMap)
            .cast<String, dynamic>(),
      );
      parsedPodos.add(mPodo);
    }
    return parsedPodos;
  }

  _checkValidYaml(Map<String, YamlMap> yamlMap) {
    final bool iterable = yamlMap.values.first[iterableKey] ?? false;
    final bool serializable = yamlMap.values.first[serializableKey] ?? true;

    if (yamlMap.values.first[fieldsKey] == null) {
      _printErrorMessage(
          message: 'FAILED WHILE PARSING PODO YAML INPUT',
          reason: 'Class fields are missing',
          explanation:
              'I CANNOT construct a data class without data. COULD YOU? :(');
      exit(1);
    }

    if (iterable && !serializable) {
      _printErrorMessage(
          message: 'FAILED WHILE PARSING PODO YAML INPUT',
          reason:
              '{iterable} cannot equal true while {serializable} equals false',
          explanation:
              'Only serializable objects can be parsed as iterables. MAKE SENSE, DUDE? -_-');
      exit(1);
    }
  }

  void _printErrorMessage(
      {required String message,
      required String reason,
      required String explanation}) {
    UltronConsole.writeInRed(largeLineSeparator);
    UltronConsole.writeInRed(message);
    UltronConsole.writeInRed('REASON: $reason');
    UltronConsole.writeInRed('EXPLANATION: $explanation');
    UltronConsole.writeInRed(largeLineSeparator);
  }

  void _printSuccess() {
    UltronConsole.writeInGreen(
        'GENERATED SERIALIZATION FILES \x1B[92m[√]\x1B[0m\n');
    UltronConsole.writeInGreen(largeLineSeparator);
    UltronConsole.writeInGreen('COMPLETED ALL PODOs!');
    UltronConsole.writeInGreen(largeLineSeparator);
  }

  void _printFailure(dynamic failureResult) {
    UltronConsole.writeInRed(failureResult);
    UltronConsole.writeInRed(largeLineSeparator);
    UltronConsole.writeInRed('ERROR WHILE GENERATING SERIALIZATION FILES');
    UltronConsole.writeInRed(largeLineSeparator);
  }
}
