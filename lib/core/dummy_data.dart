import '../models/note.dart';

List<Note> getInitialNotes() {
  final now = DateTime.now();
  return [
    // Pinned Notes
    Note(
      id: 'p1',
      title: 'Finalisasi Pitch Deck Q4 & Peluncuran MVP',
      content: 'Perlu review ulang metrik konversi user onboard, sinkronisasi grafik cash flow mingguan bersama tim finance, serta testing prototype mobile v2.1.',
      category: 'Pekerjaan',
      priority: NotePriority.mendesak,
      date: now,
      isPinned: true,
    ),
    Note(
      id: 'p2',
      title: 'Riset Metodologi & Studi Kasus Skripsi',
      content: 'Pengumpulan referensi jurnal terkait model evaluasi sistem dan penyusunan kuesioner pengujian usability testing.',
      category: 'Tugas Kuliah',
      priority: NotePriority.tinggi,
      date: now.subtract(const Duration(hours: 3)),
      isPinned: true,
    ),

    // Daily Notes
    Note(
      id: 'd1',
      title: 'Rencana Aplikasi Mobile',
      content: 'Penyusunan kerangka kerja aplikasi, wireframe user flows, serta seleksi palet warna toska untuk pengalaman visual yang jernih.',
      category: 'Tugas Kuliah',
      priority: NotePriority.rendah,
      date: now,
      isPinned: false,
    ),
    Note(
      id: 'd2',
      title: 'Analisis Algoritma Machine Learning (Tugas 4)',
      content: 'Review perbandingan performa XGBoost vs Random Forest pada dataset prediksi churn nasabah. Menyertakan matriks F1-score dan AUC-ROC chart.',
      category: 'Tugas Kuliah',
      priority: NotePriority.mendesak,
      date: now.subtract(const Duration(days: 2)),
      isPinned: false,
    ),
    Note(
      id: 'd3',
      title: 'Catatan Rapat Sinkronisasi Sprint 12',
      content: 'Perubahan dependensi library Tailwind, implementasi skema warna safe teal, serta migrasi API endpoint ke GraphQL v2 terjadwal akhir bulan.',
      category: 'Pekerjaan',
      priority: NotePriority.tinggi,
      date: now.subtract(const Duration(days: 12)),
      isPinned: false,
    ),
    Note(
      id: 'd4',
      title: 'Konsep UI/UX Micro-Interactions 2026',
      content: 'Eksplorasi dynamic spring animations, fluid gesture navigation, dan kartu adaptif untuk aplikasi produktivitas harian.',
      category: 'Ide Kreatif',
      priority: NotePriority.sedang,
      date: now.subtract(const Duration(days: 4)),
      isPinned: false,
    ),
    Note(
      id: 'd5',
      title: 'Jadwal Olahraga & Rutinitas Pagi',
      content: 'Lari pagi 30 menit setiap Selasa dan Kamis, diselingi latihan core dan hidrasi teratur untuk menjaga stamina.',
      category: 'Pribadi',
      priority: NotePriority.rendah,
      date: now.subtract(const Duration(days: 1)),
      isPinned: false,
    ),
    Note(
      id: 'd6',
      title: 'Anggaran Operasional & Pengeluaran Bulanan',
      content: 'Rekapitulasi biaya langganan cloud storage, server dev, dan alokasi dana darurat kuartal akhir.',
      category: 'Keuangan',
      priority: NotePriority.sedang,
      date: now.subtract(const Duration(days: 6)),
      isPinned: false,
    ),
    Note(
      id: 'd7',
      title: 'Ringkasan Materi Sistem Terdistribusi',
      content: 'Konsep konsensus Raft vs Paxos, partisi jaringan, dan model konsistensi eventual consistency pada database skala besar.',
      category: 'Tugas Kuliah',
      priority: NotePriority.sedang,
      date: now.subtract(const Duration(days: 40)),
      isPinned: false,
    ),
  ];
}

final List<Note> initialNotes = getInitialNotes();
