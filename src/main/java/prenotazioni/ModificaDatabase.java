package prenotazioni;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import database.dao.CollocazioniStanze;
import database.dao.Prenotazioni;
import database.object.Prenotazione;

/**
 * Servlet implementation class ModificaDatabase
 */
@WebServlet( "/gestioneDati/ModificaDatabase" )
public class ModificaDatabase extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public ModificaDatabase() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet( HttpServletRequest request, HttpServletResponse response ) throws ServletException, IOException {

		if ( false ) {
			System.out.println( "parametri:\n" );
			for ( Map.Entry<String, String[]> e : request.getParameterMap().entrySet() ) {
				System.out.println( e.getKey() );
				for ( String s : e.getValue() ) {
					System.out.println( "\t"
							+ s );
				}
			}
			System.out.println( "\n\nattributi:\n" );
			Iterator<String> it = request.getAttributeNames().asIterator();
			while ( it.hasNext() ) {
				String s = it.next();
				System.out.println( s
						+ ": "
						+ request.getAttribute( s ) );
			}
		}

		String azione = request.getParameter( "azione" );

		if ( azione == null ) {
			azione = request.getParameter( "azione2" );
			if ( azione == null ) {
				azione = request.getParameter( "azione3" );
			}
		}

		String tabella = request.getParameter( "tabella" );

		if ( tabella == null ) {
			tabella = request.getParameter( "tabella2" );
			if ( tabella == null ) {
				tabella = request.getParameter( "tabella3" );
			}
		}

		String errore = ""; // scritta di errore da rimandare alla pagina di gestione dati

		if ( azione.equals( "aggiungi" ) ) {
			switch ( tabella ) {
				case "prenotazioni": {

					try {
						if ( request.getParameter( "tipoPrenotazione" ).equals( "singola" ) ) {
							GestioneDati.aggiungiPrenotazione( request.getParameter( "stanza" ), request.getParameter( "anagrafica" ),
									request.getParameter( "numeroOspiti" ), formatData( request.getParameter( "dataArrivo" ) ),
									formatData( request.getParameter( "dataPartenza" ) ) );
						} else {
							for ( String stanza : request.getParameterMap().get( "multiStanze" ) ) {
								// TODO per ogni stanza apre il database, fa l'insert e poi lo richiude fare che
								// lo apre una sola volta, fa tutte le insert e poi lo chiude
								GestioneDati.aggiungiPrenotazione( stanza, request.getParameter( "anagrafica1" ), request.getParameter( "numeroOspiti1" ),
										formatData( request.getParameter( "dataArrivo" ) ), formatData( request.getParameter( "dataPartenza" ) ) );
							}
						}
					} catch ( DatiException e ) {
						errore = e.getMessage();
					}

					break;
				}
				case "anagrafiche": {
					GestioneDati.aggiungiAnagrafica( request.getParameter( "nome" ), request.getParameter( "cognome" ),
							request.getParameter( "numeroDiTelefono" ) );
					break;
				}
				case "gruppiStanze": {
					GestioneDati.aggiungiGruppoStanze( request.getParameter( "gruppoStanze" ) );
					String[] stanze = request.getParameter( "stanze" ).split( "\r\n" );
					for ( String s : stanze ) {
						GestioneDati.aggiungiStanza( s.replace( "\n", "" ) );
						GestioneDati.aggiungiCollocazioneStanzeLastIDs();
					}
					break;
				}
				case "stanze": {
					GestioneDati.aggiungiStanza( request.getParameter( "stanza" ) );
					GestioneDati.aggiungiCollocazioneStanzeLastID( request.getParameter( "gruppoStanze" ) );
					break;
				}
				default: {
					System.out.println( "nse capito che devi fa" );
				}
			}
		} else if ( azione.equals( "modifica" ) ) {

			switch ( tabella ) {
				case "prenotazioni": {

					try {
						GestioneDati.modificaPrenotazione( request.getParameter( "idDato" ), request.getParameter( "stanza" ),
								request.getParameter( "anagrafica" ), request.getParameter( "numeroOspiti" ),
								formatData( request.getParameter( "dataArrivo" ) ), formatData( request.getParameter( "dataPartenza" ) ) );
					} catch ( DatiException e ) {
						errore = e.getMessage();

						request.setAttribute( "idDato", request.getParameter( "idDato" ) );
						request.setAttribute( "gruppoStanze", CollocazioniStanze.getIDGruppoStanza( request.getParameter( "stanza" ) ) );
						request.setAttribute( "stanza", request.getParameter( "stanza" ) );
						request.setAttribute( "anagrafica", request.getParameter( "anagrafica" ) );
						request.setAttribute( "numeroOspiti", request.getParameter( "numeroOspiti" ) );
						request.setAttribute( "dataArrivo", request.getParameter( "dataArrivo" ) );
						request.setAttribute( "dataPartenza", request.getParameter( "dataPartenza" ) );
					}

					break;
				}
				case "anagrafiche": {
					GestioneDati.modificaAnagrafica( request.getParameter( "idDato" ), request.getParameter( "modificaNome" ),
							request.getParameter( "modificaCognome" ), request.getParameter( "modificaNumeroDiTelefono" ) );
					break;
				}
				default: {
					System.out.println( "nse capito che devi fa" );
				}
			}

		} else {

			switch ( tabella ) {
				case "prenotazioni": {
					GestioneDati.eliminaPrenotazione( request.getParameter( "idEliminazione" ) );
					break;
				}
				case "anagrafiche": {
					ArrayList<Prenotazione> prenotazioni = Prenotazioni.getPrenotazioniIdAnagrafica( request.getParameter( "idEliminazione" ) );
					for ( Prenotazione p : prenotazioni ) {
						GestioneDati.eliminaPrenotazione( ""
								+ p.getIdPrenotazione() );
					}
					GestioneDati.eliminaAnagrafica( request.getParameter( "idEliminazione" ) );
					break;
				}
				default: {
					System.out.println( "nse capito che devi fa" );
				}
			}
		}
		if ( !errore.isEmpty() ) {
			request.setAttribute( "errore", errore );
			request.setAttribute( "azione", azione );
		}

		request.getRequestDispatcher( "/gestioneDati/"
				+ tabella
				+ ".jsp" ).forward( request, response );
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost( HttpServletRequest request, HttpServletResponse response ) throws ServletException, IOException {
		doGet( request, response );
	}

	private String formatData( String data ) {
		String[] d = data.split( "-" );
		if ( d.length == 1 ) {
			return "";
		}
		return d[2]
				+ "/"
				+ d[1]
				+ "/"
				+ d[0];
	}

}
