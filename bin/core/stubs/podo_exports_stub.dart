String podoExportsStub({required List<String> dependencies}) {
  return _buildExports(dependencies);
}

String _buildExports(List<String> dependencies) {
  final StringBuffer exportsBuffer = StringBuffer();
  for (String dependency in dependencies) {
    exportsBuffer.writeln('export \'$dependency\';');
  }

  return exportsBuffer.toString();
}
