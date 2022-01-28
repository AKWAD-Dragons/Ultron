import 'package:recase/recase.dart';

import '../console.dart';
import '../resources/constants.dart';
import '../stubs/bloc/bloc_stub.dart';
import '../stubs/bloc/event_stub.dart';
import '../stubs/bloc/exports_stub.dart';
import '../stubs/bloc/state_stub.dart';
import 'service.dart';

class BlocService extends UltronService {
  /// Creates a new PODO.
  Future<void> makeSingleBloc(
      {required className, bool hasForceFlag = false}) async {
    ReCase rc = ReCase(className);
    String blocName = rc.pascalCase;

    String blocStubValue = blocStub(blocName);
    String blocExportsStubValue = blocExportsStub(blocName);
    String blocEventStubValue = blocEventStub(blocName);
    String blocStateStubValue = blocStateStub(blocName);

    await _createBlocEventFile(className, blocEventStubValue,
        forceCreate: hasForceFlag);
    await _createBlocStateFile(className, blocStateStubValue,
        forceCreate: hasForceFlag);
    await _createBlocExportsFile(className, blocExportsStubValue,
        forceCreate: hasForceFlag);
    await _createBlocFile(className, blocStubValue, forceCreate: hasForceFlag);
    _printTailStatement(blocName);
  }

  Future<void> _createBlocEventFile(String className, String value,
      {String folderPath = blocFolder, bool forceCreate = false}) async {
    String blocDirPath = folderPath;
    String namedBlocDirPath = '$folderPath/$className';
    String filePath = '$namedBlocDirPath/${className.toLowerCase()}_event.dart';

    await _createFile(
        parentDir: blocDirPath,
        blocDir: namedBlocDirPath,
        filePath: filePath,
        fileContent: value,
        forceCreate: forceCreate);
    _printCreatedStatement('${className}_event');
  }

  Future<void> _createBlocStateFile(String className, String value,
      {String folderPath = blocFolder, bool forceCreate = false}) async {
    String blocDirPath = folderPath;
    String namedBlocDirPath = '$folderPath/$className';
    String filePath = '$namedBlocDirPath/${className.toLowerCase()}_state.dart';

    await _createFile(
        parentDir: blocDirPath,
        blocDir: namedBlocDirPath,
        filePath: filePath,
        fileContent: value,
        forceCreate: forceCreate);
    _printCreatedStatement('${className}_state');
  }

  Future<void> _createBlocExportsFile(String className, String value,
      {String folderPath = blocFolder, bool forceCreate = false}) async {
    String blocDirPath = folderPath;
    String namedBlocDirPath = '$folderPath/$className';
    String filePath = '$namedBlocDirPath/exports.dart';

    await _createFile(
        parentDir: blocDirPath,
        blocDir: namedBlocDirPath,
        filePath: filePath,
        fileContent: value,
        forceCreate: forceCreate);
    _printCreatedStatement('exports');
  }

  Future<void> _createBlocFile(String className, String value,
      {String folderPath = blocFolder, bool forceCreate = false}) async {
    String blocDirPath = folderPath;
    String namedBlocDirPath = '$folderPath/$className';
    String filePath = '$namedBlocDirPath/${className.toLowerCase()}_bloc.dart';

    await _createFile(
        parentDir: blocDirPath,
        blocDir: namedBlocDirPath,
        filePath: filePath,
        fileContent: value,
        forceCreate: forceCreate);
    _printCreatedStatement('${className}_bloc');
  }

  Future<void> _createFile(
      {required String parentDir,
      required String blocDir,
      required String filePath,
      required String fileContent,
      bool forceCreate = false}) async {
    await makeDirectory(parentDir);
    await makeDirectory(blocDir);
    await checkIfFileExists(filePath, shouldForceCreate: forceCreate);
    await createNewFile(filePath, fileContent);
  }

  void _printCreatedStatement(String className) {
    UltronConsole.writeInGreen(
        'CREATED ' + className.toLowerCase() + '.dart \x1B[92m[√]\x1B[0m\n');
  }

  void _printTailStatement(String className) {
    UltronConsole.writeInGreen(largeLineSeparator);
    UltronConsole.writeInGreen('$className BLoC SUCCESSFULLY CREATED!');
    UltronConsole.writeInGreen('MAY THE LOGIC BE IN YOUR FAVOR <3');
    UltronConsole.writeInGreen(largeLineSeparator);
  }
}
