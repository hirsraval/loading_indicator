import 'package:extensions/context_extensions.dart';
import 'package:flutter/material.dart';

import 'loading_dialog.dart';

abstract class LoadingHandler {
  const LoadingHandler();

  void startLoading();

  void stopLoading();

  void handleLoading(bool loading) {
    if (loading) {
      startLoading();
    } else {
      stopLoading();
    }
  }
}

class LoadingDialogHandler extends LoadingHandler {
  LoadingDialogHandler(BuildContext context) : _context = context;

  final BuildContext _context;
  Route? _dialogRoute;

  Route _buildDialogRoute(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final CapturedThemes themes = InheritedTheme.capture(from: context, to: Navigator.of(context).context);
    return DialogRoute(
      context: context,
      barrierDismissible: false,
      useSafeArea: true,
      settings: const RouteSettings(name: "/loading_dialog"),
      themes: themes,
      builder: (context) => const LoadingDialog(),
    );
  }

  @override
  void startLoading() {
    if (_dialogRoute != null) return;
    _dialogRoute = _buildDialogRoute(_context);
    _context.navigator.push(_dialogRoute!);
  }

  @override
  void stopLoading() {
    if (_dialogRoute != null) _context.navigator.removeRoute(_dialogRoute!);
    _dialogRoute = null;
  }
}
