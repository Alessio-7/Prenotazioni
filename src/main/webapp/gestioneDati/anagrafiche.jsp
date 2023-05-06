<%@page import="database.dao.Prenotazioni"%>
<%@page
	import="prenotazioni.GestioneDati, database.dao.Anagrafiche, database.object.Anagrafica"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<title>Gestione Dati</title>

<jsp:include page="/jsp/bootstrap.jsp" />

<link rel="stylesheet" href="../css/gestioneDati.css">

<script type="text/javascript">	
window.onload = function(){
	window.history.pushState("", "", '/prenotazioni/gestioneDati/anagrafiche.jsp');
}

function aggiungiDati(){	
	document.getElementById("azione").value="aggiungi";
	document.getElementById("tabella").value="anagrafiche";
	document.getElementById("aggiungiDatabase").submit();
}

function modificaDati(){	
	document.getElementById("azione2").value="modifica";
	document.getElementById("tabella2").value="anagrafiche";
	document.getElementById("modificaDatabase").submit();
}

function eliminaDati(){	
	document.getElementById("azione3").value="elimina";
	document.getElementById("tabella3").value="anagrafiche";
	document.getElementById("eliminaDatabase").submit();
}

function aggiornaModalModificaAnagrafica(id, nome, cognome, telefono){
	document.getElementById("idDato").value = id;
	document.getElementById("modificaNome").value = nome;
	document.getElementById("modificaCognome").value = cognome;
	document.getElementById("modificaNumeroDiTelefono").value = telefono;

}

function aggiornaModalEliminaAnagrafica(id, nome, nPrenotazioni){
	document.getElementById("idEliminazione").value = id;
	if(nPrenotazioni == 0){
		document.getElementById("messaggioEliminazione").innerHTML = "Eliminare l'anagrafica di "+nome+"?";
	}else if (nPrenotazioni == 1){
		document.getElementById("messaggioEliminazione").innerHTML = "Eliminare l'anagrafica di "+nome+" e la prenotazione a suo nome?";
	}else{
		document.getElementById("messaggioEliminazione").innerHTML = "Eliminare l'anagrafica di "+nome+" e le "+nPrenotazioni+" prenotazioni a suo nome?";
	}
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
						<th scope="col">Nome</th>
						<th scope="col">Cognome</th>
						<th scope="col">Telefono</th>
						<th scope="col"></th>
					</tr>
				</thead>
				<tbody>
					<%
					for ( Anagrafica anagrafica : Anagrafiche.getAnagrafiche() ) {
					%>
					<tr>
						<td><%= anagrafica.getNome() %></td>
						<td><%= anagrafica.getCognome() %></td>
						<td><%= anagrafica.getTelefono() %></td>
						<td class="cellaBottoni"><div class="contenitoreBottoni">
								<button class="bottoneModifica" title="Modifica"
									onclick="aggiornaModalModificaAnagrafica('<%= anagrafica.getIdAnagrafica() %>', '<%= anagrafica.getNome() %>', '<%= anagrafica.getCognome() %>', '<%= anagrafica.getTelefono() %>')"
									data-bs-toggle="modal" data-bs-target="#modificaModal">
									<i class="bi bi-pencil-square"></i>
								</button>
								<button class="bottoneElimina" title="Elimina"
									data-bs-toggle="modal" data-bs-target="#eliminaModal"
									onclick="aggiornaModalEliminaAnagrafica('<%=anagrafica.getIdAnagrafica()%>', '<%=anagrafica.getNome()
		+ " "
		+ anagrafica.getCognome()%>', '<%=Prenotazioni.getNprenotazioniIdAnagrafica( ""+anagrafica.getIdAnagrafica() )%>')">
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
			<jsp:param name="scrittaBottone" value="Nuova anagrafica" />
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
							anagrafica</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"
							aria-label="Close"></button>
					</div>
					<div class="modal-body">
						<div class="row mb-3">
							<label class="form-label" for="nome">Nome</label> <input
								class="form-control" name="nome" id="nome" type="text"
								placeholder="Nome" required>
						</div>
						<div class="row mb-3">
							<label class="form-label" for="cognome">Cognome</label> <input
								class="form-control" name="cognome" id="cognome" type="text"
								placeholder="Cognome" required>
						</div>
						<div class="row mb-3">
							<label class="form-label" for="numeroDiTelefono">Numero
								di telefono</label> <input class="form-control" name="numeroDiTelefono"
								id="numeroDiTelefono" type="text"
								placeholder="Numero di telefono" required>
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

	<form id="modificaDatabase" action="ModificaDatabase"
		onsubmit="modificaDati()">
		<input type="hidden" name="azione2" id="azione2"></input> <input
			type="hidden" name="tabella2" id="tabella2"></input> <input
			type="hidden" name="idDato" id="idDato"></input>
		<div class="modal fade" id="modificaModal" tabindex="-1"
			aria-labelledby="exampleModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="exampleModalLabel">Modifica
							anagrafica</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"
							aria-label="Close"></button>
					</div>
					<div class="modal-body">
						<div class="row mb-3">
							<label class="form-label" for="nome">Nome</label> <input
								class="form-control" name="modificaNome" id="modificaNome"
								type="text" placeholder="Nome" required>
						</div>
						<div class="row mb-3">
							<label class="form-label" for="cognome">Cognome</label> <input
								class="form-control" name="modificaCognome" id="modificaCognome"
								type="text" placeholder="Cognome" required>
						</div>
						<div class="row mb-3">
							<label class="form-label" for="numeroDiTelefono">Numero
								di telefono</label> <input class="form-control"
								name="modificaNumeroDiTelefono" id="modificaNumeroDiTelefono"
								type="text" placeholder="Numero di telefono" required>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary"
							data-bs-dismiss="modal">Annulla</button>
						<input type="submit" class="btn btn-primary" value="Modifica">
					</div>
				</div>
			</div>
		</div>
	</form>

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