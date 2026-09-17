# LKPD 1 - Dasar Docker dan Web Server HTTP

## Petunjuk Awal
Instance/mesin yang digunakan adalah Ubuntu/Debian.

## Langkah Kerja

### 1. Update dan install docker.io
```bash
sudo apt update && apt install -y docker.io
```

Cek apakah docker sudah active running:
```bash
sudo systemctl status docker
```

Jika belum active running, jalankan:
```bash
sudo systemctl start docker
sudo systemctl enable docker
```

### 2. Ubah agar user Anda bisa akses docker tanpa sudo
```bash
sudo usermod -aG docker $USERMU
sudo newgrp docker
```

Contoh jika usernya "deri":
```bash
sudo usermod -aG docker deri
sudo newgrp docker
```

### 3. Sekarang docker dapat dijalankan tanpa sudo
```bash
docker --version
docker -v
docker run hello-world
```

### 4. Buat direktori lokal yang akan di-mounting ke dalam container
```bash
sudo mkdir -p /var/mywww
```

Clone repository ini ke dalam direktori tersebut:
```bash
cd /var/mywww
git clone https://github.com/Deri-Nugroho/docker-1.git .
```

File `index.html` akan otomatis terisi tanpa perlu input manual.

### 5. Jalankan image httpd:alpine sebagai container web-http yang listen di port 8080 lokal

**PENTING:** Jika ada container dengan nama yang sama atau port 8080 sudah digunakan, hapus dulu:
```bash
docker stop web-http 2>/dev/null || true
docker rm web-http 2>/dev/null || true
```

```bash
docker run -d --name web-http -p 8080:80 -v /var/mywww:/usr/local/apache2/htdocs httpd:alpine
```

### 6. Coba start dan stop container web-http
```bash
docker stop web-http
docker start web-http
```

## Pilihan Image Web Server Lain

### httpd:latest (~145 MB)

**PENTING:** Hapus container yang ada sebelum membuat yang baru:
```bash
docker stop web-http 2>/dev/null || true
docker rm web-http 2>/dev/null || true
```

```bash
docker run -d \
  --name web-http \
  -p 8080:80 \
  -v /var/mywww:/var/www/html \
  -w /var/www/html \
  httpd:latest
```

### php:apache (~450 MB+, sudah lengkap Apache2 + PHP)

**PENTING:** Hapus container yang ada sebelum membuat yang baru:
```bash
docker stop web-http 2>/dev/null || true
docker rm web-http 2>/dev/null || true
```

```bash
docker run -d \
  --name web-http \
  -p 8080:80 \
  -v /var/mywww:/var/www/html \
  php:apache
```

### LAMPP (PHP + MySQL Server)

**PENTING:** Hapus container yang ada sebelum membuat yang baru:
```bash
docker stop web-http 2>/dev/null || true
docker rm web-http 2>/dev/null || true
docker stop lamp-all 2>/dev/null || true
docker rm lamp-all 2>/dev/null || true
```

```bash
docker pull cto4/aio:latest
docker run -d --name lamp-all \
  -p 8080:80 \
  -p 8081:8080 \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=admin123 \
  -v $(pwd)/src:/var/www/localhost/htdocs \
  -v $(pwd)/db-data:/run/mysqld \
  cto4/aio:latest
```

## Membuat Custom Image dengan docker commit

**PENTING:** Hapus container ubuntu yang ada sebelum membuat yang baru:
```bash
docker stop ubuntu 2>/dev/null || true
docker rm ubuntu 2>/dev/null || true
```

```bash
docker pull ubuntu:24.04
docker images ubuntu
docker run -d --name ubuntu ubuntu:24.04 tail -f /dev/null
docker exec -it ubuntu bash
```

### Konfigurasi di dalam Container

Setelah masuk ke dalam container, lakukan konfigurasi berikut:

**Opsi 1: Menggunakan script otomatis**
```bash
# Copy script dari repository (jika sudah di-clone ke /var/mywww)
cp /var/mywww/setup-ubuntu-container.sh /tmp/
chmod +x /tmp/setup-ubuntu-container.sh
bash /tmp/setup-ubuntu-container.sh
```

**Opsi 2: Manual step-by-step**
```bash
# 1. Update package lists
apt update

# 2. Install basic utilities
apt install -y curl wget vim git

# 3. Install Apache web server
apt install -y apache2

# 4. Install PHP dan modul
apt install -y php php-mysql php-curl php-gd php-mbstring php-xml php-zip

# 5. Konfigurasi Apache
a2enmod rewrite

# 6. Buat halaman index
echo "<h1>Hello dari Custom Ubuntu Container</h1>" > /var/www/html/index.html
echo "<p>Container ini dikonfigurasi dengan Apache + PHP</p>" >> /var/www/html/index.html

# 7. Buat file PHP info untuk testing
echo "<?php phpinfo(); ?>" > /var/www/html/info.php

# 8. Start Apache
service apache2 start
```

Setelah selesai melakukan konfigurasi di dalam container, **KELUAR DULU** dari container:
```bash
exit
```

Kemudian jalankan commit dari host machine (bukan dari dalam container):
```bash
docker commit ubuntu ubuntu-custom:v1
```

Cek dengan:
```bash
docker image ls
```

## Akses Web Server

Setelah container berjalan, akses web server melalui browser di:
```
http://localhost:8080
```

Atau jika menggunakan instance remote:
```
http://<IP-INSTANCE>:8080
```
