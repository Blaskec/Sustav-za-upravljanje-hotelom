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
//_____________________________fetch soba i aranzman i booker______________________________________
$odabrana_soba = $_POST['soba_odabir'];
$odabrani_aranzman = $_POST['aranzman'];
$booker = $_POST['booker_odabir'];
//_____________________________fetch soba i aranzman cijene________________________________________
$select_soba_cijena = "SELECT standardna_cijena
                          FROM soba
                          WHERE sifra = '$odabrana_soba';";
$result_soba_cijena = mysqli_query($conn,$select_soba_cijena);
$resultCheck = mysqli_num_rows($result_soba_cijena);
if ($resultCheck > 0){
  while ($row = mysqli_fetch_assoc($result_soba_cijena)){
    $odabrana_soba_cijena =  $row['standardna_cijena'];
  }
}
$select_soba_id = "SELECT id_soba
                          FROM soba
                          WHERE sifra = '$odabrana_soba';";
$result_soba_id = mysqli_query($conn,$select_soba_id);
$resultCheck = mysqli_num_rows($result_soba_id);
if ($resultCheck > 0){
  while ($row = mysqli_fetch_assoc($result_soba_id)){
    $odabrana_soba_id =  $row['id_soba'];
  }
}
$select_aranzman_cijena = "SELECT cijena
                          FROM aranzman
                          WHERE opis_aranzmana = '$odabrani_aranzman';";
$result_aranzman_cijena = mysqli_query($conn,$select_aranzman_cijena);
$resultCheck = mysqli_num_rows($result_aranzman_cijena);
if ($resultCheck > 0){
  while ($row = mysqli_fetch_assoc($result_aranzman_cijena)){
    $odabrani_aranzman_cijena =  $row['cijena'];
  }
}
$select_aranzman_id = "SELECT id_aranzman
                          FROM aranzman
                          WHERE opis_aranzmana = '$odabrani_aranzman';";
$result_aranzman_id = mysqli_query($conn,$select_aranzman_id);
$resultCheck = mysqli_num_rows($result_aranzman_id);
if ($resultCheck > 0){
  while ($row = mysqli_fetch_assoc($result_aranzman_id)){
    $odabrani_aranzman_id =  $row['id_aranzman'];
  }
}
//_____________________________fetch booker - podaci______________________________________
$select_booker_ime = "SELECT CONCAT(ime ,' ' ,prezime) AS booker
                    FROM gosti_temp
                    WHERE id_gost = $booker;";
$result_booker_ime = mysqli_query($conn,$select_booker_ime);
$resultCheck = mysqli_num_rows($result_booker_ime);
if ($resultCheck > 0){
  while ($row = mysqli_fetch_assoc($result_booker_ime)){
    $booker_ime_prezime =  ($row['booker']);
  }
}
$select_booker_oib = "SELECT oib
                    FROM gosti_temp
                    WHERE id_gost = $booker;";
                    if (!mysqli_query($conn,$select_booker_oib))
                      echo("Greska booker oib:".mysqli_error($conn));
$result_booker_oib = mysqli_query($conn,$select_booker_oib);
$resultCheck = mysqli_num_rows($result_booker_oib);
if ($resultCheck > 0){
  while ($row = mysqli_fetch_assoc($result_booker_oib)){
    $booker_oib =  ($row['oib']);
  }
}
$select_booker_boi = "SELECT broj_osobne_iskaznice
                    FROM gosti_temp
                    WHERE id_gost = $booker;";
$result_booker_boi = mysqli_query($conn,$select_booker_boi);
$resultCheck = mysqli_num_rows($result_booker_boi);
if ($resultCheck > 0){
  while ($row = mysqli_fetch_assoc($result_booker_boi)){
    $booker_boi =  ($row['broj_osobne_iskaznice']);
  }
}
$select_booker_dr = "SELECT datum_rodenja
                    FROM gosti_temp
                    WHERE id_gost = $booker;";
$result_booker_dr = mysqli_query($conn,$select_booker_dr);
$resultCheck = mysqli_num_rows($result_booker_dr);
if ($resultCheck > 0){
  while ($row = mysqli_fetch_assoc($result_booker_dr)){
    $booker_dr =  ($row['datum_rodenja']);
  }
}
$select_booker_id = "SELECT id_gost
                    FROM gosti_temp
                    WHERE id_gost = $booker;";
$result_booker_id = mysqli_query($conn,$select_booker_id);
$resultCheck = mysqli_num_rows($result_booker_id);
if ($resultCheck > 0){
  while ($row = mysqli_fetch_assoc($result_booker_id)){
    $booker_id =  ($row['id_gost']);
  }
}
$select_booker_ime = "SELECT ime
                    FROM gosti_temp
                    WHERE id_gost = $booker;";
$result_booker_ime = mysqli_query($conn,$select_booker_ime);
$resultCheck = mysqli_num_rows($result_booker_ime);
if ($resultCheck > 0){
  while ($row = mysqli_fetch_assoc($result_booker_ime)){
    $booker_ime =  ($row['ime']);
  }
}
$select_booker_prezime = "SELECT prezime
                    FROM gosti_temp
                    WHERE id_gost = $booker;";
$result_booker_prezime = mysqli_query($conn,$select_booker_prezime);
$resultCheck = mysqli_num_rows($result_booker_prezime);
if ($resultCheck > 0){
  while ($row = mysqli_fetch_assoc($result_booker_prezime)){
    $booker_prezime =  ($row['prezime']);
  }
}
$drop_temp_booker = "DROP TABLE IF EXISTS temp_booker;";
if (!mysqli_query($conn,$drop_temp_booker))
  echo("Greska:".mysqli_error($conn));
$create_temp_booker = "CREATE TABLE IF NOT EXISTS temp_booker (
	  id_gost SERIAL AUTO_INCREMENT,
    ime VARCHAR(20) NOT NULL,
    prezime VARCHAR(20) NOT NULL,
    OIB VARCHAR(30) NOT NULL,
    broj_osobne_iskaznice VARCHAR(30) NOT NULL,
    id_mjesto_prebivalista BIGINT UNSIGNED NOT NULL,
    datum_rodenja DATE NOT NULL,
    CONSTRAINT gost_id_gost_pk PRIMARY KEY (id_gost),
    CONSTRAINT gost_broj_oi_uq UNIQUE (broj_osobne_iskaznice),
    CONSTRAINT gost_oib_uq UNIQUE (OIB)
);";
if (!mysqli_query($conn,$create_temp_booker))
  echo("Greska:".mysqli_error($conn));
$insert_temp_booker = "INSERT INTO temp_booker (ime,prezime,OIB,broj_osobne_iskaznice,id_mjesto_prebivalista,datum_rodenja)
VALUES ('$booker_ime','$booker_prezime','$booker_oib','$booker_boi',0,'$booker_dr');";
if (!mysqli_query($conn,$insert_temp_booker))
  echo("Greska kod unosa bookera:".mysqli_error($conn));

//______________________________fetch dodatne usluge______________________________________
    $polje_du_id = [];
    $select_du_id = "SELECT id_dodatne_usluge
                   FROM dodatne_usluge;";
     $result_du_id = mysqli_query($conn,$select_du_id);
     $resultCheck = mysqli_num_rows($result_du_id);
     if ($resultCheck > 0){
       while ($row = mysqli_fetch_assoc($result_du_id)){
         array_push($polje_du_id,$row['id_dodatne_usluge']);
       }
     }

     //_______________________fetch mjesto_prebivalsita____________________________________
     //fetch $drzava
     $select_drzava = "SELECT drzava
                         FROM odabrano_mjesto_prebivalista;";
     $result_drzava = mysqli_query($conn,$select_drzava);
     $resultCheck = mysqli_num_rows($result_drzava);
     if ($resultCheck > 0){
       while ($row = mysqli_fetch_assoc($result_drzava)){
         $odabrana_drzava =  ($row['drzava']);
       }
     }
     //fetch $grad

     $select_grad = "SELECT grad
                         FROM odabrano_mjesto_prebivalista;";
     $result_grad = mysqli_query($conn,$select_grad);
     $resultCheck = mysqli_num_rows($result_grad);
     if ($resultCheck > 0){
       while ($row = mysqli_fetch_assoc($result_grad)){
         $odabrani_grad =  ($row['grad']);
       }
     }
     //fetch $postanski_broj

     $select_pb = "SELECT postanski_broj
                         FROM odabrano_mjesto_prebivalista;";
     $result_pb = mysqli_query($conn,$select_pb);
     $resultCheck = mysqli_num_rows($result_pb);
     if ($resultCheck > 0){
       while ($row = mysqli_fetch_assoc($result_pb)){
         $odabrani_pb =  ($row['postanski_broj']);
       }
     }
     //fetch $adresa

     $select_ad = "SELECT adresa
                         FROM odabrano_mjesto_prebivalista;";
     $result_ad = mysqli_query($conn,$select_ad);
     $resultCheck = mysqli_num_rows($result_ad);
     if ($resultCheck > 0){
       while ($row = mysqli_fetch_assoc($result_ad)){
         $odabrana_adresa =  ($row['adresa']);
       }
     }
     //_____________________________datum fetch___________________________________
     $select_dd = "SELECT dolazak
                         FROM odabrani_period;";
     $result_dd = mysqli_query($conn,$select_dd);
     $resultCheck = mysqli_num_rows($result_dd);
     if ($resultCheck > 0){
       while ($row = mysqli_fetch_assoc($result_dd)){
         $odabrani_dd =  ($row['dolazak']);
       }
     }
     //fetch $datum_odlaska

     $select_do = "SELECT odlazak
                         FROM odabrani_period;";
     $result_do = mysqli_query($conn,$select_do);
     $resultCheck = mysqli_num_rows($result_do);
     if ($resultCheck > 0){
       while ($row = mysqli_fetch_assoc($result_do)){
         $odabrani_do =  ($row['odlazak']);
       }
     }
     //_____________________________Datum trajanje i sezona izracun____________________________
     $datum1 = ("'".$odabrani_dd."'");
     $datum2 = ("'".$odabrani_do."'");
     $result_trajanje= mysqli_query($conn,"SELECT DATEDIFF($datum2,$datum1) AS trajanje;");
     $resultCheck = mysqli_num_rows($result_trajanje);
     if ($resultCheck > 0){
       while ($row = mysqli_fetch_assoc($result_trajanje)){
         $trajanje =  ($row['trajanje']);
       }
     }
     $result_sezona= mysqli_query($conn,"SELECT izracun_sezone($datum1,$datum2) AS sezona_id;");
     $resultCheck = mysqli_num_rows($result_sezona);
     if ($resultCheck > 0){
       while ($row = mysqli_fetch_assoc($result_sezona)){
         $sezona =  ($row['sezona_id']);
       }
     }
     switch($sezona){
       case 11:
        $sezona_naziv = 'Ljeto [A]';
        $multiplikator = 2.00;
          break;
       case 12:
        $sezona_naziv = 'Jesen [B]';
        $multiplikator = 1.25;
         break;
       case 13:
        $sezona_naziv = 'Zima [C]';
        $multiplikator = 1.00;
          break;
        case 14:
         $sezona_naziv = 'Proljeće [D]';
         $multiplikator = 1.50;
           break;
     }
     //_____________________________dodatni gosti___________________________________
     $polje_gosti_id = [];
     $select_id_gosti = "SELECT id_gost
                          FROM gosti_temp
                          WHERE id_gost !=$booker;";
      $result_id_gosti = mysqli_query($conn,$select_id_gosti);
      $resultCheck = mysqli_num_rows($result_id_gosti);
      if ($resultCheck > 0){
        while ($row = mysqli_fetch_assoc($result_id_gosti)){
          array_push($polje_gosti_id,$row['id_gost']);
        }
      }

     $polje_gosti_ime = [];
     $select_ime_gosti = "SELECT ime
                          FROM gosti_temp
                          WHERE id_gost !=$booker;";
      $result_ime_gosti = mysqli_query($conn,$select_ime_gosti);
      $resultCheck = mysqli_num_rows($result_ime_gosti);
      if ($resultCheck > 0){
        while ($row = mysqli_fetch_assoc($result_ime_gosti)){
          array_push($polje_gosti_ime,$row['ime']);
        }
      }
      $polje_gosti_prezime = [];
      $select_prezime_gosti = "SELECT prezime
                           FROM gosti_temp
                           WHERE id_gost !=$booker;";
       $result_prezime_gosti = mysqli_query($conn,$select_prezime_gosti);
       $resultCheck = mysqli_num_rows($result_prezime_gosti);
       if ($resultCheck > 0){
         while ($row = mysqli_fetch_assoc($result_prezime_gosti)){
           array_push($polje_gosti_prezime,$row['prezime']);
         }
       }
       $polje_gosti_oib = [];
       $select_oib_gosti = "SELECT oib
                            FROM gosti_temp
                            WHERE id_gost !=$booker;";
        $result_oib_gosti = mysqli_query($conn,$select_oib_gosti);
        $resultCheck = mysqli_num_rows($result_oib_gosti);
        if ($resultCheck > 0){
          while ($row = mysqli_fetch_assoc($result_oib_gosti)){
            array_push($polje_gosti_oib,$row['oib']);
          }
        }
        $polje_gosti_boi = [];
        $select_boi_gosti = "SELECT broj_osobne_iskaznice
                             FROM gosti_temp
                             WHERE id_gost !=$booker;";
         $result_boi_gosti = mysqli_query($conn,$select_boi_gosti);
         $resultCheck = mysqli_num_rows($result_boi_gosti);
         if ($resultCheck > 0){
           while ($row = mysqli_fetch_assoc($result_boi_gosti)){
             array_push($polje_gosti_boi,$row['broj_osobne_iskaznice']);
           }
         }
         $polje_gosti_dr = [];
         $select_dr_gosti = "SELECT datum_rodenja
                              FROM gosti_temp
                              WHERE id_gost !=$booker;";
          $result_dr_gosti = mysqli_query($conn,$select_dr_gosti);
          $resultCheck = mysqli_num_rows($result_dr_gosti);
          if ($resultCheck > 0){
            while ($row = mysqli_fetch_assoc($result_dr_gosti)){
              array_push($polje_gosti_dr,$row['datum_rodenja']);
            }
          }
      $delete_booker_from_gosti_temp = "DELETE FROM gosti_temp WHERE id_gost = $booker;";
      if (!mysqli_query($conn,$delete_booker_from_gosti_temp))
        echo("Greska:".mysqli_error($conn));
      $length_gosti = count($polje_gosti_id);

      $drop_temp_rezervacija = "DROP TABLE IF EXISTS temp_rezervacija;";
      mysqli_query($conn,$drop_temp_rezervacija);
      $create_temp_rezervacija = "CREATE TABLE IF NOT EXISTS temp_rezervacija (
      	id_rezervacija SERIAL AUTO_INCREMENT,
          id_soba BIGINT UNSIGNED NOT NULL,
          id_gost BIGINT UNSIGNED NOT NULL,
          id_sezona BIGINT UNSIGNED NOT NULL DEFAULT 11,
          id_aranzman BIGINT UNSIGNED NOT NULL,
          pocetak_rezervacije DATE NOT NULL,
          kraj_rezervacije DATE NOT NULL,
          broj_osoba TINYINT NOT NULL DEFAULT 1,
          CONSTRAINT temp_rezervacija_id_rezervacija_pk PRIMARY KEY (id_rezervacija),
          CONSTRAINT temp_rezervacija_check_broj_osoba CHECK (broj_osoba>0)
      );";
        mysqli_query($conn,$create_temp_rezervacija);
      $insert_temp_rezervacija = "INSERT INTO temp_rezervacija (id_soba,id_gost,id_sezona,id_aranzman,pocetak_rezervacije,kraj_rezervacije,broj_osoba)
      VALUES ($odabrana_soba_id,$booker_id,DEFAULT,$odabrani_aranzman_id,'$odabrani_dd','$odabrani_do',DEFAULT);";
      if (!mysqli_query($conn,$insert_temp_rezervacija))
        echo("Greska:".mysqli_error($conn));

        $get_temp_res_id = "SELECT id_rezervacija FROM temp_rezervacija;";
        $result_get_temp_res_id = mysqli_query($conn,$get_temp_res_id);
        $resultCheck = mysqli_num_rows($result_get_temp_res_id);
        if ($resultCheck > 0){
          while ($row = mysqli_fetch_assoc($result_get_temp_res_id)){
            $temp_res_id =  ($row['id_rezervacija']);
          }
        }


      $drop_temp_odabrane_usluge = "DROP TABLE IF EXISTS temp_odabrane_usluge;";
        mysqli_query($conn,$drop_temp_odabrane_usluge);
      $create_temp_odabrane_usluge = "CREATE TABLE IF NOT EXISTS temp_odabrane_usluge (
        id_odabrane_usluge SERIAL AUTO_INCREMENT,
      	id_dodatne_usluge BIGINT UNSIGNED NOT NULL,
      	id_rezervacija BIGINT UNSIGNED NOT NULL,
        kolicina INTEGER NOT NULL,
        CONSTRAINT temp_odabrane_usluge_id_odabrane_u_pk PRIMARY KEY (id_odabrane_usluge),
        CONSTRAINT temp_odabrane_usluge_check_kolicina CHECK (kolicina>0)
      );";
      if (!mysqli_query($conn,$create_temp_odabrane_usluge))
        echo("Greska:".mysqli_error($conn));

      $drop_temp_odabrani_gosti = "DROP TABLE IF EXISTS temp_odabrani_gosti;";
        mysqli_query($conn,$drop_temp_odabrani_gosti);
      $create_temp_odabrani_gosti = "CREATE TABLE IF NOT EXISTS temp_odabrani_gosti (
        id_odabrani_gost SERIAL AUTO_INCREMENT,
        id_gost BIGINT UNSIGNED NOT NULL,
        id_rezervacija BIGINT UNSIGNED NOT NULL,
        CONSTRAINT temp_odabrani_gost_id_odabrani_g_pk PRIMARY KEY (id_odabrani_gost)
      );";
        mysqli_query($conn,$create_temp_odabrani_gosti);
      $ukupna_cijena=0;
      $ukupna_cijena = ($trajanje*$odabrana_soba_cijena)+$odabrani_aranzman_cijena;

     //________________________________ispis______________________________________
     echo('<!DOCTYPE html>
     <html lang="en">
     <head>
       <meta charset="UTF-8">
       <meta name="viewport" content="width=device-width, initial-scale=1.0">
       <meta http-equiv="X-UA-Compatible" content="ie=edge">
       <!--W3.CSS-->
       <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
       <!--Fontawesome-->
       <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.6.3/css/all.css" integrity="sha384-UHRtZLI+pbxtHCWp1t77Bi1L4ZtiqrqD80Kn4Z8NTSRyMA2Fd33n5dQ8lWUE00s/" crossorigin="anonymous" />
       <!--CSS-->
       <link rel="stylesheet" type="text/css" href="style.css">
       <!--JS-->
       <script src="script.js"></script>
       <!--jQuery-->
       <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
       <!--CSS-->
       <title>Sustav za upravljanje hotelom</title>
       <link rel="icon" href="favicon.ico" type="image/x-icon">
       <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
     </head>
     <body>
       <div class="w3-row w3-container">
         <!--side-->
         <div class="w3-container w3-col m0 l2"></div>
         <!--end side-->
         <!--main-->
         <div class="w3-container w3-khaki  w3-col s12 m12 l8 w3-padding-32">
           <div class="w3-card-2 w3-amber">
             <a title="Povratak na prijavu" href="index.html"><button style="line-height:50%;" type="button" name="back_button" class="w3-button w3-circle w3-black w3-large w3-margin-left w3-margin-top"><i style="margin-top:1px;" class="fas fa-arrow-left fa-2x"></i></button></a>
             <h1 class="w3-center w3-padding-32"><b>UNESENI PODACI</b></h1>
             <hr>
             <div class="w3-container w3-center">
             <form name= "potvrda_rezervacije" action="potvrda-rezervacije.php" method="POST" onsubmit="return rezervacija_potvrda()">
               <h2>Mjesto prebivališta gostiju</h2>
               <p><b>Država: </b>'.$odabrana_drzava.'</p>
               <p><b>Grad: </b>'.$odabrani_grad.'</p>
               <p><b>Poštanski broj: </b>'.$odabrani_pb.'</p>
               <p><b>Adresa prebivališta: </b>'.$odabrana_adresa.'</p>
               <hr>
               <h2>Razdoblje boravka</h2>
               <p><b>Od</b> '.$odabrani_dd.'<b> do </b>'.$odabrani_do.'</p>
               <p><b>Trajanje: </b>'.$trajanje.' dana</p>
               <p><b>Turistička sezona: </b>'.$sezona_naziv.'</p>
               <hr>
               <h2>Gosti</h2>
               <p>Rezervacija i račun glasit će na: <b>'.$booker_ime_prezime.'</b></p>
               <p><b>Ime i prezime: </b>'.$booker_ime_prezime.'</p>
               <p><b>OIB: </b>'.$booker_oib.'</p>
               <p><b>Broj osobne iskaznice: </b>'.$booker_boi.'</p>
               <p><b>Datum rođenja: </b>'.$booker_dr.'</p>
               <br>
               <h4>Popis ostalih gostiju:</h4>');
               for ($i=0; $i < $length_gosti; $i++){
                 echo ('<p><b>'.$i+1 .'. gost: </b>');
                 echo ($polje_gosti_ime[$i]." ".$polje_gosti_prezime[$i].", <b>OIB: </b>".$polje_gosti_oib[$i].", <b>Br. osobne iskaznice: </b>"
                 .$polje_gosti_boi[$i].", <b>Datum rođenja: </b>".$polje_gosti_dr[$i]."<br>");
                 $insert_temp_odabrani_gosti = "INSERT INTO temp_odabrani_gosti (id_gost,id_rezervacija)
                 VALUES ($polje_gosti_id[$i],$temp_res_id);";
                 if (!mysqli_query($conn,$insert_temp_odabrani_gosti))
                   echo("Greska:".mysqli_error($conn));}
              echo('
               <hr>
               <h2>Odabrana soba i aranžman</h2>
               <p><b>Odabrana soba: </b>'.$odabrana_soba.'</p>
               <p>Cijena sobe: '.$odabrana_soba_cijena.' kn</p>
               <p><b>Odabrani aranžman: </b>'.$odabrani_aranzman.'</p>
               <p>Cijena aranžmana: '.$odabrani_aranzman_cijena.' kn</p>
               <hr>
               <h2>Dodatne usluge</h2>');
               foreach($polje_du_id as $item){
                 $select_du_naziv = "SELECT naziv
             		                FROM dodatne_usluge
                                WHERE id_dodatne_usluge = $item";
                  $result_du_naziv = mysqli_query($conn,$select_du_naziv);
                  $resultCheck = mysqli_num_rows($result_du_naziv);
                  if ($resultCheck > 0){
                    while ($row = mysqli_fetch_assoc($result_du_naziv)){
                      $du_naziv= $row['naziv'];
                    }
                  }

                  $select_du_cijena = "SELECT cijena
                                 FROM dodatne_usluge
                                 WHERE id_dodatne_usluge = $item;";
                   $result_du_cijena = mysqli_query($conn,$select_du_cijena);
                   $resultCheck = mysqli_num_rows($result_du_cijena);
                   if ($resultCheck > 0){
                     while ($row = mysqli_fetch_assoc($result_du_cijena)){
                       $du_cijena= $row['cijena'];
                     }
                   }

                   $select_du_id = "SELECT id_dodatne_usluge
                                  FROM dodatne_usluge
                                  WHERE id_dodatne_usluge = $item;";
                    $result_du_id = mysqli_query($conn,$select_du_id);
                    $resultCheck = mysqli_num_rows($result_du_id);
                    if ($resultCheck > 0){
                      while ($row = mysqli_fetch_assoc($result_du_id)){
                        $du_id= $row['id_dodatne_usluge'];
                      }
                    }

                 if (isset($_POST[$item])){
                   echo ("<b>".$du_naziv."</b>");
                   echo (" - odabrana količina: ".$_POST['q_'.$item]);
                   $temp_k = intval($_POST['q_'.$item]);
                   echo('<br>');
                   echo ("Cijena: ".$du_cijena." kn x ". $_POST['q_'.$item]." = ".intval($du_cijena)*intval($_POST['q_'.$item])." kn");
                   echo('<br><br>');
                   $insert_temp_odabrane_usluge ="INSERT INTO temp_odabrane_usluge (id_dodatne_usluge,id_rezervacija,kolicina)
                   VALUES ($du_id,$temp_res_id,$temp_k);";
                   if (!mysqli_query($conn,$insert_temp_odabrane_usluge))
                     echo("Greska:".mysqli_error($conn));
                     $ukupna_cijena+=(intval($du_cijena)*intval($_POST['q_'.$item]));
                 }
               }
               echo('
               <hr>
             </div>
             <div class="w3-container w3-right-align">
             <p><b>Ukupna cijena: </b>'.$multiplikator*$ukupna_cijena.' kn</p>
             </div>
             <div class="w3-container w3-center">
               <button class="w3-button w3-round-large w3-red w3-margin-bottom" type="submit">Potvrda rezervacije</button>
               </form>
             </div>
             </div>
             <!--End Soba-->
           </div>
         </div>
         <!--end main-->
         <!--side-->
         <div class="w3-container w3-col l2">
         </div>
         <!--end side-->
       <div class="w3-row creators w3-amber w3-margin-top w3-center">
         <p><b>Projekt - Baze podataka 2, FIPU</b></p>
         <p><b>Tim 4</b> - Sustav za upravljanje hotelom</p>
         <p>Web aplikaciju izradio Luka Blašković</p>
       </div>
     </body>

     </html>
');





 ?>
