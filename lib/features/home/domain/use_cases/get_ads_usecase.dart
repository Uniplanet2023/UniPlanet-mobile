import 'package:uniplanet/features/home/domain/repository/ad_repository.dart';
import '../entities/advertisement.dart';

class GetAdsUseCase {
  final AdRepository repository;

  GetAdsUseCase(this.repository);

  Future<List<Advertisement>> call({required String type}) async {
    return await repository.getAds(type: type);
  }
}
