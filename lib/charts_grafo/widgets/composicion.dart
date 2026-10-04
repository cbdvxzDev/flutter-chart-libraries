import 'package:flutter/material.dart';

/// Dos vistas lado a lado (en pantallas angostas, una sobre otra).
class SideBySide extends StatelessWidget {
  const SideBySide(this.children, {super.key});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, c) {
        final items = [for (final w in children) Expanded(child: w)];
        return c.maxWidth > 700 ? Row(children: items) : Column(children: items);
      });
}

/// Un titulo encima de una vista.
class Titled extends StatelessWidget {
  const Titled(this.title, this.child, {super.key});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) => Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
        Expanded(child: child),
      ]);
}

/// Una vista con una leyenda debajo.
class Captioned extends StatelessWidget {
  const Captioned(this.child, this.caption, {super.key});
  final Widget child;
  final String caption;
  @override
  Widget build(BuildContext context) => Column(children: [
        Expanded(child: child),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(caption,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
      ]);
}
