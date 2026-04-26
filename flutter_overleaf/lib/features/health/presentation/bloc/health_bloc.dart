import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_overleaf/features/health/domain/usecases/check_health.dart';
import 'package:flutter_overleaf/features/health/presentation/bloc/health_event.dart';
import 'package:flutter_overleaf/features/health/presentation/bloc/health_state.dart';

@lazySingleton
class HealthBloc extends Bloc<HealthEvent, HealthState> {
  HealthBloc(this._checkHealth) : super(const HealthState.unknown()) {
    on<CheckRequested>(_onCheckRequested);
    on<HealthReset>(_onReset);

    // Fire immediately + start periodic polling.
    add(const HealthEvent.checkRequested());
    _timer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => add(const HealthEvent.checkRequested()),
    );
  }

  final CheckHealth _checkHealth;
  Timer? _timer;

  Future<void> _onCheckRequested(
    CheckRequested event,
    Emitter<HealthState> emit,
  ) async {
    emit(const HealthState.checking());

    final result = await _checkHealth();
    result.fold(
      (failure) => emit(HealthState.disconnected(message: failure.toString())),
      (status) => emit(HealthState.connected(status: status)),
    );
  }

  void _onReset(HealthReset event, Emitter<HealthState> emit) {
    emit(const HealthState.unknown());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
