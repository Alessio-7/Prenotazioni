package database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class Connessione {

	private static Statement stat;

	static public Connection getConn() {
		Connection conn = null;
		try {
			Class.forName( "org.sqlite.JDBC" );
			conn = DriverManager.getConnection( "jdbc:sqlite:F:\\Computer\\Documenti\\java-workspace\\prenotazioni\\database\\prenotazioni.db" );
			// conn = DriverManager.getConnection(
			// "jdbc:sqlite:C:\\Users\\Silvia\\eclipse-workspace\\prenotazioni\\database\\prenotazioni.db"
			// );
		} catch ( SQLException | ClassNotFoundException e ) {
			e.printStackTrace();
		}

		return conn;
	}

	/*
	 * public void setConn( Connection conn ) { this.conn = conn; }
	 */

	protected static ResultSet eseguiSelect( String query ) {
		return eseguiSelect( query, true );
	}

	protected static ResultSet eseguiSelect( String query, boolean connessioneAutomatica ) {
		try {

			if ( connessioneAutomatica )
				apriConnessione();
			ResultSet ret = stat.executeQuery( query );
			return ret;
		} catch ( SQLException e ) {
			e.printStackTrace();
		}
		return null;
	}

	public static void eseguiUpdate( String query ) {
		eseguiUpdate( query, true );
	}

	public static void eseguiUpdate( String query, boolean connessioneAutomatica ) {
		try {
			if ( connessioneAutomatica )
				apriConnessione();
			stat.executeUpdate( query );
			if ( connessioneAutomatica )
				chiudiConnessione();
		} catch ( SQLException e ) {
			e.printStackTrace();
		}
	}

	public static void eseguiInsert( String query ) {
		eseguiInsert( query, true );
	}

	public static void eseguiInsert( String query, boolean connessioneAutomatica ) {
		try {
			if ( connessioneAutomatica )
				apriConnessione();
			stat.executeUpdate( query );
			if ( connessioneAutomatica )
				chiudiConnessione();
		} catch ( SQLException e ) {
			e.printStackTrace();
		}
	}

	public static void apriConnessione() throws SQLException {
		stat = getConn().createStatement();
	}

	public static void chiudiConnessione() throws SQLException {
		stat.close();
	}
}
