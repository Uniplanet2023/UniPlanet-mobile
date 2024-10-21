// lib/data/datasources/advertisement_remote_data_source.dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:uniplanet/config/api/server_address.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/core/helper/dio_helper.dart';
import 'package:uniplanet/features/advertiser/data/models/advertisement_model.dart';
import 'package:uniplanet/features/advertiser/domain/entities/advertisement.dart';

abstract class AdvertisementRemoteDataSource {
  // Future<AdvertisementModel> getAdvertisement(String advertiserId);
  Future<List<AdvertisementModel>> getAdvertisements(String advertiserId);
  Future<void> editAdvertisement(Advertisement advertisement);
  Future<void> removeAdvertisement(String id);
  Future<Either<Failure, void>> cancelSubscription(String advertisementId);
}

class AdvertisementRemoteDataSourceImpl
    implements AdvertisementRemoteDataSource {
  AdvertisementRemoteDataSourceImpl();

  // @override
  // Future<AdvertisementModel> getAdvertisement(String id) async {
  //   Response res = await DioHelper.instance.dio.get(
  //       '$productURI/get-my-ads/$id',
  //       options: DioHelper.instance.getDioOptions());

  //   if (res.statusCode == 200) {
  //     return AdvertisementModel.fromJson(json.decode(res.data));
  //   } else {
  //     throw Exception('Failed to load advertisement');
  //   }
  // }

  @override
  Future<List<AdvertisementModel>> getAdvertisements(
      String advertiserId) async {
    Response response = await DioHelper.instance.dio.get(
        '$productURI/get-my-ads/$advertiserId',
        options: DioHelper.instance.getDioOptions());

    if (response.statusCode == 200) {
      List<AdvertisementModel> adList = (response.data as List)
          .map((data) => AdvertisementModel.fromJson(data))
          .toList();
      return adList;
    } else {
      throw Exception('Failed to load advertisements');
    }
  }

  @override
  Future<void> editAdvertisement(Advertisement advertisement) async {
    Response response = await DioHelper.instance.dio.get(
        '$productURI/edit-advertisement',
        data: {advertisement},
        options: DioHelper.instance.getDioOptions());
    if (response.statusCode != 204) {
      throw Exception('Failed to edit advertisement');
    }
  }

  @override
  Future<void> removeAdvertisement(String id) async {
    Response response = await DioHelper.instance.dio.get(
        '$productURI/edit-advertisement/$id',
        options: DioHelper.instance.getDioOptions());

    if (response.statusCode != 204) {
      throw Exception('Failed to remove advertisement');
    }
  }

  @override
  Future<Either<Failure, void>> cancelSubscription(
      String advertisementId) async {
    Response response =
        await DioHelper.instance.dio.post('$productURI/cancel-subscription',
            data: {
              'advertisementId': advertisementId,
            },
            options: DioHelper.instance.getDioOptions());

    if (response.statusCode != 200) {
      return Left(Failure());
    } else {
      return const Right(null);
    }
  }
}
