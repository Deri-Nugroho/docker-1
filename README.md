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
```bash
docker run -d \
  --name web-http \
  -p 8080:80 \
  -v /var/mywww:/var/www/html \
  -w /var/www/html \
  httpd:latest
```

### php:apache (~450 MB+, sudah lengkap Apache2 + PHP)
```bash
docker run -d \
  --name web-http \
  -p 8080:80 \
  -v /var/mywww:/var/www/html \
  php:apache
```

### LAMPP (PHP + MySQL Server)
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

```bash
docker pull ubuntu:24.04
docker images ubuntu
docker run -d --name ubuntu ubuntu:24.04 tail -f /dev/null
docker exec -it ubuntu bash
```

Setelah melakukan konfigurasi di dalam container:

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
