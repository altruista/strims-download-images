strims-download-images
======================

Skrypt bash/php do pobierania zdjęc ze strimu ze zdjęciami np. s/dlugieszyny, s/fotohistoria itd.

Do odpalenia skryptu potrzebne jest wpisanie hasła, i należy wyłączym w ustawieniach użytkownika otwieranie w ramkach

#### Wymagania
- PHP 5+ z php-curl
- wget

#### Użycie (bash)
strims-download-images [OPCJE]
 -u nazwa użytkownika (wymagane)
 -p hasło użytkownika (wymagane)
 -s nazwa strimu (wymagane)
 -f strona od
 -t strona do
 -o katalog gdzie mają być zapisane zdjęcia
Użytkownik musi mieć wyłączone ramki w ustawieniach

Przykład:
strims-download-images -u Jan -p dupa123 -s "s/Ciekawostki"
