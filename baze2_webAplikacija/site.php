<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <meta charset="utf-8">
    <title>Sustav za upravljanje hotelom</title>
    <link rel='icon' href='favicon.ico' type='image/x-icon'>
    <link rel='shortcut icon' href='favicon.ico' type='image/x-icon'>
  </head>
  <body>
    <?php

    global $conn;

    $odabir = 0;

    $odabir = $_POST["taskOption"];

    switch ($odabir) {
      case 1:
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

      $drop_mp_temp = "DROP TABLE IF EXISTS odabrano_mjesto_prebivalista;";
      if (!mysqli_query($conn, $drop_mp_temp)){
        echo ("Error: ". mysqli_error($conn));
      }

      $drop_datum_temp = "DROP TABLE IF EXISTS odabrani_period;";
      if (!mysqli_query($conn, $drop_datum_temp)){
        echo ("Error: ". mysqli_error($conn));
      }

      $drop_gosti_temp = "DROP TABLE IF EXISTS gosti_temp;";
      if (!mysqli_query($conn, $drop_gosti_temp)){
        echo ("Error: ". mysqli_error($conn));
      }
      $drop_temp_odabrani_gosti= "DROP TABLE IF EXISTS temp_odabrani_gosti;";
      if (!mysqli_query($conn, $drop_temp_odabrani_gosti)){
        echo ("Error: ". mysqli_error($conn));
      }
      $drop_temp_odabrane_usluge = "DROP TABLE IF EXISTS temp_odabrane_usluge;";
      if (!mysqli_query($conn, $drop_temp_odabrane_usluge)){
        echo ("Error: ". mysqli_error($conn));
      }
      $drop_temp_rezervacija = "DROP TABLE IF EXISTS temp_rezervacija;";
      if (!mysqli_query($conn, $drop_temp_rezervacija)){
        echo ("Error: ". mysqli_error($conn));
      }
      $drop_temp_booker = "DROP TABLE IF EXISTS temp_booker;";
      if (!mysqli_query($conn, $drop_temp_booker)){
        echo ("Error: ". mysqli_error($conn));
      }
      include "main_gost.php";

        break;
      case 2:
      $username = "djelatnik";
      $password = "djelatnik";
      $servername = "localhost";
      // Create connection
      $conn = mysqli_connect($servername, $username, $password);
      // Check connection
      if (mysqli_connect_error()) {
        die("Problem kod povezivanja na MySQL bazu podataka: " . mysqli_connect_error());
      }

      include "main_djelatnik.php";
      break;

      case 3:
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

      $drop_mp_temp = "DROP TABLE IF EXISTS odabrano_mjesto_prebivalista;";
      mysqli_query($conn,$drop_mp_temp);

      $drop_datum_temp = "DROP TABLE IF EXISTS odabrani_period;";
      mysqli_query($conn, $drop_datum_temp);

      $drop_gosti_temp = "DROP TABLE IF EXISTS gosti_temp;";
      mysqli_query($conn, $drop_gosti_temp);

      include "main_root.php";

    }
    ?>

  </body>
</html>
