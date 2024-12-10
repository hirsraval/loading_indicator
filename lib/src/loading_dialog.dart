import 'package:flutter/material.dart';

import 'loading_indicator.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: EdgeInsets.zero,
        child: Center(
          child: Material(
            type: MaterialType.card,
            shape: CircleBorder(),
            child: SizedBox.square(
              dimension: 64,
              child: LoadingIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
