<?php
//_________________________KONEKCIJA_____________________________________________
$username = "djelatnik";
$password = "djelatnik";
$servername = "localhost";
// Create connection
$conn = mysqli_connect($servername, $username, $password);
// Check connection
if (mysqli_connect_error()) {
  die("Problem kod povezivanja na MySQL bazu podataka: " . mysqli_connect_error());
}
echo "<div class='w3-amber'>Uspješno povezivanje sa MySQL bazom podataka!</div>";
echo "<div class='w3-amber w3-margin-bottom	'>Prijavljeni korisnik: ","<b>", $username, "</b></div>";
if (!mysqli_select_db($conn, "sustav_za_upravljanje_hotelom")) {
  echo("Error description: " . mysqli_error($conn));
}

$soba_kat = $_POST['input_kat'];
$soba_cijena = $_POST['input_cijena'];
$soba_vrsta = $_POST['input_vrsta'];

$soba_insert = "INSERT INTO soba (sifra,kat,standardna_cijena,vrsta)
VALUES (DEFAULT, '$soba_kat', '$soba_cijena', '$soba_vrsta');";
mysqli_query($conn, $soba_insert);
header ("Location: ../baze2_webAplikacija/main_djelatnik.php");

 ?>
