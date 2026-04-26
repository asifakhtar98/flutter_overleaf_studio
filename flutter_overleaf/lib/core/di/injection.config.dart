// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_overleaf/core/config/server_config.dart' as _i792;
import 'package:flutter_overleaf/core/logging/talker_service.dart' as _i785;
import 'package:flutter_overleaf/core/network/dio_client.dart' as _i126;
import 'package:flutter_overleaf/features/compiler/data/datasources/compiler_remote_datasource.dart'
    as _i574;
import 'package:flutter_overleaf/features/compiler/data/repositories/compiler_repository_impl.dart'
    as _i114;
import 'package:flutter_overleaf/features/compiler/domain/repositories/compiler_repository.dart'
    as _i787;
import 'package:flutter_overleaf/features/compiler/domain/usecases/compile_project.dart'
    as _i906;
import 'package:flutter_overleaf/features/compiler/domain/usecases/compile_single.dart'
    as _i997;
import 'package:flutter_overleaf/features/compiler/presentation/bloc/compiler_bloc.dart'
    as _i1038;
import 'package:flutter_overleaf/features/editor/presentation/bloc/editor_bloc.dart'
    as _i422;
import 'package:flutter_overleaf/features/health/data/datasources/health_remote_datasource.dart'
    as _i338;
import 'package:flutter_overleaf/features/health/data/repositories/health_repository_impl.dart'
    as _i471;
import 'package:flutter_overleaf/features/health/domain/repositories/health_repository.dart'
    as _i775;
import 'package:flutter_overleaf/features/health/domain/usecases/check_health.dart'
    as _i415;
import 'package:flutter_overleaf/features/health/presentation/bloc/health_bloc.dart'
    as _i829;
import 'package:flutter_overleaf/features/project/domain/usecases/export_project.dart'
    as _i13;
import 'package:flutter_overleaf/features/project/domain/usecases/import_project.dart'
    as _i922;
import 'package:flutter_overleaf/features/project/presentation/bloc/project_bloc.dart'
    as _i855;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:talker_flutter/talker_flutter.dart' as _i207;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final talkerModule = _$TalkerModule();
    final dioModule = _$DioModule();
    gh.lazySingleton<_i422.EditorBloc>(() => _i422.EditorBloc());
    gh.lazySingleton<_i13.ExportProjectUseCase>(
      () => _i13.ExportProjectUseCase(),
    );
    gh.lazySingleton<_i922.ImportProjectUseCase>(
      () => _i922.ImportProjectUseCase(),
    );
    gh.lazySingleton<_i855.ProjectBloc>(
      () => _i855.ProjectBloc(
        gh<_i922.ImportProjectUseCase>(),
        gh<_i13.ExportProjectUseCase>(),
      ),
    );
    gh.lazySingleton<_i207.Talker>(
      () => talkerModule.talker(gh<_i792.ServerConfig>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => dioModule.dio(gh<_i792.ServerConfig>(), gh<_i207.Talker>()),
    );
    gh.lazySingleton<_i574.CompilerRemoteDatasource>(
      () => _i574.CompilerRemoteDatasource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i338.HealthRemoteDatasource>(
      () => _i338.HealthRemoteDatasource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i787.CompilerRepository>(
      () => _i114.CompilerRepositoryImpl(
        gh<_i574.CompilerRemoteDatasource>(),
        gh<_i207.Talker>(),
      ),
    );
    gh.lazySingleton<_i775.HealthRepository>(
      () => _i471.HealthRepositoryImpl(
        gh<_i338.HealthRemoteDatasource>(),
        gh<_i207.Talker>(),
      ),
    );
    gh.factory<_i906.CompileProject>(
      () => _i906.CompileProject(gh<_i787.CompilerRepository>()),
    );
    gh.factory<_i997.CompileSingle>(
      () => _i997.CompileSingle(gh<_i787.CompilerRepository>()),
    );
    gh.factory<_i415.CheckHealth>(
      () => _i415.CheckHealth(gh<_i775.HealthRepository>()),
    );
    gh.lazySingleton<_i1038.CompilerBloc>(
      () => _i1038.CompilerBloc(compileProject: gh<_i906.CompileProject>()),
    );
    gh.lazySingleton<_i829.HealthBloc>(
      () => _i829.HealthBloc(gh<_i415.CheckHealth>()),
    );
    return this;
  }
}

class _$TalkerModule extends _i785.TalkerModule {}

class _$DioModule extends _i126.DioModule {}
