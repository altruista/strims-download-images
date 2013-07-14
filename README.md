strims-download-images
======================

Skrypt bash/php do pobierania zdjęc ze strimu ze zdjęciami np. s/dlugieszyny, s/fotohistoria itd.

Do odpalenia skryptu potrzebne jest wpisanie hasła, i należy wyłączym w ustawieniach użytkownika otwieranie w ramkach

Po co bash? Bo mogę :) I miałem okazję pouczyć się skryptowania w bashu

Plik `strims-download-images.php` można też odpalać z poziomu konsoli, wystarczy zaledwie tam pętla co pobierze obrazki aby on samodzielnie działał (to w sumie niedługo dodam)

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

#### Użycie (php, skrypt robiący listę linków)

	php strims-download-images.php [OPCJE]
	 --username     nazwa użytkownika (wymagane)
	 --password     hasło użytkownika (wymagane)
	 --strim        nazwa strimu np. "s/Ciekawostki" (wymagane)
	 --from         strona początkowa
	 --to           strona końcowa
	 --quiet        nie pokazuj postępu
	 --output-file  plik z wynikiem (wymagane)
         --download-images (wkrótce. wtedy to będzie samodzielny skrypt)

Przykład (sparsowanie 10 stron s/FotoHistoria):

	php strims-download-images.php --username Jan --password dupa123 --to 10 --strim "s/FotoHistoria" --output-file lista.txt

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
