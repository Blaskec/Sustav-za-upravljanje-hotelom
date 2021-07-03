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
$br = 1;
 while (TRUE){
   if(isset($_POST['remove_gost'.$br])){
     break;
   }
   $br++;
}
mysqli_query($conn,"DELETE FROM gosti_temp WHERE id_gost = $br;");

$last_id = mysqli_insert_id($conn);
include_once "main_root.php";
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
