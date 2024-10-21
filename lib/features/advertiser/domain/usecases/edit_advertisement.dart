// lib/domain/usecases/edit_advertisement.dart
import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/core/usecases/usecase.dart';
import 'package:uniplanet/features/advertiser/domain/entities/advertisement.dart';
import 'package:uniplanet/features/advertiser/domain/repository/advertisement_repository.dart';

class EditAdvertisement implements UseCase<void, Advertisement> {
  final AdvertisementRepository repository;

  EditAdvertisement(this.repository);

  @override
  Future<Either<Failure, void>> call(Advertisement advertisement) async {
    return await repository.editAdvertisement(advertisement);
  }
}
