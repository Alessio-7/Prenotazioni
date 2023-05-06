<%@page
	import="prenotazioni.GestioneDati, prenotazioni.Calendario, database.dao.Prenotazioni, database.object.Prenotazione, database.dao.Anagrafiche, database.object.Anagrafica"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<title>Gestione Dati</title>

<jsp:include page="/jsp/bootstrap.jsp"></jsp:include>
<link rel="stylesheet" href="../css/gestioneDati.css">

<script type="text/javascript">	
const collapseElementList = document.querySelectorAll('.collapse')
const collapseList = [...collapseElementList].map(collapseEl => new bootstrap.Collapse(collapseEl))

<%boolean erroreAggiungi = false;
boolean erroreModifica = false;
String msgErrore = (String) request.getAttribute("errore");
if (msgErrore != null) {
	if (!msgErrore.isEmpty()) {
		switch (((String) request.getAttribute("azione"))) {
			case "aggiungi" : {
				erroreAggiungi = true;
				break;
			}
			case "modifica" : {
				erroreModifica = true;
				break;
			}
		}
	}
}%>

function mostraErrore(){
	var erroreAggiungi = <%=erroreAggiungi%>;
	var erroreModifica = <%=erroreModifica%>;
	
	if(erroreAggiungi||erroreModifica){
		alert("<%=msgErrore != null ? msgErrore.replaceAll("<br>", " ") : ""%>");
	}
	
	if(erroreAggiungi){
		document.getElementById("aggiungiModal").showModal();
	}
	
	if(erroreModifica){
		aggiornaModalModificaPrenotazione(
				<%=request.getAttribute("idDato")%>,
				<%=request.getAttribute("modificaGruppoStanze")%>,
				<%=request.getAttribute("modificaStanza")%>,
				<%=request.getAttribute("modificaAnagrafica")%>,
				<%=request.getAttribute("modificaNumeroOspiti")%>,
				<%=request.getAttribute("modificaDataArrivo")%>,
				<%=request.getAttribute("modificaDataPartenza")%>				
				)
		document.getElementById("modificaModal").showModal();
	}
}

window.onload = function(){
	window.history.pushState("", "", '/prenotazioni/gestioneDati/prenotazioni.jsp');
		
	mostraErrore();
}

function eliminaDati(){	
	document.getElementById("azione3").value="elimina";
	document.getElementById("tabella3").value="prenotazioni";
	document.getElementById("eliminaDatabase").submit();
}

function aggiornaModalEliminaPrenotazione(id, nome, stanza, dataArrivo, dataPartenza){
	document.getElementById("idEliminazione").value = id;
	document.getElementById("messaggioEliminazione").innerHTML = "Eliminare la prenotazione di "+nome+"?<br>Stanza : "+stanza+"<br>Data arrivo : "+dataArrivo+"<br>Data partenza : "+dataPartenza;
}

function apriModificaPrenotazione(id, gruppoStanze, stanza, anagrafica, numeroOspiti, dataArrivo, dataPartenza){
	let url = window.location.href;
	url = url.slice(0, -16);
	url = new URL(url+"modificaPrenotazione.jsp");

	url.searchParams.append('idDato', id);
	url.searchParams.set('gruppoStanze', gruppoStanze);
	url.searchParams.set('stanza', stanza);
	url.searchParams.set('anagrafica', anagrafica);
	url.searchParams.set('numeroOspiti', numeroOspiti);
	url.searchParams.set('dataArrivo', dataArrivo);
	url.searchParams.set('dataPartenza', dataPartenza);
	
	window.location.replace(url);
}
</script>
</head>
<body>
	<div class="pagina">
		<jsp:include page="/jsp/gui/navbar.jsp" />
		<div class="tabella">
			<table class="table table-striped table-hover">
				<thead>
					<tr>
						<th scope="col">Gruppo Stanze</th>
						<th scope="col">Stanza</th>
						<th scope="col">Anagrafica</th>
						<th scope="col">Numero ospiti</th>
						<th scope="col">Data arrivo</th>
						<th scope="col">Data partenza</th>
						<th scope="col"></th>
					</tr>
				</thead>
				<tbody>
					<%
					for ( Prenotazione prenotazione : Prenotazioni.getPrenotazioni() ) {
					%>
					<tr>
						<td><%= prenotazione.getGruppoStanze() %></td>
						<td><%= prenotazione.getStanza() %></td>
						<td>
							<div class="dropdown">
								<button class="infoAnagrafica dropdown-toggle" type="button"
									id="dropdownMenuButton1" data-bs-toggle="dropdown"
									aria-expanded="false"><%=prenotazione.getAnagrafica().getCognome()
		+ " "
		+ prenotazione.getAnagrafica().getNome()%></button>
								<div class="dropdown-menu p-3 " style="max-width: auto;">
									<%= prenotazione.getAnagrafica().getInfoAnagraficaHTML() %>
								</div>
							</div>
						</td>
						<td><%= prenotazione.getnOspiti() %></td>
						<td><%=Calendario.formatData( prenotazione.getArrivo() )%></td>
						<td><%=Calendario.formatData( prenotazione.getPartenza() )%></td>
						<td class="cellaBottoni"><div class="contenitoreBottoni">
								<button class="bottoneModifica" title="Modifica"
									onclick="apriModificaPrenotazione('<%=prenotazione.getIdPrenotazione()
		+ "', "
		+ prenotazione.getIdGruppo()
		+ ", "
		+ prenotazione.getIdStanza()
		+ ", '"
		+ prenotazione.getAnagrafica().getIdAnagrafica()
		+ "', "
		+ prenotazione.getnOspiti()
		+ ", '"
		+ prenotazione.getArrivoF()
		+ "', '"
		+ prenotazione.getPartenzaF()%>')">
									<i class="bi bi-pencil-square"></i>
								</button>
								<button class="bottoneElimina" title="Elimina"
									data-bs-toggle="modal" data-bs-target="#eliminaModal"
									onclick="aggiornaModalEliminaPrenotazione('<%=prenotazione.getIdPrenotazione()%>', '<%=prenotazione.getAnagrafica().getNome()
		+ " "
		+ prenotazione.getAnagrafica().getCognome()%>', '<%=prenotazione.getStanza()%>', '<%=Calendario.formatData( prenotazione.getArrivo() )%>', '<%=Calendario.formatData( prenotazione.getPartenza() )%>')">
									<i class="bi bi-trash"></i>
								</button>
							</div></td>
					</tr>
					<%
					}
					%>
				</tbody>
			</table>
		</div>
		<jsp:include page="/jsp/gestioneDati/cambiaVisualizzazione.jsp">
			<jsp:param name="scrittaBottone" value="Nuova prenotazione" />
		</jsp:include>
	</div>

	<form id="eliminaDatabase" action="ModificaDatabase"
		onsubmit="eliminaDati()">
		<input type="hidden" name="azione3" id="azione3"></input> <input
			type="hidden" name="tabella3" id="tabella3"></input> <input
			type="hidden" name="idEliminazione" id="idEliminazione"></input>
		<div class="modal fade" id="eliminaModal" tabindex="-1"
			aria-labelledby="exampleModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="exampleModalLabel">Elimina
							prenotazione</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"
							aria-label="Close"></button>
					</div>
					<div class="modal-body">

						<div class="messaggioEliminazione" id="messaggioEliminazione"></div>

						<div class="modal-footer">
							<button type="button" class="btn btn-secondary"
								data-bs-dismiss="modal">Annulla</button>
							<input type="submit" class="btn btn-danger" value="Elimina">
						</div>
					</div>
				</div>
			</div>
		</div>
	</form>
</body>