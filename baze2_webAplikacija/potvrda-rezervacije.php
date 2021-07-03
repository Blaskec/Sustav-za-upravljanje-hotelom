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
$call_izradaRezervacije = "CALL izradaRezervacije();";
if (!mysqli_query($conn,$call_izradaRezervacije))
  echo("Greska u izradi rezervacije:".mysqli_error($conn));
header ("Location: ../baze2_webAplikacija/index.html?rezervacija = uspjesno");
 ?>
