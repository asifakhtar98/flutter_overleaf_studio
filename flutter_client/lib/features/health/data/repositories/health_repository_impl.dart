import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:flutter_latex_client/core/error/exceptions.dart';
import 'package:flutter_latex_client/core/error/failures.dart';
import 'package:flutter_latex_client/core/utils/typedefs.dart';
import 'package:flutter_latex_client/features/health/data/datasources/health_remote_datasource.dart';
import 'package:flutter_latex_client/features/health/domain/entities/health_status.dart';
import 'package:flutter_latex_client/features/health/domain/repositories/health_repository.dart';

@LazySingleton(as: HealthRepository)
class HealthRepositoryImpl implements HealthRepository {
  const HealthRepositoryImpl(this._datasource, this._talker);

  final HealthRemoteDatasource _datasource;
  final Talker _talker;

  @override
  FutureEither<HealthStatus> checkHealth() async {
    try {
      final result = await _datasource.checkHealth();
      _talker.info(
        'Health OK: TeX Live ${result.texliveVersion}',
      );
      return Right(result);
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        _talker.warning(
          'Health check failed: ${(e.error! as NetworkException).message}',
        );
        return Left(
          Failure.network(message: (e.error! as NetworkException).message),
        );
      }
      _talker.error('Health check server error: ${e.message}');
      return Left(Failure.server(message: e.message ?? 'Health check failed'));
    } on Exception catch (e, st) {
      _talker.handle(e, st, 'Unexpected health check error');
      return Left(Failure.unknown(message: e.toString()));
    }
  }
}
