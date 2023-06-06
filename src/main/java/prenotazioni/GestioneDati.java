package prenotazioni;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Map.Entry;

import database.Connessione;
import database.dao.Anagrafiche;
import database.dao.CollocazioniStanze;
import database.dao.Prenotazioni;
import database.object.Anagrafica;
import database.object.Prenotazione;

public class GestioneDati {

	private static void validaPrenotazione( String idPrenotazione, String idStanza, String idAnagrafica, String numeroOspiti, String dataArrivo,
			String dataPartenza ) throws DatiException {

		String erroriCampi = "";

		if ( idStanza.contains( "a" ) ) {
			erroriCampi += "Stanza<br>";
		}
		if ( numeroOspiti.isEmpty() ) {
			erroriCampi += "Numero ospiti<br>";
		}
		if ( dataArrivo.isEmpty() ) {
			erroriCampi += "Data arrivo<br>";
		}
		if ( dataPartenza.isEmpty() ) {
			erroriCampi += "Data partenza<br>";
		}

		if ( !erroriCampi.isEmpty() ) {
			throw new DatiException( "I seguenti campi non possono essere vuoti:<br>"
					+ erroriCampi );
		}

		Prenotazione p = new Prenotazione();
		p.setIdPrenotazione( Integer.valueOf( idPrenotazione ) );
		p.setIdGruppo( CollocazioniStanze.getIDGruppoStanza( idStanza ) );
		p.setIdStanza( Integer.parseInt( idStanza ) );
		p.setArrivo( dataArrivo );
		p.setPartenza( dataPartenza );

		if ( p.getArrivo().isAfter( p.getPartenza() ) ) {
			throw new DatiException( "La data di arrivo deve precedere quella di partenza" );
		}

		Prenotazione stessoGiorno = Prenotazioni.valida( p );

		if ( stessoGiorno != null ) {
			throw new DatiException( "Prenotazione di "
					+ stessoGiorno.getAnagrafica().getCognome()
					+ " "
					+ stessoGiorno.getAnagrafica().getNome()
					+ " � stata gi� assegnata alla camera "
					+ stessoGiorno.getStanza()
					+ ", dal giorno "
					+ Calendario.formatData( stessoGiorno.getArrivo() )
					+ " al giorno "
					+ Calendario.formatData( stessoGiorno.getPartenza() ) );
		}

	}

	public static void aggiungiPrenotazione( String idStanza, String idAnagrafica, String numeroOspiti, String dataArrivo, String dataPartenza, float ricavo, String note )
			throws DatiException {

		validaPrenotazione( "-1", idStanza, idAnagrafica, numeroOspiti, dataArrivo, dataPartenza );

		Connessione.eseguiInsert( "INSERT INTO Prenotazioni (idStanza, idAnagrafica, numeroOspiti, dataArrivo, dataPartenza, ricavo, note) VALUES ("
				+ idStanza
				+ ", "
				+ idAnagrafica
				+ ","
				+ numeroOspiti
				+ ", \""
				+ dataArrivo
				+ "\", \""
				+ dataPartenza
				+ "\", \""
				+ ricavo
				+ "\", \""
				+ note
				+ "\")" );
	}

	public static void modificaPrenotazione( String id, String idStanza, String idAnagrafica, String numeroOspiti, String dataArrivo, String dataPartenza, float ricavo, String note )
			throws DatiException {

		validaPrenotazione( id, idStanza, idAnagrafica, numeroOspiti, dataArrivo, dataPartenza );

		Connessione.eseguiUpdate( "UPDATE Prenotazioni SET idStanza = "
				+ idStanza
				+ ", idAnagrafica = "
				+ idAnagrafica
				+ ", numeroOspiti = "
				+ numeroOspiti
				+ ", dataArrivo = \""
				+ dataArrivo
				+ "\", dataPartenza = \""
				+ dataPartenza
				+ "\", ricavo = \""
				+ ricavo
				+ "\", note = \""
				+ note
				+ "\" WHERE idPrenotazione ="
				+ id );

	}

	public static void eliminaPrenotazione( String id ) {
		Connessione.eseguiUpdate( "DELETE FROM Prenotazioni WHERE idPrenotazione="
				+ id );
	}

	public static void aggiungiAnagrafica( String nome, String cognome, String telefono ) {
		Connessione.eseguiInsert( "INSERT INTO Anagrafica (nome, cognome, telefono) VALUES (\""
				+ nome
				+ "\", \""
				+ cognome
				+ "\", \""
				+ telefono
				+ "\")" );

	}

	public static void modificaAnagrafica( String id, String nome, String cognome, String telefono ) {
		Connessione.eseguiUpdate( "UPDATE Anagrafica SET nome = \""
				+ nome
				+ "\", cognome = \""
				+ cognome
				+ "\", telefono = \""
				+ telefono
				+ "\" WHERE idAnag ="
				+ id );
	}

	public static void eliminaAnagrafica( String id ) {
		Connessione.eseguiUpdate( "DELETE FROM Anagrafica WHERE idAnag="
				+ id );
	}

	public static void aggiungiCollocazioneStanzeLastIDs() {
		aggiungiCollocazioneStanzeLastID( CollocazioniStanze.getLastIDGruppoStanze() );

	}

	public static void aggiungiCollocazioneStanzeLastID( String idGruppo ) {
		aggiungiCollocazioneStanze( CollocazioniStanze.getLastIDStanza(), idGruppo );

	}

	public static void aggiungiCollocazioneStanze( String idStanza, String idGruppo ) {
		Connessione.eseguiInsert( "INSERT INTO CollocazioniStanze (idStanza, idGruppo) VALUES ("
				+ idStanza
				+ ", "
				+ idGruppo
				+ ")" );

	}

	public static void aggiungiGruppoStanze( String nomeGruppo ) {
		Connessione.eseguiInsert( "INSERT INTO GruppiStanze (nomeGruppo) VALUES (\""
				+ nomeGruppo
				+ "\")" );

	}

	public static void aggiungiStanza( String nomeStanza ) {
		Connessione.eseguiInsert( "INSERT INTO Stanze (nomeStanza) VALUES (\""
				+ nomeStanza
				+ "\")" );

	}

	public static String generaListsAnagrafiche() {
		String lAnagrafiche = "var lAnagrafiche = [";
		String lIDanagrafiche = "var lIDanagrafiche = [";

		ArrayList<Anagrafica> anagrafiche = Anagrafiche.getAnagrafiche();

		int i = 0;
		for ( Anagrafica anagrafica : anagrafiche ) {
			i++ ;

			lAnagrafiche += "\""
					+ anagrafica.getCognome()
					+ " "
					+ anagrafica.getNome()
					+ "\"";

			lIDanagrafiche += "\""
					+ anagrafica.getIdAnagrafica()
					+ "\"";

			if ( i != anagrafiche.size() ) {
				lAnagrafiche += ",";
				lIDanagrafiche += ",";
			}
		}

		lAnagrafiche += "];\n";
		lIDanagrafiche += "];\n";

		return lAnagrafiche + lIDanagrafiche;
	}

	public static String generaObjectGruppiStanze() {
		String ritorno = "var oGruppiStanze = {\r\n";

		LinkedHashMap<String, ArrayList<String>> gruppiStanze = CollocazioniStanze.getGruppiStanze();

		int i = 0;
		for ( Map.Entry<String, ArrayList<String>> e : gruppiStanze.entrySet() ) {
			i++ ;

			ritorno += "\t\""
					+ e.getKey()
					+ "\":[";
			for ( String stanza : e.getValue() ) {
				ritorno += "\""
						+ stanza
						+ "\", ";
			}

			ritorno = ritorno.substring( 0, ritorno.length() - 2 );

			ritorno += "]";
			if ( i != gruppiStanze.size() ) {
				ritorno += ",";
			}
			ritorno += "\r\n";
		}

		ritorno += "}\n\n";
		ritorno += "var oIDGruppiStanze = {\r\n";

		LinkedHashMap<Integer, ArrayList<Integer>> IDgruppiStanze = CollocazioniStanze.getIDGruppiStanze();

		i = 0;
		for ( Entry<Integer, ArrayList<Integer>> e : IDgruppiStanze.entrySet() ) {
			i++ ;

			ritorno += "\t\""
					+ e.getKey()
					+ "\":[";
			for ( Integer stanza : e.getValue() ) {
				ritorno += "\""
						+ stanza
						+ "\", ";
			}

			ritorno = ritorno.substring( 0, ritorno.length() - 2 );

			ritorno += "]";
			if ( i != IDgruppiStanze.size() ) {
				ritorno += ",";
			}
			ritorno += "\r\n";
		}

		ritorno += "}";

		return ritorno;
	}
}