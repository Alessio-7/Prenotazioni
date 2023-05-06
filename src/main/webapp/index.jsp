<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<jsp:include page="/jsp/bootstrap.jsp" />
<link rel="stylesheet" href="./css/login.css">
<title>Login</title>
</head>
<body>

	<svg xmlns="http://www.w3.org/2000/svg" style="display: none;">
  <symbol id="exclamation-triangle-fill" fill="currentColor"
			viewBox="0 0 16 16">
    <path
			d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z" />
  </symbol>
</svg>


	<%
	boolean errore = false;
	try {
		errore = request.getParameter( "erroreCredenziali" ).equals( "true" );
	} catch ( Exception e ) {
	}
	%>
	<form action="Login" method="post" class="card">
		<h1>Login</h1>
		<%= errore?"<div class=\"alert alert-danger d-flex align-items-center alert-dismissible fade show\" role=\"alert\"><svg class=\"bi flex-shrink-0 me-2\" width=\"24\" height=\"24\" role=\"img\"aria-label=\"Danger:\"><use xlink:href=\"#exclamation-triangle-fill\" /></svg><div>User name o password errati</div><button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"alert\" aria-label=\"Close\"></button></div>":"" %>
		<div class="form-group">
			<label for="inputUserName">User name</label> <input type="text"
				class="form-control <%=errore ? "is-invalid" : ""%>"
				name="inputUserName" id="inputUserName"
				placeholder="Inserire l'user name">
		</div>
		<div class="form-group">
			<label for="inputPassword">Password</label> <input type="password"
				class="form-control <%=errore ? "is-invalid" : ""%>"
				id="inputPassword" placeholder="Inserire la password">
		</div>
		<div
			class="form-check d-flex align-items-center justify-content-between">
			<div>
				<input type="checkbox" class="form-check-input"
					name="inputRicordaCredenziali" id="inputRicordaCredenziali">
				<label class="form-check-label" for="inputRicordaCredenziali">Ricordami</label>
			</div>
			<button type="submit" class="btn btn-primary btnAccedi">Accedi</button>
		</div>
	</form>
</body>
</html>