import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/note.dart';

class DetailNoteScreen extends StatefulWidget {
  final Note? note;
  const DetailNoteScreen({super.key, this.note});

  @override
  State<DetailNoteScreen> createState() => _DetailNoteScreenState();
}

class _DetailNoteScreenState extends State<DetailNoteScreen> {
  late Note _note;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final argNote = ModalRoute.of(context)?.settings.arguments as Note?;
      _note = widget.note ??
          argNote ??
          Note(
            id: 'fallback',
            title: 'Catatan Tidak Ditemukan',
            content: 'Detail catatan tidak tersedia.',
            category: 'Umum',
            priority: NotePriority.rendah,
            date: DateTime.now(),
          );
      _initialized = true;
    }
  }

  void _togglePin() {
    setState(() {
      _note = _note.copyWith(isPinned: !_note.isPinned);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_note.isPinned ? 'Catatan disematkan' : 'Sematan dilepas'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: Color(0xFFFFDAD6),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete_forever, size: 28, color: Color(0xFFBA1A1A)),
            ),
            const SizedBox(height: 14),
            const Text(
              'Hapus Catatan Ini?',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.onSurface),
            ),
            const SizedBox(height: 8),
            const Text(
              'Catatan yang dihapus tidak dapat dipulihkan kembali.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context, 'delete');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFBA1A1A),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Hapus', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Future<void> _openEditScreen() async {
    final updated = await Navigator.pushNamed(
      context,
      '/add-note',
      arguments: _note,
    ) as Note?;
    if (!mounted) return;

    if (updated != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perubahan catatan disimpan (Simulasi UI)'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String _formatDate(DateTime d) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    final hour = d.hour.toString().padLeft(2, '0');
    final min = d.minute.toString().padLeft(2, '0');
    return '${d.day} ${months[d.month - 1]} ${d.year}, $hour:$min WIB';
  }

  Color _priorityBg(NotePriority p) {
    switch (p) {
      case NotePriority.mendesak:
      case NotePriority.tinggi:
        return const Color(0xFFFFDAD6);
      case NotePriority.sedang:
        return const Color(0xFFFEF3C7);
      case NotePriority.rendah:
        return AppColors.tertiary;
    }
  }

  Color _priorityFg(NotePriority p) {
    switch (p) {
      case NotePriority.mendesak:
      case NotePriority.tinggi:
        return const Color(0xFFBA1A1A);
      case NotePriority.sedang:
        return const Color(0xFFD97706);
      case NotePriority.rendah:
        return AppColors.primaryDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface.withValues(alpha: 0.9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.pop(context, _note),
        ),
        title: const Text(
          'Detail Catatan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.onSurface),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
              color: _note.isPinned ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
            tooltip: _note.isPinned ? 'Lepas Sematan' : 'Sematkan Catatan',
            onPressed: _togglePin,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Floating Utility Sub-Bar (Category & Edit/Delete actions)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.folder, size: 14, color: AppColors.primary),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _note.category.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Edit Button
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.primary),
                      onPressed: _openEditScreen,
                      tooltip: 'Ubah Catatan',
                    ),
                    // Delete Button
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20, color: Color(0xFFBA1A1A)),
                      onPressed: _showDeleteDialog,
                      tooltip: 'Hapus Catatan',
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Card Utama Detail Catatan
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.outline),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Row with Icon
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.description, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _note.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.schedule, size: 14, color: AppColors.onSurfaceVariant),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Terakhir diedit: ${_formatDate(_note.date)}',
                                    style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Properties Grid
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        // Prioritas
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.flag_outlined, size: 16, color: AppColors.onSurfaceVariant),
                                SizedBox(width: 6),
                                Text('Prioritas', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w500)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _priorityBg(_note.priority),
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              child: Text(
                                _note.priority.label,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: _priorityFg(_note.priority),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 16, color: AppColors.outline),
                        // Kategori Tag
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.folder_special_outlined, size: 16, color: AppColors.onSurfaceVariant),
                                SizedBox(width: 6),
                                Text('Kategori Tag', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w500)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceWhite,
                                borderRadius: BorderRadius.circular(9999),
                                border: Border.all(color: AppColors.outline),
                              ),
                              child: Text(
                                _note.category,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Divider(color: AppColors.outline),
                  const SizedBox(height: 12),

                  // Content Section
                  const Row(
                    children: [
                      Icon(Icons.edit_note_rounded, size: 20, color: AppColors.primary),
                      SizedBox(width: 6),
                      Text(
                        'Isi Catatan',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Text(
                    _note.content,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.onSurface,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
