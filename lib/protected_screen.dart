import 'package:flutter/material.dart';
import 'package:protected_screen/protected_screen_native.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ProtectedScreen extends StatefulWidget {
  final Widget child;
  const ProtectedScreen({Key? key, required this.child}) : super(key: key);

  @override
  State<ProtectedScreen> createState() => _ProtectedScreenState();
}

class _ProtectedScreenState extends State<ProtectedScreen> with WidgetsBindingObserver {
  VisibilityInfo visibilityInfo = const VisibilityInfo(key: ValueKey(null));

  bool get isVisible => visibilityInfo.visibleFraction > 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final bool movingToBackground =
        state == AppLifecycleState.inactive || state == AppLifecycleState.paused || state == AppLifecycleState.detached;
    if (!isVisible) return;
    if (movingToBackground) {
      ProtectedScreenHandler.addProtection();
    } else {
      ProtectedScreenHandler.removeProtection();
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
        key: const ValueKey("protected_screen"),
        onVisibilityChanged: (info) => visibilityInfo = info,
        child: widget.child);
  }
}
