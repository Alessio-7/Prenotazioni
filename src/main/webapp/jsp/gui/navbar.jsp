<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<style type="text/css">
.menubar {
	background: rgb(30, 96, 145);
	background: linear-gradient(90deg, rgba(22, 138, 173, 1) 0%,
		rgba(82, 182, 154, 1) 74%);
	grid-area: menubar;
}
</style>
<nav
	class="menubar navbar navbar-expand-lg navbar-dark bd-navbar sticky-top">
	<div class="container-fluid">
		<a class="navbar-brand" style="padding-left: 17px; font-size: 24px;">
			<i class="bi bi-journal-bookmark-fill"></i> ToBook
		</a>
		<div class="collapse navbar-collapse" id="navbarNav">
			<ul class="navbar-nav">
				<li class="nav-item"><a class="nav-link active"
					aria-current="page" href="/prenotazioni/calendario.jsp"><i
						class="bi me-2 bi-calendar-week"></i>Calendario</a></li>
			</ul>
			<ul class="navbar-nav">
				<li class="nav-item"><a class="nav-link active"
					aria-current="page"
					href="/prenotazioni/gestioneDati/prenotazioni.jsp"><i
						class="bi me-2 bi-server"></i>Gestione dati</a></li>
			</ul>
		</div>
	</div>
</nav>