import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/dummy_data.dart';
import '../models/note.dart';
import '../widgets/note_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Note> _notes;
  final _searchController = TextEditingController();

  String _searchQuery = '';
  String _selectedCategory = 'all';
  String _selectedTimeFilter = 'semua';

  final List<Map<String, String>> _categories = [
    {'id': 'all', 'label': 'Semua Kategori'},
    {'id': 'Tugas Kuliah', 'label': 'Tugas Kuliah'},
    {'id': 'Pekerjaan', 'label': 'Pekerjaan'},
    {'id': 'Pribadi', 'label': 'Pribadi'},
    {'id': 'Ide Kreatif', 'label': 'Ide Kreatif'},
    {'id': 'Keuangan', 'label': 'Keuangan'},
  ];

  final List<String> _timeFilters = ['Semua', 'Hari Ini', 'Minggu Ini', 'Bulan Ini', 'Arsip'];

  @override
  void initState() {
    super.initState();
    _notes = List.from(initialNotes);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Note> get _filteredNotes {
    return _notes.where((note) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchTitle = note.title.toLowerCase().contains(query);
        final matchContent = note.content.toLowerCase().contains(query);
        if (!matchTitle && !matchContent) return false;
      }

      // Category filter
      if (_selectedCategory != 'all' && note.category != _selectedCategory) {
        return false;
      }

      // Time filter
      if (_selectedTimeFilter != 'semua') {
        final now = DateTime.now();
        final startOfToday = DateTime(now.year, now.month, now.day);
        final noteDate = DateTime(note.date.year, note.date.month, note.date.day);
        final diffDays = startOfToday.difference(noteDate).inDays;

        if (_selectedTimeFilter == 'hari-ini') {
          if (diffDays != 0) return false;
        } else if (_selectedTimeFilter == 'minggu-ini') {
          if (diffDays < 0 || diffDays > 7) return false;
        } else if (_selectedTimeFilter == 'bulan-ini') {
          if (diffDays < 0 || diffDays > 30) return false;
        } else if (_selectedTimeFilter == 'arsip') {
          if (diffDays <= 30) return false;
        }
      }

      return true;
    }).toList();
  }

  void _togglePin(Note note) {
    setState(() {
      final index = _notes.indexWhere((n) => n.id == note.id);
      if (index != -1) {
        _notes[index] = note.copyWith(isPinned: !note.isPinned);
      }
    });
  }

  void _deleteNote(Note note) {
    setState(() {
      _notes.removeWhere((n) => n.id == note.id);
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Catatan "${note.title}" dihapus'),
        action: SnackBarAction(
          label: 'Batal',
          textColor: AppColors.secondaryContainer,
          onPressed: () {
            setState(() => _notes.insert(0, note));
          },
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _openDetail(Note note) async {
    final result = await Navigator.pushNamed(context, '/detail-note', arguments: note);
    if (result == 'delete') {
      _deleteNote(note);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pinnedNotes = _filteredNotes.where((n) => n.isPinned).toList();
    final unpinnedNotes = _filteredNotes.where((n) => !n.isPinned).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background.withValues(alpha: 0.9),
        elevation: 0,
        titleSpacing: 20,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.edit_note_rounded, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 8),
            const Text(
              'FNotes',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, size: 20, color: AppColors.onSurfaceVariant),
            tooltip: 'Keluar',
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryContainer,
              child: const Icon(Icons.person, size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Header
            const Text(
              'SENIN, 26 OKTOBER 2026',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Halo, Pengguna ✨',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
                letterSpacing: -0.4,
              ),
            ),

            const SizedBox(height: 16),

            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val.trim()),
                decoration: InputDecoration(
                  hintText: 'Cari catatan berdasarkan judul...',
                  hintStyle: const TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
                  prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.onSurfaceVariant),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.cancel, size: 18, color: AppColors.onSurfaceVariant),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Time Filter Horizontal Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _timeFilters.map((tf) {
                  final isSelected = _selectedTimeFilter == tf.toLowerCase().replaceAll(' ', '-');
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTimeFilter = tf.toLowerCase().replaceAll(' ', '-')),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.surfaceWhite,
                          borderRadius: BorderRadius.circular(9999),
                          border: Border.all(color: isSelected ? AppColors.primary : AppColors.outline),
                          boxShadow: isSelected
                              ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 6)]
                              : [],
                        ),
                        child: Text(
                          tf,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 10),

            // Category Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((c) {
                  final isSelected = _selectedCategory == c['id'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedCategory = c['id']!),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryContainer : AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (c['id'] == 'all')
                              Icon(Icons.grid_view_rounded, size: 14, color: isSelected ? Colors.white : AppColors.onSurfaceVariant)
                            else
                              Container(
                                width: 6,
                                height: 6,
                                margin: const EdgeInsets.only(right: 4),
                                decoration: BoxDecoration(
                                  color: c['id'] == 'Pekerjaan' ? AppColors.primary : AppColors.secondary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            const SizedBox(width: 4),
                            Text(
                              c['label']!,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Pinned Notes Section
            if (pinnedNotes.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.push_pin, size: 18, color: AppColors.primary),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Catatan Tersemat',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${pinnedNotes.length} Tersemat',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...pinnedNotes.map((note) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: NoteCard(
                      note: note,
                      onTap: () => _openDetail(note),
                      onTogglePin: () => _togglePin(note),
                      onDelete: () => _deleteNote(note),
                    ),
                  )),
              const SizedBox(height: 12),
            ],

            // Daily Notes List Section
            const Row(
              children: [
                Icon(Icons.description_outlined, size: 18, color: AppColors.primary),
                SizedBox(width: 6),
                Text(
                  'Daftar Catatan Harian',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (unpinnedNotes.isEmpty && pinnedNotes.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                alignment: Alignment.center,
                child: const Column(
                  children: [
                    Icon(Icons.search_off_rounded, size: 40, color: AppColors.outlineVariant),
                    SizedBox(height: 8),
                    Text(
                      'Tidak ada catatan yang cocok.',
                      style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
                    ),
                  ],
                ),
              )
            else
              ...unpinnedNotes.map((note) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: NoteCard(
                      note: note,
                      onTap: () => _openDetail(note),
                      onTogglePin: () => _togglePin(note),
                      onDelete: () => _deleteNote(note),
                    ),
                  )),

            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newNote = await Navigator.pushNamed(context, '/add-note') as Note?;
          if (!context.mounted) return;
          if (newNote != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Catatan "${newNote.title}" disimpan (Simulasi UI)'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded, size: 22),
        label: const Text('Catatan Baru', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
      ),
    );
  }
}
