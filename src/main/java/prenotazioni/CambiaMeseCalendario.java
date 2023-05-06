package prenotazioni;

import java.io.IOException;
import java.time.LocalDate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class CambiaMeseCalendario
 */
@WebServlet( "/CambiaMeseCalendario" )
public class CambiaMeseCalendario extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public CambiaMeseCalendario() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet( HttpServletRequest request, HttpServletResponse response ) throws ServletException, IOException {

		LocalDate data = Calendario.toDate( request.getParameter( "data" ) );
		int sommaGiorni = Integer.valueOf( request.getParameter( "sommaGiorni" ) );
		int nGiorniVisualizzati = Math.abs( sommaGiorni );

		request.setAttribute( "data", Calendario.formatData( data.plusDays( sommaGiorni ) ) );
		request.setAttribute( "nGiorniVisualizzati", nGiorniVisualizzati );
		request.getRequestDispatcher( "calendario.jsp" ).forward( request, response );
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost( HttpServletRequest request, HttpServletResponse response ) throws ServletException, IOException {
		doGet( request, response );
	}

}
