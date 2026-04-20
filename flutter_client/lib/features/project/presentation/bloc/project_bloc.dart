import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:rxdart/rxdart.dart';

import 'package:flutter_latex_client/features/project/domain/entities/project_file.dart';
import 'package:flutter_latex_client/features/project/domain/usecases/import_project.dart';
import 'package:flutter_latex_client/features/project/domain/usecases/export_project.dart';
import 'package:flutter_latex_client/features/project/presentation/bloc/project_event.dart';
import 'package:flutter_latex_client/features/project/presentation/bloc/project_state.dart' show ProjectState, ProjectFolder;

const _defaultMainTex = r'''
\documentclass{article}
\begin{document}

Hello, \LaTeX!

\end{document}
''';

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
                content: _defaultMainTex,
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
          .flatMap((group) => group.debounceTime(const Duration(milliseconds: 300)).switchMap(mapper)),
    );
    on<SetMainFile>(_onSetMainFile);
    on<AddFolder>(_onAddFolder);
    on<ToggleFolder>(_onToggleFolder);
    on<ImportProjectEvent>(_onImportProject);
    on<ExportProjectEvent>(_onExportProject);
    on<LoadFiles>(_onLoadFiles);
  }

  Future<void> _onImportProject(
    ImportProjectEvent event,
    Emitter<ProjectState> emit,
  ) async {
    final result = await _importProject();
    result.fold(
      (failure) {},
      (List<ProjectFile> files) {
        emit(state.copyWith(
          files: files,
          activeFilePath: files.isNotEmpty ? files.first.path : null,
          mainFilePath: files.any((f) => f.isMainFile)
              ? files.firstWhere((f) => f.isMainFile).path
              : null,
        ));
      },
    );
  }

  Future<void> _onExportProject(
    ExportProjectEvent event,
    Emitter<ProjectState> emit,
  ) async {
    await _exportProject(state.files);
  }

  void _onLoadFiles(
    LoadFiles event,
    Emitter<ProjectState> emit,
  ) {
    emit(state.copyWith(
      files: event.files,
      activeFilePath: event.activeFilePath ?? state.activeFilePath,
      mainFilePath: event.mainFilePath ?? state.mainFilePath,
    ));
  }

  void _onAddFile(AddFile event, Emitter<ProjectState> emit) {
    final exists = state.files.any((f) => f.path == event.path);
    if (exists) return;

    final newFile = ProjectFile(
      name: event.name,
      path: event.path,
      content: event.content,
    );

    emit(
      state.copyWith(
        files: [...state.files, newFile],
        activeFilePath: event.path,
      ),
    );
  }

  void _onRemoveFile(RemoveFile event, Emitter<ProjectState> emit) {
    final updated = state.files.where((f) => f.path != event.path).toList();
    final newActive = state.activeFilePath == event.path
        ? (updated.isNotEmpty ? updated.first.path : null)
        : state.activeFilePath;
    final newMain = state.mainFilePath == event.path ? null : state.mainFilePath;

    emit(
      state.copyWith(
        files: updated,
        activeFilePath: newActive,
        mainFilePath: newMain,
      ),
    );
  }

  void _onRenameFile(RenameFile event, Emitter<ProjectState> emit) {
    final updated = state.files.map((f) {
      if (f.path == event.oldPath) {
        final dir = event.oldPath.contains('/')
            ? '${event.oldPath.substring(0, event.oldPath.lastIndexOf('/'))}/'
            : '';
        final newPath = '$dir${event.newName}';
        return f.copyWith(name: event.newName, path: newPath);
      }
      return f;
    }).toList();

    emit(state.copyWith(files: updated));
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
    final exists = state.folders.any((f) => f.path == event.path);
    if (exists) return;

    final newFolder = ProjectFolder(
      name: event.name,
      path: event.path,
    );

    emit(
      state.copyWith(
        folders: [...state.folders, newFolder],
      ),
    );
  }

  void _onToggleFolder(ToggleFolder event, Emitter<ProjectState> emit) {
    final updatedFolders = _toggleFolderRecursive(state.folders, event.path);
    emit(state.copyWith(folders: updatedFolders));
  }

  List<ProjectFolder> _toggleFolderRecursive(
    List<ProjectFolder> folders,
    String targetPath,
  ) {
    return folders.map((folder) {
      if (folder.path == targetPath) {
        return folder.copyWith(isExpanded: !folder.isExpanded);
      }
      if (folder.children.isNotEmpty) {
        return folder.copyWith(
          children: _toggleFolderRecursive(folder.children, targetPath),
        );
      }
      return folder;
    }).toList();
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
