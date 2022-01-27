import '../resources/constants.dart';
import 'service.dart';

class WidgetService extends UltronService {
  /// Creates a new Stateless Widget.
  Future<void> makeStatelessWidget(String className, String value,
      {String folderPath = uiFolder, bool forceCreate = false}) async {
    String filePath = '$folderPath/${className.toLowerCase()}_widget.dart';

    await makeDirectory(folderPath);
    await checkIfFileExists(filePath, shouldForceCreate: forceCreate);
    await createNewFile(filePath, value);
  }

  /// Creates a new Stateful Widget.
  Future<void> makeStatefulWidgetFile(String className, String value,
      {String folderPath = uiFolder, bool forceCreate = false}) async {
    String filePath = '$folderPath/${className.toLowerCase()}_widget.dart';

    await makeDirectory(folderPath);
    await checkIfFileExists(filePath, shouldForceCreate: forceCreate);
    await createNewFile(filePath, value);
  }
}
