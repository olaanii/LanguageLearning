import '../../../../../core/usecase/mapper.dart';
import '../../domain/domain.dart';
import '../models/user_model.dart';

class UserMapper implements Mapper<UserModel, UserEntity> {
  @override
  UserEntity toEntity(UserModel model) {
    return UserEntity(
      id: model.id,
      email: model.email,
      name: model.name,
      avatar: model.avatar,
      score: model.score,
      level: model.level,
      progress: model.progress,
    );
  }

  @override
  UserModel fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      avatar: entity.avatar,
      score: entity.score,
      level: entity.level,
      progress: entity.progress,
    );
  }
}
