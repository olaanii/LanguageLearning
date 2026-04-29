abstract class Mapper<Model, Entity> {
  Entity toEntity(Model model);
  Model fromEntity(Entity entity);
}
