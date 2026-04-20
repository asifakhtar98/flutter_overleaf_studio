// Core typedefs and extensions
import 'package:fpdart/fpdart.dart';

import 'package:flutter_overleaf/core/error/failures.dart';

/// Shorthand for async Either results from use cases.
typedef FutureEither<T> = Future<Either<Failure, T>>;
