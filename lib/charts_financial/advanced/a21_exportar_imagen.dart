// Avanzada 21 · Exportar la gráfica como imagen
import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';

import '../common.dart';
import '../panels.dart';

Widget a21ExportarImagen() => const _A21();

class _A21 extends StatefulWidget {
  const _A21();

  @override
  State<_A21> createState() => _A21State();
}

class _A21State extends FcState<_A21> {
  @override
  GChart buildChart() {
    d.add('s20', sma(d.c, 20), label: 'SMA 20');
    return fcChart(d, [
      fcPricePanel(d, weight: 0.72, over: [fcLine('s20', fcOrange, w: 1.6)]),
      fcVolumePanel(d, weight: 0.28, timeAxis: true),
    ]);
  }

  Future<void> _export() async {
    // La librería vuelve a dibujar la gráfica en una imagen en memoria.
    final image = await chart.saveAsImage();
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Imagen de ${image.width} × ${image.height} px'),
        content: SizedBox(
          width: 480,
          child: DecoratedBox(
            decoration: BoxDecoration(border: Border.all(color: fcGrey)),
            child: RawImage(image: image, fit: BoxFit.contain),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cerrar')),
        ],
      ),
    );
  }

  @override
  List<Widget> controls(BuildContext context) => [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: FilledButton.icon(
              onPressed: _export,
              icon: const Icon(Icons.image_outlined, size: 18),
              label: const Text('Capturar como imagen'),
            ),
          ),
        ),
      ];
}
