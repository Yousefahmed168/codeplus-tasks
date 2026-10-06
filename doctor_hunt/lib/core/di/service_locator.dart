import 'package:get_it/get_it.dart';

import '../services/admin_service.dart';
import '../services/appointment_service.dart';
import '../services/auth_service.dart';
import '../services/cloudinary_service.dart';
import '../services/favorite_service.dart';
import '../services/user_service.dart';

/// Global service locator instance.
final GetIt sl = GetIt.instance;

/// Registers all application services with [sl].
/// Must be called once in [main] before [runApp].
void setupServiceLocator() {
  // Auth
  sl.registerLazySingleton<AuthService>(() => AuthService.instance);

  // User data
  sl.registerLazySingleton<UserService>(() => UserService.instance);

  // Favorites
  sl.registerLazySingleton<FavoriteService>(() => FavoriteService.instance);

  // Admin
  sl.registerLazySingleton<AdminService>(() => AdminService.instance);

  // Appointments
  sl.registerLazySingleton<AppointmentService>(() => AppointmentService.instance);

  // Cloudinary
  sl.registerLazySingleton<CloudinaryService>(() => CloudinaryService.instance);
}
