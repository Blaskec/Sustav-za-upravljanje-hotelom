<?php
$username = "root";
$password = "root";
$servername = "localhost";
// Create connection
$conn = mysqli_connect($servername, $username, $password);
// Check connection
if (mysqli_connect_error()) {
  die("Problem kod povezivanja na MySQL bazu podataka: " . mysqli_connect_error());
}
mysqli_select_db($conn, "sustav_za_upravljanje_hotelom");

$datum_dolaska = $_POST['datum_dolaska'];
$datum_odlaska = $_POST['datum_odlaska'];

$drop_datum_temp = "DROP TABLE IF EXISTS odabrani_period;";
mysqli_query($conn, $drop_datum_temp);

$create_datum_temp = "CREATE TABLE IF NOT EXISTS odabrani_period(
  id_odabrani_period SERIAL AUTO_INCREMENT,
    dolazak DATE NOT NULL,
    odlazak DATE NOT NULL,
    CONSTRAINT odabrani_period_pk PRIMARY KEY (id_odabrani_period)
);";
mysqli_query($conn, $create_datum_temp);

$insert_period = "INSERT INTO odabrani_period (dolazak,odlazak) VALUES ('$datum_dolaska', '$datum_odlaska');";
mysqli_query($conn, $insert_period);

include "main_root.php";
echo '<script type="text/javascript">',
     'datum();',
     '</script>'
;
if ($odabrana_drzava != '' && $odabrani_grad != '' && $odabrani_pb != '' && $odabrana_adresa != '') {
  echo '<script type="text/javascript">',
       'mjestoPrebivalista();',
       '</script>';
}
if ($odabrani_dd != '' && $odabrani_do != '') {
    echo '<script type="text/javascript">',
         'datum();',
         '</script>';
     }
if ($gost_test ==1)
  echo '<script type="text/javascript">',
      'gost();',
      '</script>';

 ?>
