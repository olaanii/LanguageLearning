import '../utils/result.dart';

abstract class UseCase<Output, Params> {
  Future<Result<Output>> call(Params params);
}

class NoParams {
  const NoParams();
}
