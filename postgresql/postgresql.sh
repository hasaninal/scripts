#!/bin/bash

# PostgreSQL 17 kurulumu için otomatik betik
# Kullanım: sudo ./postgresql.sh

set -e

echo "PostgreSQL 17 kurulumu başlıyor..."

# Paket listelerini güncelle
echo "Paket listeleri güncelleniyor..."
sudo apt-get update -y

# Gerekli bağımlılıkları yükle
echo "Gerekli bağımlılıklar yükleniyor..."
sudo apt-get install -y wget gnupg ca-certificates

# PostgreSQL GPG anahtarını ekle
echo "PostgreSQL GPG anahtarı ekleniyor..."
wget -qO - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo gpg --dearmor -o /usr/share/keyrings/postgresql.gpg

# PostgreSQL deposunu ekle
echo "PostgreSQL deposu ekleniyor..."
echo "deb [signed-by=/usr/share/keyrings/postgresql.gpg] http://apt.postgresql.org/pub/repos/apt/ jammy-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list

# Paket listelerini yeniden güncelle
echo "Paket listeleri yeniden güncelleniyor..."
sudo apt-get update -y

# PostgreSQL 17'yi yükle
echo "PostgreSQL 17 yükleniyor..."
sudo apt-get install -y postgresql-17 postgresql-client-17

# PostgreSQL hizmetini başlat ve etkinleştir
echo "PostgreSQL hizmeti başlatılıyor ve etkinleştiriliyor..."
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Uzak bağlantıları etkinleştir
echo "Uzak bağlantılar için yapılandırma düzenleniyor..."
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/17/main/postgresql.conf

echo "pg_hba.conf dosyasına erişim kuralları ekleniyor..."
echo "host    all             all             0.0.0.0/0               md5" | sudo tee -a /etc/postgresql/17/main/pg_hba.conf
echo "host    all             all             ::/0                    md5" | sudo tee -a /etc/postgresql/17/main/pg_hba.conf

# PostgreSQL hizmetini yeniden başlat
echo "PostgreSQL hizmeti yeniden başlatılıyor..."
sudo systemctl restart postgresql

# Kurulumun tamamlandığını bildirin
echo "PostgreSQL 17 kurulumu başarıyla tamamlandı!"
echo "PostgreSQL sürümünü kontrol etmek için: psql --version"
