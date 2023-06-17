package database.object;

import java.io.Serializable;
import java.text.DecimalFormat;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

import prenotazioni.Calendario;

public class Prenotazione implements Serializable {

	private static final long serialVersionUID = 1L;

	public static final String PUNTO = "<i class=\"bi bi-dot\"></i>";
	public static final String CROCE = "<i class=\"bi bi-x\"></i>";
	public static final String ARRIVO = "A";
	public static final String PARTENZA = "P";
	public static final String PARTENZA_ARRIVO = "PA";
	public static final String ARRIVO_PARTENZA = "AP";

	private Integer idPrenotazione;
	private Integer idGruppo;
	private String gruppoStanze;
	private Integer idStanza;
	private String stanza;
	private Anagrafica anagrafica;
	private int nOspiti;
	private LocalDate arrivo;
	private LocalDate partenza;
	private float ricavo;
	private String note;

	private static final DecimalFormat twoPlaces = new DecimalFormat( "0.00" );

	public String dataCompresaSimbolo( LocalDate data ) {

		if ( arrivo.equals( partenza ) && data.equals( arrivo ) ) {
			return ARRIVO_PARTENZA;
		}

		if ( data.equals( arrivo ) ) {
			return ARRIVO;
		}

		if ( data.equals( partenza ) ) {
			return PARTENZA;
		}

		if ( arrivo.compareTo( data ) * partenza.compareTo( data ) < 0 ) {
			return PUNTO;
		}
		return "";
	}

	public boolean dataCompresa( LocalDate data ) {
		return arrivo.compareTo( data ) * partenza.compareTo( data ) <= 0;
	}

	public long giorniDopoArrivo( LocalDate data ) {
		return ChronoUnit.DAYS.between( arrivo, data ) + 1l;

	}

	public String getGruppoStanze() {
		return gruppoStanze;
	}

	public void setGruppoStanze( String gruppoStanze ) {
		this.gruppoStanze = gruppoStanze;
	}

	public String getStanza() {
		return stanza;
	}

	public void setStanza( String stanza ) {
		this.stanza = stanza;
	}

	public String getInfoAnagrafica() {
		return anagrafica.getInfoAnagrafica();
	}

	public String getInfoAnagraficaHTML() {
		return anagrafica.getInfoAnagraficaHTML();
	}

	public Anagrafica getAnagrafica() {
		return anagrafica;
	}

	public void setAnagrafica( Anagrafica anagrafica ) {
		this.anagrafica = anagrafica;
	}

	public int getnOspiti() {
		return nOspiti;
	}

	public void setnOspiti( int nOspiti ) {
		this.nOspiti = nOspiti;
	}

	public LocalDate getArrivo() {
		return arrivo;
	}

	public void setArrivo( String arrivo ) {
		this.arrivo = Calendario.toDate( arrivo );
	}

	public LocalDate getPartenza() {
		return partenza;
	}

	public void setPartenza( String partenza ) {
		this.partenza = Calendario.toDate( partenza );
	}

	public Integer getIdPrenotazione() {
		return idPrenotazione;
	}

	public void setIdPrenotazione( Integer idPrenotazione ) {
		this.idPrenotazione = idPrenotazione;
	}

	public String getArrivoF() {
		return arrivo.getYear()
				+ "-"
				+ ( arrivo.getMonthValue() < 10 ? "0"
						+ arrivo.getMonthValue() : arrivo.getMonthValue() )
				+ "-"
				+ ( arrivo.getDayOfMonth() < 10 ? "0"
						+ arrivo.getDayOfMonth() : arrivo.getDayOfMonth() );
	}

	public String getPartenzaF() {
		return partenza.getYear()
				+ "-"
				+ ( partenza.getMonthValue() < 10 ? "0"
						+ partenza.getMonthValue() : partenza.getMonthValue() )
				+ "-"
				+ ( partenza.getDayOfMonth() < 10 ? "0"
						+ partenza.getDayOfMonth() : partenza.getDayOfMonth() );
	}

	public Integer getIdGruppo() {
		return idGruppo;
	}

	public void setIdGruppo( Integer idGruppo ) {
		this.idGruppo = idGruppo;
	}

	public Integer getIdStanza() {
		return idStanza;
	}

	public void setIdStanza( Integer idStanza ) {
		this.idStanza = idStanza;
	}

	public float getRicavo() {
		return ricavo;
	}

	public String getSRicavo() {
		return "&euro; "
				+ twoPlaces.format( ricavo );
	}

	public static String formatSoldi( float soldi ) {
		return "&euro; "
				+ twoPlaces.format( soldi );
	}

	public void setRicavo( float ricavo ) {
		this.ricavo = ricavo;
	}

	public String getNote() {
		return note;
	}

	public void setNote( String note ) {
		this.note = note.replaceAll( "\n", " " );
	}
}
