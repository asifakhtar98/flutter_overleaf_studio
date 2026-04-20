# flutter_overleaf

A minimal, Overleaf-like LaTeX editor built with Flutter. Consumes the [TeX Live Compilation API](../README.md) — send `.tex` source, get a PDF back.

## What it is

A cross-platform frontend (web, macOS, iOS) for the TeX Live REST API server in this repo. Write LaTeX, hit compile, see the PDF — no Overleaf account needed.

## Stack

| Layer | Technology |
|---|---|
| State | `flutter_bloc` + `hydrated_bloc` (persists project across sessions) |
| DI | `get_it` + `injectable` |
| Models | `freezed` sealed classes |
| Networking | `dio` → `POST /api/v1/compile` |
| PDF | `pdfrx` |
| Editor | `TextField` + custom line-number gutter |
| File tree | `flutter_fancy_tree_view` |
| Layout | `multi_split_view` (3-pane desktop, tabs on mobile) |
| Error handling | `fpdart` `Either<Failure, T>` |
| Observability | `talker` + `talker_flutter` (Unified logging, Dio & Bloc interceptors, in-app log viewer) |

## Features

- **Multi-file projects** with a file tree — add, delete, rename files
- **Engine picker** — `pdflatex`, `xelatex`, `lualatex`
- **Draft mode** — faster compiles by skipping image rendering
- **Live PDF preview** — rendered in-app via `pdfrx`
- **Compile log panel** — full stdout/stderr with timing
- **Cache badge** — shows `X-Cached: true` hits from the server
- **Session persistence** — open project survives restarts via `HydratedBloc`
- **Responsive** — split-pane on desktop, tab-view on mobile

## API consumed

```
POST /api/v1/compile          # LaTeX → PDF (JSON or multipart/zip)
GET  /api/v1/health           # Server status + TeX Live version
```

Auth: `X-API-Key` header — set `apiKey` in `ServerConfig` inside `main.dart`.

## Run

```bash
# From repo root
cd flutter_client
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d chrome --web-port 51886
```

> Point `ServerConfig.baseUrl` at your running TeX Live API instance before compiling.
