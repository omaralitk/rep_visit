
import 'package:get_it/get_it.dart';

import '../network/http_client.dart';

final getIt = GetIt.instance;

class ServiceLocator {
  setup() {
    /// http client
    getIt.registerLazySingleton<HttpClient>(() => HttpClient());

    // ///login
    // getIt.registerLazySingleton<BaseLoginData>(() => LoginDataImpl(getIt()));
    // getIt.registerLazySingleton<BaseLoginRepo>(() => LoginRepoImpl(getIt()));
  }
}