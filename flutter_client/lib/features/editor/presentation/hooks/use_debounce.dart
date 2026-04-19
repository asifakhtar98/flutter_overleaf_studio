import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Debounces a value by [duration].
/// Returns the last stable value after no changes for [duration].
T useDebounce<T>(
  T value, {
  Duration duration = const Duration(milliseconds: 500),
}) {
  return use(_DebouncedHook(value, duration));
}

class _DebouncedHook<T> extends Hook<T> {
  const _DebouncedHook(this.value, this.duration);

  final T value;
  final Duration duration;

  @override
  _DebouncedHookState<T> createState() => _DebouncedHookState<T>();
}

class _DebouncedHookState<T>
    extends HookState<T, _DebouncedHook<T>> {
  late T _debouncedValue = hook.value;
  Timer? _timer;

  @override
  T build(BuildContext context) => _debouncedValue;

  @override
  void didUpdateHook(_DebouncedHook<T> oldHook) {
    super.didUpdateHook(oldHook);
    if (hook.value != oldHook.value) {
      _timer?.cancel();
      _timer = Timer(hook.duration, () {
        setState(() {
          _debouncedValue = hook.value;
        });
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
