// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_latex_client/core/config/server_config.dart' as _i706;
import 'package:flutter_latex_client/core/logging/talker_service.dart' as _i909;
import 'package:flutter_latex_client/core/network/dio_client.dart' as _i127;
import 'package:flutter_latex_client/features/compiler/data/datasources/compiler_remote_datasource.dart'
    as _i982;
import 'package:flutter_latex_client/features/compiler/data/repositories/compiler_repository_impl.dart'
    as _i637;
import 'package:flutter_latex_client/features/compiler/domain/repositories/compiler_repository.dart'
    as _i572;
import 'package:flutter_latex_client/features/compiler/domain/usecases/compile_project.dart'
    as _i938;
import 'package:flutter_latex_client/features/compiler/domain/usecases/compile_single.dart'
    as _i607;
import 'package:flutter_latex_client/features/compiler/presentation/bloc/compiler_bloc.dart'
    as _i251;
import 'package:flutter_latex_client/features/editor/presentation/bloc/editor_bloc.dart'
    as _i294;
import 'package:flutter_latex_client/features/health/data/datasources/health_remote_datasource.dart'
    as _i867;
import 'package:flutter_latex_client/features/health/data/repositories/health_repository_impl.dart'
    as _i105;
import 'package:flutter_latex_client/features/health/domain/repositories/health_repository.dart'
    as _i689;
import 'package:flutter_latex_client/features/health/domain/usecases/check_health.dart'
    as _i96;
import 'package:flutter_latex_client/features/project/domain/usecases/export_project.dart'
    as _i462;
import 'package:flutter_latex_client/features/project/domain/usecases/import_project.dart'
    as _i964;
import 'package:flutter_latex_client/features/project/presentation/bloc/project_bloc.dart'
    as _i625;
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
    gh.factory<_i294.EditorBloc>(() => _i294.EditorBloc());
    gh.lazySingleton<_i462.ExportProjectUseCase>(
      () => _i462.ExportProjectUseCase(),
    );
    gh.lazySingleton<_i964.ImportProjectUseCase>(
      () => _i964.ImportProjectUseCase(),
    );
    gh.lazySingleton<_i207.Talker>(
      () => talkerModule.talker(gh<_i706.ServerConfig>()),
    );
    gh.factory<_i625.ProjectBloc>(
      () => _i625.ProjectBloc(
        gh<_i964.ImportProjectUseCase>(),
        gh<_i462.ExportProjectUseCase>(),
      ),
    );
    gh.lazySingleton<_i361.Dio>(
      () => dioModule.dio(gh<_i706.ServerConfig>(), gh<_i207.Talker>()),
    );
    gh.lazySingleton<_i982.CompilerRemoteDatasource>(
      () => _i982.CompilerRemoteDatasource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i867.HealthRemoteDatasource>(
      () => _i867.HealthRemoteDatasource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i572.CompilerRepository>(
      () => _i637.CompilerRepositoryImpl(
        gh<_i982.CompilerRemoteDatasource>(),
        gh<_i207.Talker>(),
      ),
    );
    gh.lazySingleton<_i689.HealthRepository>(
      () => _i105.HealthRepositoryImpl(
        gh<_i867.HealthRemoteDatasource>(),
        gh<_i207.Talker>(),
      ),
    );
    gh.factory<_i938.CompileProject>(
      () => _i938.CompileProject(gh<_i572.CompilerRepository>()),
    );
    gh.factory<_i607.CompileSingle>(
      () => _i607.CompileSingle(gh<_i572.CompilerRepository>()),
    );
    gh.factory<_i96.CheckHealth>(
      () => _i96.CheckHealth(gh<_i689.HealthRepository>()),
    );
    gh.factory<_i251.CompilerBloc>(
      () => _i251.CompilerBloc(
        compileSingle: gh<_i607.CompileSingle>(),
        compileProject: gh<_i938.CompileProject>(),
      ),
    );
    return this;
  }
}

class _$TalkerModule extends _i909.TalkerModule {}

class _$DioModule extends _i127.DioModule {}
