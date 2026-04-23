import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/auth_usecases.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

import 'features/control/data/datasources/device_remote_data_source.dart';
import 'features/control/data/repositories/device_repository_impl.dart';
import 'features/control/domain/repositories/device_repository.dart';
import 'features/control/domain/usecases/execute_command.dart';
import 'features/control/domain/usecases/get_system_info.dart';
import 'features/control/domain/usecases/listen_to_system_stream.dart';
import 'features/control/domain/usecases/pair_device.dart';
import 'features/control/presentation/bloc/control_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // --- Auth Features ---
  
  sl.registerFactory(() => AuthBloc(
        loginWithEmailAndPassword: sl(),
        signUpWithEmailAndPassword: sl(),
        logout: sl(),
        getUserStream: sl(),
      ));

  sl.registerLazySingleton(() => LoginWithEmailAndPassword(sl()));
  sl.registerLazySingleton(() => SignUpWithEmailAndPassword(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => GetUserStream(sl()));

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl()
    ),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
    ),
  );

  sl.registerLazySingleton(() => FirebaseAuth.instance);


  // --- Control Features ---
  
  sl.registerFactory(
    () => ControlBloc(
      pairDevice: sl(),
      getSystemInfo: sl(),
      executeCommand: sl(),
      listenToSystemStream: sl(),
      disconnectSocket: sl(),
    ),
  );

  sl.registerLazySingleton(() => PairDevice(sl()));
  sl.registerLazySingleton(() => GetSystemInfo(sl()));
  sl.registerLazySingleton(() => ExecuteCommand(sl()));
  sl.registerLazySingleton(() => ListenToSystemStream(sl()));
  sl.registerLazySingleton(() => DisconnectSocket(sl()));

  sl.registerLazySingleton<DeviceRepository>(
    () => DeviceRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
    
  );

  sl.registerLazySingleton<DeviceRemoteDataSource>(
    () => DeviceRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton(() => Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      ));
}
