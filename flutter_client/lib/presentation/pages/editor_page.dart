import 'package:flutter/material.dart';

import 'package:flutter_latex_client/features/compiler/presentation/widgets/compile_log_panel.dart';
import 'package:flutter_latex_client/presentation/widgets/responsive_layout.dart';
import 'package:flutter_latex_client/presentation/widgets/toolbar.dart';

class EditorPage extends StatelessWidget {
  const EditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Toolbar(),
          Expanded(child: ResponsiveLayout()),
          CompileLogPanel(),
        ],
      ),
    );
  }
}
