import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_overleaf/features/health/domain/entities/health_status.dart';

@lazySingleton
class HealthRemoteDatasource {
  const HealthRemoteDatasource(this._dio);

  final Dio _dio;

  Future<HealthStatus> checkHealth() async {
    final response = await _dio.get<Map<String, dynamic>>('/api/v1/health');
    return HealthStatus.fromJson(response.data!);
  }
}
