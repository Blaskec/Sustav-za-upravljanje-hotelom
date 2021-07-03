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

$du_naziv = $_POST['input_du_naziv'];
$du_cijena = $_POST['input_du_cijena'];

$soba_insert = "INSERT INTO dodatne_usluge (naziv,cijena)
VALUES ('$du_naziv','$du_cijena');";
mysqli_query($conn, $soba_insert);
header ("Location: ../baze2_webAplikacija/main_djelatnik.php?dodatna_usluga= uspješno_dodano");

 ?>
