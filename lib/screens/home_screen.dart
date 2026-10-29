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
  late List<Note> notes;
  String selectedCategory = 'Semua';

  final List<String> categories = ['Semua', 'Pekerjaan', 'Ide', 'Pribadi', 'Belajar'];

  @override
  void initState() {
    super.initState();
    notes = List.from(dummyNotes);
  }

  @override
  Widget build(BuildContext context) {
    final filtered = selectedCategory == 'Semua'
        ? notes
        : notes.where((n) => n.category == selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Catatan Harian',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            Text(
              'FNotes • Ruang Ide',
              style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.onSurfaceVariant),
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.outline),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, size: 20, color: AppColors.onSurfaceVariant),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari catatan...',
                        hintStyle: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Category Chips
          SizedBox(
            height: 38,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final cat = categories[i];
                final isSelected = cat == selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() => selectedCategory = cat),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surfaceWhite,
                      borderRadius: BorderRadius.circular(9999),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.outline,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Notes List
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      'Belum ada catatan di kategori ini.',
                      style: TextStyle(color: AppColors.onSurfaceVariant),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final item = filtered[i];
                      return NoteCard(
                        note: item,
                        onTap: () {
                          Navigator.pushNamed(context, '/detail-note', arguments: item);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 3,
        onPressed: () async {
          final newNote = await Navigator.pushNamed(context, '/new-note') as Note?;
          if (newNote != null) {
            setState(() {
              notes.insert(0, newNote);
            });
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Catat', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}
