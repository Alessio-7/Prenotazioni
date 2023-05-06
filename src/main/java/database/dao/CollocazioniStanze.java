package database.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;

import database.Connessione;
import database.object.Stanza;

public class CollocazioniStanze extends Connessione {

	public static LinkedHashMap<String, ArrayList<String>> getGruppiStanze() {
		LinkedHashMap<String, ArrayList<String>> ritorno = new LinkedHashMap<>();
		try {

			ResultSet gruppi = eseguiSelect( "SELECT GruppiStanze.nomeGruppo FROM GruppiStanze" );
			while ( gruppi.next() ) {
				ritorno.put( gruppi.getString( 1 ), new ArrayList<String>() );
			}
			gruppi.close();

			ResultSet table = eseguiSelect(
					"SELECT nomeGruppo,nomeStanza FROM (Stanze LEFT JOIN CollocazioniStanze on Stanze.idstanza=CollocazioniStanze.idStanza LEFT JOIN GruppiStanze on GruppiStanze.idgruppo = CollocazioniStanze.idGruppo)" );
			while ( table.next() ) {

				ritorno.get( table.getString( 1 ) ).add( table.getString( 2 ) );
			}
			table.close();
			getConn().close();
		} catch ( SQLException e ) {
			e.printStackTrace();
		}
		return ritorno;
	}

	public static LinkedHashMap<Integer, ArrayList<Integer>> getIDGruppiStanze() {
		LinkedHashMap<Integer, ArrayList<Integer>> ritorno = new LinkedHashMap<>();
		try {

			ResultSet gruppi = eseguiSelect( "SELECT GruppiStanze.idGruppo FROM GruppiStanze" );
			while ( gruppi.next() ) {
				ritorno.put( gruppi.getInt( 1 ), new ArrayList<Integer>() );
			}
			gruppi.close();

			ResultSet table = eseguiSelect( "SELECT idGruppo, idStanza FROM CollocazioniStanze" );
			while ( table.next() ) {

				ritorno.get( table.getInt( 1 ) ).add( table.getInt( 2 ) );
			}
			table.close();
			getConn().close();
		} catch ( SQLException e ) {
			e.printStackTrace();
		}
		return ritorno;
	}

	public static ArrayList<Stanza> getStanze() {
		ArrayList<Stanza> ritorno = new ArrayList<>();
		try {
			ResultSet table = eseguiSelect(
					"SELECT nomeGruppo, nomeStanza FROM (Stanze LEFT JOIN CollocazioniStanze on CollocazioniStanze.idStanza = Stanze.idStanza LEFT JOIN GruppiStanze on GruppiStanze.idGruppo = CollocazioniStanze.idGruppo) ORDER BY nomeGruppo;" );
			while ( table.next() ) {
				Stanza stanza = new Stanza();
				stanza.setGruppoStanze( table.getString( "nomeGruppo" ) );
				stanza.setStanza( table.getString( "nomeStanza" ) );
				ritorno.add( stanza );
			}
			table.close();
			getConn().close();
		} catch ( SQLException e ) {
			e.printStackTrace();
		}
		return ritorno;
	}

	public static int getNumeroStanze() {
		int ritorno = 0;
		try {
			ResultSet res = eseguiSelect( "SELECT count(nomeStanza) FROM Stanze" );
			res.next();
			ritorno = res.getInt( 1 );
			res.close();
		} catch ( SQLException e ) {
			e.printStackTrace();
		}
		return ritorno;
	}

	public static String getLastIDStanza() {
		int ritorno = 0;
		try {
			ResultSet res = eseguiSelect( "SELECT max(idStanza) FROM Stanze" );
			res.next();
			ritorno = res.getInt( 1 );
			res.close();
		} catch ( SQLException e ) {
			e.printStackTrace();
		}
		return ritorno
				+ "";
	}

	public static String getLastIDGruppoStanze() {
		int ritorno = 0;
		try {
			ResultSet res = eseguiSelect( "SELECT max(idGruppo) FROM GruppiStanze" );
			res.next();
			ritorno = res.getInt( 1 );
			res.close();
		} catch ( SQLException e ) {
			e.printStackTrace();
		}
		return ritorno
				+ "";
	}

	public static int getIDGruppoStanza( String idStanza ) {
		int ritorno = 0;
		try {
			ResultSet res = eseguiSelect( "SELECT idGruppo FROM CollocazioniStanze WHERE idStanza = "
					+ idStanza );
			res.next();
			ritorno = res.getInt( 1 );
			res.close();
		} catch ( SQLException e ) {
			e.printStackTrace();
		}
		return ritorno;
	}

}
