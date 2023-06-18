<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page
	import="java.util.ArrayList, java.util.LinkedHashMap, prenotazioni.Wizard, prenotazioni.TreeStep, prenotazioni.GestioneDati, database.dao.Anagrafiche, database.object.Anagrafica  "%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Nuova Prenotazione</title>
<jsp:include page="/jsp/bootstrap.jsp" />
<link rel="stylesheet" href="../css/login.css">

<script>
<%=GestioneDati.generaObjectGruppiStanze()%>
<%=GestioneDati.generaListsAnagrafiche()%>

function getElementsById(ids) {
	let idList = ids.split(" ");
    let results = [], item;
    for (let i = 0; i < idList.length; i++) {
        item = document.getElementById(idList[i]);
        if (item) {
            results.push(item);
        }
    }
    return(results);
}

function impostaOspiti(anagrafica, numeroOspiti){
	//let anagrafica = document.getElementById("anagrafica");

	for (let i = 0; i < lAnagrafiche.length; i++) {
		anagrafica.options[i] = new Option(lAnagrafiche[i], lIDanagrafiche[i]);
	}
	//document.getElementById("numeroOspiti").min = 1;
	numeroOspiti.min=1;
}

function impostaSelects(){	
	
	//let multiStanze = document.getElementById("multiStanze");	
	
	let gruppoStanze = document.getElementById("gruppoStanze");
	let stanza = document.getElementById("stanza");

	for (let x in oGruppiStanze) {
		gruppoStanze.options[gruppoStanze.options.length] = new Option(x);
	}
	
	let j = 0;
	for (let x in oIDGruppiStanze) {
		gruppoStanze.options[j].value = x;
		j++;
	}
	
	function cambiaSelect() {
		stanza.length = 0;
		let w = oIDGruppiStanze[gruppoStanze.value];
		let z = oGruppiStanze[gruppoStanze.options[gruppoStanze.selectedIndex].text];
		for (let i = 0; i < z.length; i++) {
			stanza.options[stanza.options.length] = new Option(z[i], w[i]);
		}
	}

	cambiaSelect();
	
	gruppoStanze.onchange = function() {
		cambiaSelect();
	}
	function aggiornaData(){
		document.getElementById("dataPartenza").min = document.getElementById("dataArrivo").value;
		document.getElementById("dataArrivo").max = document.getElementById("dataPartenza").value;
	}
	
	document.getElementById("dataArrivo").onchange = function(){
		aggiornaData();
	}
	
	document.getElementById("dataPartenza").onchange = function(){
		aggiornaData();
	}
	
	let multiStanze = document.getElementById("multiStanze");
	
	for (let x in oGruppiStanze) {
		for (let y in oGruppiStanze[x]) {
			multiStanze.options[multiStanze.options.length] = new Option(x+" - "+oGruppiStanze[x][y]);
		}
	}
	
	j = 0;
	for (let x in oIDGruppiStanze) {
		for (let y in oIDGruppiStanze[x]) {
			multiStanze.options[j].value = oIDGruppiStanze[x][y];
			j++;
		}
	}
}

function impostaBranchSelectors(){
	document.getElementById("branchSingolo").addEventListener("click", function(){document.getElementById("tipoPrenotazione").value="singola"});
	document.getElementById("branchGruppo").addEventListener("click", function(){document.getElementById("tipoPrenotazione").value="gruppo"});
}

window.onload = function(){
	impostaSelects();
	impostaBranchSelectors();
	
	anagrafiche = getElementsById("anagrafica anagrafica1");
	numeriOspiti = getElementsById("numeroOspiti numeroOspiti1");
	
	for(let i = 0; i < anagrafiche.length; i++){
		impostaOspiti(anagrafiche[i], numeriOspiti[i]);
	}
}

function aggiungiDati(){	
	document.getElementById("azione").value="aggiungi";
	document.getElementById("tabella").value="prenotazioni";
	//alert(document.getElementById("selezioneMultiStanze").value);
	document.getElementById("aggiungiDatabase").submit();
}

</script>
</head>
<body>
	<%
	/*LinkedHashMap<String, ArrayList<Wizard.Campo>> tabs = new LinkedHashMap<String, ArrayList<Wizard.Campo>>();
	ArrayList<Wizard.Campo> campi;

	campi = new ArrayList<Wizard.Campo>();

	campi.add( new Wizard.Campo( "select", "gruppoStanze", "Gruppo stanze" ) );
	campi.add( new Wizard.Campo( "select", "stanza", "Stanza" ) );
	campi.add( new Wizard.Campo( "hidden", "azione", "" ) );
	campi.add( new Wizard.Campo( "hidden", "tabella", "" ) );

	tabs.put( "Scelta stanza", campi );

	campi = new ArrayList<Wizard.Campo>();

	campi.add( new Wizard.Campo( "date", "dataArrivo", "Data arrivo" ) );
	campi.add( new Wizard.Campo( "date", "dataPartenza", "Data partenza" ) );

	tabs.put( "Data", campi );

	campi = new ArrayList<Wizard.Campo>();

	campi.add( new Wizard.Campo( "select", "anagrafica", "Anagrafica referente" ) );
	campi.add( new Wizard.Campo( "number", "numeroOspiti", "Numero ospiti" ) );

	tabs.put( "Referente e ospiti", campi );
	
	campi = new ArrayList<Wizard.Campo>();

	campi.add( new Wizard.Campo( "text", "anagrafica", "Anagrafica" ) );
	campi.add( new Wizard.Campo( "number", "numeroOspiti", "Numero ospiti" ) );
	campi.add( new Wizard.Campo( "number", "numeroOspiti", "Numero ospiti" ) );
	campi.add( new Wizard.Campo( "number", "numeroOspiti", "Numero ospiti" ) );
	campi.add( new Wizard.Campo( "number", "numeroOspiti", "Numero ospiti" ) );
	campi.add( new Wizard.Campo( "number", "numeroOspiti", "Numero ospiti" ) );
	

	tabs.put( "Ospiti2", campi );*/
	
	
	TreeStep<ArrayList<Wizard.Campo>> root;
	ArrayList<Wizard.Campo> campi;
	
	//---date---
	
	campi = new ArrayList<Wizard.Campo>();

	campi.add( new Wizard.Campo( "date", "dataArrivo", "Data arrivo" ) );
	campi.add( new Wizard.Campo( "date", "dataPartenza", "Data partenza" ) );
	campi.add( new Wizard.Campo( "hidden", "azione", "" ) );
	campi.add( new Wizard.Campo( "hidden", "tabella", "" ) );
	
	root = new TreeStep<ArrayList<Wizard.Campo>>("Data", campi);
	
	//---selezione---
	
	campi = new ArrayList<Wizard.Campo>();

	campi.add( new Wizard.Campo( "branchSelector", "branchSingolo", "Singolo" ) );
	campi.add( new Wizard.Campo( "branchSelector", "branchGruppo", "Gruppo" ) );
	campi.add( new Wizard.Campo( "hidden", "tipoPrenotazione", "" ) );
	
	TreeStep<ArrayList<Wizard.Campo>> selezione = root.addChild( "Selezione", campi );
	
	//---anagrafica---
	
	campi = new ArrayList<Wizard.Campo>();

	campi.add( new Wizard.Campo( "select", "anagrafica", "Anagrafica referente" ) );
	campi.add( new Wizard.Campo( "number", "numeroOspiti", "Numero ospiti totali" ) );
	
	TreeStep<ArrayList<Wizard.Campo>> singolo = selezione.addChild("Ospiti", campi);
	
	campi = new ArrayList<Wizard.Campo>();

	campi.add( new Wizard.Campo( "select", "anagrafica1", "Anagrafica referente" ) );
	campi.add( new Wizard.Campo( "number", "numeroOspiti1", "Numero ospiti totali" ) );
	
	TreeStep<ArrayList<Wizard.Campo>> gruppo = selezione.addChild("Ospiti", campi);
	
	//---stanze---
	
	campi = new ArrayList<Wizard.Campo>();

	campi.add( new Wizard.Campo( "select", "gruppoStanze", "Gruppo stanze" ) );
	campi.add( new Wizard.Campo( "select", "stanza", "Stanza" ) );
	
	singolo = singolo.addChild("Stanza",campi);
	
	campi = new ArrayList<Wizard.Campo>();

	//TODO https://harvesthq.github.io/chosen/
	campi.add( new Wizard.Campo( "multiSelect", "multiStanze", "Stanze - selezione multipla premendo CTRL" ) );
	
	gruppo = gruppo.addChild("Stanze", campi);

	// ---ricavo---
	
	//TODO fare in modo di ricongiungere i due branch in uno unico, per non creare due volte gli step ricavo e note
	
	campi = new ArrayList<Wizard.Campo>();
	campi.add( new Wizard.Campo( "money", "ricavo", "Ricavo" ) );
	
	singolo = singolo.addChild("Ricavo",campi);
	
	campi = new ArrayList<Wizard.Campo>();
	campi.add( new Wizard.Campo( "money", "ricavo1", "Ricavo" ) );
	
	gruppo = gruppo.addChild("Ricavo",campi);
	
	// ---note---
	
	campi = new ArrayList<Wizard.Campo>();
	campi.add( new Wizard.Campo( "textarea", "note", "Note - max 500 caratteri" ) );
	
	singolo = singolo.addChild("Note",campi);
	
	campi = new ArrayList<Wizard.Campo>();
	campi.add( new Wizard.Campo( "textarea", "note1", "Note - max 500 caratteri" ) );
	
	gruppo = gruppo.addChild("Note",campi);
	
	
	//---id---
	
	root.addIdToName();
	
	%>
	<div class="card">
		<jsp:include page="/jsp/treeWizard.jsp">
			<jsp:param name="formId" value="aggiungiDatabase" />
			<jsp:param name="action" value="ModificaDatabase" />
			<jsp:param name="onsubmit" value="aggiungiDati()" />
			<jsp:param name="title" value="Nuova prenotazione" />
			<jsp:param name="tabs" value="<%=Wizard.generateTreeTabs( root )%>" />
			<jsp:param name="tabsObject" value="<%=Wizard.generateTabsObject( root )%>" />
			<jsp:param name="returnPage"
				value="/prenotazioni/gestioneDati/prenotazioni.jsp" />
		</jsp:include>
	</div>
</body>
</html>