#!/bin/bash

# VALKEY INSTALL
sudo apt-get update -y
sudo apt install -y build-essential tcl

git clone https://github.com/valkey-io/valkey.git
cd valkey
git checkout 8.0
make
# Optionally, you can run the tests:
make test
cd ..


# KVROCKS INSTALL
sudo apt-get update -y
sudo apt install -y git gcc g++ make cmake autoconf automake libtool python3 libssl-dev
git clone --recursive  https://github.com/apache/kvrocks.git kvrocks
cd kvrocks
git checkout 2.10
./x.py build
cd ..


# OTHERS DEPS
sudo apt install -y python3-dev  # for compiling things
sudo apt install -y libpango-1.0-0 libharfbuzz0b libpangoft2-1.0-0  # For HTML -> PDF
sudo apt install -y libreoffice-nogui # For Office -> PDF
sudo apt install -y exiftool  # for extracting exif information
sudo apt install -y unrar  # for extracting rar files
sudo apt install -y libxml2-dev libxslt1-dev antiword unrtf poppler-utils tesseract-ocr flac ffmpeg lame libmad0 libsox-fmt-mp3 sox libjpeg-dev swig  # for textract
sudo apt install -y libssl-dev  # seems required for yara-python
sudo apt install -y libcairo2-dev  # Required by reportlab

# sudo add-apt-repository ppa:libreoffice/ppa
# sudo apt-get update -y
# sudo apt-get install -y libreoffice

#PANDORA INSTALL 
git clone https://github.com/pandora-analysis/pandora.git
cd pandora  # if you're not already in the directory

## NEED VENV
python3 -m venv ~/venv # CREATE VENV
source ~/venv/bin/activate # ENTER IN VENV 
pip install -U pip setuptools
pip install poetry
poetry install
echo PANDORA_HOME="`pwd`" >> .env
poetry run python tools/3rdparty.py
cp config/generic.json.sample config/generic.json


#ANTIVIRUS INSTALL
sudo apt install -y clamav-daemon
# In order for the module to work, you need the signatures.
# Running the command "freshclam" will do it but if the script is already running
# (it is started by the systemd service clamav-freshclam)
# You might want to run the commands below:
sudo systemctl stop clamav-freshclam.service  # Stop the service
sudo freshclam  # Run the signatures update
sudo systemctl start clamav-freshclam.service # Start the service so we keep getting the updates
sudo service clamav-daemon start

#COMMODO INSTALL
cd
wget https://download.comodo.com/cis/download/installs/linux/cav-linux_x64.deb
sudo dpkg --ignore-depends=libssl0.9.8 -i cav-linux_x64.deb
sudo wget http://cdn.download.comodo.com/av/updates58/sigs/bases/bases.cav -O /opt/COMODO/scanners/bases.cav

#WORKERS CONF
cd pandora
for file in pandora/workers/*.sample; do cp -i ${file} ${file%%.sample}; done

# Update and launch
poetry run update --yes

# START OR STOP PANDORA
# poetry run start
# poetry run stop
