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
		String visualizzazione = request.getParameter( "visualizzazione" );
		int direzione = Integer.valueOf( request.getParameter( "direzione" ) );

		switch ( visualizzazione ) {
			case "settimana":
				data = data.plusWeeks( direzione );
				break;
			case "mese":
				if ( direzione == 1 ) {
					data = data.plusDays( 32 );
				}
				if ( direzione == -1 ) {
					data = data.plusDays( -2 );
				} else {
					break;
				}

				data = LocalDate.of( data.getYear(), data.getMonthValue(), 1 );
				break;
		}

		request.setAttribute( "data", Calendario.formatData( data ) );
		request.setAttribute( "visualizzazione", visualizzazione );
		request.setAttribute( "sideBarCollapsed", request.getParameter( "sideBarCollapsed" ) );
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
