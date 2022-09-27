import 'package:flutter/material.dart';
import 'package:protected_screen/protected_screen_native.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ProtectedScreen extends StatefulWidget {
  final Widget child;
  const ProtectedScreen({Key? key, required this.child}) : super(key: key);

  @override
  State<ProtectedScreen> createState() => _ProtectedScreenState();
}

class _ProtectedScreenState extends State<ProtectedScreen> {
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    ProtectedScreenHandler.addProtectionForPause();
  }

  void _onVisibilityLost() {
    // if the widget is not visible, there can be no information that needs protection, so remove protection for next pause
    ProtectedScreenHandler.removeProtectionForPause();
  }

  void _onVisibilityGained() {
    // if the widget is visible, hide the screen in the app switcher
    ProtectedScreenHandler.addProtectionForPause();
  }

  void _onVisibilityInfoChanged(VisibilityInfo newInfo) {
    // if visibility status didnt change do nothing
    if (newInfo.isVisible == isVisible) return;
    isVisible = newInfo.isVisible;
    if (newInfo.isVisible) {
      _onVisibilityGained();
    } else {
      _onVisibilityLost();
    }
  }

  @override
  void dispose() {
    super.dispose();
    ProtectedScreenHandler.removeProtectionForPause();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
        key: const ValueKey("protected_screen"), onVisibilityChanged: _onVisibilityInfoChanged, child: widget.child);
  }
}

extension on VisibilityInfo {
  bool get isVisible {
    return visibleFraction > 0;
  }
}
