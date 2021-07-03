<?php
$username = "gost";
$password = "";
$servername = "localhost";
// Create connection
$conn = mysqli_connect($servername, $username, $password);
// Check connection
if (mysqli_connect_error()) {
  die("Problem kod povezivanja na MySQL bazu podataka: " . mysqli_connect_error());
}
mysqli_select_db($conn, "sustav_za_upravljanje_hotelom");

$drzava = $_POST['drzava'];
$grad = $_POST['grad'];
$p_broj = $_POST['p_broj'];
$adresa = $_POST['adresa'];

$drop_mp_temp = "DROP TABLE IF EXISTS odabrano_mjesto_prebivalista;";
mysqli_query($conn, $drop_mp_temp);

$create_mp_temp = "CREATE TABLE IF NOT EXISTS odabrano_mjesto_prebivalista(
    id_mjesto_prebivalista SERIAL AUTO_INCREMENT,
    drzava VARCHAR(50) NOT NULL,
    grad VARCHAR(50) NOT NULL,
    postanski_broj VARCHAR(20) NOT NULL,
    adresa VARCHAR(50) NOT NULL,
    CONSTRAINT mjesto_preb_temp_pk PRIMARY KEY (id_mjesto_prebivalista)
);";

mysqli_query($conn, $create_mp_temp);

$insert_mp = "INSERT INTO odabrano_mjesto_prebivalista (drzava,grad,postanski_broj,adresa)
VALUES ('$drzava', '$grad', '$p_broj', '$adresa');";
mysqli_query($conn, $insert_mp);

    include "main_gost.php";
    echo '<script type="text/javascript">',
         'mjestoPrebivalista();',
         '</script>';

if ($odabrani_dd != '' && $odabrani_do != '') {
    echo '<script type="text/javascript">',
         'datum();',
         '</script>';
     }

 ?>
