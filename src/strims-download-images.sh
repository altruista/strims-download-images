######################################################
# Sprawdzanie czy jest php, wget, openssl, file
######################################################

type php >/dev/null 2>&1 || { echo >&2 "PHP jest wymagane do uruchomienia skryptu"; exit 1; }
type openssl >/dev/null 2>&1 || { echo >&2 "openssl/base64 jest wymagane do odczytania i uruchomienia skryptu php"; exit 1; }
type wget >/dev/null 2>&1 || { echo >&2 "wget jest wymagane do pobrania obrazków"; exit 1; }
type file >/dev/null 2>&1 || { echo >&2 "file jest wymagane do pobrania obrazków"; exit 1; }

if php -r 'echo function_exists("curl_init") ? 1 : 0;' | grep -q "0"; then
    echo >&2 "Moduł Curl musi być zainstalowany i włączony dla PHP"; 
    exit 1;
fi

######################################################
# Argumenty
######################################################

usage() { 
    echo "Użycie: $0 [OPCJE]" 1>&2; 
    echo " -u nazwa użytkownika (wymagane)"
    echo " -p hasło użytkownika (wymagane)"
    echo " -s nazwa strimu (wymagane)"
    echo " -f strona od"
    echo " -t strona do"
    echo " -o katalog gdzie mają być zapisane zdjęcia"
    echo "Użytkownik musi miec wyłączone ramki w ustawieniach"
    echo ""
    echo "Przykład:"
    echo "$0 -u Jan -p dupa123 -s \"s/Ciekawostki\""
    exit 1; 
}

OPT_OUTPUT_DIR="./"
OPT_PAGE_FROM=1
OPT_PAGE_TO=1

while getopts ":u:p:f:t:s:o:" o; do
    case "${o}" in
        u)
            OPT_USERNAME=${OPTARG}            
            ;;
        p)
            OPT_PASSWORD=${OPTARG}
            ;;
        f)
            OPT_PAGE_FROM=${OPTARG}
            ;;
        t)
            OPT_PAGE_TO=${OPTARG}
            ;;
        s)
            OPT_STRIM=${OPTARG}
            ;;
        o)
            OPT_OUTPUT_DIR=${OPTARG}
            ;;
        *)
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "$OPT_USERNAME" ]; then
    echo "Podaj nazwę użytkownika"
    usage
fi

if [ -z "$OPT_PASSWORD" ]; then
    echo "Podaj hasło użytkownika"
    usage
fi

if [ -z "$OPT_STRIM" ]; then
    echo "Podaj nazwę strimu"
    usage
fi

######################################################
# Przygotowujemy plik PHP
######################################################

PHP_SCRIPT_FILE="/tmp/strims-download.$RANDOM.php"
echo "${PHP_SCRIPT}" | openssl base64 -d > ${PHP_SCRIPT_FILE}
chmod +x ${PHP_SCRIPT_FILE}

######################################################
# Odpalenie skryptu php co sprarsuje nam strima
######################################################

IMAGE_LIST_FILE="/tmp/strims-download.$RANDOM-list.txt"
php ${PHP_SCRIPT_FILE} --username $OPT_USERNAME --password $OPT_PASSWORD --strim $OPT_STRIM --from $OPT_PAGE_FROM --to $OPT_PAGE_TO --output-file $IMAGE_LIST_FILE
rm ${PHP_SCRIPT_FILE}

######################################################
# Pobieranie plików
######################################################

IMAGES_COUNT=$(cat $IMAGE_LIST_FILE | wc -l)
IMAGE_NR=1

while read -r IMG_URL IMG_FILENAME tail; do
    # pokazujemy progres
    echo -n "Pobieranie obrazka $IMAGE_NR z $IMAGES_COUNT... "
    IMAGE_NR=`expr $IMAGE_NR + 1`
    IMG_FILEPATH="${OPT_OUTPUT_DIR}${IMG_FILENAME}"

    if [ -f "$IMG_FILEPATH" ]; then
        echo "Obrazek już pobrany"
        continue ;
    fi

    # pobieramy zdjęcie
    wget -q -nv -O "${IMG_FILEPATH}" "${IMG_URL}"

    # sprawdzamy co to za plik
    case $(file -b --mime-type  "$IMG_FILEPATH") in        
        image/jpeg)
            echo "OK (obrazek jpg)"
            ;;
        image/png)
            echo "OK (obrazek png)"
            ;;
        image/gif)
            echo "OK (obrazek gif)"
            ;;
        *)
            echo "To nie obrazek"
            rm $IMG_FILEPATH
            ;;
    esac
    
done <$IMAGE_LIST_FILE

echo "Gotowe!"