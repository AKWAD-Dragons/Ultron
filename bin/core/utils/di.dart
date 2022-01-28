import 'package:get_it/get_it.dart';

import '../services/bloc_service.dart';
import '../services/general_service.dart';
import '../services/podo_service.dart';
import '../services/service.dart';
import '../services/widget_service.dart';

class DependencyInjector {
  static void registerAll() {
    GetIt.instance
        .registerLazySingleton<GeneralService>(() => GeneralService());
    GetIt.instance.registerLazySingleton<PodoService>(() => PodoService());
    GetIt.instance.registerLazySingleton<BlocService>(() => BlocService());
    GetIt.instance.registerLazySingleton<WidgetService>(() => WidgetService());
  }

  static T get<T extends UltronService>() {
    return GetIt.instance<T>();
  }
}
