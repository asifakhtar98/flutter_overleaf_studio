import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Tracks line count from a [TextEditingController].
int useLineCount(TextEditingController controller) {
  final lineCount = useState(1);

  useEffect(() {
    void listener() {
      var count = 1;
      final text = controller.text;
      for (var i = 0; i < text.length; i++) {
        if (text.codeUnitAt(i) == 10) count++;
      }
      if (lineCount.value != count) {
        lineCount.value = count;
      }
    }

    controller.addListener(listener);
    listener(); // Initial count
    return () => controller.removeListener(listener);
  }, [controller]);

  return lineCount.value;
}
