/// Type-safe LaTeX compilation engine matching the backend's StrEnum.
enum Engine {
  pdflatex,
  xelatex,
  lualatex,
  latexmk;

  /// Display label for UI dropdowns.
  String get label => switch (this) {
    Engine.pdflatex => 'pdfLaTeX',
    Engine.xelatex => 'XeLaTeX',
    Engine.lualatex => 'LuaLaTeX',
    Engine.latexmk => 'LaTeXMK',
  };
}
