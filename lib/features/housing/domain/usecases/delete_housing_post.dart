import 'package:uniplanet/features/housing/domain/repositories/housing_repository.dart';

class DeleteHousingPost {
  final HousingRepository repository;

  DeleteHousingPost(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteHousingPost(id);
  }
}
