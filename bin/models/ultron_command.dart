class UltronCommand {
  String? name;
  int? optionsCount;
  List<String>? arguments;
  String? type;
  Function? action;

  UltronCommand(
      {this.name, this.optionsCount, this.arguments, this.type, this.action});
}
