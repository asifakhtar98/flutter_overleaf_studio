import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Tracks line count from a [TextEditingController].
int useLineCount(TextEditingController controller) {
  final lineCount = useState(1);

  useEffect(
    () {
      void listener() {
        final count = '\n'.allMatches(controller.text).length + 1;
        if (lineCount.value != count) {
          lineCount.value = count;
        }
      }

      controller.addListener(listener);
      listener(); // Initial count
      return () => controller.removeListener(listener);
    },
    [controller],
  );

  return lineCount.value;
}
