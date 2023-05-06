<%@ page contentType="text/html"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>

<!DOCTYPE html>
<html lang="en">
<head>
<title>SQLite Demo</title>
</head>
<body>
	<table>
		<thead>
			<tr>
				<th>Item No.</th>
				<th>Name</th>
				<th>Price</th>
				<th>Description</th>
			</tr>
		</thead>
		<tbody>
			<%
                Class.forName("org.sqlite.JDBC");
                Connection conn =
                     DriverManager.getConnection("jdbc:sqlite:F:\\Computer\\Documenti\\java-workspace\\prenotazioni\\database\\prenotazioni.db");
                Statement stat = conn.createStatement();
 
                ResultSet rs = stat.executeQuery("select * from stanze;");
 
                while (rs.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rs.getString("idstanza") + "</td>");
                    out.println("<td>" + rs.getString("nomestanza") + "</td>");
                    out.println("<td>" + rs.getString("tipostanza") + " </td>");
                    out.println("</tr>");
                }
 
                rs.close();
                conn.close();
            %>
		</tbody>
	</table>
</body>
</html>