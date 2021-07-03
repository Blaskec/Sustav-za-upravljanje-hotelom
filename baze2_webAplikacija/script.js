function pass_racun_create(){
  if(confirm("Jeste li sigurni da želite izraditi račun?") == true){
    alert("Račun izrađen.");
    return true;
  }
  else
    return false;
}
function rezervacija_potvrda(){
  if(confirm("Jeste li sigurni da želite potvrditi rezervaciju?") == true){
    alert("Hvala Vam na rezervaciji!");
    return true;
  }
  else
    return false;
}
function mjestoPrebivalista_provjera() {
  var x1 = document.forms["mP_forma"]["drzava"].value;
  var x2 = document.forms["mP_forma"]["grad"].value;
  var x3 = document.forms["mP_forma"]["p_broj"].value;
  var x4 = document.forms["mP_forma"]["adresa"].value;
  var x1_b = x1.replace( /^\D+/g, '');
  var x2_b = x2.replace( /^\D+/g, '');
  if(x1=='' || x2=='' || x3=='' ||  x4=='' || x1_b!='' || x2_b!=''){
    if (x1=='' || x1_b!=''){
      document.getElementById('#mp-drzava').classList.add("alert-color-change");
    }
    if (x2=='' || x2_b!=''){
      document.getElementById('#mp-grad').classList.add("alert-color-change");
    }
    if (x3==''){
      document.getElementById('#mp-postanski_broj').classList.add("alert-color-change");
    }
    if (x4==''){
      document.getElementById('#mp-adresa').classList.add("alert-color-change");
    }
    console.log("mjesto_prebivalista-provjera: FALSE");
    return false;
  }
  else {
    console.log("mjesto_prebivalista-provjera: TRUE");
    return true;
  };
}

function revert(id) {
  document.getElementById(id).classList.remove("alert-color-change");
}


function datum_provjera(){
  console.log("Datum projvera");
  var x1 = document.forms["datum_forma"]["datum_dolaska"].value;
  var x2 = document.forms["datum_forma"]["datum_odlaska"].value;
  if(x1=='' || x2==''){

    if (x1==''){
      document.getElementById('#d-dolazak').classList.add("alert-color-change");
    }
    if (x2==''){
      document.getElementById('#d-odlazak').classList.add("alert-color-change");
    }
    console.log("datum-provjera: FALSE");
    return false;
  }
  else {
    console.log("datum-provjera: TRUE");
    return true;
  };
}


function provjera_korisnika(){
  console.log('Provjera odabranog korisnika...')
  var lista = document.getElementById('lista_korisnika');
  var polje_lozinka = document.getElementById('polje_lozinka');
  var tekst_lozinka = document.getElementById('tekst_lozinka');
  console.log (lista.value);

  if (lista.value==1){
    polje_lozinka.style.display = "none";
    tekst_lozinka.style.display = "none";
  }
  else {
    polje_lozinka.style.display = "block";
    tekst_lozinka.style.display = "block";
  }
}

function passCheck() {
  var lozinka = document.getElementById('polje_lozinka').value;
  var lista = document.getElementById('lista_korisnika').value;
  if (lista==2) {
    if (lozinka=='') {
      alert("Niste upisali lozinku");
      return false;
    }
    else if (lozinka!='djelatnik') {
      alert("Upisali ste krivu lozinku");
      return false;
      }

  }
  else if (lista==3) {
    if (lozinka==''){
      alert("Upisali ste krivu lozinku");
      return false;
    }
    else if (lozinka!='root') {
      alert("Upisali ste krivu lozinku");
      return false;
      }
  }
}
function insertAfter(referenceNode, newNode) {
  referenceNode.parentNode.insertBefore(newNode, referenceNode.nextSibling);
}

function izracunDodatnihUsluga(id) {
  alert(id);
  var usluga = document.getElementById("label_"+id).innerHTML;
  usluga = usluga.replace( /^\D+/g, '');
  usluga = usluga.substring(0,usluga.length-6);
  var id2 = parseInt(id, 10);
  id2 = id2+1;
  alert(id2);
  var kolicina = document.getElementById("q_"+id).value;
  alert(kolicina);
}

function izracunCijene() {
  var trajanje = document.getElementById("trajanje").innerHTML;
  var multiplikator = document.getElementById("multiplikator").innerHTML;
  var sel = document.getElementById("aranzman_select");
  var aranzman = sel.options[sel.selectedIndex].text;
  aranzman = aranzman.replace( /^\D+/g, '');
  aranzman = aranzman.substring(0,aranzman.length-2);
  var sel2 = document.getElementById("#odabir_sobe");
  var soba = sel2.options[sel2.selectedIndex].text;
  soba = soba.substr(14);
  soba = soba.replace( /^\D+/g, '');
  soba = soba.substring(0,soba.length-2);

  var id = 1;
  var sum = 0;
  do {
    var id4 = id-1;
    var id5 = document.getElementById("label_"+id4);
    var id2 = document.getElementById("q_"+id);
    if (id2 != null) {
      var id3 = id-1;
      var usluga = document.getElementById("label_"+id3).innerHTML;
      usluga = usluga.replace( /^\D+/g, '');
      usluga = usluga.substring(0,usluga.length-6);
      var kolicina = document.getElementById("q_"+id).value;
      sum=sum+(usluga*kolicina);
    }
    else if (id5 == null) {
      break;
    }
    id = id + 1;
  } while (1);
  multiplikator = parseInt(multiplikator, 10);
  soba = parseInt(soba, 10);
  trajanje = parseInt(trajanje, 10);
  aranzman = parseInt(aranzman, 10);
  sum = parseInt(sum, 10);
  var ukupna_cijena = multiplikator*((soba*trajanje)+aranzman+sum);
  document.getElementById("#ukupna_cijena").innerHTML = ukupna_cijena;
}
