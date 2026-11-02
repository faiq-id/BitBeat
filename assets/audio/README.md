# 🎵 Audio Assets Directory

Folder ini digunakan untuk menyimpan file audio/musik lokal yang diputar oleh aplikasi **BitBeat**.

> **Catatan Lisensi & Hak Cipta:**  
> File audio (`.mp3`, `.wav`, dll.) sengaja diabaikan oleh Git (`.gitignore`) demi kepatuhan terhadap hak cipta serta menjaga ukuran repositori tetap ringan.

---

### 📥 Panduan Cara Mengisi Audio ke Aplikasi

Untuk menambahkan lagu agar dapat diputar di aplikasi:

1. **Tambahkan File Audio**:
   - Letakkan file audio favorit Anda yang berformat `.mp3` langsung ke dalam folder ini (`assets/audio/`).
   
2. **Daftarkan di `pubspec.yaml`**:
   - Pastikan path file atau folder audio terdaftar pada bagian `flutter -> assets` di file `pubspec.yaml`:
     ```yaml
     flutter:
       assets:
         - assets/audio/
     ```

3. **Sinkronisasi Kode Playlist**:
   - Daftarkan nama file audio pada daftar lagu / playlist aplikasi (misalnya pada file repository/bloc player).

4. **Jalankan Ulang Aplikasi**:
   - Lakukan `flutter run` atau restart aplikasi agar aset audio yang baru ditambahkan terbaca secara sempurna.
