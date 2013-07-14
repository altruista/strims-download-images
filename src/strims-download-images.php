<?php
/********************************
 * Funkcje pomocnicze 
 ********************************/

/**
 * Wywala polskie znaki
 * @link http://programistyczny.blogspot.co.uk/2012/05/php-jak-usunac-polskie-znaki.html
 * @param string 
 * @return string 
 */
function replace_diacritics($string) {    

    $characters = array();

    $characters['Ą'] = 'a';
    $characters['Ć'] = 'c';
    $characters['Ę'] = 'e';
    $characters['Ł'] = 'l';
    $characters['Ń'] = 'n';
    $characters['Ó'] = 'o';
    $characters['Ś'] = 's';
    $characters['Ż'] = 'z';
    $characters['Ź'] = 'z';
    $characters['ą'] = 'a';
    $characters['ć'] = 'c';
    $characters['ę'] = 'e';
    $characters['ł'] = 'l';
    $characters['ń'] = 'n';
    $characters['ó'] = 'o';
    $characters['ś'] = 's';
    $characters['ż'] = 'z';
    $characters['ź'] = 'z';

    $keys = array_keys($characters);
    $values = array_values($characters);

    return str_replace($keys, $values, $string);
}

/**
 * Tworzenie nazwy pliku
 * @param type $listing
 * @return type
 */
function nice_filename($listing) {
    $title = replace_diacritics($listing->title);
    $title = str_replace(' ', '_', $title);
    $title = str_replace(Array('/', '\\'), '_', $title);
    $ext = strtolower(@end(explode(".", $listing->link)));
    if (strlen($ext) > 4) $ext = "jpg";
    if (strlen($title) > 30) $title = substr($title, 0, 25);
    return $listing->id . '_' . $title . ".{$ext}";
}

/********************************
 * Strims API
 ********************************/

if (!class_exists('Strims')) {
    require_once "Strims.class.php";
}

$api_options = Array(
    'cookie_file' => tempnam(sys_get_temp_dir(), 'strims-download-cookie')
);

$strims = new Strims($api_options);

/********************************
 * Opcje / argumenty
 ********************************/

$script_options =  Array(
    'username' => 'nazwa użytkownika (wymagane)',
    'password' => 'hasło użytkownika (wymagane)',
    'strim' => 'nazwa strimu np. "s/Ciekawostki"',
    'from' => 'strona początkowa',
    'to' => 'strona końcowa',
    'quiet' => 'nie pokazuj postępu',
    'output-file' => 'plik z wynikiem (wymagane)'
);    

$help = "Użycie: php strims-download-images.php [OPCJE]".PHP_EOL;
$long_opts = Array();

foreach($script_options as $key => $description) {
    $long_opts[] = "{$key}:";
    $help .= " --{$key} {$description}" . PHP_EOL;
}

$opt = getopt("", $long_opts);
$help .= "    
Przykład użycia:
php strims-download-images.php --username Jan --password dupa123 --strim \"s/Ciekawostki\" --output-file linki.txt
";

if (empty($opt)) {
    echo $help;
    exit(1);
}

$options = Array(
    'username'      => isset($opt['username']) ? $opt['username'] : die("Błąd: Wymagana nazwa użytkownika" . PHP_EOL . PHP_EOL . $help),
    'password'      => isset($opt['password']) ? $opt['password'] : die("Błąd: Wymagane hasło użytkownika" . PHP_EOL . PHP_EOL . $help),
    'page_from'     => isset($opt['from']) ? $opt['from'] : 1,
    'page_to'       => isset($opt['to']) ? $opt['to'] : 1,
    'quiet'         => isset($opt['quiet']) ? $opt['quiet'] : 0,
    'strim'         => isset($opt['strim']) ? $opt['strim'] : die("Błąd: Wymagana nazwa strimu" . PHP_EOL . PHP_EOL . $help),
    'output-file'   => isset($opt['output-file']) ? $opt['output-file'] : die("Błąd: Wymagany plik wyjściowy" . PHP_EOL . PHP_EOL . $help),
);

if (!($options['page_from'] > 0)) {
    $options['page_from'] = 1;
}

if (!($options['page_to'] > 0)) {
    $options['page_to'] = 1;
}

if ($options['page_to'] < $options['page_from']) {
    $options['page_to'] = $options['page_from'];
}

/********************************
 * Właściwy skrypt
 ********************************/

if (!$options['quiet']) { 
    echo "Logowanie... ";
}

if (!$strims->login($options['username'], $options['password'])) {
    die('Błąd: Nie mozna zalogować');
}

if (!$options['quiet']) { 
    echo "OK" . PHP_EOL;
}

$fh = @fopen($options['output-file'], 'w');
if (!$fh) {
    die("Bład: Nie mogę otworzyć pliku {$options['output-file']}" . PHP_EOL . PHP_EOL . $help);
}

for ($page = $options['page_from']; $page <= $options['page_to']; $page++) {
    if (!$options['quiet']) {
        echo "Parsuje strone {$page} z {$options['page_to']}... ";
    }
    $listings = $strims->get_listings($options['strim'], $page);
    if (empty($listings)) {
        if (!$options['quiet']) {
            echo "Nie ma więcej linków." . PHP_EOL;
        }
        exit;
    }
    foreach ($listings as $listing) {
        $filename = nice_filename($listing);
        fwrite($fh, "{$listing->link} {$filename}" . PHP_EOL);
    }
    if (!$options['quiet']) {
        echo "OK" . PHP_EOL;
    }
}

fclose($fh);