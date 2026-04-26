import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_event.freezed.dart';

@freezed
sealed class HealthEvent with _$HealthEvent {
  const factory HealthEvent.checkRequested() = CheckRequested;
  const factory HealthEvent.reset() = HealthReset;
}
