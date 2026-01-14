# Rizky Maulana Web Panel

**Rizky Maulana Web Panel** adalah panel manajemen server berbasis web yang mudah digunakan untuk mengelola Apache dan tugas server lainnya. Panel ini memiliki antarmuka yang sederhana dan dapat dikustomisasi sesuai kebutuhan Anda.

## Fitur

- **Instalasi dan penghapusan Apache web panel secara otomatis**.
- **Halaman login yang responsif** dengan desain yang menarik.
- **Keamanan terintegrasi** untuk Apache menggunakan skrip otomatis.

---

## Daftar Isi

1. [Instalasi](#instalasi)
    - [Instalasi Web Panel](#instalasi-web-panel)
    - [Akses Halaman Login](#akses-halaman-login)
2. [Penghapusan Web Panel](#penghapusan-web-panel)

---

## Instalasi

Ikuti langkah-langkah di bawah ini untuk menginstal **Rizky Maulana Web Panel** pada server Debian, Ubuntu, atau Linux Mint.

### Instalasi Web Panel

1. **Siapkan server** dengan sistem operasi **Debian**, **Ubuntu**, atau **Linux Mint**.
2. **Login sebagai root** atau pastikan Anda menggunakan `sudo` untuk menjalankan perintah.

   Jalankan perintah berikut untuk menginstal **Rizky Maulana Web Panel**:

    ```bash
    wget -qO- https://raw.githubusercontent.com/cmdecho/apache-secure-installer/main/install_apache_secure.sh | sudo bash
    ```

    Perintah ini akan:
    - Menginstal **Apache**, **PHP**, dan beberapa paket yang diperlukan.
    - Mengonfigurasi Apache dengan pengaturan keamanan yang disarankan.

3. **Verifikasi Instalasi**  
   Setelah instalasi selesai, Anda dapat mengakses panel web melalui browser Anda di:


**Login menggunakan**:
- Username: `admin`
- Password: `RIZKY`

### Akses Halaman Login

Setelah instalasi, Anda dapat mengakses halaman login melalui URL berikut:

[http://localhost/rizky_web/login.php](http://localhost/rizky_web/login.php)

Halaman ini memungkinkan Anda untuk masuk ke dalam panel dan mulai mengelola server Anda.

---

## Penghapusan Web Panel

Jika Anda ingin menghapus **Rizky Maulana Web Panel** dan semua komponennya, jalankan perintah berikut:

```bash
wget -qO- https://raw.githubusercontent.com/cmdecho/apache-secure-installer/main/remove_apache_webpanel.sh | sudo bash

   
