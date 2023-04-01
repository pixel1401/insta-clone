
import 'package:insta_clone/features/domain/replay/replay_entity.dart';
import 'package:insta_clone/features/domain/repository/firebase_repository.dart';

class DeleteReplayUseCase {
  final FirebaseRepository repository;

  DeleteReplayUseCase({required this.repository});

  Future<void> call(ReplayEntity replay) {
    return repository.deleteReplay(replay);
  }
}