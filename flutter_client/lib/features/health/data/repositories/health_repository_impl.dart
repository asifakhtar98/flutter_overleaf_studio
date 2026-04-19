import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_latex_client/core/error/exceptions.dart';
import 'package:flutter_latex_client/core/error/failures.dart';
import 'package:flutter_latex_client/core/utils/typedefs.dart';
import 'package:flutter_latex_client/features/health/data/datasources/health_remote_datasource.dart';
import 'package:flutter_latex_client/features/health/domain/entities/health_status.dart';
import 'package:flutter_latex_client/features/health/domain/repositories/health_repository.dart';

@LazySingleton(as: HealthRepository)
class HealthRepositoryImpl implements HealthRepository {
  const HealthRepositoryImpl(this._datasource);

  final HealthRemoteDatasource _datasource;

  @override
  FutureEither<HealthStatus> checkHealth() async {
    try {
      final result = await _datasource.checkHealth();
      return Right(result);
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        return Left(
          Failure.network(message: (e.error! as NetworkException).message),
        );
      }
      return Left(Failure.server(message: e.message ?? 'Health check failed'));
    } on Exception catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }
}
