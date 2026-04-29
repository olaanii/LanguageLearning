import '../../../../../core/usecase/mapper.dart';
import '../../domain/entities/lesson_entity.dart';
import '../models/lesson_model.dart';

class LessonMapper implements Mapper<LessonModel, LessonEntity> {
  @override
  LessonEntity toEntity(LessonModel model) {
    return LessonEntity(
      id: model.id,
      lessonPrefix: model.lessonPrefix,
      title: model.title,
      description: model.description,
      category: model.category,
      difficulty: model.difficulty,
      locked: model.locked,
      progress: model.progress,
      totalItems: model.totalItems,
      image: model.image,
      colorBg: model.colorBg,
    );
  }

  @override
  LessonModel fromEntity(LessonEntity entity) {
    return LessonModel(
      id: entity.id,
      lessonPrefix: entity.lessonPrefix,
      title: entity.title,
      description: entity.description,
      category: entity.category,
      difficulty: entity.difficulty,
      locked: entity.locked,
      progress: entity.progress,
      totalItems: entity.totalItems,
      image: entity.image,
      colorBg: entity.colorBg,
    );
  }
}
