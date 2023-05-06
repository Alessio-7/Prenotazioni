<div id="cambiaVisualizzazione"
	class="laterale d-flex flex-column flex-shrink-0 p-3 bg-light"
	style="width: 205px;">
	<%
	String scrittaBottone = request.getParameter( "scrittaBottone" );
	if ( scrittaBottone.equals( "Nuova prenotazione" ) ) {
	%>
	<a href="/prenotazioni/gestioneDati/nuovaPrenotazione.jsp"
		class="aggiungi"
		style="color: black; text-decoration: none; padding: 1px 6px;"><i
		class="bi bi-plus-lg"
		style="font-size: 30px; margin-left: 15px; margin-right: 15px;"></i> <%= scrittaBottone%></a>
	<%
	} else {
	%>
	<button class="aggiungi" data-bs-toggle="modal"
		data-bs-target="#aggiungiModal">
		<i class="bi bi-plus-lg"
			style="font-size: 30px; margin-left: 15px; margin-right: 15px;"></i>
		<%= scrittaBottone%>
	</button>
	<%
	}
	%>
	<ul class="nav nav-pills flex-column mb-auto">
		<li class="nav-item"><a
			href="/prenotazioni/gestioneDati/prenotazioni.jsp"
			class="linkSideBar nav-link" aria-current="page"> <i
				class="bi me-2 bi-calendar2-week"></i> Prenotazioni
		</a></li>
		<li class="nav-item"><a
			href="/prenotazioni/gestioneDati/anagrafiche.jsp"
			class="linkSideBar nav-link" aria-current="page"> <i
				class="bi me-2 bi-people"></i> Anagrafiche
		</a></li>
		<li class="nav-item"><a
			href="/prenotazioni/gestioneDati/gruppiStanze.jsp"
			class="linkSideBar nav-link" aria-current="page"> <i
				class="bi me-2 bi-building"></i> Gruppi stanze
		</a></li>
		<li class="nav-item"><a
			href="/prenotazioni/gestioneDati/stanze.jsp"
			class="linkSideBar nav-link" aria-current="page"> <i
				class="bi me-2 bi-door-open"></i> Stanze
		</a></li>
	</ul>
</div>