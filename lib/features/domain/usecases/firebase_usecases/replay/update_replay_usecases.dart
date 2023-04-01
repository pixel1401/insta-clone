
import 'package:insta_clone/features/domain/replay/replay_entity.dart';
import 'package:insta_clone/features/domain/repository/firebase_repository.dart';

class UpdateReplayUseCase {
  final FirebaseRepository repository;

  UpdateReplayUseCase({required this.repository});

  Future<void> call(ReplayEntity replay) {
    return repository.updateReplay(replay);
  }
}