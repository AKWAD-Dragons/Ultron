class PODO {
  String name;
  bool iterable;
  bool serializable;
  Map<String, dynamic> fields;

  PODO(
      {required this.name,
      this.iterable = false,
      this.serializable = true,
      required this.fields});
}
