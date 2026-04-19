import 'package:injectable/injectable.dart';

import 'package:flutter_latex_client/core/utils/typedefs.dart';
import 'package:flutter_latex_client/features/health/domain/entities/health_status.dart';
import 'package:flutter_latex_client/features/health/domain/repositories/health_repository.dart';

@injectable
class CheckHealth {
  const CheckHealth(this._repository);

  final HealthRepository _repository;

  FutureEither<HealthStatus> call() => _repository.checkHealth();
}
