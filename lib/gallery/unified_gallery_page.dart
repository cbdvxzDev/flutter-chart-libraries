import 'package:flutter/material.dart';

import 'gallery_catalog.dart';
import 'gallery_models.dart';
import 'gallery_theme.dart';
import 'glyph_painter.dart';

/// Pantalla principal: riel de librerías y cuadrícula de gráficas.
class UnifiedGalleryPage extends StatefulWidget {
  const UnifiedGalleryPage({super.key});

  @override
  State<UnifiedGalleryPage> createState() => _UnifiedGalleryPageState();
}

class _UnifiedGalleryPageState extends State<UnifiedGalleryPage> {
  /// Por debajo de este ancho el riel pasa arriba.
  static const _narrowWidth = 800.0;

  /// Ancho mínimo de una tarjeta y separación entre tarjetas.
  static const _cardMinWidth = 230.0;
  static const _gap = 16.0;

  final _searchController = TextEditingController();

  int _libraryIndex = 0;
  bool _showBasic = true;

  /// Categoría elegida; `null` significa "Todas".
  String? _category;
  String _query = '';

  GalleryLibrary get _library => galleryLibraries[_libraryIndex];

  List<GalleryEntry> get _levelEntries =>
      _showBasic ? _library.basic : _library.advanced;

  /// Categorías del nivel actual, sin repetir y en orden de aparición.
  List<String> get _categories =>
      {for (final e in _levelEntries) e.category}.toList();

  /// Gráficas que pasan el filtro de categoría y la búsqueda.
  List<GalleryEntry> get _visibleEntries {
    final query = _query.trim().toLowerCase();
    return [
      for (final e in _levelEntries)
        if ((_category == null || e.category == _category) &&
            e.title.toLowerCase().contains(query))
          e,
    ];
  }

  void _selectLibrary(int index) => setState(() {
    _libraryIndex = index;
    _category = null;
  });

  void _selectLevel(bool basic) => setState(() {
    _showBasic = basic;
    _category = null;
  });

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GalleryColors.page,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final narrow = constraints.maxWidth < _narrowWidth;
            final rail = _Rail(
              selected: _libraryIndex,
              horizontal: narrow,
              onSelect: _selectLibrary,
            );
            final content = _buildContent(narrow ? 16 : 32);
            if (narrow) {
              return Column(
                children: [
                  rail,
                  Expanded(child: content),
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(width: 240, child: rail),
                Expanded(child: content),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(double padding) {
    final library = _library;
    final entries = _visibleEntries;
    return LayoutBuilder(
      builder: (context, constraints) {
        final gridWidth = constraints.maxWidth - padding * 2;
        final columns = ((gridWidth + _gap) / (_cardMinWidth + _gap))
            .floor()
            .clamp(1, 12);
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(padding, padding, padding, 24),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(library),
                    const SizedBox(height: 24),
                    _buildFilters(library),
                  ],
                ),
              ),
            ),
            if (entries.isEmpty)
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                sliver: const SliverToBoxAdapter(
                  child: Text(
                    'Ninguna gráfica coincide con la búsqueda.',
                    style: GalleryText.empty,
                  ),
                ),
              )
            else
              SliverPadding(
                padding: EdgeInsets.fromLTRB(padding, 0, padding, padding),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisSpacing: _gap,
                    crossAxisSpacing: _gap,
                    mainAxisExtent: 196,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, i) =>
                        _ChartCard(entry: entries[i], library: library),
                    childCount: entries.length,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(GalleryLibrary library) {
    // El Wrap ocupa todo el ancho para que spaceBetween mande el buscador
    // a la derecha; si no cabe, el buscador baja a la línea siguiente.
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 24,
        runSpacing: 16,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                library.packageLabel,
                style: GalleryText.headerPackage.copyWith(color: library.color),
              ),
              const SizedBox(height: 4),
              Text(library.name, style: GalleryText.headerTitle),
              const SizedBox(height: 4),
              Text(library.description, style: GalleryText.headerDescription),
            ],
          ),
          SizedBox(
            width: 280,
            height: 44,
            child: TextField(
              key: const ValueKey('buscar'),
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
              style: GalleryText.search,
              cursorColor: library.color,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Buscar gráfica',
                hintStyle: GalleryText.search.copyWith(
                  color: GalleryColors.inkSoft,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: GalleryColors.inkSoft,
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
                filled: true,
                fillColor: GalleryColors.surface,
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(
                    color: GalleryColors.fieldBorder,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: library.color, width: 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(GalleryLibrary library) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          // Si la pantalla es muy estrecha, el control se achica para caber.
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: _LevelSwitch(
              basicCount: library.basic.length,
              advancedCount: library.advanced.length,
              showBasic: _showBasic,
              onChanged: _selectLevel,
            ),
          ),
        ),
        _CategoryChip(
          label: 'Todas',
          selected: _category == null,
          color: library.color,
          onTap: () => setState(() => _category = null),
        ),
        for (final category in _categories)
          _CategoryChip(
            label: category,
            selected: _category == category,
            color: library.color,
            onTap: () => setState(() => _category = category),
          ),
      ],
    );
  }
}

/// Columna oscura con el título y un botón por librería.
///
/// Con [horizontal] en `true` (pantalla estrecha) los botones van en una
/// fila que se desplaza de lado.
class _Rail extends StatelessWidget {
  const _Rail({
    required this.selected,
    required this.horizontal,
    required this.onSelect,
  });

  final int selected;
  final bool horizontal;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final buttons = [
      for (var i = 0; i < galleryLibraries.length; i++)
        _RailButton(
          key: ValueKey('libreria-$i'),
          library: galleryLibraries[i],
          selected: i == selected,
          onTap: () => onSelect(i),
        ),
    ];
    return Container(
      key: const ValueKey('riel'),
      color: GalleryColors.ink,
      padding: EdgeInsets.all(horizontal ? 16 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Taller de gráficas', style: GalleryText.railTitle),
          const SizedBox(height: 4),
          Text(
            '${galleryLibraries.length} librerías · $galleryTotal gráficas',
            style: GalleryText.railSubtitle,
          ),
          SizedBox(height: horizontal ? 12 : 24),
          if (horizontal)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final button in buttons)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: SizedBox(width: 230, child: button),
                    ),
                ],
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: buttons.length,
                separatorBuilder: (_, _) => const SizedBox(height: 4),
                itemBuilder: (_, i) => buttons[i],
              ),
            ),
        ],
      ),
    );
  }
}

/// Botón de una librería en el riel.
class _RailButton extends StatelessWidget {
  const _RailButton({
    super.key,
    required this.library,
    required this.selected,
    required this.onTap,
  });

  final GalleryLibrary library;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? GalleryColors.railSelected : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 52),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Container(width: 12, height: 12, color: library.railColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(library.name, style: GalleryText.railName),
                        Text(
                          library.package,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GalleryText.railPackage,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('${library.total}', style: GalleryText.railCount),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Control segmentado "Básicas | Avanzadas".
class _LevelSwitch extends StatelessWidget {
  const _LevelSwitch({
    required this.basicCount,
    required this.advancedCount,
    required this.showBasic,
    required this.onChanged,
  });

  final int basicCount;
  final int advancedCount;
  final bool showBasic;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        border: Border.all(color: GalleryColors.ink),
        borderRadius: BorderRadius.circular(6),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _segment('nivel-basicas', 'Básicas', basicCount, showBasic, true),
          _segment(
            'nivel-avanzadas',
            'Avanzadas',
            advancedCount,
            !showBasic,
            false,
          ),
        ],
      ),
    );
  }

  Widget _segment(
    String key,
    String label,
    int count,
    bool active,
    bool basic,
  ) {
    final foreground = active ? GalleryColors.surface : GalleryColors.ink;
    return Semantics(
      selected: active,
      button: true,
      child: Material(
        key: ValueKey(key),
        color: active ? GalleryColors.ink : GalleryColors.surface,
        child: InkWell(
          onTap: () => onChanged(basic),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: '$label '),
                    TextSpan(text: '$count', style: GalleryText.segmentCount),
                  ],
                ),
                style: GalleryText.segment.copyWith(color: foreground),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Ficha de categoría.
class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(22),
      side: BorderSide(color: selected ? color : GalleryColors.fieldBorder),
    );
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? color : GalleryColors.surface,
        shape: shape,
        child: InkWell(
          customBorder: shape,
          onTap: onTap,
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            // widthFactor: 1 hace que la ficha mida lo que mide su texto.
            child: Center(
              widthFactor: 1,
              child: Text(
                label,
                style: GalleryText.chip.copyWith(
                  color: selected ? GalleryColors.surface : GalleryColors.ink,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tarjeta de una gráfica: miniatura, número, categoría y título.
class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.entry, required this.library});

  final GalleryEntry entry;
  final GalleryLibrary library;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: GalleryColors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: const BorderSide(color: GalleryColors.cardBorder),
      ),
      child: InkWell(
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute<void>(builder: entry.open)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 104,
              color: library.lightColor,
              alignment: Alignment.center,
              child: CustomPaint(
                size: const Size(150, 80),
                painter: GlyphPainter(glyph: entry.glyph, color: library.color),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          entry.number.toString().padLeft(2, '0'),
                          style: GalleryText.cardMeta,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            entry.category,
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GalleryText.cardMeta,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Flexible(
                      child: Text(
                        entry.displayTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GalleryText.cardTitle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
