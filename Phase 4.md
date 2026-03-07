# Phase 4 – Logischer Entwurf

## Relationen

### `Kämpfer`
| Attribut | Typ |
|---|---|
| **Name** | string |
| Gewicht | decimal |
| Größe | decimal |
| Reichweite | decimal |
| GebDatum | date |
| Größe/Reichweite-Verhältnis | decimal |
| Auslage | string |
| SLpM | decimal |
| Str. Acc. | decimal |
| SApM | decimal |
| Str. Def. | decimal |
| TD Avg. | decimal |
| TD Acc. | decimal |
| TD Def. | decimal |
| Sub. Avg | decimal |
| Gym | string |
| Background | string |
| vertritt → Land.Name | Fremdschlüssel |

---

### `Kampf`
| Attribut | Typ |
|---|---|
| **ID** | string |
| Rundenzahl | integer |
| Ergebnisart | string |
| Siegrunde | integer |
| Siegminute | decimal |
| Titelkampf | logical |
| enthalten_in → Event.Name | Fremdschlüssel |
| stattgefunden_in → Gewichtsklasse.Name | Fremdschlüssel |
| gelandete_td | integer |
| gelandete_sigTreffer | integer |
| CardPosition | logical |

---

### `Kampf_Kämpfer`
| Attribut | Typ |
|---|---|
| Kampf → Kampf.ID | Fremdschlüssel |
| Kämpfer → Kämpfer.Name | Fremdschlüssel |
| Takedowns | integer |
| Sig_Treffer | integer |

---

### `Event`
| Attribut | Typ |
|---|---|
| **Name** | string |
| Datum | date |
| Zuschauerzahl | integer |
| Einnahmen | decimal |
| inLand → Land.Name | Fremdschlüssel |

---

### `Land`
| Attribut | Typ |
|---|---|
| **Name** | string |

---

### `Gewichtsklasse`
| Attribut | Typ |
|---|---|
| **Name** | string |
| Maximalgewicht | decimal |
| Minimalgewicht | decimal |

---

## Einschränkungen

### `Kämpfer`
- `Str_Acc`: 0 < Str_Acc < 1  
- `Str_Def`: 0 < Str_Def < 1  
- `TD_Acc`: 0 < TD_Acc < 1  
- `TD_Def`: 0 < TD_Def < 1  

### `Kampf`
- `ID` besteht aus **16 Zeichen**  
- `Rundenzahl`: 0 ≤ Rundenzahl ≤ 5  
- `Ergebnisart` ∈ {`Sub`, `KO`, `Draw`, `Dec`, `Disq`}  
- `Siegrunde`: 0 < Siegrunde ≤ 5  
- `Titelkampf` ∈ {`Ja`, `Nein`}  
- `CardPosition` ∈ {`Main`, `Under`}  

### `Gewichtsklasse`
`Name` ∈ {`Flyweight`, `Bantamweight`, `Featherweight`, `Lightweight`, `Welterweight`, `Middleweight`, `Light Heavyweight`, `Heavyweight`}
