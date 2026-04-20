import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:rxdart/rxdart.dart';

import 'package:flutter_latex_client/core/constants/app_constants.dart';
import 'package:flutter_latex_client/core/utils/path_utils.dart';
import 'package:flutter_latex_client/features/project/domain/entities/project_file.dart';
import 'package:flutter_latex_client/features/project/domain/usecases/import_project.dart';
import 'package:flutter_latex_client/features/project/domain/usecases/export_project.dart';
import 'package:flutter_latex_client/features/project/presentation/bloc/project_event.dart';
import 'package:flutter_latex_client/features/project/presentation/bloc/project_state.dart'
    show ProjectState;

@injectable
class ProjectBloc extends HydratedBloc<ProjectEvent, ProjectState> {
  final ImportProjectUseCase _importProject;
  final ExportProjectUseCase _exportProject;

  ProjectBloc(this._importProject, this._exportProject)
    : super(
        const ProjectState(
          files: [
            ProjectFile(
              name: 'main.tex',
              path: 'main.tex',
              content: defaultMainTex,
              isMainFile: true,
            ),
          ],
          activeFilePath: 'main.tex',
          mainFilePath: 'main.tex',
        ),
      ) {
    on<AddFile>(_onAddFile);
    on<RemoveFile>(_onRemoveFile);
    on<RenameFile>(_onRenameFile);
    on<SelectFile>(_onSelectFile);
    on<UpdateFileContent>(
      _onUpdateFileContent,
      transformer: (events, mapper) => events
          .groupBy((e) => e.path)
          .flatMap(
            (group) => group
                .debounceTime(const Duration(milliseconds: 300))
                .switchMap(mapper),
          ),
    );
    on<SetMainFile>(_onSetMainFile);
    on<AddFolder>(_onAddFolder);
    on<RenameFolder>(_onRenameFolder);
    on<DeleteFolder>(_onDeleteFolder);
    on<ImportProjectEvent>(_onImportProject);
    on<ExportProjectEvent>(_onExportProject);
    on<LoadFiles>(_onLoadFiles);
  }

  Future<void> _onImportProject(
    ImportProjectEvent event,
    Emitter<ProjectState> emit,
  ) async {
    emit(state.copyWith(isImporting: true, importError: null));
    final result = await _importProject(
      bytes: event.bytes,
      fromPicker: event.bytes == null,
    );
    result.fold(
      (_) {
        emit(state.copyWith(isImporting: false));
      },
      (List<ProjectFile> files) {
        emit(
          state.copyWith(
            files: files,
            activeFilePath: files.isNotEmpty ? files.first.path : null,
            mainFilePath: files.any((f) => f.isMainFile)
                ? files.firstWhere((f) => f.isMainFile).path
                : null,
            isImporting: false,
          ),
        );
      },
    );
  }

  Future<void> _onExportProject(
    ExportProjectEvent event,
    Emitter<ProjectState> emit,
  ) async {
    emit(state.copyWith(isExporting: true, importError: null));
    final result = await _exportProject(state.files);
    result.fold(
      (failure) {
        emit(state.copyWith(isExporting: false, importError: 'Export failed'));
      },
      (void _) {
        emit(state.copyWith(isExporting: false));
      },
    );
  }

  void _onLoadFiles(LoadFiles event, Emitter<ProjectState> emit) {
    emit(
      state.copyWith(
        files: event.files,
        activeFilePath: event.activeFilePath ?? state.activeFilePath,
        mainFilePath: event.mainFilePath ?? state.mainFilePath,
      ),
    );
  }

  void _onAddFile(AddFile event, Emitter<ProjectState> emit) {
    var finalPath = event.path;
    var finalName = event.name;

    var counter = 1;
    while (state.files.any((f) => f.path == finalPath)) {
      final dotIndex = event.name.lastIndexOf('.');
      if (dotIndex == -1) {
        finalName = '${event.name} ($counter)';
        finalPath = '${event.path} ($counter)';
      } else {
        final baseName = event.name.substring(0, dotIndex);
        final extension = event.name.substring(dotIndex);
        final dir = event.path.contains('/')
            ? '${event.path.substring(0, event.path.lastIndexOf('/'))}/'
            : '';
        finalName = '$baseName ($counter)$extension';
        finalPath = '$dir$baseName ($counter)$extension';
      }
      counter++;
    }

    final newFile = ProjectFile(
      name: finalName,
      path: finalPath,
      content: event.content,
    );

    emit(
      state.copyWith(
        files: [...state.files, newFile],
        activeFilePath: finalPath,
      ),
    );
  }

  void _onRemoveFile(RemoveFile event, Emitter<ProjectState> emit) {
    final updated = state.files.where((f) => f.path != event.path).toList();
    final newActive = state.activeFilePath == event.path
        ? (updated.isNotEmpty ? updated.first.path : null)
        : state.activeFilePath;
    final newMain = state.mainFilePath == event.path
        ? null
        : state.mainFilePath;

    emit(
      state.copyWith(
        files: updated,
        activeFilePath: newActive,
        mainFilePath: newMain,
      ),
    );
  }

  void _onRenameFile(RenameFile event, Emitter<ProjectState> emit) {
    final newPath = replaceLastPathSegment(event.oldPath, event.newName);
    final updated = state.files.map((f) {
      if (f.path == event.oldPath) {
        return f.copyWith(name: event.newName, path: newPath);
      }
      return f;
    }).toList();

    emit(state.copyWith(
      files: updated,
      activeFilePath: state.activeFilePath == event.oldPath
          ? newPath
          : state.activeFilePath,
      mainFilePath: state.mainFilePath == event.oldPath
          ? newPath
          : state.mainFilePath,
    ));
  }

  void _onSelectFile(SelectFile event, Emitter<ProjectState> emit) {
    emit(state.copyWith(activeFilePath: event.path));
  }

  void _onUpdateFileContent(
    UpdateFileContent event,
    Emitter<ProjectState> emit,
  ) {
    final updated = state.files.map((f) {
      if (f.path == event.path) {
        return f.copyWith(content: event.content);
      }
      return f;
    }).toList();

    emit(state.copyWith(files: updated));
  }

  void _onSetMainFile(SetMainFile event, Emitter<ProjectState> emit) {
    final updated = state.files.map((f) {
      return f.copyWith(isMainFile: f.path == event.path);
    }).toList();

    emit(state.copyWith(files: updated, mainFilePath: event.path));
  }

  void _onAddFolder(AddFolder event, Emitter<ProjectState> emit) {
    // Create a .gitkeep placeholder so the folder is visible in the tree.
    final placeholder = ProjectFile(
      name: '.gitkeep',
      path: '${event.path}/.gitkeep',
    );
    emit(state.copyWith(files: [...state.files, placeholder]));
  }

  void _onRenameFolder(RenameFolder event, Emitter<ProjectState> emit) {
    final newFolderPath = replaceLastPathSegment(event.oldPath, event.newName);
    final updated = state.files.map((f) {
      if (f.path.startsWith('${event.oldPath}/')) {
        final newPath = f.path.replaceFirst(event.oldPath, newFolderPath);
        return f.copyWith(path: newPath);
      }
      return f;
    }).toList();

    String? newActivePath;
    if (state.activeFilePath != null &&
        state.activeFilePath!.startsWith('${event.oldPath}/')) {
      newActivePath = state.activeFilePath!.replaceFirst(event.oldPath, newFolderPath);
    }

    String? newMainPath;
    if (state.mainFilePath != null &&
        state.mainFilePath!.startsWith('${event.oldPath}/')) {
      newMainPath = state.mainFilePath!.replaceFirst(event.oldPath, newFolderPath);
    }

    emit(state.copyWith(
      files: updated,
      activeFilePath: newActivePath ?? state.activeFilePath,
      mainFilePath: newMainPath ?? state.mainFilePath,
    ));
  }

  void _onDeleteFolder(DeleteFolder event, Emitter<ProjectState> emit) {
    final updated = state.files
        .where((f) => !f.path.startsWith('${event.path}/'))
        .toList();

    String? newActive;
    if (state.activeFilePath != null &&
        state.activeFilePath!.startsWith('${event.path}/')) {
      newActive = updated.isNotEmpty ? updated.first.path : null;
    }

    String? newMain;
    if (state.mainFilePath != null &&
        state.mainFilePath!.startsWith('${event.path}/')) {
      newMain = null;
    }

    emit(state.copyWith(
      files: updated,
      activeFilePath: newActive ?? state.activeFilePath,
      mainFilePath: newMain ?? state.mainFilePath,
    ));
  }

  @override
  ProjectState? fromJson(Map<String, dynamic> json) {
    try {
      return ProjectState.fromJson(json);
    } on Object {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(ProjectState state) {
    try {
      return state.toJson();
    } on Object {
      return null;
    }
  }
}
