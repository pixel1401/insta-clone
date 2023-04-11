import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:insta_clone/features/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:insta_clone/features/data/data_sources/remote_data_source/remote_data_source_impl.dart';
import 'package:insta_clone/features/data/repository/firebase_repository_impl.dart';
import 'package:insta_clone/features/domain/repository/firebase_repository.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/comment/create_comment_usecase.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/comment/dalete_comment_usecase.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/comment/like_comment_usecase.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/comment/read_comment_usecase.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/comment/update_comment_usecase.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/posts/create_post_usecases.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/posts/delete_post_usecases.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/posts/like_post_usecases.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/posts/read_post_usecases.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/posts/read_single_post_usecase.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/posts/update_post_usecases.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/replay/create_replay_usecases.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/replay/delete_replay_usecases.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/replay/like_replay_usecases.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/replay/read_replay_usecases.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/replay/update_replay_usecases.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/storage/delete_file_usecase_to_storage.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/storage/upload_image_usecase_to_storage.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/user/create_user_usecase.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/user/follow_unfollow_user_usecase.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/user/get_current_uid_user_usecase.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/user/get_single_other_user_usecase.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/user/get_single_user_usecase.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/user/get_users_usecase.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/user/is_sign_in_usecase.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/user/sign_in_user_usecase.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/user/sign_out_usecase.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/user/sign_up_user_usecase.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/user/update_user_usecase.dart';
import 'package:insta_clone/features/presentation/cubit/comment/comment_cubit.dart';
import 'package:insta_clone/features/presentation/cubit/post/get_single_post/get_single_post_cubit.dart';
import 'package:insta_clone/features/presentation/cubit/post/post_cubit.dart';
import 'package:insta_clone/features/presentation/cubit/replay/replay_cubit.dart';
import 'package:insta_clone/features/presentation/cubit/user/get_single_other_user/get_single_other_user_cubit.dart';
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
    () => UserCubit(updateUserUseCase: sl.call(), getUsersUseCase: sl.call() , followUnFollowUseCase: sl.call()),
  );

  sl.registerFactory(
    () => GetSingleUserCubit(getSingleUserUseCase: sl.call()),
  );

  sl.registerFactory(
    () => GetSingleOtherUserCubit(getSingleOtherUserUseCase: sl.call()),
  );


  sl.registerFactory(() => PostCubit(
      readPostsUseCase: sl.call(),
      updatePostsUseCase: sl.call(),
      deletePostsUseCase: sl.call(),
      createPostsUseCase: sl.call(),
      likePostsUseCase: sl.call()));

  sl.registerFactory(() => CommentCubit(
      readCommentsUseCase: sl.call(),
      updateCommentUseCase: sl.call(),
      deleteCommentUseCase: sl.call(),
      createCommentUseCase: sl.call(),
      likeCommentUseCase: sl.call()));

   sl.registerFactory(
        () => GetSinglePostCubit(
          readSinglePostUseCase: sl.call()
    ),
  );

  sl.registerFactory(() => ReplayCubit(
      createReplayUseCase: sl.call(),
      updateReplayUseCase: sl.call(),
      readReplaysUseCase: sl.call(),
      likeReplayUseCase: sl.call(),
      deleteReplayUseCase: sl.call()));


  // Use Cases
  sl.registerLazySingleton(() => SignOutUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => IsSignInUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => SignUpUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => SignInUserUseCase(repository: sl.call()));

  sl.registerLazySingleton(() => UpdateUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => GetCurrentUidUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => GetUsersUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => CreateUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => GetSingleUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => FollowUnFollowUseCase(repository: sl.call()));
  sl.registerLazySingleton(
      () => GetSingleOtherUserUseCase(repository: sl.call()));


  sl.registerLazySingleton(() => ReadPostsUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => CreatePostsUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => DeletePostsUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdatePostsUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => LikePostsUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadSinglePostUseCase(repository: sl.call()));

  sl.registerLazySingleton(() => ReadCommentUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteCommentUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateCommentUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => CreateCommentUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => LikeCommentUseCase(repository: sl.call()));

  sl.registerLazySingleton(() => ReadReplaysUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteReplayUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateReplayUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => CreateReplayUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => LikeReplayUseCase(repository: sl.call()));


  // COULD STORAGE
  sl.registerLazySingleton(
      () => UploadImageToStorageUseCase(repository: sl.call()));  
  sl.registerLazySingleton(() => DeleteFileToStorageUseCase(repository: sl.call()));


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
