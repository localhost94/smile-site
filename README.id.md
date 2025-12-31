# Dokumentasi Platform SMILE

Repository ini berisi dokumentasi untuk platform SMILE (Sistem Monitoring Imunisasi dan Logistik Secara Elektronik) Digital Public Good (DPG).

## Ikhtisar

SMILE adalah platform manajemen logistik komprehensif yang dikembangkan bersama oleh Kementerian Kesehatan Indonesia dan UNDP Indonesia. Sejak awal berdiri pada tahun 2018, SMILE telah berkembang menjadi Digital Public Good yang kuat yang mengatasi beberapa Tujuan Pembangunan Berkelanjutan (SDGs).

## Struktur Dokumentasi

### Dokumentasi Inti

- **[Pelacak Tugas DPG](docs/dpg/tasks-tracker.md)** - Lacak tugas langsung, persyaratan tata kelola, dan bukti yang diperlukan untuk persiapan dan kepatuhan DPG
  - [Lihat sebagai HTML](assets/html/dpg-tasks-tracker.html) (GitHub Pages)
- **[Infrastruktur Cloud](docs/cloud-infrastructure.md)** - Arsitektur dan penyiapan terperinci infrastruktur cloud SMILE di AWS
  - [Lihat sebagai HTML](assets/html/cloud-infrastructure.html) (GitHub Pages)
- **[Mekanisme Streaming Data](docs/data-streaming.md)** - Dokumentasi arsitektur streaming data SMILE
  - [Lihat sebagai HTML](assets/html/data-streaming.html) (GitHub Pages)
- **[Panduan Deploy dan Instalasi](docs/deployment-guide.md)** - Panduan komprehensif untuk deploying SMILE5 di AWS
  - [Lihat sebagai HTML](assets/html/deployment-guide.html) (GitHub Pages)
- **[Dokumen Ikhtisar Teknis](docs/technical-overview.md)** - Dokumentasi teknis terpusat yang mencakup teknologi, kerangka kerja, dan infrastruktur
  - [Lihat sebagai HTML](assets/html/technical-overview.html) (GitHub Pages)

## Dukungan Bahasa

Situs ini mendukung dua bahasa:
- **Bahasa Inggris** (default)
- **Bahasa Indonesia**

Untuk beralih bahasa, gunakan pemilih bahasa di sudut kanan atas halaman. Dokumentasi juga tersedia dalam versi bahasa Indonesia di folder `docs/id/`.

## Memulai

1. Clone repository ini
2. Navigasi ke direktori `site`
3. Buka `index.html` di browser Anda untuk melihat hub dokumentasi
4. Akses dokumen sebagai sumber markdown atau versi HTML yang di-render
5. Deploy ke GitHub Pages atau platform hosting pilihan Anda

## Pengembangan Lokal

### Menggunakan Jekyll

```bash
# Install Jekyll dan dependensi
gem install jekyll bundler

# Navigasi ke direktori site
cd site

# Install dependensi
bundle install

# Serve lokal
bundle exec jekyll serve
```

### Menggunakan Python (Simple HTTP Server)

```bash
# Navigasi ke direktori site
cd site

# Mulai HTTP server sederhana
python -m http.server 8000
```

Kemudian kunjungi `http://localhost:8000` di browser Anda.

## GitHub Pages

Situs ini dikonfigurasi untuk bekerja dengan GitHub Pages. Untuk deploy:

1. Push repository ke GitHub
2. Aktifkan GitHub Pages di pengaturan repository
3. Pilih branch main sebagai sumber
4. Situs akan tersedia di `https://usernameanda.github.io/nama-repository`

## Berkontribusi

1. Fork repository
2. Buat branch fitur
3. Lakukan perubahan Anda
4. Submit pull request

## Lisensi

Proyek ini adalah bagian dari inisiatif Digital Public Good SMILE.

## Kontak

Untuk pertanyaan atau dukungan mengenai dokumentasi platform SMILE, silakan hubungi tim pengembang.
