package prenotazioni;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class Login
 */
@WebServlet( { "/Login" } )
public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Login() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet( HttpServletRequest request, HttpServletResponse response ) throws ServletException, IOException {
		String username = request.getParameter( "inputUserName" );
		String password = request.getParameter( "inputPassword" );
		String ricordaCredenziali = request.getParameter( "inputRicordaCredenziali" );

		if ( username.equals( "hackersgen" ) && password.equals( "sorint" ) ) {
			response.sendRedirect( "./calendario.jsp" );
		} else {
			response.sendRedirect( "./index.jsp?erroreCredenziali=true" );
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost( HttpServletRequest request, HttpServletResponse response ) throws ServletException, IOException {
		doGet( request, response );
	}

}
