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
    $username = "root";
    $password = "root";
    $servername = "localhost";
    // Create connection
    $conn = mysqli_connect($servername, $username, $password);
    // Check connection
    if (mysqli_connect_error()) {
      die("Problem kod povezivanja na MySQL bazu podataka: " . mysqli_connect_error());
    }
    echo "<div class='w3-amber'>Uspješno povezivanje sa MySQL bazom podataka!</div>";
    echo "<div class='w3-amber w3-margin-bottom	'>Prijavljeni korisnik: ","<b>", $username, "</b></div>";
    include "main_root.html";
    if (!mysqli_select_db($conn, "sustav_za_upravljanje_hotelom")) {
      echo("Greška kod povezivanja sa MySQL bazom podataka: " . mysqli_error($conn));
    }
    //_________________________KONEKCIJA_____________________________________________
    ?>
    <?php
    //________________________Rad sa MySQL bazom podataka____________________________

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

    //Vadenje dodatnih usluga iz baze
    $polje_du = [];
    $select_du = "SELECT naziv
		                FROM dodatne_usluge;";
     $result_du = mysqli_query($conn,$select_du);
     $resultCheck = mysqli_num_rows($result_du);
     if ($resultCheck > 0){
       while ($row = mysqli_fetch_assoc($result_du)){
         array_push($polje_du,$row['naziv']);
       }
     }
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

    //Vadenje soba iz baze
    // vadenje SGL soba iz baze
    $odabrani_dd2 = '1000-01-01';
    $odabrani_do2 = '1000-01-02';

    $chck_datum = mysqli_query($conn,"SELECT * FROM odabrani_period LIMIT 1 ");
    if ($chck_datum !== FALSE) {
      //fetch $datum_dolaska2
      $select_dd = "SELECT dolazak
                          FROM odabrani_period;";
      $result_dd = mysqli_query($conn,$select_dd);
      $resultCheck = mysqli_num_rows($result_dd);
      if ($resultCheck > 0){
        while ($row = mysqli_fetch_assoc($result_dd)){
          $odabrani_dd2 =  ($row['dolazak']);
        }
      }
      //fetch $datum_odlaska2

      $select_do = "SELECT odlazak
                          FROM odabrani_period;";
      $result_do = mysqli_query($conn,$select_do);
      $resultCheck = mysqli_num_rows($result_do);
      if ($resultCheck > 0){
        while ($row = mysqli_fetch_assoc($result_do)){
          $odabrani_do2 =  ($row['odlazak']);
        }
      }
    }

    $polje_s = [];
    $select_sgl_soba = "SELECT sifra FROM soba LEFT OUTER JOIN rezervacija ON rezervacija.id_soba = soba.id_soba
    WHERE
        vrsta = 'SGL' AND
        ((((pocetak_rezervacije > '$odabrani_dd2') AND (pocetak_rezervacije > '$odabrani_do2')) OR ((kraj_rezervacije < '$odabrani_dd2')
         AND (kraj_rezervacije < '$odabrani_do2'))) OR id_rezervacija IS NULL); ";
     $result_sgl_soba = mysqli_query($conn,$select_sgl_soba);
     $resultCheck = mysqli_num_rows($result_sgl_soba);
     if ($resultCheck > 0){
       while ($row = mysqli_fetch_assoc($result_sgl_soba)){
         array_push($polje_s,$row['sifra']);
       }
     }
     // vadenje DBL soba iz baze
     $polje_s1 = [];
     $select_dbl_soba = "SELECT sifra FROM soba LEFT OUTER JOIN rezervacija ON rezervacija.id_soba = soba.id_soba
     WHERE
         vrsta = 'DBL' AND
         ((((pocetak_rezervacije > '$odabrani_dd2') AND (pocetak_rezervacije > '$odabrani_do2')) OR ((kraj_rezervacije < '$odabrani_dd2')
          AND (kraj_rezervacije < '$odabrani_do2'))) OR id_rezervacija IS NULL); ";
      $result_dbl_soba = mysqli_query($conn,$select_dbl_soba);
      $resultCheck = mysqli_num_rows($result_dbl_soba);
      if ($resultCheck > 0){
        while ($row = mysqli_fetch_assoc($result_dbl_soba)){
          array_push($polje_s1,$row['sifra']);
        }
      }
      // vadenje TWIN soba iz baze
      $polje_s3 = [];
      $select_twin_soba = "SELECT sifra FROM soba LEFT OUTER JOIN rezervacija ON rezervacija.id_soba = soba.id_soba
      WHERE
          vrsta = 'TWIN' AND
          ((((pocetak_rezervacije > '$odabrani_dd2') AND (pocetak_rezervacije > '$odabrani_do2')) OR ((kraj_rezervacije < '$odabrani_dd2')
           AND (kraj_rezervacije < '$odabrani_do2'))) OR id_rezervacija IS NULL); ";
       $result_twin_soba = mysqli_query($conn,$select_twin_soba);
       $resultCheck = mysqli_num_rows($result_twin_soba);
       if ($resultCheck > 0){
         while ($row = mysqli_fetch_assoc($result_twin_soba)){
           array_push($polje_s3,$row['sifra']);
         }
       }
       // vadenje TRPl soba iz baze
       $polje_s4 = [];
       $select_trpl_soba = "SELECT sifra FROM soba LEFT OUTER JOIN rezervacija ON rezervacija.id_soba = soba.id_soba
       WHERE
           vrsta = 'TRPL' AND
           ((((pocetak_rezervacije > '$odabrani_dd2') AND (pocetak_rezervacije > '$odabrani_do2')) OR ((kraj_rezervacije < '$odabrani_dd2')
            AND (kraj_rezervacije < '$odabrani_do2'))) OR id_rezervacija IS NULL); ";
        $result_trpl_soba = mysqli_query($conn,$select_trpl_soba);
        $resultCheck = mysqli_num_rows($result_trpl_soba);
        if ($resultCheck > 0){
          while ($row = mysqli_fetch_assoc($result_trpl_soba)){
            array_push($polje_s4,$row['sifra']);
          }
        }
        //vadenje QDPl soba iz baze
        $polje_s5 = [];
        $select_qdpl_soba = "SELECT sifra FROM soba LEFT OUTER JOIN rezervacija ON rezervacija.id_soba = soba.id_soba
        WHERE
            vrsta = 'QDPL' AND
            ((((pocetak_rezervacije > '$odabrani_dd2') AND (pocetak_rezervacije > '$odabrani_do2')) OR ((kraj_rezervacije < '$odabrani_dd2')
             AND (kraj_rezervacije < '$odabrani_do2'))) OR id_rezervacija IS NULL); ";
         $result_qdpl_soba = mysqli_query($conn,$select_qdpl_soba);
         $resultCheck = mysqli_num_rows($result_qdpl_soba);
         if ($resultCheck > 0){
           while ($row = mysqli_fetch_assoc($result_qdpl_soba)){
             array_push($polje_s5,$row['sifra']);
           }
         }
        //fetch $drzava

        $odabrana_drzava = '';
        $odabrani_grad = '';
        $odabrani_pb = '';
        $odabrana_adresa = '';
        $odabrani_do = '';
        $odabrani_dd = '';
        $trajanje = 0;
        $sezona = 0;
        $gost_test = 0;

        $chck_mp = mysqli_query($conn,"SELECT * FROM odabrano_mjesto_prebivalista LIMIT 1 ");
        if ($chck_mp !== FALSE) {
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
        }
        $chck_datum = mysqli_query($conn,"SELECT * FROM odabrani_period LIMIT 1 ");
        if ($chck_datum !== FALSE) {
          //fetch $datum_dolaska
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
        }
        $gost_chck = mysqli_query($conn, "SELECT * FROM gosti_temp LIMIT 1");


        if ($gost_chck !== FALSE){
            $gost_test = 1;

          $polje_gosti_id = [];
          $select_id_gosti = "SELECT id_gost
                               FROM gosti_temp;";
           $result_id_gosti = mysqli_query($conn,$select_id_gosti);
           $resultCheck = mysqli_num_rows($result_id_gosti);
           if ($resultCheck > 0){
             while ($row = mysqli_fetch_assoc($result_id_gosti)){
               array_push($polje_gosti_id,$row['id_gost']);
             }
           }

          $polje_gosti_ime = [];
          $select_ime_gosti = "SELECT ime
                               FROM gosti_temp;";
           $result_ime_gosti = mysqli_query($conn,$select_ime_gosti);
           $resultCheck = mysqli_num_rows($result_ime_gosti);
           if ($resultCheck > 0){
             while ($row = mysqli_fetch_assoc($result_ime_gosti)){
               array_push($polje_gosti_ime,$row['ime']);
             }
           }
           $polje_gosti_prezime = [];
           $select_prezime_gosti = "SELECT prezime
                                FROM gosti_temp;";
            $result_prezime_gosti = mysqli_query($conn,$select_prezime_gosti);
            $resultCheck = mysqli_num_rows($result_prezime_gosti);
            if ($resultCheck > 0){
              while ($row = mysqli_fetch_assoc($result_prezime_gosti)){
                array_push($polje_gosti_prezime,$row['prezime']);
              }
            }
            $polje_gosti_oib = [];
            $select_oib_gosti = "SELECT oib
                                 FROM gosti_temp;";
             $result_oib_gosti = mysqli_query($conn,$select_oib_gosti);
             $resultCheck = mysqli_num_rows($result_oib_gosti);
             if ($resultCheck > 0){
               while ($row = mysqli_fetch_assoc($result_oib_gosti)){
                 array_push($polje_gosti_oib,$row['oib']);
               }
             }
             $polje_gosti_boi = [];
             $select_boi_gosti = "SELECT broj_osobne_iskaznice
                                  FROM gosti_temp;";
              $result_boi_gosti = mysqli_query($conn,$select_boi_gosti);
              $resultCheck = mysqli_num_rows($result_boi_gosti);
              if ($resultCheck > 0){
                while ($row = mysqli_fetch_assoc($result_boi_gosti)){
                  array_push($polje_gosti_boi,$row['broj_osobne_iskaznice']);
                }
              }
              $polje_gosti_dr = [];
              $select_dr_gosti = "SELECT datum_rodenja
                                   FROM gosti_temp;";
               $result_dr_gosti = mysqli_query($conn,$select_dr_gosti);
               $resultCheck = mysqli_num_rows($result_dr_gosti);
               if ($resultCheck > 0){
                 while ($row = mysqli_fetch_assoc($result_dr_gosti)){
                   array_push($polje_gosti_dr,$row['datum_rodenja']);
                 }
               }

        }

        // PHP RAD NAD BAZOM
     ?>



<script type="text/JavaScript">

      function gost_provjera(){
        var x1= document.getElementById('#g-ime').value;
        var x2= document.getElementById('#g-prezime').value;
        var x3= document.getElementById('#g-oib').value;
        var x4= document.getElementById('#g-broj_osobne').value;
        var x5= document.getElementById('#g-datum_rodenja').value;

        if(x1=='' || x2==''|| x3==''|| x4==''|| x5==''){

          if (x1==''){
            document.getElementById('#g-ime').classList.add("alert-color-change");
          }
          if (x2==''){
            document.getElementById('#g-prezime').classList.add("alert-color-change");
          }
          if (x3==''){
            document.getElementById('#g-oib').classList.add("alert-color-change");
          }
          if (x4==''){
            document.getElementById('#g-broj_osobne').classList.add("alert-color-change");
          }
          if (x5==''){
            document.getElementById('#g-datum_rodenja').classList.add("alert-color-change");
          }
          console.log("gost-provjera: FALSE");
          return false;
        }
        if ('<?php echo ($odabrana_drzava); ?>' == '') {
          alert("Molimo da prije unesete mjesto prebivališta.");
          return false;
        }
        else {
          console.log("gost-provjera: TRUE");
          return true;
        }
      }// gost provjera

      function gost() {
        if('<?php echo($gost_test);?>' != 0){
        var gost_id = [];
          gost_id = <?php if ($gost_test != 0) echo (json_encode($polje_gosti_id)); else echo('blank');?>;
        var ime = [];
          ime = <?php if ($gost_test != 0) echo (json_encode($polje_gosti_ime)); else echo('blank');?>;
        var prezime = [];
          prezime = <?php if ($gost_test != 0) echo (json_encode($polje_gosti_prezime)); else echo('blank');?>;
        var oib = [];
          oib = <?php if ($gost_test != 0) echo (json_encode($polje_gosti_oib)); else echo('blank');?>;
        var boi = [];
          boi = <?php if ($gost_test != 0) echo (json_encode($polje_gosti_boi)); else echo('blank');?> ;
        var datum = [];
          datum = <?php if ($gost_test != 0) echo (json_encode($polje_gosti_dr)); else echo('blank');?>;
          }
          for(var i = 0; i < gost_id.length; i++) {


              var j = i+1;
              $(".gosti").append(
                  '<form name="remove_gost'+gost_id[i]+'" action="root_gost_izbrisan.php" method="POST"><p><b>' + j + '.</b> ' + ime[i] + ', ' + prezime[i]+ ', ' + '<b>OIB:</b> ' + oib[i] + ', '+ '<b>Broj osobne iskaznice:</b> ' + boi[i] + ', '+ '<b>Datum rođenja:</b> ' + datum[i] +
                   '<input id="Gost_'+gost_id[i]+'" name="remove_gost'+gost_id[i]+'[Gost_'+gost_id[i]+']" type="hidden"  value="">' + '<button class="w3-right w3-text-red delete" type="submit">X</button></p></form>'
              );
              document.getElementById("Gost_"+gost_id[i]).value = gost_id[i];
              document.getElementById("#broj_gostiju").innerHTML =
              <?php
              if ($gost_test != 0){
              $result_bg = mysqli_query($conn,"SELECT COUNT(*) AS bg FROM gosti_temp;");
              $resultCheck = mysqli_num_rows($result_bg);
              if ($resultCheck > 0){
                while ($row = mysqli_fetch_assoc($result_bg)){
                  echo ($row['bg']);
                }
              }
            }
               ?>+0;
               var selectBooker = document.getElementById('booker_odabir');
               selectBooker.name = "booker_odabir";
               var booker_ime = [];
               var booker_prezime = [];
               booker_id = <?php if ($gost_test != 0) echo (json_encode($polje_gosti_id)); else echo('blank');?>;
               booker_ime = <?php if ($gost_test != 0) echo (json_encode($polje_gosti_ime)); else echo('blank');?>;
               booker_prezime = <?php if ($gost_test != 0) echo (json_encode($polje_gosti_prezime)); else echo('blank');?>;
                   var option = [];
                   option[i] = document.createElement("option");
                   option[i].value = booker_id[i];
                   option[i].text = booker_ime[i]+" "+booker_prezime[i];
                   selectBooker.appendChild(option[i]);
          }



      } // gost kraj

      function deleteGost(obj) {
        var broj_gostiju = document.getElementById("#broj_gostiju").innerHTML;
        var o = obj;
        while(!o.id) {
          o = o.parentNode;
        }
        var id = o.id;
        document.getElementById("#broj_gostiju").innerHTML = parseInt(broj_gostiju) - 1;
        document.getElementById(id).remove();

      } // delete gost kraj

      function mjestoPrebivalista() {

        console.log("Mjesto prebivalista postavljeno...");
        var drzava = '<?php echo ($odabrana_drzava); ?>';
        var grad = '<?php echo ($odabrani_grad); ?>';
        var postanski_broj = '<?php echo ($odabrani_pb); ?>';
        var adresa = '<?php echo ($odabrana_adresa); ?>';
        var mjesto_prebivalista = ("<b>Država:</b> "+ drzava +"<br><b> Grad:</b> "+ grad +"<br><b> Adresa:</b> " + adresa +  "<br><b> Poštanski broj:</b> "+ postanski_broj);
        document.getElementById("#mp-insert").innerHTML = mjesto_prebivalista;
      }// mjestoPrebivalista

        function datum() {
          var dolazak = '<?php echo ($odabrani_dd); ?>';
          var odlazak = '<?php echo ($odabrani_do); ?>';
          <?php
            if ($odabrani_dd != '' && $odabrani_do != '') {
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
            }
          ?>
          if (dolazak !='' || odlazak!= '') {
            var trajanje = <?php echo ($trajanje); ?>;
            if (trajanje>60) {
              alert("Upozorenje: Rezervirati možete najviše 60 dana.");
              return false;
            }
            var sezona = <?php echo ($sezona); ?>;
            switch (sezona) {
              case 11:
                sezona = "Ljeto [A]";
                break;
              case 12:
                sezona = "Jesen [B]";
                break;
              case 13:
                sezona = "Zima [C]";
                break;
              case 14:
                sezona = "Proljeće [D]";
                break;
            }
            var datum = ("<b>Dolazak:</b> " + dolazak + "<br> <b>Odlazak:</b> " + odlazak + "<br> <b>Trajanje:</b> " + trajanje + " dana" + "<br><b> Sezona:</b> " + sezona);
            document.getElementById("#d-insert").innerHTML = datum;
          }

        }
          // On page load
          window.onload = function on_load_prikaz() {
            console.log("Aranzman loaded...");
            var selectListAranzman = document.getElementById('aranzman_select');
            while (selectListAranzman.lastElementChild) {
                selectListAranzman.removeChild(selectListAranzman.lastElementChild);}
              var array3 = [];
              array3 = <?php echo (json_encode($polje_ar));?>;
              for (var i = 0; i < array3.length; i++) {
                  var option = document.createElement("option");
                  option.value = array3[i];
                  option.name = "aranzman_stavka";
                  option.text = array3[i];
                  selectListAranzman.appendChild(option);}
            //----------------------------------------------------------------
            console.log("Sobe_SGL_loaded...");
        var selectList = document.getElementById("#odabir_sobe");
        while (selectList.lastElementChild) {
            selectList.removeChild(selectList.lastElementChild);}
        var array = [];
        array = <?php echo (json_encode($polje_s));?>;
        for (var i = 0; i < array.length; i++) {
            var option = document.createElement("option");
            option.value = array[i];
            option.name = "soba_stavka";
            option.text = array[i];
            selectList.appendChild(option);}
//----------------------------------------------------------------
          console.log("Dodatne usluge loaded...");

        var br=0;
        var glavna_sekcija_du = document.getElementById('sekcija_dodatne_usluge');
        var dodatna_sekcija = [];

        var array2 = [];
        var du_id = [];
        array2 = <?php echo (json_encode($polje_du));?>;
        du_id = <?php echo (json_encode($polje_du_id));?>;

        for (var i =0; i < array2.length; i++){
          var input = document.createElement("input");
          var label = document.createElement("label");
          input.id= (i);
          input.className = "w3-check checkbox";
          input.name = du_id[i];
          input.type = "checkbox";
          label.for = (i);
          label.innerHTML = "<b> "+array2[i]+"</b>";

          input.setAttribute("onchange", 'dodatne_usluge_kolicina(this.id)');
          document.body.appendChild(input);
          var third = document.createElement('div');
          third.className = "w3-container";
          third.id="du_sekcija_"+i;
          if (br==0) {
            glavna_sekcija_du.appendChild(third);
            third.appendChild(input);
            third.appendChild(label);

          }
          else{
            dodatna_sekcija[br].appendChild(third);
            third.appendChild(input);
            third.appendChild(label);
          }

            if((i+1)%5==0){
              br++;
              dodatna_sekcija[br]= document.createElement("div");
              dodatna_sekcija[br].className = "w3-row";
              if (br==1) {
                insertAfter(glavna_sekcija_du,dodatna_sekcija[br]);
                insertAfter(glavna_sekcija_du,document.createElement("hr"));
              }
              else {
                insertAfter(dodatna_sekcija[br-1],dodatna_sekcija[br]);
                insertAfter(dodatna_sekcija[br-1],document.createElement("hr"));
              }
            }
        }
      }

          //dodatne_usluge_kolicina
          function dodatne_usluge_kolicina(chckbox_id){
            var checkbox = document.getElementById(chckbox_id);
            var sekcija_id = ("du_sekcija_"+ parseInt(chckbox_id));
            var sekcija = document.getElementById(sekcija_id);
            var d_usluge = [];
            d_usluge = <?php echo (json_encode($polje_du_id));?>;

              console.log("Sekcija: "+ sekcija.id);
            if (checkbox.checked) {
              var kolicina = document.createElement("input");
              var label = document.createElement("label");
                for (var i =0; i < d_usluge.length; i++){
                  if (i==chckbox_id){
                    kolicina.name = "q_"+ d_usluge[i];
                    break;
                  }

                }
              kolicina.id= "q_"+ d_usluge[i];
              kolicina.type = "number";
              kolicina.min = "1";
              kolicina.value= 1;
              label.for = "q_"+ d_usluge[i];
              label.innerHTML = "Molimo unesite količinu...";
              kolicina.className= "w3-input";
              sekcija.appendChild(document.createElement("br"));
              sekcija.appendChild(label);
              sekcija.appendChild(kolicina);


            }
            else {
              sekcija.removeChild(sekcija.lastChild);
              sekcija.removeChild(sekcija.lastChild);
              sekcija.removeChild(sekcija.lastChild);
            }
            console.log(chckbox_id +" - "+ checkbox.checked);
          }

          // soba 1 set
          function prikaz_soba(vrijednost){
            var x=vrijednost;
            if (x==1) {
              console.log("1. opcija");
          var selectList = document.getElementById("#odabir_sobe");
          while (selectList.lastElementChild) {
              selectList.removeChild(selectList.lastElementChild);}

          var array = [];
          array = <?php echo (json_encode($polje_s));?>;
          for (var i = 0; i < array.length; i++) {
              var option = document.createElement("option");
              option.value = array[i];
              option.name = "odabir_soba";
              option.text = array[i];
              selectList.appendChild(option);
          }
            }
            // soba 2
            else if (x==2){
              console.log("2. opcija");
          var selectList = document.getElementById("#odabir_sobe");
          while (selectList.lastElementChild) {
              selectList.removeChild(selectList.lastElementChild);}
          var array = [];
          array = <?php echo (json_encode($polje_s1));?>;
          for (var i = 0; i < array.length; i++) {
              var option = document.createElement("option");
              option.value = array[i];
              option.name = "odabir_soba";
              option.text = array[i];
              selectList.appendChild(option);
          }
            }
            // soba 3 set
            else if (x==3){
              console.log("3. opcija");
          var selectList = document.getElementById("#odabir_sobe");
          while (selectList.lastElementChild) {
              selectList.removeChild(selectList.lastElementChild);}
          var array = [];
          array = <?php echo (json_encode($polje_s3));?>;
          for (var i = 0; i < array.length; i++) {
              var option = document.createElement("option");
              option.value = array[i];
              option.name = "odabir_soba";
              option.text = array[i];
              selectList.appendChild(option);
          }
            }
            // soba 4 set
            else if (x==4){
              console.log("4. opcija");
          var selectList = document.getElementById("#odabir_sobe");
          while (selectList.lastElementChild) {
              selectList.removeChild(selectList.lastElementChild);}
          var array = [];
          array = <?php echo (json_encode($polje_s4));?>;
          for (var i = 0; i < array.length; i++) {
              var option = document.createElement("option");
              option.value = array[i];
              option.name = "odabir_soba";
              option.text = array[i];
              selectList.appendChild(option);
          }
            }
            //soba 5 set
            else if (x==5){
              console.log("5. opcija");
          var selectList = document.getElementById("#odabir_sobe");
          while (selectList.lastElementChild) {
              selectList.removeChild(selectList.lastElementChild);}
          var array = [];
          array = <?php echo (json_encode($polje_s5));?>;
          for (var i = 0; i < array.length; i++) {
              var option = document.createElement("option");
              option.value = array[i];
              option.name = "odabir_soba";
              option.text = array[i];
              selectList.appendChild(option);
          }
            }
          }
          function rezervacija_provjera(){
            if (<?php if ($chck_mp !== FALSE) echo 1; else echo 0;?>){
              console.log("Mjesto prebivalista - OK");
            }
            else {
              console.log("Mjesto prebivalista - nije postavljeno");
              alert ("Niste unijeli mjesto prebivališta gostiju.");
              return false;
            }
            if (<?php if ($chck_datum !== FALSE) echo 1; else echo 0;?>){
              console.log("Datum - OK");
            }
            else {
              console.log("Datum - nije postavljeno");
              alert ("Niste odabrali datume boravka.");
              return false;
            }
            if (<?php if ($gost_chck !== FALSE) echo 1; else echo 0;?>){
              console.log("Gosti - OK");
            }
            else {
              console.log("Gosti - nije postavljeno");
              alert ("Morate unijeti bar jednog gosta.");
              return false;
            }

          }
      </script>
  </body>
</html>
