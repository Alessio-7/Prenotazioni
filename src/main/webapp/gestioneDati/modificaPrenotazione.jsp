<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page
	import="java.util.ArrayList, java.util.LinkedHashMap, prenotazioni.Wizard, prenotazioni.TreeStep, prenotazioni.GestioneDati, database.dao.Anagrafiche, database.object.Anagrafica  "%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Modifica Prenotazione</title>
<jsp:include page="/jsp/bootstrap.jsp" />
<link rel="stylesheet" href="../css/login.css">

<script>
<%=GestioneDati.generaObjectGruppiStanze()%>
<%=GestioneDati.generaListsAnagrafiche()%>

function impostaOspiti(anagrafica, numeroOspiti){

	for (let i = 0; i < lAnagrafiche.length; i++) {
		anagrafica.options[i] = new Option(lAnagrafiche[i], lIDanagrafiche[i]);
	}
	numeroOspiti.min=1;
}

function impostaSelects(){	
	
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
}

window.onload = function(){
	impostaSelects();
	impostaOspiti(document.getElementById("anagrafica"), document.getElementById("numeroOspiti"));
	aggiornaDati();
	window.history.pushState("", "", '/prenotazioni/gestioneDati/modificaPrenotazione.jsp');
}

function modificaDati(){	
	document.getElementById("azione").value="modifica";
	document.getElementById("tabella").value="prenotazioni";
	document.getElementById("modificaDatabase").submit();
}

function aggiornaDati(){
	
	const searchParams = Object.fromEntries(  
			  new URLSearchParams(window.location.search)
	)
	const event = new Event('change');
	let element;
	for (var a in searchParams) {
		element = document.getElementById(a);
		element.value = searchParams[a];
		element.dispatchEvent(event);
	}
}

</script>
</head>
<body>
	<%
	LinkedHashMap<String, ArrayList<Wizard.Campo>> tabs = new LinkedHashMap<String, ArrayList<Wizard.Campo>>();
	ArrayList<Wizard.Campo> campi;

	campi = new ArrayList<Wizard.Campo>();

	campi.add( new Wizard.Campo( "date", "dataArrivo", "Data arrivo" ) );
	campi.add( new Wizard.Campo( "date", "dataPartenza", "Data partenza" ) );

	tabs.put( "Data", campi );
	
	campi = new ArrayList<Wizard.Campo>();

	campi.add( new Wizard.Campo( "select", "anagrafica", "Anagrafica referente" ) );
	campi.add( new Wizard.Campo( "number", "numeroOspiti", "Numero ospiti" ) );

	tabs.put( "Ospiti", campi );
	
	campi = new ArrayList<Wizard.Campo>();

	campi.add( new Wizard.Campo( "select", "gruppoStanze", "Gruppo stanze" ) );
	campi.add( new Wizard.Campo( "select", "stanza", "Stanza" ) );
	campi.add( new Wizard.Campo( "hidden", "azione", "" ) );
	campi.add( new Wizard.Campo( "hidden", "tabella", "" ) );
	campi.add( new Wizard.Campo( "hidden", "idDato", "" ) );

	tabs.put( "Scelta stanza", campi );
	
	%>
	<div class="card">
		<jsp:include page="/jsp/linearWizard.jsp">
			<jsp:param name="formId" value="modificaDatabase" />
			<jsp:param name="action" value="ModificaDatabase" />
			<jsp:param name="onsubmit" value="modificaDati()" />
			<jsp:param name="title" value="Modifica prenotazione" />
			<jsp:param name="tabs" value="<%=Wizard.generateLinearTabs( tabs )%>" />
			<jsp:param name="returnPage"
				value="/prenotazioni/gestioneDati/prenotazioni.jsp" />
		</jsp:include>
	</div>
</body>
</html>