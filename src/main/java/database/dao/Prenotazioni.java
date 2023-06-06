package database.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;

import database.Connessione;
import database.object.Prenotazione;

public class Prenotazioni extends Connessione {

	private static final String TUTTE_LE_PRENOTAZIONI = "SELECT idPrenotazione, rel.idGruppo, nomeGruppo, prenotazione.idStanza, nomeStanza, idAnagrafica, numeroOspiti, dataArrivo, dataPartenza, ricavo, note\r\n"
			+ "FROM ( \r\n"
			+ "	Prenotazioni as prenotazione \r\n"
			+ "	LEFT JOIN Stanze as stanza \r\n"
			+ "		ON stanza.idStanza=prenotazione.idStanza\r\n"
			+ "	LEFT JOIN CollocazioniStanze as rel \r\n"
			+ "		ON stanza.idstanza=rel.idStanza \r\n"
			+ "	LEFT JOIN GruppiStanze as piano\r\n"
			+ "		ON piano.idgruppo= rel.idGruppo\r\n"
			+ ")ORDER BY idPrenotazione DESC;";

	private static ArrayList<Prenotazione> getPrenotazioni(String select) {
		//System.out.println( select );
		// iniziaTimer();
		ArrayList<Prenotazione> ritorno = new ArrayList<>();
		try {
			ResultSet rit = eseguiSelect(select);
			while (rit.next()) {				
				Prenotazione prenotazione = new Prenotazione();

				prenotazione.setIdPrenotazione(rit.getInt("idPrenotazione"));
				prenotazione.setIdGruppo(rit.getInt("idGruppo"));
				prenotazione.setGruppoStanze(rit.getString("nomeGruppo"));
				prenotazione.setIdStanza(rit.getInt("idStanza"));
				prenotazione.setStanza(rit.getString("nomeStanza"));
				prenotazione.setAnagrafica(Anagrafiche.getAnagrafica(rit.getInt("idAnagrafica")));
				prenotazione.setnOspiti(rit.getInt("numeroOspiti"));
				prenotazione.setArrivo(rit.getString("dataArrivo"));
				prenotazione.setPartenza(rit.getString("dataPartenza"));
				prenotazione.setRicavo(rit.getFloat("ricavo"));
				prenotazione.setNote(rit.getString("note"));

				ritorno.add(prenotazione);
			}

			rit.close();
			getConn().close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		// finisciTimer();
		return ritorno;
	}

	public static ArrayList<Prenotazione> getPrenotazioni() {
		return getPrenotazioni(TUTTE_LE_PRENOTAZIONI);
	}

	public static ArrayList<Prenotazione> getPrenotazioniIdAnagrafica(String idAnagrafica) {
		return getPrenotazioni(
				"SELECT idPrenotazione, rel.idGruppo, nomeGruppo, prenotazione.idStanza, nomeStanza, idAnagrafica, numeroOspiti, dataArrivo, dataPartenza\r\n"
						+ "\r\n" + "FROM ( \r\n" + "\r\n" + "	Prenotazioni as prenotazione \r\n" + "\r\n"
						+ "	LEFT JOIN Stanze as stanza \r\n" + "\r\n"
						+ "		ON stanza.idStanza=prenotazione.idStanza\r\n" + "\r\n"
						+ "	LEFT JOIN CollocazioniStanze as rel \r\n" + "\r\n"
						+ "		ON stanza.idstanza=rel.idStanza \r\n" + "\r\n" + "	LEFT JOIN GruppiStanze as piano\r\n"
						+ "\r\n" + "		ON piano.idgruppo= rel.idGruppo\r\n" + "\r\n" + ")WHERE idAnagrafica="
						+ idAnagrafica);
	}

	public static int getNprenotazioniIdAnagrafica(String idAnagrafica) {
		int ritorno = 0;
		try {
			ResultSet res = eseguiSelect(
					"SELECT count(idAnagrafica) FROM Prenotazioni WHERE idAnagrafica=" + idAnagrafica);
			res.next();
			ritorno = res.getInt(1);
			res.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return ritorno;
	}

	public static boolean prenotazioneDellaStanza(Prenotazione prenotazione, String gruppoStanze, String stanza) {
		return prenotazione.getGruppoStanze().equals(gruppoStanze) && prenotazione.getStanza().equals(stanza);
	}

	public static boolean prenotazioniDellaStessaStanza(Prenotazione p1, Prenotazione p2) {
		return prenotazioneDellaStanza(p1, p2.getGruppoStanze(), p2.getStanza());
	}

	public static Prenotazione valida(Prenotazione p) {
		ArrayList<Prenotazione> prenotazioni = getPrenotazioni(
				"SELECT idPrenotazione, rel.idGruppo, nomeGruppo, prenotazione.idStanza, nomeStanza, idAnagrafica, numeroOspiti, dataArrivo, dataPartenza, ricavo, note\r\n"
						+ "FROM (\r\n" + "Prenotazioni as prenotazione \r\n" + "LEFT JOIN Stanze as stanza \r\n"
						+ "	ON stanza.idStanza=prenotazione.idStanza \r\n" + "LEFT JOIN CollocazioniStanze as rel \r\n"
						+ "	ON stanza.idstanza=rel.idStanza \r\n" + "LEFT JOIN GruppiStanze as piano \r\n"
						+ "	ON piano.idgruppo= rel.idGruppo\r\n" + ")\r\n" + "WHERE rel.idGruppo = " + p.getIdGruppo()
						+ " AND prenotazione.idStanza = " + p.getIdStanza());

		Iterator<Prenotazione> i = prenotazioni.iterator();
		while (i.hasNext()) {
			Prenotazione controllo = i.next();

			if (p.getIdPrenotazione() == controllo.getIdPrenotazione()) {
				continue;
			}

			boolean condizione1 = controllo.dataCompresa(p.getArrivo())
					|| controllo.dataCompresa(p.getPartenza().minusDays(1)); // se l'intervallo
																				// della p. da
			// validare è compreso
			// nell'intervallo di controllo
			boolean condizione2 = controllo.getArrivo().isAfter(p.getArrivo())
					&& p.getPartenza().isAfter(controllo.getPartenza()); // se l'intervallo
			// della p. da
			// validare
			// comprende
			// l'intervallo di
			// controllo
			if (condizione1 || condizione2) {
				return controllo;
			}
		}

		return null;
	}
}
