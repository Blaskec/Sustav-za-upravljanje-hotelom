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

    //Vadenje soba iz baze
    // vadenje SGL soba iz baze
    $polje_s = [];
    $select_sgl_soba = "SELECT *
                         FROM soba
                         WHERE vrsta='SGL'; ";
     $result_sgl_soba = mysqli_query($conn,$select_sgl_soba);
     $resultCheck = mysqli_num_rows($result_sgl_soba);
     if ($resultCheck > 0){
       while ($row = mysqli_fetch_assoc($result_sgl_soba)){
         array_push($polje_s,$row['sifra']);
       }
     }
     // vadenje DBL soba iz baze
     $polje_s1 = [];
     $select_dbl_soba = "SELECT *
                          FROM soba
                          WHERE vrsta='DBL'; ";
      $result_dbl_soba = mysqli_query($conn,$select_dbl_soba);
      $resultCheck = mysqli_num_rows($result_dbl_soba);
      if ($resultCheck > 0){
        while ($row = mysqli_fetch_assoc($result_dbl_soba)){
          array_push($polje_s1,$row['sifra']);
        }
      }
      // vadenje TWIN soba iz baze
      $polje_s3 = [];
      $select_twin_soba = "SELECT *
                           FROM soba
                           WHERE vrsta='TWIN'; ";
       $result_twin_soba = mysqli_query($conn,$select_twin_soba);
       $resultCheck = mysqli_num_rows($result_twin_soba);
       if ($resultCheck > 0){
         while ($row = mysqli_fetch_assoc($result_twin_soba)){
           array_push($polje_s3,$row['sifra']);
         }
       }
       // vadenje TRPl soba iz baze
       $polje_s4 = [];
       $select_trpl_soba = "SELECT *
                            FROM soba
                            WHERE vrsta='TRPL'; ";
        $result_trpl_soba = mysqli_query($conn,$select_trpl_soba);
        $resultCheck = mysqli_num_rows($result_trpl_soba);
        if ($resultCheck > 0){
          while ($row = mysqli_fetch_assoc($result_trpl_soba)){
            array_push($polje_s4,$row['sifra']);
          }
        }
        //vadenje QDPl soba iz baze
        $polje_s5 = [];
        $select_qdpl_soba = "SELECT *
                             FROM soba
                             WHERE vrsta='QDPL'; ";
         $result_qdpl_soba = mysqli_query($conn,$select_qdpl_soba);
         $resultCheck = mysqli_num_rows($result_qdpl_soba);
         if ($resultCheck > 0){
           while ($row = mysqli_fetch_assoc($result_qdpl_soba)){
             array_push($polje_s5,$row['sifra']);
           }
         }
         //Vadenje aranzmana iz baze
         $polje_ar = [];
         $select_ar = "SELECT opis_aranzmana
     		                FROM aranzman;";
          $result_ar = mysqli_query($conn,$select_ar);
          $resultCheck = mysqli_num_rows($result_ar);
          if ($resultCheck > 0){
            while ($row = mysqli_fetch_assoc($result_ar)){
              array_push($polje_ar,$row['opis_aranzmana']);
            }
          }
          //Vadenje naziva dodatnih usluga
          $polje_du_naziv = [];
          $select_du_naziv = "SELECT naziv
                         FROM dodatne_usluge;";
           $result_du_naziv = mysqli_query($conn,$select_du_naziv);
           $resultCheck = mysqli_num_rows($result_du_naziv);
           if ($resultCheck > 0){
             while ($row = mysqli_fetch_assoc($result_du_naziv)){
               array_push($polje_du_naziv,$row['naziv']);
             }
           }
           //Vadenje racun_prikaz pogleda iz baze podataka
           $polje_racuna = [];
           $select_racun_prikaz = "SELECT *
                                    FROM racun_prikaz;";
            $result_racun_prikaz = mysqli_query($conn,$select_racun_prikaz);
            $resultCheck = mysqli_num_rows($result_racun_prikaz);
            if ($resultCheck > 0){
              while ($row = mysqli_fetch_assoc($result_racun_prikaz)){
                array_push($polje_racuna,$row['sifra']);
              }
            }
            $polje_rez_bez_racun = [];
            $select_rez_bez_racun = "SELECT rezervacija_id
                           FROM rezervacija_bez_racuna;";
             $result_rez_bez_racun = mysqli_query($conn,$select_rez_bez_racun);
             $resultCheck = mysqli_num_rows($result_rez_bez_racun);
             if ($resultCheck > 0){
               while ($row = mysqli_fetch_assoc($result_rez_bez_racun)){
                 array_push($polje_rez_bez_racun,$row['rezervacija_id']);
               }
             }
             //___________________________Pogledi fetch_______________________
             $polje_gosti_trenutno_u_hotelu = [];
             $select_gosti_trenutno_u_hotelu = "SELECT id_rezervacija
                            FROM gosti_trenutno_u_hotelu;";
              $result_gosti_trenutno_u_hotelu = mysqli_query($conn,$select_gosti_trenutno_u_hotelu);
              $resultCheck = mysqli_num_rows($result_gosti_trenutno_u_hotelu);
              if ($resultCheck > 0){
                while ($row = mysqli_fetch_assoc($result_gosti_trenutno_u_hotelu)){
                  array_push($polje_gosti_trenutno_u_hotelu,$row['id_rezervacija']);
                }
              }
              $polje_gosti_sve = [];
              $select_gosti_sve = "SELECT ime
                             FROM prikaz_gostiju_ukupni_podaci;";
               $result_gosti_sve = mysqli_query($conn,$select_gosti_sve);
               $resultCheck = mysqli_num_rows($result_gosti_sve);
               if ($resultCheck > 0){
                 while ($row = mysqli_fetch_assoc($result_gosti_sve)){
                   array_push($polje_gosti_sve,$row['ime']);
                 }
               }


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
            <h1 class="w3-center w3-padding-32"><b>DJELATNIK - rad nad sustavom</b></h1><hr>
            <div class = "w3-container">
              <i class="fas fa-eye fa-2x"> <h2 style="display:inline-block">Pogledi</h2></i><br><br>
                <button onclick="document.getElementById(\'id01\').style.display=\'block\'"
                class="w3-button w3-black">Gosti trenutno u hotelu</button>

                <div id="id01" class="w3-modal">
                  <div class="w3-modal-content">
                    <div class="w3-container">
                      <span onclick="document.getElementById(\'id01\').style.display=\'none\'"
                      class="w3-button w3-display-topright">&times;</span>
                      <h2>Pogled - Gosti trenutno u hotelu</h2>
                      <table class="w3-table w3-striped w3-bordered w3-margin-bottom w3-hoverable">
                      <tr class="w3-dark-grey">
                      <th>ID_rezervacija</th>
                      <th>Ime</th>
                      <th>Prezime</th>
                      <th>Šifra sobe</th>
                      </tr>');
                      $i = 1;
                      foreach ($polje_gosti_trenutno_u_hotelu as $p1_stavka){

                        $select_gtuh_ime = "SELECT ime
                                       FROM gosti_trenutno_u_hotelu
                                       WHERE id_rezervacija = '$p1_stavka';";
                         $result_gtuh_ime = mysqli_query($conn,$select_gtuh_ime);
                         $resultCheck = mysqli_num_rows($result_gtuh_ime);
                         if ($resultCheck > 0){
                           while ($row = mysqli_fetch_assoc($result_gtuh_ime)){
                             $gtuh_ime= $row['ime'];
                           }
                         }
                         $select_gtuh_prezime = "SELECT prezime
                                        FROM gosti_trenutno_u_hotelu
                                        WHERE id_rezervacija = '$p1_stavka';";
                          $result_gtuh_prezime = mysqli_query($conn,$select_gtuh_prezime);
                          $resultCheck = mysqli_num_rows($result_gtuh_prezime);
                          if ($resultCheck > 0){
                            while ($row = mysqli_fetch_assoc($result_gtuh_prezime)){
                              $gtuh_prezime= $row['prezime'];
                            }
                          }
                          $select_gtuh_sifra = "SELECT sifra
                                         FROM gosti_trenutno_u_hotelu
                                         WHERE id_rezervacija = '$p1_stavka';";
                           $result_gtuh_sifra = mysqli_query($conn,$select_gtuh_sifra);
                           $resultCheck = mysqli_num_rows($result_gtuh_sifra);
                           if ($resultCheck > 0){
                             while ($row = mysqli_fetch_assoc($result_gtuh_sifra)){
                               $gtuh_sifra= $row['sifra'];
                             }
                           }

                        if($i%2==0){
                          echo ('<tr class="w3-light-grey ">
                          <th>'.$p1_stavka.'</th>
                          <th>'.$gtuh_ime.'</th>
                          <th>'.$gtuh_prezime.'</th>
                          <th>'.$gtuh_sifra.'</th>
                          </tr>');
                        }
                      else {
                        echo ('<tr class="w3-light-grey ">
                        <th>'.$p1_stavka.'</th>
                        <th>'.$gtuh_ime.'</th>
                        <th>'.$gtuh_prezime.'</th>
                        <th>'.$gtuh_sifra.'</th>
                        </tr>');
                      }
                      $i++;
                      }
                      echo('</table>
                    </div>
                  </div>
                </div>');
                echo('
                <button onclick="document.getElementById(\'id02\').style.display=\'block\'"
                class="w3-button w3-black">Najpopularnija soba</button>

                <div id="id02" class="w3-modal">
                  <div class="w3-modal-content">
                    <div class="w3-container">
                      <span onclick="document.getElementById(\'id02\').style.display=\'none\'"
                      class="w3-button w3-display-topright">&times;</span>
                      <h2>Pogled - Najpopularnija soba</h2>
                      <table class="w3-table w3-striped w3-bordered w3-margin-bottom w3-hoverable">
                      <tr class="w3-dark-grey">
                      <th>ID_soba</th>
                      <th>Šifra</th>
                      <th>Kat</th>
                      <th>Cijena</th>
                      <th>Vrsta</th>
                      </tr>');
                      $select_ns_id = "SELECT id_soba
                                     FROM najpopularnija_soba;";
                       $result_ns_id = mysqli_query($conn,$select_ns_id);
                       $resultCheck = mysqli_num_rows($result_ns_id);
                       if ($resultCheck > 0){
                         while ($row = mysqli_fetch_assoc($result_ns_id)){
                           $ns_id= $row['id_soba'];
                         }
                       }
                       $select_ns_sifra = "SELECT sifra
                                      FROM najpopularnija_soba;";
                        $result_ns_sifra = mysqli_query($conn,$select_ns_sifra);
                        $resultCheck = mysqli_num_rows($result_ns_sifra);
                        if ($resultCheck > 0){
                          while ($row = mysqli_fetch_assoc($result_ns_sifra)){
                            $ns_sifra= $row['sifra'];
                          }
                        }
                        $select_ns_kat = "SELECT kat
                                       FROM najpopularnija_soba;";
                         $result_ns_kat = mysqli_query($conn,$select_ns_kat);
                         $resultCheck = mysqli_num_rows($result_ns_kat);
                         if ($resultCheck > 0){
                           while ($row = mysqli_fetch_assoc($result_ns_kat)){
                             $ns_kat= $row['kat'];
                           }
                         }
                         $select_ns_cijena = "SELECT standardna_cijena
                                        FROM najpopularnija_soba;";
                          $result_ns_cijena = mysqli_query($conn,$select_ns_cijena);
                          $resultCheck = mysqli_num_rows($result_ns_cijena);
                          if ($resultCheck > 0){
                            while ($row = mysqli_fetch_assoc($result_ns_cijena)){
                              $ns_cijena= $row['standardna_cijena'];
                            }
                          }
                          $select_ns_vrsta = "SELECT vrsta
                                         FROM najpopularnija_soba;";
                           $result_ns_vrsta = mysqli_query($conn,$select_ns_vrsta);
                           $resultCheck = mysqli_num_rows($result_ns_vrsta);
                           if ($resultCheck > 0){
                             while ($row = mysqli_fetch_assoc($result_ns_vrsta)){
                               $ns_vrsta= $row['vrsta'];
                             }
                           }
                          echo ('<tr class="w3-light-grey ">
                          <th>'.$ns_id.'</th>
                          <th>'.$ns_sifra.'</th>
                          <th>'.$ns_kat.'</th>
                          <th>'.$ns_cijena.'</th>
                          <th>'.$ns_vrsta.'</th>
                          </tr>');

                      echo('</table>
                    </div>
                  </div>
                </div>');

                echo('
                <button onclick="document.getElementById(\'id03\').style.display=\'block\'"
                class="w3-button w3-black">Najpopularnija usluga</button>

                <div id="id03" class="w3-modal">
                  <div class="w3-modal-content">
                    <div class="w3-container">
                      <span onclick="document.getElementById(\'id03\').style.display=\'none\'"
                      class="w3-button w3-display-topright">&times;</span>
                      <h2>Pogled - Najpopularnija usluga</h2>
                      <table class="w3-table w3-striped w3-bordered w3-margin-bottom w3-hoverable">
                      <tr class="w3-dark-grey">
                      <th>ID_dodatna_usluga</th>
                      <th>Naziv</th>
                      <th>Cijena</th>
                      </tr>');
                      $select_ndu_id = "SELECT id_dodatne_usluge
                                     FROM najpopularnija_usluga;";
                       $result_ndu_id = mysqli_query($conn,$select_ndu_id);
                       $resultCheck = mysqli_num_rows($result_ndu_id);
                       if ($resultCheck > 0){
                         while ($row = mysqli_fetch_assoc($result_ndu_id)){
                           $ndu_id= $row['id_dodatne_usluge'];
                         }
                       }
                       $select_ndu_naziv = "SELECT naziv
                                      FROM najpopularnija_usluga;";
                        $result_ndu_naziv = mysqli_query($conn,$select_ndu_naziv);
                        $resultCheck = mysqli_num_rows($result_ndu_naziv);
                        if ($resultCheck > 0){
                          while ($row = mysqli_fetch_assoc($result_ndu_naziv)){
                            $ndu_naziv= $row['naziv'];
                          }
                        }
                        $select_ndu_cijena = "SELECT cijena
                                       FROM najpopularnija_usluga;";
                         $result_ndu_cijena = mysqli_query($conn,$select_ndu_cijena);
                         $resultCheck = mysqli_num_rows($result_ndu_cijena);
                         if ($resultCheck > 0){
                           while ($row = mysqli_fetch_assoc($result_ndu_cijena)){
                             $ndu_cijena= $row['cijena'];
                           }
                         }
                          echo ('<tr class="w3-light-grey ">
                          <th>'.$ndu_id.'</th>
                          <th>'.$ndu_naziv.'</th>
                          <th>'.$ndu_cijena.'</th>
                          </tr>');

                      echo('</table>
                    </div>
                  </div>
                </div>');

                echo('
                <button onclick="document.getElementById(\'id04\').style.display=\'block\'"
                class="w3-button w3-black">Rezervacije po sezoni</button>

                <div id="id04" class="w3-modal">
                  <div class="w3-modal-content">
                    <div class="w3-container">
                      <span onclick="document.getElementById(\'id04\').style.display=\'none\'"
                      class="w3-button w3-display-topright">&times;</span>
                      <h2>Pogled - Rezervacije po sezoni</h2>
                      <table class="w3-table w3-striped w3-bordered w3-margin-bottom w3-hoverable">
                      <tr class="w3-dark-grey">
                      <th>Ljetne rezervacije</th>
                      <th>Jesenske rezervacije</th>
                      <th>Zimske rezervacije</th>
                      <th>Proljetne rezervacije</th>
                      </tr>');
                      $select_rps_1 = "SELECT ljetne_rezervacije
                                     FROM broj_rezervacija_po_sezoni;";
                       $result_rps_1 = mysqli_query($conn,$select_rps_1);
                       $resultCheck = mysqli_num_rows($result_rps_1);
                       if ($resultCheck > 0){
                         while ($row = mysqli_fetch_assoc($result_rps_1)){
                           $rps_1= $row['ljetne_rezervacije'];
                         }
                       }
                       $select_rps_2 = "SELECT jesenske_rezervacije
                                      FROM broj_rezervacija_po_sezoni;";
                        $result_rps_2 = mysqli_query($conn,$select_rps_2);
                        $resultCheck = mysqli_num_rows($result_rps_2);
                        if ($resultCheck > 0){
                          while ($row = mysqli_fetch_assoc($result_rps_2)){
                            $rps_2= $row['jesenske_rezervacije'];
                          }
                        }
                        $select_rps_3 = "SELECT zimske_rezervacije
                                       FROM broj_rezervacija_po_sezoni;";
                         $result_rps_3 = mysqli_query($conn,$select_rps_3);
                         $resultCheck = mysqli_num_rows($result_rps_3);
                         if ($resultCheck > 0){
                           while ($row = mysqli_fetch_assoc($result_rps_3)){
                             $rps_3= $row['zimske_rezervacije'];
                           }
                         }
                         $select_rps_4 = "SELECT proljetne_rezervacije
                                        FROM broj_rezervacija_po_sezoni;";
                          $result_rps_4 = mysqli_query($conn,$select_rps_4);
                          $resultCheck = mysqli_num_rows($result_rps_4);
                          if ($resultCheck > 0){
                            while ($row = mysqli_fetch_assoc($result_rps_4)){
                              $rps_4= $row['proljetne_rezervacije'];
                            }
                          }
                          echo ('<tr class="w3-light-grey ">
                          <th>'.$rps_1.'</th>
                          <th>'.$rps_2.'</th>
                          <th>'.$rps_3.'</th>
                          <th>'.$rps_4.'</th>
                          </tr>');

                      echo('</table>
                    </div>
                  </div>
                </div>');

                echo ('<button onclick="document.getElementById(\'id05\').style.display=\'block\'"
                class="w3-button w3-black">Gosti - ukupno boravka/potrošeno</button>

                <div id="id05" class="w3-modal">
                  <div class="w3-modal-content">
                    <div class="w3-container">
                      <span onclick="document.getElementById(\'id05\').style.display=\'none\'"
                      class="w3-button w3-display-topright">&times;</span>
                      <h2>Pogled - Gosti - ukupno boravka/potrošeno</h2>
                      <table class="w3-table w3-striped w3-bordered w3-margin-bottom w3-hoverable">
                      <tr class="w3-dark-grey">
                      <th>Ime</th>
                      <th>Prezime</th>
                      <th>Broj rezervacija</th>
                      <th>Ukupno potrošeno</th>
                      </tr>');
                      $i = 1;
                      foreach ($polje_gosti_sve as $stavka_ime){

                        $select_pku_ime = "SELECT ime
                                       FROM prikaz_gostiju_ukupni_podaci
                                       WHERE ime = '$stavka_ime';";
                         $result_pku_ime  = mysqli_query($conn,$select_pku_ime);
                         $resultCheck = mysqli_num_rows($result_pku_ime);
                         if ($resultCheck > 0){
                           while ($row = mysqli_fetch_assoc($result_pku_ime)){
                             $pku_ime= $row['ime'];
                           }
                         }
                         $select_pku_prezime = "SELECT prezime
                                        FROM prikaz_gostiju_ukupni_podaci
                                        WHERE ime = '$stavka_ime';";
                          $result_pku_prezime  = mysqli_query($conn,$select_pku_prezime);
                          $resultCheck = mysqli_num_rows($result_pku_prezime);
                          if ($resultCheck > 0){
                            while ($row = mysqli_fetch_assoc($result_pku_prezime)){
                              $pku_prezime= $row['prezime'];
                            }
                          }
                          $select_pku_br = "SELECT broj_rezervacija
                                         FROM prikaz_gostiju_ukupni_podaci
                                         WHERE ime = '$stavka_ime';";
                           $result_pku_br  = mysqli_query($conn,$select_pku_br);
                           $resultCheck = mysqli_num_rows($result_pku_br);
                           if ($resultCheck > 0){
                             while ($row = mysqli_fetch_assoc($result_pku_br)){
                               $pku_br= $row['broj_rezervacija'];
                             }
                           }
                           $select_pku_uk = "SELECT ukupno_potroseno
                                          FROM prikaz_gostiju_ukupni_podaci
                                          WHERE ime = '$stavka_ime';";
                            $result_pku_uk  = mysqli_query($conn,$select_pku_uk);
                            $resultCheck = mysqli_num_rows($result_pku_uk);
                            if ($resultCheck > 0){
                              while ($row = mysqli_fetch_assoc($result_pku_uk)){
                                $pku_uk= $row['ukupno_potroseno'];
                              }
                            }

                        if($i%2==0){
                          echo ('<tr class="w3-light-grey ">
                          <th>'.$pku_ime.'</th>
                          <th>'.$pku_prezime.'</th>
                          <th>'.$pku_br.'</th>
                          <th>'.$pku_uk.' kn</th>
                          </tr>');
                        }
                      else {
                        echo ('<tr class="w3-light-grey ">
                        <th>'.$pku_ime.'</th>
                        <th>'.$pku_prezime.'</th>
                        <th>'.$pku_br.'</th>
                        <th>'.$pku_uk.' kn</th>
                        </tr>');
                      }
                      $i++;
                    }
                      echo('</table>
                    </div>
                  </div>
                </div>');

//__________________________________________________________________________________________________
                echo('
            </div>
            <hr>
            <div class="w3-container">
              <i class="fas fa-receipt fa-2x"> <h2 style="display:inline-block">Popis računa</h2></i>
              <table class="w3-table w3-striped w3-bordered w3-margin-bottom w3-hoverable">
              <tr class="w3-dark-grey">
              <th>Šifra</th>
              <th>Datum i vrijeme izdavanja</th>
              <th>Racun izdao</th>
              <th>Rezervirao</th>
              <th>Ukupna cijena</th>
              </tr>');
              $i = 1;
              foreach ($polje_racuna as $racun_stavka){

                $select_racun_datum = "SELECT datum_i_vrijeme_izdavanja
                               FROM racun_prikaz
                               WHERE sifra = '$racun_stavka';";
                 $result_racun_datum = mysqli_query($conn,$select_racun_datum);
                 //if (!mysqli_query($conn,$select_s_kat))
                 //echo("Error description: ". mysqli_error($conn));
                 $resultCheck = mysqli_num_rows($result_racun_datum);
                 if ($resultCheck > 0){
                   while ($row = mysqli_fetch_assoc($result_racun_datum)){
                     $racun_datum= $row['datum_i_vrijeme_izdavanja'];
                   }
                 }
                 $select_racun_djel = "SELECT racun_izdao
                                FROM racun_prikaz
                                WHERE sifra = '$racun_stavka';";
                  $result_racun_djel = mysqli_query($conn,$select_racun_djel);
                  //if (!mysqli_query($conn,$select_s_kat))
                  //echo("Error description: ". mysqli_error($conn));
                  $resultCheck = mysqli_num_rows($result_racun_djel);
                  if ($resultCheck > 0){
                    while ($row = mysqli_fetch_assoc($result_racun_djel)){
                      $racun_izdao= $row['racun_izdao'];
                    }
                  }
                  $select_racun_booker = "SELECT rezervirao
                                 FROM racun_prikaz
                                 WHERE sifra = '$racun_stavka';";
                   $result_racun_booker = mysqli_query($conn,$select_racun_booker);
                   //if (!mysqli_query($conn,$select_s_kat))
                   //echo("Error description: ". mysqli_error($conn));
                   $resultCheck = mysqli_num_rows($result_racun_booker);
                   if ($resultCheck > 0){
                     while ($row = mysqli_fetch_assoc($result_racun_booker)){
                       $racun_rezervirao= $row['rezervirao'];
                     }
                   }
                   $select_racun_cj = "SELECT ukupna_cijena
                                  FROM racun_prikaz
                                  WHERE sifra = '$racun_stavka';";
                    $result_racun_cj = mysqli_query($conn,$select_racun_cj);
                    //if (!mysqli_query($conn,$select_s_kat))
                    //echo("Error description: ". mysqli_error($conn));
                    $resultCheck = mysqli_num_rows($result_racun_cj);
                    if ($resultCheck > 0){
                      while ($row = mysqli_fetch_assoc($result_racun_cj)){
                        $racun_cijena= $row['ukupna_cijena'];
                      }
                    }
                if($i%2==0){
                  echo ('<tr class="w3-light-grey ">
                  <th>'.$racun_stavka.'</th>
                  <th>'.$racun_datum.'</th>
                  <th>'.$racun_izdao.'</th>
                  <th>'.$racun_rezervirao.'</th>
                  <th>'.$racun_cijena.' kn</th>
                  </tr>');
                }
              else {
                echo ('<tr class="w3-sand ">
                <th>'.$racun_stavka.'</th>
                <th>'.$racun_datum.'</th>
                <th>'.$racun_izdao.'</th>
                <th>'.$racun_rezervirao.'</th>
                <th>'.$racun_cijena.' kn</th>
                </tr>');
              }
              $i++;
              }
              echo('</table></div>
              <div class="w3-container">
                <hr>
                <i class="fas fa-plane-departure fa-2x"> <h2 style="display:inline-block">Popis rezervacija bez izdanog računa</h2></i>
                <table class="w3-table w3-striped w3-bordered w3-margin-bottom w3-hoverable">
                <tr class="w3-dark-grey">
                <th>ID rezervacije</th>
                <th>Rezervirao</th>
                <th>Aranžman</th>
                <th>Šifra sobe</th>
                <th>Sezona</th>
                <th>Početak</th>
                <th>Kraj</th>
                <th>Broj osoba</th>
                </tr>');
                $i = 1;
                foreach ($polje_rez_bez_racun as $rez){

                  $select_rez_rezervirao = "SELECT rezervirao
                                 FROM rezervacija_bez_racuna
                                 WHERE rezervacija_id = $rez;";
                   $result_rez_rezervirao = mysqli_query($conn,$select_rez_rezervirao);
                   $resultCheck = mysqli_num_rows($result_rez_rezervirao);
                   if ($resultCheck > 0){
                     while ($row = mysqli_fetch_assoc($result_rez_rezervirao)){
                       $rez_rezervirao= $row['rezervirao'];
                     }
                   }
                   $select_rez_aranzman = "SELECT aranzman
                                  FROM rezervacija_bez_racuna
                                  WHERE rezervacija_id = $rez;";
                    $result_rez_aranzman = mysqli_query($conn,$select_rez_aranzman);
                    $resultCheck = mysqli_num_rows($result_rez_aranzman);
                    if ($resultCheck > 0){
                      while ($row = mysqli_fetch_assoc($result_rez_aranzman)){
                        $rez_aranzman= $row['aranzman'];
                      }
                    }
                    $select_rez_soba = "SELECT sifra_sobe
                                   FROM rezervacija_bez_racuna
                                   WHERE rezervacija_id = $rez;";
                     $result_rez_soba = mysqli_query($conn,$select_rez_soba);
                     $resultCheck = mysqli_num_rows($result_rez_soba);
                     if ($resultCheck > 0){
                       while ($row = mysqli_fetch_assoc($result_rez_soba)){
                         $rez_soba= $row['sifra_sobe'];
                       }
                     }
                     $select_rez_sezona = "SELECT sezona
                                    FROM rezervacija_bez_racuna
                                    WHERE rezervacija_id = $rez;";
                      $result_rez_sezona = mysqli_query($conn,$select_rez_sezona);
                      $resultCheck = mysqli_num_rows($result_rez_sezona);
                      if ($resultCheck > 0){
                        while ($row = mysqli_fetch_assoc($result_rez_sezona)){
                          $rez_sezona= $row['sezona'];
                        }
                      }
                      $select_rez_pr = "SELECT pocetak_rezervacije
                                     FROM rezervacija_bez_racuna
                                     WHERE rezervacija_id = $rez;";
                       $result_rez_pr = mysqli_query($conn,$select_rez_pr);
                       $resultCheck = mysqli_num_rows($result_rez_pr);
                       if ($resultCheck > 0){
                         while ($row = mysqli_fetch_assoc($result_rez_pr)){
                           $rez_pr= $row['pocetak_rezervacije'];
                         }
                       }
                       $select_rez_kr = "SELECT kraj_rezervacije
                                      FROM rezervacija_bez_racuna
                                      WHERE rezervacija_id = $rez;";
                        $result_rez_kr = mysqli_query($conn,$select_rez_kr);
                        $resultCheck = mysqli_num_rows($result_rez_kr);
                        if ($resultCheck > 0){
                          while ($row = mysqli_fetch_assoc($result_rez_kr)){
                            $rez_kr= $row['kraj_rezervacije'];
                          }
                        }
                        $select_rez_br = "SELECT broj_osoba
                                       FROM rezervacija_bez_racuna
                                       WHERE rezervacija_id = $rez;";
                         $result_rez_br = mysqli_query($conn,$select_rez_br);
                         $resultCheck = mysqli_num_rows($result_rez_br);
                         if ($resultCheck > 0){
                           while ($row = mysqli_fetch_assoc($result_rez_br)){
                             $rez_br= $row['broj_osoba'];
                           }
                         }
                  if($i%2==0){
                    echo ('<tr class="w3-red">
                    <th>'.$rez.'</th>
                    <th>'.$rez_rezervirao.'</th>
                    <th>'.$rez_aranzman.'</th>
                    <th>'.$rez_soba.'</th>
                    <th>'.$rez_sezona.'</th>
                    <th>'.$rez_pr.'</th>
                    <th>'.$rez_kr.'</th>
                    <th>'.$rez_br.'</th>
                    </tr>');
                  }
                else {
                  echo ('<tr class="w3-pale-red">
                  <th>'.$rez.'</th>
                  <th>'.$rez_rezervirao.'</th>
                  <th>'.$rez_aranzman.'</th>
                  <th>'.$rez_soba.'</th>
                  <th>'.$rez_sezona.'</th>
                  <th>'.$rez_pr.'</th>
                  <th>'.$rez_kr.'</th>
                  <th>'.$rez_br.'</th>
                  </tr>');
                }
                $i++;
                }
                echo ('</table>
                <form name="racun_create" action="djelatnik_create_racun.php" method="POST" onsubmit="return pass_racun_create()">
                <h4>Unos ID-a rezervacije za koju želite izraditi račun</h4>
                <input required name="rezervacija_ID" class="w3-input w3-border" type="text" placeholder = "ID rezervacije - pr. 550">
                <h4>Vaše ime</h4>
                <input required name="djelatnik_racun_ime" class="w3-input w3-border" type="text" placeholder = "Molimo unesite vaše ime...">
                <h4>Vaše prezime</h4>
                <input required name="djelatnik_racun_prezime" class="w3-input w3-border" type="text" placeholder = "Molimo unesite vaše prezime...">
                <button class="w3-button w3-round-large w3-black w3-margin-top" type="submit">Izradi račun</button>
                <hr>
                </form>');

                echo('</table></div>');


              echo('

            <div class="w3-container">
              <i class="fas fa-bed fa-2x"> <h2 style="display:inline-block">Popis soba</h2></i>
              <h4>Jednokrevetne sobe (SGL)</h4>
              <table class="w3-table w3-striped w3-bordered w3-margin-bottom w3-hoverable">
              <tr class="w3-dark-grey">
              <th>Šifra</th>
              <th>Kat</th>
              <th>Cijena</th>
              <th>Vrsta</th>
              </tr>');
              $i = 1;
              foreach ($polje_s as $s_soba){

                $select_s_kat = "SELECT kat
                               FROM soba
                               WHERE sifra = '$s_soba';";
                 $result_s_kat = mysqli_query($conn,$select_s_kat);
                 //if (!mysqli_query($conn,$select_s_kat))
                 //echo("Error description: ". mysqli_error($conn));
                 $resultCheck = mysqli_num_rows($result_s_kat);
                 if ($resultCheck > 0){
                   while ($row = mysqli_fetch_assoc($result_s_kat)){
                     $s_kat= $row['kat'];
                   }
                 }
                 $select_s_c = "SELECT standardna_cijena
                                FROM soba
                                WHERE sifra = '$s_soba';";
                  $result_s_c = mysqli_query($conn,$select_s_c);
                  $resultCheck = mysqli_num_rows($result_s_c);
                  if ($resultCheck > 0){
                    while ($row = mysqli_fetch_assoc($result_s_c)){
                      $s_c= $row['standardna_cijena'];
                    }
                  }
                  $select_s_vr = "SELECT vrsta
                                 FROM soba
                                 WHERE sifra = '$s_soba';";
                   $result_s_vr = mysqli_query($conn,$select_s_vr);
                   $resultCheck = mysqli_num_rows($result_s_vr);
                   if ($resultCheck > 0){
                     while ($row = mysqli_fetch_assoc($result_s_vr)){
                       $s_vr= $row['vrsta'];
                     }
                   }
                if($i%2==0){
                  echo ('<tr class="w3-light-grey ">
                  <th>'.$s_soba.'</th>
                  <th>'.$s_kat.'</th>
                  <th>'.$s_c.' kn</th>
                  <th>'.$s_vr.'</th>
                  </tr>');
                }
              else {
                echo ('<tr class="w3-sand ">
                <th>'.$s_soba.'</th>
                <th>'.$s_kat.'</th>
                <th>'.$s_c.' kn</th>
                <th>'.$s_vr.'</th>
                </tr>');
              }
              $i++;
              }
              echo ('<tr class="w3-light-grey ">
              <form name="soba_insert" action="djelatnik_soba-insert.php" method="POST">
              <th>&nbsp&nbsp&nbsp&nbsp&nbspAUTO</th>
              <th><input name="input_kat" class="w3-input w3-border w3-centered" type="text" placeholder = "Unos..."></th>
              <th><input name="input_cijena" class="w3-input w3-border" type="text" placeholder = "Unos..."></th>
              <th><input name="input_vrsta" class="w3-input w3-border" type="text" value = "SGL" readonly><button class="w3-button w3-round-large w3-black w3-right" type="submit">Unesi</button></th>
              </tr></table>
              </form>');
              //________________________Dvokrevetne sobe DBL__________________________
              echo('
              <h4>Dvokrevetne sobe (DBL)</h4>
              <table class="w3-table w3-striped w3-bordered w3-margin-bottom w3-hoverable">
              <tr class="w3-dark-grey">
              <th>Šifra</th>
              <th>Kat</th>
              <th>Cijena</th>
              <th>Vrsta</th>
              </tr>');
              $i=0;
              foreach ($polje_s1 as $s1_soba){
                $select_s1_kat = "SELECT kat
                               FROM soba
                               WHERE sifra = '$s1_soba';";
                 $result_s1_kat = mysqli_query($conn,$select_s1_kat);
                 //if (!mysqli_query($conn,$select_s_kat))
                 //echo("Error description: ". mysqli_error($conn));
                 $resultCheck = mysqli_num_rows($result_s1_kat);
                 if ($resultCheck > 0){
                   while ($row = mysqli_fetch_assoc($result_s1_kat)){
                     $s1_kat= $row['kat'];
                   }
                 }
                 $select_s1_c = "SELECT standardna_cijena
                                FROM soba
                                WHERE sifra = '$s1_soba';";
                  $result_s1_c = mysqli_query($conn,$select_s1_c);
                  $resultCheck = mysqli_num_rows($result_s1_c);
                  if ($resultCheck > 0){
                    while ($row = mysqli_fetch_assoc($result_s1_c)){
                      $s1_c= $row['standardna_cijena'];
                    }
                  }
                  $select_s1_vr = "SELECT vrsta
                                 FROM soba
                                 WHERE sifra = '$s1_soba';";
                   $result_s1_vr = mysqli_query($conn,$select_s1_vr);
                   $resultCheck = mysqli_num_rows($result_s1_vr);
                   if ($resultCheck > 0){
                     while ($row = mysqli_fetch_assoc($result_s1_vr)){
                       $s1_vr= $row['vrsta'];
                     }
                   }
                   if($i%2==0){
                     echo ('<tr class="w3-light-grey ">
                     <th>'.$s1_soba.'</th>
                     <th>'.$s1_kat.'</th>
                     <th>'.$s1_c.' kn</th>
                     <th>'.$s1_vr.'</th>
                     </tr>');
                   }
                 else {
                   echo ('<tr class="w3-sand ">
                   <th>'.$s1_soba.'</th>
                   <th>'.$s1_kat.'</th>
                   <th>'.$s1_c.' kn</th>
                   <th>'.$s1_vr.'</th>
                   </tr>');
                 }
                 $i++;
              }
              echo ('<tr class="w3-light-grey ">
              <form name="soba_insert" action="djelatnik_soba-insert.php" method="POST">
              <th>&nbsp&nbsp&nbsp&nbsp&nbspAUTO</th>
              <th><input name="input_kat" class="w3-input w3-border w3-centered" type="text" placeholder = "Unos..."></th>
              <th><input name="input_cijena" class="w3-input w3-border" type="text" placeholder = "Unos..."></th>
              <th><input name="input_vrsta" class="w3-input w3-border" type="text" value = "DBL" readonly><button class="w3-button w3-round-large w3-black w3-right" type="submit">Unesi</button></th>
              </tr></table>
              </form>');

            //________________________Dvokrevetne TWIN sobe__________________________
            echo('
            <h4>Dvokrevetne sobe (TWIN)</h4>
            <table class="w3-table w3-striped w3-bordered w3-margin-bottom w3-hoverable">
            <tr class="w3-dark-grey">
            <th>Šifra</th>
            <th>Kat</th>
            <th>Cijena</th>
            <th>Vrsta</th>
            </tr>');
            $i=0;
            foreach ($polje_s3 as $s3_soba){
              $select_s3_kat = "SELECT kat
                             FROM soba
                             WHERE sifra = '$s3_soba';";
               $result_s3_kat = mysqli_query($conn,$select_s3_kat);
               //if (!mysqli_query($conn,$select_s_kat))
               //echo("Error description: ". mysqli_error($conn));
               $resultCheck = mysqli_num_rows($result_s3_kat);
               if ($resultCheck > 0){
                 while ($row = mysqli_fetch_assoc($result_s3_kat)){
                   $s3_kat= $row['kat'];
                 }
               }
               $select_s3_c = "SELECT standardna_cijena
                              FROM soba
                              WHERE sifra = '$s3_soba';";
                $result_s3_c = mysqli_query($conn,$select_s3_c);
                $resultCheck = mysqli_num_rows($result_s3_c);
                if ($resultCheck > 0){
                  while ($row = mysqli_fetch_assoc($result_s3_c)){
                    $s3_c= $row['standardna_cijena'];
                  }
                }
                $select_s3_vr = "SELECT vrsta
                               FROM soba
                               WHERE sifra = '$s3_soba';";
                 $result_s3_vr = mysqli_query($conn,$select_s3_vr);
                 $resultCheck = mysqli_num_rows($result_s3_vr);
                 if ($resultCheck > 0){
                   while ($row = mysqli_fetch_assoc($result_s3_vr)){
                     $s3_vr= $row['vrsta'];
                   }
                 }
                 if($i%2==0){
                   echo ('<tr class="w3-light-grey ">
                   <th>'.$s3_soba.'</th>
                   <th>'.$s3_kat.'</th>
                   <th>'.$s3_c.' kn</th>
                   <th>'.$s3_vr.'</th>
                   </tr>');
                 }
               else {
                 echo ('<tr class="w3-sand ">
                 <th>'.$s3_soba.'</th>
                 <th>'.$s3_kat.'</th>
                 <th>'.$s3_c.' kn</th>
                 <th>'.$s3_vr.'</th>
                 </tr>');
               }
               $i++;
            }
            echo ('<tr class="w3-light-grey ">
            <form name="soba_insert" action="djelatnik_soba-insert.php" method="POST">
            <th>&nbsp&nbsp&nbsp&nbsp&nbspAUTO</th>
            <th><input name="input_kat" class="w3-input w3-border w3-centered" type="text" placeholder = "Unos..."></th>
            <th><input name="input_cijena" class="w3-input w3-border" type="text" placeholder = "Unos..."></th>
            <th><input name="input_vrsta" class="w3-input w3-border" type="text" value = "TWIN" readonly><button class="w3-button w3-round-large w3-black w3-right" type="submit">Unesi</button></th>
            </tr></table>
            </form>');

          //________________________Trokrevetne sobe__________________________
          echo('
          <h4>Trokrevetne sobe (TRPL)</h4>
          <table class="w3-table w3-striped w3-bordered w3-margin-bottom w3-hoverable">
          <tr class="w3-dark-grey">
          <th>Šifra</th>
          <th>Kat</th>
          <th>Cijena</th>
          <th>Vrsta</th>
          </tr>');
          $i=0;
          foreach ($polje_s4 as $s4_soba){
            $select_s4_kat = "SELECT kat
                           FROM soba
                           WHERE sifra = '$s4_soba';";
             $result_s4_kat = mysqli_query($conn,$select_s4_kat);
             //if (!mysqli_query($conn,$select_s_kat))
             //echo("Error description: ". mysqli_error($conn));
             $resultCheck = mysqli_num_rows($result_s4_kat);
             if ($resultCheck > 0){
               while ($row = mysqli_fetch_assoc($result_s4_kat)){
                 $s4_kat= $row['kat'];
               }
             }
             $select_s4_c = "SELECT standardna_cijena
                            FROM soba
                            WHERE sifra = '$s4_soba';";
              $result_s4_c = mysqli_query($conn,$select_s4_c);
              $resultCheck = mysqli_num_rows($result_s4_c);
              if ($resultCheck > 0){
                while ($row = mysqli_fetch_assoc($result_s4_c)){
                  $s4_c= $row['standardna_cijena'];
                }
              }
              $select_s4_vr = "SELECT vrsta
                             FROM soba
                             WHERE sifra = '$s4_soba';";
               $result_s4_vr = mysqli_query($conn,$select_s4_vr);
               $resultCheck = mysqli_num_rows($result_s4_vr);
               if ($resultCheck > 0){
                 while ($row = mysqli_fetch_assoc($result_s4_vr)){
                   $s4_vr= $row['vrsta'];
                 }
               }
               if($i%2==0){
                 echo ('<tr class="w3-light-grey ">
                 <th>'.$s4_soba.'</th>
                 <th>'.$s4_kat.'</th>
                 <th>'.$s4_c.' kn</th>
                 <th>'.$s4_vr.'</th>
                 </tr>');
               }
             else {
               echo ('<tr class="w3-sand ">
               <th>'.$s4_soba.'</th>
               <th>'.$s4_kat.'</th>
               <th>'.$s4_c.' kn</th>
               <th>'.$s4_vr.'</th>
               </tr>');
             }
             $i++;
          }
          echo ('<tr class="w3-light-grey ">
          <form name="soba_insert" action="djelatnik_soba-insert.php" method="POST">
          <th>&nbsp&nbsp&nbsp&nbsp&nbspAUTO</th>
          <th><input name="input_kat" class="w3-input w3-border w3-centered" type="text" placeholder = "Unos..."></th>
          <th><input name="input_cijena" class="w3-input w3-border" type="text" placeholder = "Unos..."></th>
          <th><input name="input_vrsta" class="w3-input w3-border" type="text" value = "TRPL" readonly><button class="w3-button w3-round-large w3-black w3-right" type="submit">Unesi</button></th>
          </tr></table>
          </form>');

        //________________________Cetverokrevetne sobe__________________________
        echo('
        <h4>Četverokrevetne sobe (QDPL)</h4>
        <table class="w3-table w3-striped w3-bordered w3-margin-bottom w3-hoverable">
        <tr class="w3-dark-grey">
        <th>Šifra</th>
        <th>Kat</th>
        <th>Cijena</th>
        <th>Vrsta</th>
        </tr>');
        $i=0;
        foreach ($polje_s5 as $s5_soba){
          $select_s5_kat = "SELECT kat
                         FROM soba
                         WHERE sifra = '$s5_soba';";
           $result_s5_kat = mysqli_query($conn,$select_s5_kat);
           //if (!mysqli_query($conn,$select_s_kat))
           //echo("Error description: ". mysqli_error($conn));
           $resultCheck = mysqli_num_rows($result_s5_kat);
           if ($resultCheck > 0){
             while ($row = mysqli_fetch_assoc($result_s5_kat)){
               $s5_kat= $row['kat'];
             }
           }
           $select_s5_c = "SELECT standardna_cijena
                          FROM soba
                          WHERE sifra = '$s5_soba';";
            $result_s5_c = mysqli_query($conn,$select_s5_c);
            $resultCheck = mysqli_num_rows($result_s5_c);
            if ($resultCheck > 0){
              while ($row = mysqli_fetch_assoc($result_s5_c)){
                $s5_c= $row['standardna_cijena'];
              }
            }
            $select_s5_vr = "SELECT vrsta
                           FROM soba
                           WHERE sifra = '$s5_soba';";
             $result_s5_vr = mysqli_query($conn,$select_s5_vr);
             $resultCheck = mysqli_num_rows($result_s5_vr);
             if ($resultCheck > 0){
               while ($row = mysqli_fetch_assoc($result_s5_vr)){
                 $s5_vr= $row['vrsta'];
               }
             }
             if($i%2==0){
               echo ('<tr class="w3-light-grey ">
               <th>'.$s5_soba.'</th>
               <th>'.$s5_kat.'</th>
               <th>'.$s5_c.' kn</th>
               <th>'.$s5_vr.'</th>
               </tr>');
             }
           else {
             echo ('<tr class="w3-sand ">
             <th>'.$s5_soba.'</th>
             <th>'.$s5_kat.'</th>
             <th>'.$s5_c.' kn</th>
             <th>'.$s5_vr.'</th>
             </tr>');
           }
           $i++;
        }
        echo ('<tr class="w3-light-grey ">
        <form name="soba_insert" action="djelatnik_soba-insert.php" method="POST">
        <th>&nbsp&nbsp&nbsp&nbsp&nbspAUTO</th>
        <th><input name="input_kat" class="w3-input w3-border w3-centered" type="text" placeholder = "Unos..."></th>
        <th><input name="input_cijena" class="w3-input w3-border" type="text" placeholder = "Unos..."></th>
        <th><input name="input_vrsta" class="w3-input w3-border" type="text" value = "QDPL" readonly><button class="w3-button w3-round-large w3-black w3-right" type="submit">Unesi</button></th>
        </tr></table>
        </form>');

            echo('
            <div w3-container>
              <i class="fas fa-utensils fa-2x"> <h2 style="display:inline-block">Aranžmani</h2></i>
              ');
              //_________________________Aranzmani______________________________________
              echo('
              <table class="w3-table w3-striped w3-bordered w3-margin-bottom w3-hoverable">
              <tr class="w3-dark-grey">
              <th>Naziv</th>
              <th>Opis aranžmana</th>
              <th>Cijena</th>
              </tr>');
              $i=0;
              foreach ($polje_ar as $aranzman_item){
                $select_ar_naziv = "SELECT naziv
                               FROM aranzman
                               WHERE opis_aranzmana = '$aranzman_item';";
                 $result_ar_naziv = mysqli_query($conn,$select_ar_naziv);
                 //if (!mysqli_query($conn,$select_s_kat))
                 //echo("Error description: ". mysqli_error($conn));
                 $resultCheck = mysqli_num_rows($result_ar_naziv);
                 if ($resultCheck > 0){
                   while ($row = mysqli_fetch_assoc($result_ar_naziv)){
                     $ar_naziv= $row['naziv'];
                   }
                 }
                 $select_ar_cijena = "SELECT cijena
                                FROM aranzman
                                WHERE opis_aranzmana = '$aranzman_item';";
                  $result_ar_cijena = mysqli_query($conn,$select_ar_cijena);
                  $resultCheck = mysqli_num_rows($result_ar_cijena);
                  if ($resultCheck > 0){
                    while ($row = mysqli_fetch_assoc($result_ar_cijena)){
                      $ar_cijena= $row['cijena'];
                    }
                  }

                   if($i%2==0){
                     echo ('<tr class="w3-light-grey ">
                     <th>'.$ar_naziv.'</th>
                     <th>'.$aranzman_item.'</th>
                     <th>'.$ar_cijena.' kn</th>
                     </tr>');
                   }
                 else {
                   echo ('<tr class="w3-sand ">
                   <th>'.$ar_naziv.'</th>
                   <th>'.$aranzman_item.'</th>
                   <th>'.$ar_cijena.' kn</th>
                   </tr>');
                 }
                 $i++;
              }
              //_________________________Dodatne usluge______________________________________
              echo('</table></div>
              <div w3-container>
                <i class="fas fa-concierge-bell fa-2x"> <h2 style="display:inline-block">Dodatne usluge</h2></i>
              <table class="w3-table w3-striped w3-bordered w3-margin-bottom w3-hoverable">
              <tr class="w3-dark-grey">
              <th>Naziv</th>
              <th>Cijena</th>
              </tr>');
              $i=0;
              foreach ($polje_du_naziv as $du_item){
                 $select_du_cijena = "SELECT cijena
                                FROM dodatne_usluge
                                WHERE naziv = '$du_item';";
                  $result_du_naziv = mysqli_query($conn,$select_du_cijena);
                  $resultCheck = mysqli_num_rows($result_du_naziv);
                  if ($resultCheck > 0){
                    while ($row = mysqli_fetch_assoc($result_du_naziv)){
                      $du_cijena= $row['cijena'];
                    }
                  }

                   if($i%2==0){
                     echo ('<tr class="w3-light-grey ">
                     <th>'.$du_item.'</th>
                     <th>'.$du_cijena.' kn</th>
                     </tr>');
                   }
                 else {
                   echo ('<tr class="w3-sand ">
                   <th>'.$du_item.'</th>
                   <th>'.$du_cijena.' kn</th>
                   </tr>');
                 }
                 $i++;
              }
              echo ('<tr class="w3-light-grey ">
              <form name="du_insert" action="djelatnik_du-insert.php" method="POST">
              <th><input name="input_du_naziv" class="w3-input w3-border w3-centered" type="text" placeholder = "Unos..."></th>
              <th><input name="input_du_cijena" class="w3-input w3-border" type="text" placeholder = "Unos..."><button class="w3-button w3-round-large w3-black w3-right" type="submit">Unesi</button></th>

              </tr></table>
              </form>');

              //kraj
              echo('</div>
            </div>
            </div>
          </div>

        </div><!--end main-->
        <!--side-->
        <div class="w3-container w3-col l2">
        </div>
        <!--end side-->

      </div>
      <div class="w3-row creators w3-amber w3-margin-top w3-center">
        <p><b>Projekt - Baze podataka 2, FIPU</b></p>
        <p><b>Tim 4</b> - Sustav za upravljanje hotelom</p>
        <p>Web aplikaciju izradio Luka Blašković</p>
      </div>
    </body>

    </html>
');

    ?>
  </body>
</html>
