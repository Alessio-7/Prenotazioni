SELECT nomeGruppo, nomeStanza, idAnagrafica, numeroOspiti, dataArrivo, dataPartenza 
FROM (
Prenotazioni as prenotazione 
LEFT JOIN Stanze as stanza 
	ON stanza.idStanza=prenotazione.idStanza 
LEFT JOIN CollocazioniStanze as rel 
	ON stanza.idstanza=rel.idStanza 
LEFT JOIN GruppiStanze as piano 
	ON piano.idgruppo= rel.idGruppo
)