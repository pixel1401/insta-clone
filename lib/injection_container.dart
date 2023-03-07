import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:insta_clone/features/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:insta_clone/features/data/data_sources/remote_data_source/remote_data_source_impl.dart';
import 'package:insta_clone/features/data/repository/firebase_repository_impl.dart';
import 'package:insta_clone/features/domain/repository/firebase_repository.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/storage/upload_image_usecase_to_storage.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/user/create_user_usecase.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/user/get_current_uid_user_usecase.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/user/get_single_user_usecase.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/user/get_users_usecase.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/user/is_sign_in_usecase.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/user/sign_in_user_usecase.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/user/sign_out_usecase.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/user/sign_up_user_usecase.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/user/update_user_usecase.dart';
import 'package:insta_clone/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';

import 'features/presentation/cubit/auth/auth_cubit.dart';
import 'features/presentation/cubit/credential/credential_cubit.dart';
import 'features/presentation/cubit/user/user_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Cubits
  sl.registerFactory(
    () => AuthCubit(
      signOutUseCase: sl.call(),
      isSignInUseCase: sl.call(),
      getCurrentUidUseCase: sl.call(),
    ),
  );

  sl.registerFactory(
    () => CredentialCubit(
      signUpUseCase: sl.call(),
      signInUserUseCase: sl.call(),
    ),
  );

  sl.registerFactory(
    () => UserCubit(updateUserUseCase: sl.call(), getUsersUseCase: sl.call()),
  );

  sl.registerFactory(
    () => GetSingleUserCubit(getSingleUserUseCase: sl.call()),
  );

  // Use Cases
  sl.registerLazySingleton(() => SignOutUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => IsSignInUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => GetCurrentUidUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => SignUpUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => SignInUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => GetUsersUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => CreateUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => GetSingleUserUseCase(repository: sl.call()));

  // COULD STORAGE
  sl.registerLazySingleton(
      () => UploadImageToStorageUseCase(repository: sl.call()));

  // Repository

  sl.registerLazySingleton<FirebaseRepository>(
      () => FirebaseRepositoryImpl(remoteDataSource: sl.call()));

  // Remote Data Source
  sl.registerLazySingleton<FirebaseRemoteDataSource>(() =>
      FirebaseRemoteDataSourceImpl(
          firebaseFirestore: sl.call(),
          firebaseAuth: sl.call(),
          firebaseStorage: sl.call()));

  // Externals

  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseStorage = FirebaseStorage.instance;

  sl.registerLazySingleton(() => firebaseFirestore);
  sl.registerLazySingleton(() => firebaseAuth);
  sl.registerLazySingleton(() => firebaseStorage);
}
