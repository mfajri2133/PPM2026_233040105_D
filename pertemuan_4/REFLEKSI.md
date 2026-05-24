# Jawaban Pertanyaan Refleksi — Pertemuan 3

Dokumen ini berisi jawaban lengkap untuk pertanyaan refleksi yang ada pada **Modul Pertemuan 3 — Stateful Widget, Form, & Navigation**.

---

### 1. Apa beda StatelessWidget dan StatefulWidget? Sebutkan satu contoh konkret kapan masing-masing dipakai.
* **StatelessWidget**: Widget yang bersifat statis atau tidak berubah setelah dibangun (rendered). Widget ini tidak memiliki *state* internal yang dapat dimutasi selama masa hidupnya.
  * **Contoh Konkret**: Widget `DetailCatatanPage` yang hanya menampilkan informasi catatan (judul, isi, kategori) yang di-passing dari halaman sebelumnya. Data tersebut hanya dibaca dan tidak diubah di dalam halaman tersebut.
* **StatefulWidget**: Widget yang dinamis dan dapat berubah tampilannya secara real-time. Widget ini memiliki objek `State` yang menyimpan data yang dapat berubah, dan perubahannya memicu pembangunan ulang (*rebuild*) dari UI widget tersebut.
  * **Contoh Konkret**: `HomePage` yang menampung daftar (list) catatan mahasiswa. Ketika pengguna menambah atau menghapus catatan, list data tersebut berubah dan UI perlu diperbarui agar menampilkan data terbaru.

---

### 2. Mengapa kita harus memanggil `setState()` saat mengubah data? Apa yang terjadi kalau lupa?
* **Mengapa harus memanggil `setState()`**: `setState()` adalah metode yang memberi tahu Flutter framework bahwa state internal dari objek tersebut telah berubah. Flutter kemudian akan menjadwalkan pemanggilan ulang metode `build()` untuk menggambar ulang (re-render) UI berdasarkan nilai state yang baru.
* **Apa yang terjadi jika lupa**: Data atau variabel internal di memori memang akan berubah, tetapi **UI tidak akan diperbarui (re-render)**. Akibatnya, perubahan data tersebut tidak akan terlihat oleh pengguna sampai ada pemicu rebuild lain (seperti hot reload manual atau pergantian orientasi layar).

---

### 3. Apa fungsi `GlobalKey<FormState>`? Mengapa tidak cukup `TextEditingController` saja?
* **Fungsi `GlobalKey<FormState>`**: Berfungsi sebagai *remote control* atau identifier unik global untuk widget `Form`. Melalui key ini, kita bisa mengakses keadaan internal dari `FormState`, seperti memanggil `_formKey.currentState!.validate()` untuk memicu validasi pada seluruh `TextFormField` di dalam form, atau `save()` dan `reset()`.
* **Mengapa tidak cukup `TextEditingController` saja**:
  * `TextEditingController` hanya mengontrol nilai teks dari satu field input tertentu (membaca input, mengatur text default, membersihkan field).
  * `TextEditingController` tidak memiliki kemampuan untuk melakukan validasi form secara kolektif, menampilkan pesan error merah di bawah field, memeriksa apakah semua input sudah valid, atau mengelola fokus antar field. `Form` dan `GlobalKey<FormState>` bertindak sebagai orkestrator untuk seluruh input field tersebut.

---

### 4. Mengapa `TextEditingController` perlu di-`dispose()`?
* `TextEditingController` membuat koneksi ke level sistem untuk mendengarkan perubahan input teks.
* Jika controller tidak dihancurkan (*dispose*) ketika widget dihapus dari pohon widget (misalnya saat berpindah halaman atau menutup modal), controller tersebut akan tetap berada di memori dan terus mendengarkan event input. Hal ini menyebabkan kebocoran memori (**memory leak**) yang dapat menurunkan performa aplikasi atau menyebabkan crash jika aplikasi dibiarkan berjalan lama.

---

### 5. Apa beda `Navigator.push` dengan `Navigator.pushNamed`? Kapan pakai yang mana?
* **`Navigator.push`**:
  * Cara kerja: Menerima objek `Route` (biasanya `MaterialPageRoute`) secara eksplisit dan membangun halaman target secara langsung (anonymous routing).
  * Kapan digunakan: Ketika membuat aplikasi skala kecil, atau saat ingin melakukan navigasi cepat/ad-hoc ke halaman tertentu yang tidak sering diakses atau tidak memerlukan struktur rute yang kompleks.
* **`Navigator.pushNamed`**:
  * Cara kerja: Menerima string nama rute yang telah didaftarkan sebelumnya di `MaterialApp` (misalnya `'/tambah'` atau `'/detail'`).
  * Kapan digunakan: Ketika membangun aplikasi skala menengah hingga besar agar pengelolaan rute lebih rapi, terpusat, dan terstruktur. Ini memudahkan pemeliharaan kode (maintenance) dan mendukung penanganan rute dinamis melalui `onGenerateRoute`.

---

### 6. Bagaimana cara mengirim data balik dari halaman B ke halaman A?
* Di Halaman B, gunakan `Navigator.pop` dengan menyertakan argumen kedua berisi data yang ingin dikirim kembali:
  ```dart
  Navigator.pop(context, dataYangDikirimBalik);
  ```
* Di Halaman A (tempat memanggil Halaman B), tangkap nilai tersebut dengan menggunakan kata kunci `await` karena operasi navigasi bersifat asinkron:
  ```dart
  final hasil = await Navigator.pushNamed(context, '/tambah');
  if (hasil != null) {
    // Lakukan sesuatu dengan data 'hasil'
  }
  ```

---

### 7. Mengapa kita perlu cek `if (!mounted) return;` setelah `await`?
* Metode asinkron (`await`) membutuhkan waktu untuk diselesaikan. Selama waktu tunggu tersebut, pengguna bisa saja menekan tombol kembali (*back*) atau menutup halaman tempat kode tersebut berada, sehingga objek `State` dari widget tersebut dihancurkan (*unmounted*).
* Jika kita mencoba berinteraksi dengan `BuildContext` (seperti menampilkan `SnackBar` via `ScaffoldMessenger.of(context)`) pada widget yang sudah tidak terpasang di pohon widget (*unmounted*), Flutter akan melempar error pengecualian runtime.
* Pemeriksaan `if (!mounted) return;` memastikan bahwa widget masih aktif dan terpasang di layar sebelum kita memproses kode yang membutuhkan `BuildContext`.
