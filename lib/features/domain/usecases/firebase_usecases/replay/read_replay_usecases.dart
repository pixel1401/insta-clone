
import 'package:insta_clone/features/domain/replay/replay_entity.dart';
import 'package:insta_clone/features/domain/repository/firebase_repository.dart';

class ReadReplaysUseCase {
  final FirebaseRepository repository;

  ReadReplaysUseCase({required this.repository});

  Stream<List<ReplayEntity>> call(ReplayEntity replay) {
    return repository.readReplays(replay);
  }
}