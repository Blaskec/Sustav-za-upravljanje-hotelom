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
$rezervacija_id = $_POST['rezervacija_ID'];
$djelatnik_ime = $_POST['djelatnik_racun_ime'];
$djelatnik_prezime = $_POST['djelatnik_racun_prezime'];

echo ($rezervacija_id.' '.$djelatnik_ime.' '.$djelatnik_prezime);
$call_izradaRacuna = "CALL izradaRacuna($rezervacija_id, '$djelatnik_ime', '$djelatnik_prezime');";
if (!mysqli_query($conn,$call_izradaRacuna))
  echo("Greska u izradi racuna:".mysqli_error($conn));
header ("Location: ../baze2_webAplikacija/main_djelatnik.php?racun = izraden");
 ?>
