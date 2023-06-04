package database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class Connessione {

	static public Connection getConn() {
		Connection conn = null;
		try {
			Class.forName( "org.sqlite.JDBC" );
			//conn = DriverManager.getConnection( "jdbc:sqlite:F:\\Computer\\Documenti\\java-workspace\\prenotazioni\\database\\prenotazioni.db" );
			conn = DriverManager.getConnection( "jdbc:sqlite:C:\\Users\\Silvia\\eclipse-workspace\\prenotazioni\\database\\prenotazioni.db" );
		} catch ( SQLException | ClassNotFoundException e ) {
			e.printStackTrace();
		}

		return conn;
	}

	/*
	 * public void setConn( Connection conn ) { this.conn = conn; }
	 */

	protected static ResultSet eseguiSelect( String query ) {
		Statement stat;
		try {
			stat = getConn().createStatement();
			return stat.executeQuery( query );
		} catch ( SQLException e ) {
			e.printStackTrace();
		}
		return null;
	}

	public static void eseguiUpdate( String query ) {
		Statement stat;
		try {
			stat = getConn().createStatement();
			stat.executeUpdate( query );
		} catch ( SQLException e ) {
			e.printStackTrace();
		}
	}

	public static void eseguiInsert( String query ) {
		Statement stat;
		try {
			stat = getConn().createStatement();
			stat.executeUpdate( query );
			stat.close();
		} catch ( SQLException e ) {
			e.printStackTrace();
		}
	}
}
