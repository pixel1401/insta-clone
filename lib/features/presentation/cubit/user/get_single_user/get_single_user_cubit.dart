import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:insta_clone/features/domain/entities/user/user_entity.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/user/get_single_user_usecase.dart';

part 'get_single_user_state.dart';

class GetSingleUserCubit extends Cubit<GetSingleUserState> {
  final GetSingleUserUseCase getSingleUserUseCase;
  GetSingleUserCubit({required this.getSingleUserUseCase}) : super(GetSingleUserInitial(null));

  Future<void> getSingleUser({required String uid}) async {
    emit(GetSingleUserLoading(null));
    try {
      final streamResponse = getSingleUserUseCase.call(uid);
      streamResponse.listen((user) {
        emit(GetSingleUserLoaded(user: user[0]));
      });
    } on SocketException catch (_) {
      emit(GetSingleUserFailure(null));
    } catch (_) {
      emit(GetSingleUserFailure(null));
    }
  }

}
