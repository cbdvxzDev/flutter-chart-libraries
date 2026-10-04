import 'package:flutter/material.dart';

/// Miniatura: dibuja la gráfica real a un tamaño fijo y la reduce.
class ChartThumbnail extends StatelessWidget {
  const ChartThumbnail(this.builder, {super.key});
  final Widget Function() builder;

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.white,
        child: ClipRect(
          child: IgnorePointer(
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: 480,
                height: 320,
                child: Padding(padding: const EdgeInsets.all(8), child: builder()),
              ),
            ),
          ),
        ),
      );
}
