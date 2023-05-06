<%@page
	import="prenotazioni.GestioneDati, database.dao.CollocazioniStanze, database.object.Stanza"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<title>Gestione Dati</title>
<jsp:include page="/jsp/bootstrap.jsp" />
<link rel="stylesheet" href="../css/gestioneDati.css">

<script type="text/javascript">	
<%=GestioneDati.generaObjectGruppiStanze()%>

function impostaSelects(){
	var gruppoStanze = document.getElementById("gruppoStanze");
	
	for (var x in oGruppiStanze) {
		gruppoStanze.options[gruppoStanze.options.length] = new Option(x);
	}
	
	var j = 0;
	for (var x in oIDGruppiStanze) {
		gruppoStanze.options[j].value = x;
		j++;
	}
}

window.onload = function(){
	window.history.pushState("", "", '/prenotazioni/gestioneDati/stanze.jsp');
	impostaSelects();
}

function aggiungiDati(){	
	document.getElementById("azione").value="aggiungi";
	document.getElementById("tabella").value="stanze";
	document.getElementById("aggiungiDatabase").submit();
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
						<th scope="col">Stanza</th>
						<th scope="col">Gruppo stanze</th>
					</tr>
				</thead>
				<tbody>
					<%
					for ( Stanza stanza : CollocazioniStanze.getStanze() ) {
					%>
					<tr>
						<td><%= stanza.getStanza() %></td>
						<td><%= stanza.getGruppoStanze() %></td>
					</tr>
					<%
					}
					%>
				</tbody>
			</table>
		</div>
		<jsp:include page="/jsp/gestioneDati/cambiaVisualizzazione.jsp">
			<jsp:param name="scrittaBottone" value="Nuova stanza" />
		</jsp:include>
	</div>

	<form id="aggiungiDatabase" action="ModificaDatabase"
		onsubmit="aggiungiDati()">
		<input type="hidden" name="azione" id="azione"></input> <input
			type="hidden" name="tabella" id="tabella"></input>
		<div class="modal fade" id="aggiungiModal" tabindex="-1"
			aria-labelledby="exampleModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="exampleModalLabel">Aggiungi
							stanza</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"
							aria-label="Close"></button>
					</div>
					<div class="modal-body">
						<div class="row mb-3">
							<label class="form-label" for="gruppoStanze">Gruppo
								stanze</label> <select class="form-select" name="gruppoStanze"
								id="gruppoStanze" aria-label="Gruppo stanze"></select>
						</div>

						<div class="row mb-3">
							<label class="form-label" for="stanza">Stanza</label> <input
								class="form-control" name="stanza" id="stanza" type="text"
								placeholder="Stanza" required>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary"
							data-bs-dismiss="modal">Annulla</button>
						<input type="submit" class="btn btn-primary" value="Aggiungi">
					</div>
				</div>
			</div>
		</div>
	</form>
</body>