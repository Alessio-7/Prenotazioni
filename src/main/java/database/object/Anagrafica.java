package database.object;

import java.io.Serializable;

public class Anagrafica implements Serializable {

	Integer idAnagrafica;
	String nome;
	String cognome;
	String telefono;

	public String getInfoAnagrafica() {
		return cognome
				+ " "
				+ nome
				+ "\n"
				+ "Telefono: "
				+ telefono;
	}

	public String getInfoAnagraficaHTML() {
		return cognome
				+ " "
				+ nome
				+ "<br>"
				+ "Telefono: "
				+ telefono;
	}

	public Integer getIdAnagrafica() {
		return idAnagrafica;
	}

	public void setIdAnagrafica( Integer idAnagrafica ) {
		this.idAnagrafica = idAnagrafica;
	}

	public String getNome() {
		return nome;
	}

	public void setNome( String nome ) {
		this.nome = nome;
	}

	public String getCognome() {
		return cognome;
	}

	public void setCognome( String cognome ) {
		this.cognome = cognome;
	}

	public String getTelefono() {
		return telefono;
	}

	public void setTelefono( String telefono ) {
		this.telefono = telefono;
	}

}
