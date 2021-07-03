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

$g_ime = $_POST['g_ime'];
$g_prezime = $_POST['g_prezime'];
$g_oib = $_POST['g_oib'];
$g_iskaznica = $_POST['g_osobna'];
$g_datum_rodenja = $_POST['g_datum_rodenja'];

$create_gosti_temp = "CREATE TABLE IF NOT EXISTS gosti_temp(
    id_gost SERIAL AUTO_INCREMENT,
    ime VARCHAR(20) NOT NULL,
    prezime VARCHAR(20) NOT NULL,
    OIB VARCHAR(30) NOT NULL,
    broj_osobne_iskaznice VARCHAR(30) NOT NULL,
    id_mjesto_prebivalista BIGINT UNSIGNED NOT NULL DEFAULT 0,
    datum_rodenja DATE NOT NULL,
    CONSTRAINT gosti_temp_pk PRIMARY KEY (id_gost),
    CONSTRAINT gosti_temp_oi UNIQUE (broj_osobne_iskaznice),
    CONSTRAINT gosti_temp_oib UNIQUE (OIB)
);";
mysqli_query($conn, $create_gosti_temp);

$selected_mp = "SELECT id_mjesto_prebivalista
                    FROM odabrano_mjesto_prebivalista;";
$result_s_mp = mysqli_query($conn,$selected_mp);
$resultCheck = mysqli_num_rows($result_s_mp);
if ($resultCheck > 0){
  while ($row = mysqli_fetch_assoc($result_s_mp)){
    $selected_mp =  ($row['id_mjesto_prebivalista']);
  }
}

$insert_gosti_temp = "INSERT INTO gosti_temp (ime,prezime,OIB,broj_osobne_iskaznice, id_mjesto_prebivalista, datum_rodenja)
VALUES ('$g_ime', '$g_prezime', '$g_oib', '$g_iskaznica','$selected_mp','$g_datum_rodenja');";
if (mysqli_query($conn, $insert_gosti_temp)){
  $last_id = mysqli_insert_id($conn);
} else {
  echo "Error: " . $insert_gosti_temp . "<br>" . mysqli_error($conn);
}

include_once "main_gost.php";

       if ($odabrani_dd != '' && $odabrani_do != '') {
           echo '<script type="text/javascript">',
                'datum();',
                '</script>';
            }
      if ($odabrana_drzava != '' && $odabrani_grad != '' && $odabrani_pb != '' && $odabrana_adresa != '') {
          echo '<script type="text/javascript">',
               'mjestoPrebivalista();',
               '</script>';
            }
      echo '<script type="text/javascript">',
            'gost();',
            '</script>';

?>
