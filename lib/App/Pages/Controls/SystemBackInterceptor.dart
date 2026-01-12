
import 'package:flutter/material.dart';

class SystemBackInterceptor extends StatelessWidget
{
  final Widget child;
  final VoidCallback onSystemBack;

  const SystemBackInterceptor({
    super.key,
    required this.child,
    required this.onSystemBack,
  });

  @override
  Widget build(BuildContext context)
  {
    return PopScope(
      canPop: false, // Intercepts system back
      onPopInvokedWithResult: (didPop, result)
      {
        if (didPop)
        {
          return;
        }

        onSystemBack(); // Triggers your custom logic
      },
      child: child,
    );
  }
}