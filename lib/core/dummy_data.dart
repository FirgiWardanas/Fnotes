import '../models/note.dart';

final List<Note> dummyNotes = [
  Note(
    id: '1',
    title: 'Rencana Sprint Mingguan',
    content: 'Review backlog, selesaikan desain antarmuka mobile, dan sinkronisasi dengan tim UI/UX.',
    category: 'Pekerjaan',
    updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    isPinned: true,
  ),
  Note(
    id: '2',
    title: 'Ide Desain FNotes',
    content: 'Tampilan bersih, nuansa tosca dan mint, tanpa beban kognitif untuk pencatatan cepat.',
    category: 'Ide',
    updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
    isPinned: true,
  ),
  Note(
    id: '3',
    title: 'Daftar Belanja Akhir Pekan',
    content: 'Kopi biji arabika, susu oat, roti gandum, dan camilan sehat.',
    category: 'Pribadi',
    updatedAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  Note(
    id: '4',
    title: 'Buku Yang Perlu Dibaca',
    content: 'Make Time karya Jake Knapp & John Zeratsky. Atomic Habits karya James Clear.',
    category: 'Belajar',
    updatedAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
];
