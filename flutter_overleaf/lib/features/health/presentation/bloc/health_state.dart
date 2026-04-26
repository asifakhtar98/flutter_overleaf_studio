import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_overleaf/features/health/domain/entities/health_status.dart';

part 'health_state.freezed.dart';

@freezed
sealed class HealthState with _$HealthState {
  const factory HealthState.unknown() = HealthUnknown;
  const factory HealthState.checking() = HealthChecking;
  const factory HealthState.connected({required HealthStatus status}) =
      HealthConnected;
  const factory HealthState.disconnected({required String message}) =
      HealthDisconnected;
}
