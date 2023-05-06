<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page
	import="prenotazioni.Calendario, java.util.*, java.time.LocalDate, java.time.temporal.ChronoUnit, database.dao.*, database.object.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Calendario</title>
<jsp:include page="/jsp/bootstrap.jsp"/>
<link rel="stylesheet" href="./css/calendario.css">

<%
/*java.util.Enumeration en = request.getAttributeNames();
while (en.hasMoreElements()) {
	Object oo = en.nextElement();
	System.out.println(" Attributo "+oo+" = "+request.getAttribute(""+oo)+"<br>");
}
java.util.Enumeration en1 = request.getParameterNames();
while (en1.hasMoreElements()) {
	Object oo = en1.nextElement();
	System.out.println(" Paramtero "+oo+" = "+request.getParameter(""+oo)+"<br>");
}*/

final int minimoNumeroGiorni = 7;
int nGiorniVisualizzati;

Calendario c;

if (request.getAttribute("data") != null) {
	LocalDate d = Calendario.toDate((String) request.getAttribute("data"));
	nGiorniVisualizzati = (int) request.getAttribute("nGiorniVisualizzati");
	c = Calendario.periodo(d, nGiorniVisualizzati);
} else {
	nGiorniVisualizzati = 10;
	c = Calendario.periodoDaOggi(nGiorniVisualizzati);
}
%>

<script type="text/javascript">
	window.onload = function cambiaURL() {
		window.history.pushState("", "", '/prenotazioni/calendario.jsp');
		resizewidth();
	}

	function resizewidth() {
		nGiorni =
<%=c.getNumeroGiorni()%>
	;
		if (nGiorni < 14) {
			width = 50;

			if (nGiorni < 9) {
				width = 60;
			}

			var elements = document.getElementsByClassName("numeriGiorni");
			for (var i = 0; i < elements.length; i++) {
				elements[i].style.width = (width + "px");
			}

			elements = document.getElementsByClassName("giorno");
			for (var i = 0; i < elements.length; i++) {
				elements[i].style.width = (width + "px");
			}

			elements = document.getElementsByClassName("cellaTotale");
			for (var i = 0; i < elements.length; i++) {
				elements[i].style.width = (width + "px");
			}
		}
	}

	function attivaServlet(sommaGiorni) {

		document.getElementById("sommaGiorni").value = sommaGiorni;
		document.getElementById("infoMese").submit();
	}

	function avantiMese() {
		attivaServlet(
<%=nGiorniVisualizzati%>
	);
	}

	function indietroMese() {
		attivaServlet(
<%=-nGiorniVisualizzati%>
	);
	}
</script>
</head>
<body>
	<jsp:include page="/jsp/gui/navbar.jsp" />
	<table class="tabellaCalendario">
		<thead
			style="position: -webkit-sticky; position: sticky; top: 0; background-color: #f5f5f5">
			<tr>
				<%
				/*
					<td>
						<form id="nuovaPrenotazione" style="width: 232px" action="">
							<button type="Button" class="bottoneNuovaPrenotazione"
								onclick="nuovaPrenotazione()">
								<i class="bi me-2 bi-server"></i> Gestione Dati
							</button>
							<input type="hidden" name="data" id="data"
								value="<%=Calendario.formatData( c.getData( 1 ) )%/>"></input>
						</form>
					</td>*/
				%>
				<td>
					<form class="infoMese" id="infoMese" action="CambiaMeseCalendario">
						<div class="nomeMese"
							style="grid-column-end: span <%=c.getNumeroGiorni()%>; width:<%// (c.getNumeroGiorni()*28)+(c.getNumeroGiorni()*2)-1%>px">
							<button type="Button" class="bottoneCambiaMese"
								style="float: left" onclick="indietroMese()">
								<i class="bi bi-chevron-left"></i>
							</button>
							<div id="scrittaMese">
								<%= c.getNomeMese() %>
							</div>
							<input type="hidden" name="sommaGiorni" id="sommaGiorni"></input>
							<input type="hidden" name="data" id="data"
								value="<%=Calendario.formatData( c.getDataInizio() )%>"></input>
							<button type="Button" class="bottoneCambiaMese"
								style="float: right" onclick="avantiMese()">
								<i class="bi bi-chevron-right"></i>
							</button>
						</div>
						<%
						int giornoFine = c.getDataFine().getDayOfMonth();
						if ( c.getDataFine().getMonthValue() > c.getDataInizio().getMonthValue() || c.getDataFine().getYear() > c.getDataFine().getYear() ) {
							giornoFine = c.getDataInizio().lengthOfMonth() + c.getDataFine().getDayOfMonth();
						}

						for ( int i = 0; i < c.getNumeroGiorni(); i++ ) {
						%>
						<div class="numeriGiorni"
							style="<%="grid-column-start: "
		+ ( 1 + i )%>">
							<%=c.getGiornoSettimana( i )%>
						</div>
						<%
						}

						int g = c.getDataInizio().getDayOfMonth();
						for ( int i = 0; i < c.getNumeroGiorni(); i++ ) {
						if ( g > c.getDataInizio().lengthOfMonth() ) {
							g = 1;
						}
						%>
						<div class="numeriGiorni"
							style="<%="grid-column-start: "
		+ ( 1 + i )%>">
							<%=g%>
						</div>
						<%
						g++ ;
						}
						%>
					</form>
				</td>
			</tr>
			<%
			String calendarioHTML = c.getCalendarioInRangeHTML();
			%>
		</thead>
		<tbody>
			<tr>
				<td colspan="2"><%=calendarioHTML%></td>
			</tr>
		</tbody>
		<tfoot>
			<tr>
				<td colspan="3">
					<div class="calcoloTotale">
						<div class="totale"
							style="grid-row-start: 1; grid-column-start: 1;">Totale
							ospiti</div>

						<%
						for ( int i = 0; i < c.getNumeroGiorni(); i++ ) {
						%>
						<div class="cellaTotale"
							style="<%="grid-row-start: 1; grid-column-start: "
		+ ( 2 + i )%>"><%= c.getTotaleOspiti( i ) %></div>
						<%
						}
						%>
						<div class="totale"
							style="grid-row-start: 2; grid-column-start: 1; border-radius: 0 0 0 14px;">Totale
							stanze occupate</div>

						<%
						for ( int i = 0; i < c.getNumeroGiorni(); i++ ) {
						%>
						<div class="cellaTotale"
							style="<%="grid-row-start: 2; grid-column-start: "
		+ ( 2 + i )%>"><%= c.getTotalePresenze( i ) %></div>
						<%
						}
						%>
					</div>
				</td>
			</tr>
		</tfoot>
	</table>
</body>
</html>