# Anforderungsanalyse – UFC Datenbank

## Objekte

### Event
- `Event-ID` (Ganzzahl > 0; ca. 30 % definiert)
- `Name` (Text; 100 % definiert, identifizierend)
- `Datum` (Datum; 100 % definiert)
- `Zuschauerzahl` (Ganzzahl ≥ 0; ca. 80 % definiert)
- `Einnahmen` (Dezimalzahl; ca. 20 % definiert)
- `Typ` (Logical; 0 = UFC, 1 = Fight Night; 100 % definiert)

### Kampf
- `Rundenanzahl` (Ganzzahl > 0; 100 % definiert)
- `Ergebnisart` (Faktor mit 3 Leveln: {Decision, KO, Submission}; 100 % definiert)
- `Siegrunde` (Ganzzahl > 1; 100 % definiert)
- `Siegminute` (Zahl / Zeit > 0; 100 % definiert)
- `Titelkampf` (Logical; 0 = Ja, 1 = Nein; 100 % definiert)

### Kämpfer
- `Name` (Text; 100 % definiert, identifizierend)
- `Nationalität` (Text; 100 % definiert)
- `Sprache` (Text; 100 % definiert)
- `Alter` (Ganzzahl > 0; 100 % definiert)
- `Gewicht` (Dezimalzahl > 0 kg; 100 % definiert)
- `Größe` (Dezimalzahl > 0 cm; 100 % definiert)
- `Reichweite` (Dezimalzahl > 0 cm; 100 % definiert)
- `Größe-Reichweite-Verhältnis` (0 < Dezimalzahl < 1.5; 100 % definiert)
- `Auslage` (Faktor mit 3 Leveln: {Orthodox, Southpaw, Switch}; 100 % definiert)
- `Siege` (Ganzzahl ≥ 0; 100 % definiert)
- `Niederlagen` (Ganzzahl ≥ 0; 100 % definiert)
- `Unentschieden` (Ganzzahl ≥ 0; 100 % definiert)
- `SLpM` (Dezimalzahl > 0; 90 % definiert)
- `Str. Acc.` (Prozent; 90 % definiert)
- `SApM` (Dezimalzahl > 0; 90 % definiert)
- `Str. Def.` (Prozent; 90 % definiert)
- `TD Avg.` (Dezimalzahl > 0; 90 % definiert)
- `TD Acc.` (Prozent; 90 % definiert)
- `TD Def.` (Prozent; 90 % definiert)
- `Sub. Avg.` (Dezimalzahl > 0; 90 % definiert)
- `Gym` (Text; 80 % definiert)
- `Background` (Text; 80 % definiert)

### Gewichtsklasse
- `Name` (Text; identifizierend)
- `Maximalgewicht` (Dezimalzahl > 0 kg; 100 % definiert)
- `Minimalgewicht` (Dezimalzahl > 0 kg; 100 % definiert)

### Austragungsort
- `Stadt` (Text; 100 % definiert)
- `Land` (Text; 100 % definiert)
- `Arena` (Text; 100 % definiert; identifizierend)
- `Temperatur` (Dezimalzahl; 100 % definiert)
- `Sprache` (Text; 100 % definiert)

---

## Beziehungen

### Event enthält Kämpfe
- Beteiligte Objekte: Event – Kampf
- Attribut:
  - Card-Position (Logical; 0 = Main Card, 1 = Undercard; 85 % definiert)

### Kampf besteht aus zwei Kämpfern
- Beteiligte Objekte: Kampf – Kämpfer
- Attribute:
  - Rolle {Sieger, Verlierer} (100 % definiert)
  - Signifikante Treffer (Ganzzahl > 0; 80 % definiert)
  - Takedowns (Ganzzahl ≥ 0; 80 % definiert)

### Kämpfer gehört zu einer Gewichtsklasse
- Beteiligte Objekte: Kämpfer – Gewichtsklasse

### Event findet an einem Austragungsort statt
- Beteiligte Objekte: Event – Austragungsort
- Attribut:
  - Lokale Uhrzeit

---

## Datenverarbeitungsanforderungen

- **Berichterstellung**
  - Anzeige von Events mit ökonomischen Kennzahlen wie Einnahmen und Zuschauerzahl.

- **Performancevergleich**
  - Vergleich von Kämpfern anhand ihrer statistischen Leistungswerte, um z. B. den Kämpfer mit den höchsten Werten in bestimmten Kategorien zu identifizieren.

---

## Definition der Metriken

| Metrik | Bedeutung |
|------|------|
| `SLpM` | Significant Strikes Landed per Minute |
| `Str. Acc.` | Significant Striking Accuracy |
| `SApM` | Significant Strikes Absorbed per Minute |
| `Str. Def.` | Prozentsatz der gegnerischen Treffer, die nicht landen |
| `TD Avg.` | Durchschnittliche Takedowns pro 15 Minuten |
| `TD Acc.` | Takedown Accuracy |
| `TD Def.` | Prozentsatz der gegnerischen Takedown-Versuche, die abgewehrt werden |
| `Sub. Avg.` | Durchschnittliche Submission-Versuche pro 15 Minuten |
| `Background` | Ursprüngliche Kampfsportdisziplin des Kämpfers |
| `Gym` | Gym, in dem der Kämpfer trainiert |
