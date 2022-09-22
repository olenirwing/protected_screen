import 'package:flutter/material.dart';
import 'package:secure_screen/secure_screen_native.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SecureScreen extends StatefulWidget {
  final Widget child;
  const SecureScreen({Key? key, required this.child}) : super(key: key);

  @override
  State<SecureScreen> createState() => _SecureScreenState();
}

class _SecureScreenState extends State<SecureScreen> with WidgetsBindingObserver {
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
      SecureScreenHandler.secure();
    } else {
      SecureScreenHandler.unsecure();
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
        key: const ValueKey("secure_screen"),
        onVisibilityChanged: (info) => visibilityInfo = info,
        child: widget.child);
  }
}
