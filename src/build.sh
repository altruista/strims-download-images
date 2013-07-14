#!/bin/sh

TARGET_FILE="../strims-download-images"
TARGET_FILE_GZ="../strims-download-images.tar.gz"
PHP_SCRIPT_FILE="strims-download-images-full.tmp"
PHP_SCRIPT_BASE64_FILE="strims-download-images-full.tmp.base64"

######################################################
# Przygotowujemy plik PHP
######################################################

echo -n "Tworzenie skryptu PHP... "

# PHP cześć 1: strims-php-api
wget -qO- https://raw.github.com/altruista/strims-php-api/master/Strims.class.php > ${PHP_SCRIPT_FILE}

# w strims-php-api brak "?>"
echo "?>" >> ${PHP_SCRIPT_FILE}

# PHP cześć 2: właściwy skrypt pobierający w php
cat strims-download-images.php >> ${PHP_SCRIPT_FILE}

# Mielimy to do base64 i zapisujemy
openssl base64 < ${PHP_SCRIPT_FILE} > ${PHP_SCRIPT_BASE64_FILE}

echo "OK"

######################################################
# Przygotowujemy właściwty skrypt
######################################################

echo -n "Tworzenie skryptu bash... "

echo "#!/bin/sh" > ${TARGET_FILE}

# Wrzucamy skrypt php do skryptu bashowego jako string
echo "read -d '' PHP_SCRIPT <<- EOF" >> ${TARGET_FILE}
cat ${PHP_SCRIPT_BASE64_FILE} >> ${TARGET_FILE} 
echo "EOF" >> ${TARGET_FILE} 

# I dołączamy skrypt strims-download-images.sh który robi obsłuży skrypt php
cat strims-download-images.sh >> ${TARGET_FILE} 

echo "OK"

######################################################
# Usuwamy śmietnik
######################################################

echo -n "Czyszczenie... "
rm ${PHP_SCRIPT_FILE}
rm ${PHP_SCRIPT_BASE64_FILE}
chmod +x ${TARGET_FILE} 
echo "OK"

tar -czPf ${TARGET_FILE_GZ} ${TARGET_FILE}

echo "Gotowe."







