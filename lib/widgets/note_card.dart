import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onTogglePin;
  final VoidCallback onDelete;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onTogglePin,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header tags row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (note.isPinned) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.tertiary,
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.push_pin, size: 12, color: AppColors.primaryDark),
                                SizedBox(width: 4),
                                Text(
                                  'Tersemat',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryDark),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                        _buildPriorityBadge(note.priority),
                      ],
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, size: 18, color: AppColors.onSurfaceVariant),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onSelected: (val) {
                        if (val == 'pin') onTogglePin();
                        if (val == 'delete') onDelete();
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'pin',
                          child: Row(
                            children: [
                              Icon(
                                note.isPinned ? Icons.push_pin_outlined : Icons.push_pin,
                                size: 16,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(note.isPinned ? 'Lepas Sematan' : 'Sematkan Catatan'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline, size: 16, color: Colors.redAccent),
                              SizedBox(width: 8),
                              Text('Hapus', style: TextStyle(color: Colors.redAccent)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Note Title
                Text(
                  note.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),

                const SizedBox(height: 4),

                // Note Content Excerpt
                Text(
                  note.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 12),

                // Metadata Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            note.category == 'Pekerjaan'
                                ? Icons.work_outline
                                : note.category == 'Tugas Kuliah'
                                    ? Icons.school_outlined
                                    : Icons.label_outline,
                            size: 14,
                            color: note.category == 'Pekerjaan' ? AppColors.primary : AppColors.secondary,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              note.category,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: note.category == 'Pekerjaan' ? AppColors.primary : AppColors.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(note.date),
                      style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(NotePriority priority) {
    Color bg;
    Color fg;
    Color dot;

    switch (priority) {
      case NotePriority.mendesak:
        bg = const Color(0xFFFFDAD6);
        fg = const Color(0xFFBA1A1A);
        dot = const Color(0xFFBA1A1A);
        break;
      case NotePriority.tinggi:
        bg = AppColors.surfaceContainerLow;
        fg = AppColors.onSurfaceVariant;
        dot = AppColors.primary;
        break;
      case NotePriority.sedang:
      case NotePriority.rendah:
        bg = AppColors.secondaryContainer.withValues(alpha: 0.35);
        fg = AppColors.primaryDark;
        dot = AppColors.secondary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 5, height: 5, decoration: BoxDecoration(color: dot, shape: BoxShape.circle)),
          const SizedBox(width: 4),
          Text(
            priority.label,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}, $hour:$minute';
  }
}
