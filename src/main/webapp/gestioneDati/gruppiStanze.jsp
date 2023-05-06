<%@page
	import="java.util.ArrayList, java.util.LinkedHashMap, java.util.Map, java.util.Map.Entry, prenotazioni.GestioneDati, database.dao.CollocazioniStanze, database.object.Stanza"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<title>Gestione Dati</title>

<jsp:include page="/jsp/bootstrap.jsp" />

<link rel="stylesheet" href="../css/gestioneDati.css">

<script type="text/javascript">
	window.onload = function() {
		window.history.pushState("", "",
				'/prenotazioni/gestioneDati/gruppiStanze.jsp');
	}

	function aggiungiDati() {
		document.getElementById("azione").value = "aggiungi";
		document.getElementById("tabella").value = "gruppiStanze";
		document.getElementById("aggiungiDatabase").submit();
	}
</script>
</head>
<body>
	<div class="pagina">
		<jsp:include page="/jsp/gui/navbar.jsp" />
		<div class="tabella">
			<div class="accordion" id="accordionPanels">
				<%
				LinkedHashMap<String, ArrayList<String>> gruppiStanze = CollocazioniStanze.getGruppiStanze();
				int i = 0;
				for ( Entry<String, ArrayList<String>> gruppoStanze : gruppiStanze.entrySet() ) {
				%>
				<div class="accordion-item">
					<h2 class="accordion-header" id="panelsStayOpen-heading<%=i%>">
						<button class="accordion-button collapsed" type="button"
							data-bs-toggle="collapse"
							data-bs-target="#panelsStayOpen-collapse<%=i%>"
							aria-expanded="true"
							aria-controls="panelsStayOpen-collapse<%=i%>"><%= gruppoStanze.getKey() %></button>
					</h2>
					<div id="panelsStayOpen-collapse<%=i%>"
						class="accordion-collapse collapse"
						aria-labelledby="panelsStayOpen-heading<%=i%>">
						<div class="accordion-body">
							<%
							for ( String s : gruppoStanze.getValue() ) {
							%>
							<%= s %><br>
							<%
							}
							%>
						</div>
					</div>
				</div>
				<%
				i++ ;
				}
				%>
			</div>
		</div>
		<jsp:include page="/jsp/gestioneDati/cambiaVisualizzazione.jsp">
			<jsp:param name="scrittaBottone" value="Nuovo gruppo" />
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
							gruppo stanze</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"
							aria-label="Close"></button>
					</div>
					<div class="modal-body">
						<div class="row mb-3">
							<label class="form-label" for="gruppoStanze">Gruppo
								stanze</label> <input class="form-control" name="gruppoStanze"
								id="gruppoStanze" type="text" placeholder="Gruppo stanze"
								required>
						</div>
						<div class="row mb-3">
							<label class="form-label" for="stanze">Stanze collocate</label>
							<textarea class="form-control" name="stanze" id="stanze"
								rows="10"
								placeholder="Inserire le stanze collocate andando a capo per ogni stanza
Esempio:
 101
 102
 103
  ..."
								required></textarea>
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