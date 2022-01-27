import 'dart:io';

import 'service.dart';

class GeneralService extends UltronService {
  String fetchVersion() {
    String versionText = '\x1B[92m[√]\x1B[0m Ultron v0.0.1';
    String versionParams =
        ' (Channel dev, on ${Platform.operatingSystem}, locale ${Platform.localeName})';
    return versionText + versionParams;
  }
}
