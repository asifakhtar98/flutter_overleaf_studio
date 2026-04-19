import 'package:flutter_latex_client/core/utils/typedefs.dart';
import 'package:flutter_latex_client/features/health/domain/entities/health_status.dart';

abstract class HealthRepository {
  FutureEither<HealthStatus> checkHealth();
}
