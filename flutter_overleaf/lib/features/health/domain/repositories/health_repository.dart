import 'package:flutter_overleaf/core/utils/typedefs.dart';
import 'package:flutter_overleaf/features/health/domain/entities/health_status.dart';

abstract class HealthRepository {
  FutureEither<HealthStatus> checkHealth();
}
