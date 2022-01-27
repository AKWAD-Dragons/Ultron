import 'dart:io';
import 'package:args/args.dart';
import 'package:collection/collection.dart';
import 'package:recase/recase.dart';
import 'core/console.dart';
import 'core/resources/constants.dart';
import 'core/services/general_service.dart';
import 'core/services/podo_service.dart';
import 'core/services/service.dart';
import 'core/stubs/podo_stub.dart';
import 'core/stubs/podo_exports_stub.dart';
import 'core/utils/di.dart';
import 'menu.dart';
import 'models/podo.dart';
import 'models/ultron_command.dart';

final ArgParser _argParser = ArgParser();

List<UltronCommand> _availableCommands = [
  UltronCommand(
      name: 'podo',
      optionsCount: 1,
      arguments: ['-h', '-f'],
      type: 'make',
      action: _makePODO),
];

Future<void> main(List<String> arguments) async {
  DependencyInjector.registerAll();

  final List<String> args = List.from(arguments);
  if (args.isEmpty) {
    UltronConsole.writeInRed(ultronMenu);
    return;
  }

  if (args.contains('-v')) {
    UltronConsole.writeInBlack(GeneralService().fetchVersion());
    return;
  }

  List<String> argumentSplit = args[0].split(":");

  if (argumentSplit.isEmpty || argumentSplit.length <= 1) {
    UltronConsole.writeInBlack('Invalid arguments ' + args.toString());
    exit(2);
  }

  String type = argumentSplit[0];
  String action = argumentSplit[1];

  UltronCommand? ultronCommand = _availableCommands.firstWhereOrNull(
      (command) => type == command.type && command.name == action);

  if (ultronCommand == null) {
    UltronConsole.writeInBlack('Invalid arguments ' + args.toString());
    exit(1);
  }

  args.removeAt(0);
  await ultronCommand.action!(args);
}

Future<void> _makePODO(List<String> arguments) async {
  PodoService podoService = DependencyInjector.get<PodoService>();

  _argParser.addFlag(helpFlag,
      abbr: 'h',
      help: 'Creates a new model in your project.',
      negatable: false);
  _argParser.addFlag(forceFlag,
      abbr: 'f',
      help: 'Creates a new model even if it already exists.',
      negatable: false);

  final ArgResults argResults = _argParser.parse(arguments);

  _checkArguments(argResults.arguments, _argParser.usage);

  bool? hasForceFlag = argResults[forceFlag];

  _checkHelpFlag(argResults[helpFlag], _argParser.usage);

  List<PODO> availablePodos =
      await podoService.readParamsFromYaml(path: podoManifestPath);

  for (PODO podo in availablePodos) {
    await podoService.makeSinglePODO(
        podo: podo, hasForceFlag: hasForceFlag ?? false);
  }
  await podoService.exportPODODependencies(
      dependencies: podoService.listPodoFileNames(availablePodos));
  await podoService.createPODOGeneratedFiles();
}

void _checkArguments(List<String> arguments, String usage) {
  if (arguments.isEmpty) {
    UltronConsole.writeInBlack(usage);
    exit(1);
  }
}

void _checkHelpFlag(bool hasHelpFlag, String usage) {
  if (hasHelpFlag) {
    UltronConsole.writeInBlack(usage);
    exit(0);
  }
}
