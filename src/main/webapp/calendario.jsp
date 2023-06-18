<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page
	import="prenotazioni.Calendario, java.util.*, java.time.LocalDate, java.time.temporal.ChronoUnit, database.dao.*, database.object.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Calendario</title>
<jsp:include page="/jsp/bootstrap.jsp" />
<link rel="stylesheet" href="./css/calendario.css">

<%
Calendario c;
String visualizzazione;

int caselleCellaRicavo = 2;

if (request.getAttribute("data") != null) {
	LocalDate d = Calendario.toDate((String) request.getAttribute("data"));
	visualizzazione = (String) request.getAttribute("visualizzazione");
	switch (visualizzazione) {
		case "settimana" :
		c = Calendario.settimana(d);
		break;
		case "mese" :
		c = Calendario.mese(d);
		caselleCellaRicavo = 3;
		break;
		default :
	c = Calendario.questaSettimana();
	}
} else {
	visualizzazione = "settimana";
	c = Calendario.questaSettimana();
}

String sideBarCollapsed = "false";

if (request.getAttribute("sideBarCollapsed") != null) {
	sideBarCollapsed = (String) request.getAttribute("sideBarCollapsed");
}
%>

<script type="text/javascript">
	window.onload = function cambiaURL() {
		window.history.pushState("", "", '/prenotazioni/calendario.jsp');
		resizewidth();
		setDatePicker();
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

	function attivaServlet(visualizzazione, direzione) {
		//alert(document.getElementById("datePicker").value);
		//alert(formatDatePickerToData(document.getElementById("datePicker").value));
		document.getElementById("data").value = formatDatePickerToData(document.getElementById("datePicker").value);
		document.getElementById("visualizzazione").value = visualizzazione;
		document.getElementById("direzione").value = direzione;
		document.getElementById("infoMese").submit();
	}
	
	function getDateOfWeek(w, y) {
	    var d = (1 + (w - 1) * 7)+1; // 1st of January + 7 days for each week

	    return new Date(y, 0, d);
	}
	
	function getWeekNumber(d) {
	    // Copy date so don't modify original
	    d = new Date(Date.UTC(d.getFullYear(), d.getMonth(), d.getDate()));
	    // Set to nearest Thursday: current date + 4 - current day number
	    // Make Sunday's day number 7
	    d.setUTCDate(d.getUTCDate() + 4 - (d.getUTCDay()||7));
	    // Get first day of year
	    var yearStart = new Date(Date.UTC(d.getUTCFullYear(),0,1));
	    // Calculate full weeks to nearest Thursday
	    var weekNo = Math.ceil(( ( (d - yearStart) / 86400000) + 1)/7);
	    
	    return "W"+weekNo;
	}

	
	function formatDataToDatePicker(data){
		const d = data.split('/');
		
		switch('<%=visualizzazione%>'){
		case 'settimana':
			const date = new Date(d[2], d[1]-1, d[0]);
			return d[2]+"-"+getWeekNumber(date);
		case 'mese':
			return d[2]+"-"+d[1];
		}
	}
	
	function formatDatePickerToData(data){
		const d = data.split('-');
		
		switch('<%=visualizzazione%>'){
		case 'settimana':
			const date = getDateOfWeek(d[1].replace("W", ""), d[0] );
			return date.getDate()+"/"+(date.getMonth()+1)+"/"+date.getFullYear();
		case 'mese':
			return "1/"+d[1]+"/"+d[0];
		}
	}
	
	function setDatePicker(){
		let datePicker = document.getElementById("datePicker");
		let data = document.getElementById("data").value;
		
		switch('<%=visualizzazione%>'){
		case 'settimana':
			datePicker.type = "week";
			datePicker.value = formatDataToDatePicker(data);
			break;
		case 'mese':
			datePicker.type = "month";
			datePicker.value = formatDataToDatePicker(data);
			break;
		default:
			datePicker.type = "week";
		}
	}
	
	function collapseSideBar(){
		let sideBarCollapsed = document.getElementById("sideBarCollapsed").value === "true"		
		//alert(sideBarCollapsed)
		if(sideBarCollapsed){
			document.getElementById("cambiaVisualizzazione").classList.toggle("sideBarCollapsed")
		}else{
			document.getElementById("cambiaVisualizzazione").classList.add("sideBarCollapsed")
		}
		
		sideBarCollapsed=!sideBarCollapsed
		document.getElementById("sideBarCollapsed").value = sideBarCollapsed.toString()
	}
</script>
</head>
<body>
	<div class="pagina">
		<jsp:include page="/jsp/gui/navbar.jsp" />
		<div
			class="tabellaContainer d-flex justify-content-center align-items-start">
			<table class="tabellaCalendario">
				<thead
					style="position: -webkit-sticky; position: sticky; top: 0; background-color: #f5f5f5">
					<tr>
						<td>
							<form class="infoMese" id="infoMese"
								action="CambiaMeseCalendario">
								<div class="nomeMese"
									style="grid-column-end: span <%=c.getNumeroGiorni()%>; width:<%// (c.getNumeroGiorni()*28)+(c.getNumeroGiorni()*2)-1%>px">
									<button type="Button" class="bottoneCambiaMese"
										style="float: left"
										onclick="attivaServlet('<%=visualizzazione%>', -1)">
										<i class="bi bi-chevron-left"></i>
									</button>
									<div id="scrittaMese">
										<%=c.getNomeMese()%>
									</div>
									<input type="hidden" name="sideBarCollapsed"
										id="sideBarCollapsed" value="<%=sideBarCollapsed%>"> <input
										type="hidden" name="visualizzazione" id="visualizzazione"></input>
									<input type="hidden" name="direzione" id="direzione"></input> <input
										type="hidden" name="data" id="data"
										value="<%=Calendario.formatData( c.getDataInizio() )%>"></input>
									<button type="Button" class="bottoneCambiaMese"
										style="float: right"
										onclick="attivaServlet('<%=visualizzazione%>', 1)">
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
									ricavo</div>
										<div class="cellaTotaleRicavo" style="<%="grid-column-end: span "+caselleCellaRicavo+";"%>"><%= c.getTotaleRicavi()%></div>
										<div class="cellaTotaleRicavo" style="<%="grid-column-end: span "+ (c.getNumeroGiorni()-caselleCellaRicavo)+ ";"%>"></div>
								<div class="totale"
									style="grid-row-start: 2; grid-column-start: 1;">Totale
									ospiti</div>

								<%
								for ( int i = 0; i < c.getNumeroGiorni(); i++ ) {
								%>
								<div class="cellaTotale"
									style="<%="grid-row-start: 2; grid-column-start: "
		+ ( 2 + i )%>"><%=c.getTotaleOspiti( i )%></div>
								<%
								}
								%>
								<div class="totale"
									style="grid-row-start: 3; grid-column-start: 1; border-radius: 0 0 0 14px;">Totale
									stanze occupate</div>

								<%
								for ( int i = 0; i < c.getNumeroGiorni(); i++ ) {
								%>
								<div class="cellaTotale"
									style="<%="grid-row-start: 3; grid-column-start: "
		+ ( 2 + i )%>"><%=c.getTotalePresenze( i )%></div>
								<%
								}
								%>
							</div>
						</td>
					</tr>
				</tfoot>
			</table>
		</div>


		<div id="cambiaVisualizzazione"
			class="laterale d-flex flex-column flex-shrink-0 p-3 <%=sideBarCollapsed.equals( "true" ) ? "sideBarCollapsed" : ""%>">
			<ul class="nav nav-pills flex-column mb-auto">
				<div class="d-inline-flex align-items-end mb-3">
					<button type="button" class="btn btn-primary me-3"
						onclick="collapseSideBar()" style="width: min-content;">
						<i class="bi bi-list"></i>
					</button>
					<li class="nav-item">
						<h5>Visualizzazione</h5>
					</li>
				</div>
				<li class="nav-item my-3"><input class="form-control"
					type="week" id="datePicker" name="datePicker"
					onchange="attivaServlet('<%=visualizzazione%>', 0)"></li>
				<li class="nav-item my-3">
					<div class="form-check">
						<input type="radio" class="form-check-input"
							name="radioVisualizzazione" id="radioSettimana" value="settimana"
							<%=( visualizzazione.equals( "settimana" ) ? "checked" : "" )%>
							onchange="attivaServlet('settimana', 0)" /> <label
							class="form-check-label" for="radioSettimana">Settimana</label>
					</div>

					<div class="form-check">
						<input type="radio" class="form-check-input"
							name="radioVisualizzazione" id="radioMese" value="mese"
							<%=( visualizzazione.equals( "mese" ) ? "checked" : "" )%>
							onchange="attivaServlet('mese', 0)" /> <label
							class="form-check-label" for="radioMese">Mese</label>
					</div>
				</li>
				<li class="nav-item"></li>
				<li class="nav-item"></li>
			</ul>
		</div>
	</div>
</body>
</html>