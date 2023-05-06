package database.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import database.Connessione;
import database.object.Anagrafica;

public class Anagrafiche extends Connessione {

	public static Anagrafica getAnagrafica( int id ) {
		Anagrafica ritorno = null;
		try {
			ResultSet rit = eseguiSelect( "Select * from Anagrafica where idAnag="
					+ id );
			while ( rit.next() ) {
				Anagrafica anag = new Anagrafica();

				anag.setIdAnagrafica( rit.getInt( "idAnag" ) );
				anag.setNome( rit.getString( "nome" ) );
				anag.setCognome( rit.getString( "cognome" ) );
				anag.setTelefono( rit.getString( "telefono" ) );

				ritorno = anag;
			}

			rit.close();
			getConn().close();
		} catch ( SQLException e ) {
			e.printStackTrace();
		}
		return ritorno;
	}

	public static ArrayList<Anagrafica> getAnagrafiche() {
		ArrayList<Anagrafica> ritorno = new ArrayList<>();
		try {
			ResultSet rit = eseguiSelect( "Select * from Anagrafica" );
			while ( rit.next() ) {
				Anagrafica anag = new Anagrafica();

				anag.setIdAnagrafica( rit.getInt( "idAnag" ) );
				anag.setNome( rit.getString( "nome" ) );
				anag.setCognome( rit.getString( "cognome" ) );
				anag.setTelefono( rit.getString( "telefono" ) );

				ritorno.add( anag );
			}

			rit.close();
			getConn().close();
		} catch ( SQLException e ) {
			e.printStackTrace();
		}
		return ritorno;
	}
}
