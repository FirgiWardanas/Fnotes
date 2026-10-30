import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/note.dart';

class AddNoteScreen extends StatefulWidget {
  final Note? note;
  const AddNoteScreen({super.key, this.note});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _newCategoryController = TextEditingController();

  final List<String> _icons = ['🌱', '💡', '📌', '🚀', '🎯', '📚', '☕'];
  int _iconIndex = 0;

  final List<String> _categories = [
    'Tugas Kuliah',
    'Pekerjaan',
    'Pribadi',
    'Ide Kreatif',
    'Keuangan',
  ];
  late String _selectedCategory;

  NotePriority _selectedPriority = NotePriority.rendah;
  bool _isPinned = false;
  bool _showNewCategoryInput = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _selectedCategory = _categories.first;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final existing = widget.note ?? ModalRoute.of(context)?.settings.arguments as Note?;
      if (existing != null) {
        _titleController.text = existing.title;
        _contentController.text = existing.content;
        _selectedPriority = existing.priority;
        _isPinned = existing.isPinned;
        if (!_categories.contains(existing.category)) {
          _categories.add(existing.category);
        }
        _selectedCategory = existing.category;
      }
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _newCategoryController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Judul catatan wajib diisi'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    final existing = widget.note ?? ModalRoute.of(context)?.settings.arguments as Note?;
    final savedNote = Note(
      id: existing?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: _contentController.text.trim().isEmpty
          ? 'Tidak ada rincian catatan.'
          : _contentController.text.trim(),
      category: _selectedCategory,
      priority: _selectedPriority,
      date: DateTime.now(),
      isPinned: _isPinned,
    );

    Navigator.pop(context, savedNote);
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          (widget.note != null || (ModalRoute.of(context)?.settings.arguments is Note))
              ? 'Ubah Catatan'
              : 'Tambah Catatan',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        actions: [
          // Save button (mint badge with check)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: InkWell(
              onTap: _saveNote,
              borderRadius: BorderRadius.circular(9999),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 20, color: AppColors.primaryDark),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Discard / Clear button
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.onSurfaceVariant),
            onPressed: () => Navigator.pop(context),
            tooltip: 'Hapus Draf',
          ),

          // More Options Popup
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.onSurfaceVariant),
            onSelected: (val) {
              if (val == 'pin') {
                setState(() => _isPinned = !_isPinned);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_isPinned ? 'Catatan akan disematkan' : 'Sematan dilepas'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'pin',
                child: Row(
                  children: [
                    Icon(
                      _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(_isPinned ? 'Lepas Sematan' : 'Sematkan di paling atas'),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'image',
                child: Row(
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text('Tambah gambar / media'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final minEditorCardHeight = (constraints.maxHeight - 310) > 300
              ? (constraints.maxHeight - 310)
              : 300.0;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Section 1: Note Identity & Metadata Card
                Container(
                  padding: const EdgeInsets.all(16),
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
                  // Emoji Picker Icon
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _iconIndex = (_iconIndex + 1) % _icons.length;
                      });
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(_icons[_iconIndex], style: const TextStyle(fontSize: 24)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Main Title Input
                  TextField(
                    controller: _titleController,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Judul Catatan...',
                      hintStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.outlineVariant,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),

                  const Divider(color: AppColors.outline),

                  // Metadata Rows
                  const SizedBox(height: 6),

                  // Date Row
                  Row(
                    children: [
                      const SizedBox(
                        width: 90,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.schedule, size: 16, color: AppColors.onSurfaceVariant),
                            SizedBox(width: 6),
                            Flexible(
                              child: Text('Dibuat', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${DateTime.now().day} Okt ${DateTime.now().year}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.onSurface),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Priority Selector Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 90,
                        child: Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.flag_outlined, size: 16, color: AppColors.onSurfaceVariant),
                              SizedBox(width: 6),
                              Flexible(
                                child: Text('Prioritas', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: NotePriority.values.map((p) {
                            final isSelected = _selectedPriority == p;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedPriority = p),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  p.label,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Category Selector Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 90,
                        child: Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.category_outlined, size: 16, color: AppColors.onSurfaceVariant),
                              SizedBox(width: 6),
                              Flexible(
                                child: Text('Kategori', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton<String>(
                                value: _selectedCategory,
                                isExpanded: true,
                                underline: const SizedBox(),
                                icon: const Icon(Icons.expand_more, size: 18, color: AppColors.primary),
                                items: _categories.map((c) {
                                  return DropdownMenuItem(
                                    value: c,
                                    child: Text(c, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedCategory = val);
                                },
                              ),
                            ),
                            const SizedBox(height: 6),
                            if (_showNewCategoryInput) ...[
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _newCategoryController,
                                      style: const TextStyle(fontSize: 12),
                                      decoration: InputDecoration(
                                        hintText: 'Kategori baru...',
                                        hintStyle: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                        isDense: true,
                                        filled: true,
                                        fillColor: AppColors.surfaceContainerLow,
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  TextButton(
                                    onPressed: () {
                                      final text = _newCategoryController.text.trim();
                                      if (text.isNotEmpty && !_categories.contains(text)) {
                                        setState(() {
                                          _categories.add(text);
                                          _selectedCategory = text;
                                          _newCategoryController.clear();
                                          _showNewCategoryInput = false;
                                        });
                                      }
                                    },
                                    child: const Text('Simpan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                                  ),
                                ],
                              ),
                            ] else
                              GestureDetector(
                                onTap: () => setState(() => _showNewCategoryInput = true),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.add, size: 14, color: AppColors.primary),
                                      SizedBox(width: 4),
                                      Text('Kategori Baru', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary)),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Section 2: Note Content Card
            Container(
              constraints: BoxConstraints(minHeight: minEditorCardHeight),
              padding: const EdgeInsets.all(16),
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
                  const SizedBox(height: 12),

                  // Multiline Note Editor
                      TextField(
                        controller: _contentController,
                        maxLines: null,
                        style: const TextStyle(fontSize: 14, color: AppColors.onSurface, height: 1.5),
                        decoration: const InputDecoration(
                          hintText: 'Mulai ketik catatan harianmu di sini...',
                          hintStyle: TextStyle(fontSize: 14, color: AppColors.outlineVariant),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
