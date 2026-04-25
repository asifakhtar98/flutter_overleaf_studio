import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_overleaf/core/models/engine.dart';
import 'package:flutter_overleaf/features/project/domain/entities/project_file.dart';
import 'package:flutter_overleaf/features/project/domain/entities/uploaded_file_data.dart';
import 'package:flutter_overleaf/features/project/domain/usecases/export_project.dart';
import 'package:flutter_overleaf/features/project/domain/usecases/import_project.dart';
import 'package:flutter_overleaf/features/project/presentation/bloc/project_bloc.dart';
import 'package:flutter_overleaf/features/project/presentation/bloc/project_event.dart';
import 'package:flutter_overleaf/features/project/presentation/bloc/project_state.dart';

class MockImportProject extends Mock implements ImportProjectUseCase {}

class MockExportProject extends Mock implements ExportProjectUseCase {}

class MockStorage extends Mock implements Storage {}

void main() {
  late MockImportProject mockImport;
  late MockExportProject mockExport;
  late MockStorage mockStorage;

  setUp(() {
    mockImport = MockImportProject();
    mockExport = MockExportProject();
    mockStorage = MockStorage();

    when(() => mockStorage.read(any())).thenReturn(null);
    when(() => mockStorage.write(any(), any<dynamic>()))
        .thenAnswer((_) async {});
    when(() => mockStorage.delete(any())).thenAnswer((_) async {});
    when(() => mockStorage.clear()).thenAnswer((_) async {});

    HydratedBloc.storage = mockStorage;
  });

  ProjectBloc buildBloc() => ProjectBloc(mockImport, mockExport);

  group('ProjectBloc', () {
    test('initial state has default main.tex', () {
      final bloc = buildBloc();
      expect(bloc.state.files, hasLength(1));
      expect(bloc.state.files.first.name, 'main.tex');
      expect(bloc.state.activeFilePath, 'main.tex');
      expect(bloc.state.mainFilePath, 'main.tex');
      bloc.close();
    });

    blocTest<ProjectBloc, ProjectState>(
      'addFile appends file to list',
      build: buildBloc,
      act: (b) => b.add(
        const ProjectEvent.addFile(
          name: 'refs.bib',
          path: 'refs.bib',
          content: '@article{}',
        ),
      ),
      expect: () => [
        isA<ProjectState>()
            .having((s) => s.files, 'files', hasLength(2))
            .having(
              (s) => s.files.last.name,
              'last file name',
              'refs.bib',
            ),
      ],
    );

    blocTest<ProjectBloc, ProjectState>(
      'removeFile removes from list and clears activeFilePath if active',
      build: buildBloc,
      seed: () => const ProjectState(
        files: [
          ProjectFile(name: 'a.tex', path: 'a.tex', content: ''),
          ProjectFile(name: 'b.tex', path: 'b.tex', content: ''),
        ],
        activeFilePath: 'b.tex',
      ),
      act: (b) => b.add(const ProjectEvent.removeFile(path: 'b.tex')),
      expect: () => [
        isA<ProjectState>()
            .having((s) => s.files, 'files', hasLength(1))
            .having((s) => s.files.first.name, 'remaining', 'a.tex'),
      ],
    );

    blocTest<ProjectBloc, ProjectState>(
      'selectFile updates activeFilePath',
      build: buildBloc,
      seed: () => const ProjectState(
        files: [
          ProjectFile(name: 'a.tex', path: 'a.tex', content: ''),
          ProjectFile(name: 'b.tex', path: 'b.tex', content: ''),
        ],
        activeFilePath: 'a.tex',
      ),
      act: (b) => b.add(const ProjectEvent.selectFile(path: 'b.tex')),
      expect: () => [
        isA<ProjectState>()
            .having((s) => s.activeFilePath, 'activeFilePath', 'b.tex'),
      ],
    );

    blocTest<ProjectBloc, ProjectState>(
      'setEngine updates engine',
      build: buildBloc,
      act: (b) =>
          b.add(const ProjectEvent.setEngine(engine: Engine.xelatex)),
      expect: () => [
        isA<ProjectState>()
            .having((s) => s.engine, 'engine', Engine.xelatex),
      ],
    );

    blocTest<ProjectBloc, ProjectState>(
      'setDraftMode toggles draft',
      build: buildBloc,
      act: (b) => b.add(const ProjectEvent.setDraftMode(draft: true)),
      expect: () => [
        isA<ProjectState>().having((s) => s.draftMode, 'draftMode', true),
      ],
    );

    blocTest<ProjectBloc, ProjectState>(
      'setEnableCache toggles cache flag',
      build: buildBloc,
      act: (b) => b.add(const ProjectEvent.setEnableCache(enable: false)),
      expect: () => [
        isA<ProjectState>()
            .having((s) => s.enableCache, 'enableCache', false),
      ],
    );

    group('uploadFiles', () {
      blocTest<ProjectBloc, ProjectState>(
        'uploads a single text file (.bib)',
        build: buildBloc,
        act: (b) => b.add(
          ProjectEvent.uploadFiles(
            files: [
              UploadedFileData(
                name: 'refs.bib',
                bytes: Uint8List.fromList(utf8.encode('@article{}')),
              ),
            ],
          ),
        ),
        expect: () => [
          isA<ProjectState>()
              .having((s) => s.files, 'files', hasLength(2))
              .having((s) => s.files.last.name, 'name', 'refs.bib')
              .having(
                (s) => s.files.last.content,
                'content',
                '@article{}',
              )
              .having(
                (s) => s.files.last.binaryContentBase64,
                'not binary',
                isNull,
              ),
        ],
      );

      blocTest<ProjectBloc, ProjectState>(
        'uploads a binary file (.png) with base64 encoding',
        build: buildBloc,
        act: (b) => b.add(
          ProjectEvent.uploadFiles(
            files: [
              UploadedFileData(
                name: 'logo.png',
                bytes: Uint8List.fromList([0x89, 0x50, 0x4E, 0x47]),
              ),
            ],
          ),
        ),
        expect: () => [
          isA<ProjectState>()
              .having((s) => s.files, 'files', hasLength(2))
              .having((s) => s.files.last.name, 'name', 'logo.png')
              .having(
                (s) => s.files.last.binaryContentBase64,
                'has base64',
                isNotNull,
              )
              .having(
                (s) => s.files.last.content,
                'text content empty',
                '',
              ),
        ],
      );

      blocTest<ProjectBloc, ProjectState>(
        'uploads into a target folder with correct path prefix',
        build: buildBloc,
        act: (b) => b.add(
          ProjectEvent.uploadFiles(
            files: [
              UploadedFileData(
                name: 'fig.png',
                bytes: Uint8List.fromList([1, 2, 3]),
              ),
            ],
            targetFolder: 'images',
          ),
        ),
        expect: () => [
          isA<ProjectState>()
              .having(
                (s) => s.files.last.path,
                'path',
                'images/fig.png',
              )
              .having((s) => s.files.last.name, 'name', 'fig.png'),
        ],
      );

      blocTest<ProjectBloc, ProjectState>(
        'auto-renames on name collision',
        build: buildBloc,
        seed: () => const ProjectState(
          files: [
            ProjectFile(name: 'main.tex', path: 'main.tex'),
            ProjectFile(
              name: 'logo.png',
              path: 'logo.png',
              binaryContentBase64: 'old',
            ),
          ],
          activeFilePath: 'main.tex',
        ),
        act: (b) => b.add(
          ProjectEvent.uploadFiles(
            files: [
              UploadedFileData(
                name: 'logo.png',
                bytes: Uint8List.fromList([9, 9, 9]),
              ),
            ],
          ),
        ),
        expect: () => [
          isA<ProjectState>()
              .having((s) => s.files, 'files', hasLength(3))
              .having(
                (s) => s.files.last.name,
                'auto-renamed',
                'logo (1).png',
              )
              .having(
                (s) => s.files.last.path,
                'path renamed',
                'logo (1).png',
              ),
        ],
      );

      blocTest<ProjectBloc, ProjectState>(
        'uploads multiple files at once',
        build: buildBloc,
        act: (b) => b.add(
          ProjectEvent.uploadFiles(
            files: [
              UploadedFileData(
                name: 'a.tex',
                bytes: Uint8List.fromList(utf8.encode('hello')),
              ),
              UploadedFileData(
                name: 'b.png',
                bytes: Uint8List.fromList([1, 2]),
              ),
            ],
          ),
        ),
        expect: () => [
          isA<ProjectState>()
              .having((s) => s.files, 'files', hasLength(3))
              .having((s) => s.files[1].name, 'second', 'a.tex')
              .having((s) => s.files[2].name, 'third', 'b.png'),
        ],
      );
    });
  });
}
