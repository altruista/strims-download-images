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
	 
Przykład (pobranie 10 stron s/FotoHistoria):

	strims-download-images -u Jan -p dupa123 -s "s/FotoHistoria" -t 10 -o "~/Fotki/"

#### Linki:
Dyskusja: http://strims.pl/s/Linux/t/h9xt7a/skrypt-bashphp-do-pobrania-strimu-obrazkowego

Strim PHP: http://strims.pl/s/PHP

Strim Linux: http://strims.pl/s/Linux

Strims-PHP-API: https://github.com/altruista/strims-php-api/

#### Autor:
- http://strims.pl/u/altruista

#### Licencja:
Creative Commons Attribution 3.0
http://creativecommons.org/licenses/by/3.0/deed.en_US
