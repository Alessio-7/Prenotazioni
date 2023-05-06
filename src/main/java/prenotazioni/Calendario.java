package prenotazioni;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;

import database.dao.CollocazioniStanze;
import database.dao.Prenotazioni;
import database.object.Prenotazione;

public class Calendario {

	private LocalDate dataInizio;
	private LocalDate dataFine;

	private long nGiorni;

	private HashMap<LocalDate, Integer> totaliPresenze;
	private HashMap<LocalDate, Integer> totaliOspiti;

	public Calendario( LocalDate dataInizio, LocalDate dataFine ) {
		this.dataInizio = dataInizio;
		this.dataFine = dataFine;

		this.nGiorni = ChronoUnit.DAYS.between( dataInizio, dataFine ) + 1l;
	}

	public static Calendario periodo( LocalDate dataInizio, int nGiorni ) {
		return new Calendario( dataInizio, dataInizio.plusDays( nGiorni - 1 ) );
	}

	public static Calendario periodoDaOggi( int nGiorni ) {
		LocalDate dataInizio = LocalDate.now();
		return Calendario.periodo( dataInizio, nGiorni );
	}

	public static LocalDate toDate( String data ) {
		String[] dS = data.split( "/" );
		int[] d = new int[] { Integer.parseInt( dS[0] ), Integer.parseInt( dS[1] ), Integer.parseInt( dS[2] ) };
		return LocalDate.of( d[2], d[1], d[0] );
	}

	public String getNomeMese() {
		Calendar oggi = Calendar.getInstance();
		Calendar cal = Calendar.getInstance();
		cal.set( Calendar.MONTH, dataInizio.getMonthValue() - 1 );
		String nomeMese = cal.getDisplayName( Calendar.MONTH, Calendar.SHORT, Locale.getDefault() );
		nomeMese = nomeMese.substring( 0, 1 ).toUpperCase() + nomeMese.substring( 1 ) + ( oggi.get( Calendar.YEAR ) != dataInizio.getYear() ? " "
				+ dataInizio.getYear() : "" );

		if ( dataInizio.getMonthValue() != dataFine.getMonthValue() ) {
			cal.set( Calendar.MONTH, dataFine.getMonthValue() - 1 );
			String nomeMese2 = cal.getDisplayName( Calendar.MONTH, Calendar.SHORT, Locale.getDefault() );
			nomeMese2 = nomeMese2.substring( 0, 1 ).toUpperCase() + nomeMese2.substring( 1 ) + ( oggi.get( Calendar.YEAR ) != dataFine.getYear() ? " "
					+ dataFine.getYear() : "" );

			nomeMese += "-"
					+ nomeMese2;
		}

		return nomeMese;
	}

	public static String formatData( LocalDate data ) {
		return data.format( DateTimeFormatter.ofPattern( "dd/MM/yyyy" ) );
	}

	public long getNumeroGiorni() {
		return nGiorni;
	}

	public String getGiornoSettimana( int i ) {
		String[] giorniSettimana = { "Lu", "Ma", "Me", "Gi", "Ve", "Sa", "Do" };
		String[] giorniSettimanaCorti = { "L", "M", "m", "G", "V", "S", "D" };

		LocalDate giorno = dataInizio.plusDays( i );

		int index = giorno.getDayOfWeek().getValue() - 1;

		return nGiorni < 14 ? giorniSettimana[index] : giorniSettimanaCorti[index];
	}

	private void aggiungiPresenza( LocalDate data ) {
		if ( totaliPresenze.containsKey( data ) ) {
			totaliPresenze.replace( data, Integer.valueOf( totaliPresenze.get( data ) + 1 ) );
		} else {
			totaliPresenze.put( data, 1 );
		}
	}

	private void aggiungiOspiti( LocalDate data, int nOspiti ) {
		if ( totaliOspiti.containsKey( data ) ) {
			totaliOspiti.replace( data, Integer.valueOf( totaliOspiti.get( data ) + nOspiti ) );
		} else {
			totaliOspiti.put( data, nOspiti );
		}
	}

	public int getTotalePresenze( int i ) {
		LocalDate data = dataInizio.plusDays( i );
		return totaliPresenze.containsKey( data ) ? totaliPresenze.get( data ) : 0;
	}

	public int getTotaleOspiti( int i ) {
		LocalDate data = dataInizio.plusDays( i );
		return totaliOspiti.containsKey( data ) ? totaliOspiti.get( data ) : 0;
	}

	public String getCalendarioInRangeHTML() {

		String ritorno = "<div class=\"calendario\" id=\"calendario\">";

		totaliPresenze = new HashMap<>();
		totaliOspiti = new HashMap<>();

		int y = 1;
		ArrayList<Prenotazione> prenotazioni = Prenotazioni.getPrenotazioni();

		LinkedHashMap<String, ArrayList<String>> gruppiStanze = CollocazioniStanze.getGruppiStanze();
		for ( Map.Entry<String, ArrayList<String>> e : gruppiStanze.entrySet() ) {
			String gruppoStanze = e.getKey();
			int index = new ArrayList<String>( gruppiStanze.keySet() ).indexOf( gruppoStanze );
			ritorno += "<div class=\"gruppoStanze\" style=\"grid-row-start: "
					+ y
					+ "; grid-row-end: span "
					+ e.getValue().size()
					+ "; background-color: "
					+ Calendario.Colori.colore( index )
					+ ( index == 0 ? "; border-radius: 14px 0 0 0 \">" : "\">" )
					+ gruppoStanze
					+ "</div>";
			Iterator<String> iterator = e.getValue().iterator();
			while ( iterator.hasNext() ) {
				String stanza = iterator.next();
				ritorno += "<div class=\"stanza\" style=\"grid-row-start: "
						+ y
						+ "; background-color: "
						+ Calendario.Colori.colore( index )
						+ "\">"
						+ stanza
						+ "</div>";

				int giornoFine = dataFine.getDayOfMonth();
				if ( dataFine.getMonthValue() > dataInizio.getMonthValue() || dataFine.getYear() > dataInizio.getYear() ) {
					giornoFine = dataInizio.lengthOfMonth() + dataFine.getDayOfMonth();
				}

				for ( int i = dataInizio.getDayOfMonth(); i < giornoFine + 1; i++ ) {
					LocalDate data;

					if ( i > dataInizio.lengthOfMonth() ) {
						data = LocalDate.of( dataFine.getYear(), dataFine.getMonthValue(), i - dataInizio.lengthOfMonth() );
					} else {
						data = LocalDate.of( dataInizio.getYear(), dataInizio.getMonthValue(), i );
					}

					LocalDate skipData = null;
					String simbolo = "";
					String anagrafica = "";

					for ( Prenotazione prenotazione : prenotazioni ) {

						if ( prenotazione.getArrivo().equals( skipData ) ) {
							continue;
						}

						if ( Prenotazioni.prenotazioneDellaStanza( prenotazione, gruppoStanze, stanza ) ) {
							if ( prenotazione.dataCompresa( data ) ) {
								aggiungiPresenza( data );
								aggiungiOspiti( data, prenotazione.getnOspiti() );

								simbolo = prenotazione.dataCompresaSimbolo( data );

								if ( simbolo.equals( Prenotazione.PARTENZA ) ) {
									for ( Prenotazione p : prenotazioni ) {
										if ( p.equals( prenotazione ) ) {
											continue;
										}

										if ( Prenotazioni.prenotazioniDellaStessaStanza( prenotazione, p ) ) {
											if ( p.getArrivo().equals( prenotazione.getPartenza() ) ) {
												skipData = p.getArrivo();
												simbolo = Prenotazione.PARTENZA_ARRIVO;
												anagrafica = "Partenza di:\n"
														+ prenotazione.getInfoAnagrafica()
														+ "\nNumero ospiti: "
														+ prenotazione.getnOspiti()
														+ "\n\nArrivo di:\n"
														+ p.getInfoAnagrafica()
														+ "\nNumero ospiti: "
														+ p.getnOspiti();
											}
										}

									}
								}

								switch ( simbolo ) {
									case Prenotazione.ARRIVO_PARTENZA: {
										anagrafica = "Arrivo e partenza di:\n"
												+ prenotazione.getInfoAnagrafica()
												+ "\nNumero ospiti: "
												+ prenotazione.getnOspiti();
										break;
									}
									case Prenotazione.ARRIVO: {
										anagrafica = "Arrivo di:\n"
												+ prenotazione.getInfoAnagrafica()
												+ "\nNumero ospiti: "
												+ prenotazione.getnOspiti();
										break;
									}
									case Prenotazione.PARTENZA: {
										anagrafica = "Partenza di:\n"
												+ prenotazione.getInfoAnagrafica()
												+ "\nNumero ospiti: "
												+ prenotazione.getnOspiti();
										break;
									}
									case Prenotazione.PUNTO: {
										anagrafica = prenotazione.giorniDopoArrivo( data )
												+ "° Giorno di presenza di:\n"
												+ prenotazione.getInfoAnagrafica()
												+ "\nNumero ospiti: "
												+ prenotazione.getnOspiti();
										break;
									}
								}
							}
						}
					}

					ritorno += "<div class=\"giorno\" style=\"grid-column-start: "
							+ ( 3 + ( i - dataInizio.getDayOfMonth() ) )
							+ "; background-color: "
							+ Calendario.Colori.coloreChiaro( index )
							+ "\" title=\""
							+ anagrafica
							+ "\">"
							+ simbolo
							+ "</div>\n";
				}
				y++ ;
			}
		}
		ritorno += "</div>";
		return ritorno;
	}

	public LocalDate getDataInizio() {
		return dataInizio;
	}

	public LocalDate getDataFine() {
		return dataFine;
	}

	public static class Colori {

		private static int getIndexRipetuto( int index, int maxIndex ) {
			int ritorno = index;
			if ( index > maxIndex ) {
				ritorno = Math.abs( maxIndex - index );
			}
			if ( ritorno > maxIndex ) {
				ritorno = getIndexRipetuto( ritorno, maxIndex );
			}
			return ritorno;
		}

		private static int getIndexSin( int index, int maxIndex ) {
			int ritorno = 0;
			boolean sali = true;

			// TODO trovare una formula matematica che levi il for
			for ( int i = 0; i < index; i++ ) {
				if ( ritorno == 0 ) {
					sali = true;
				} else if ( ritorno == maxIndex ) {
					sali = false;
				}

				ritorno += sali ? 1 : -1;
			}

			return ritorno;
		}

		public static String colore( int index ) {
			String[] s = { "#B5E48C", "#99D98C", "#76C893", "#52B69A", "#34A0A4", "#168AAD" };
			return s[getIndexSin( index, s.length - 1 )];
		}

		public static String coloreChiaro( int index ) {
			String[] s = { "#CAECAC", "#BBE6B3", "#99D6AE", "#6FC3AB", "#45C0C4", "#1CADD9" };
			return s[getIndexSin( index, s.length - 1 )];
		}
	}
}
