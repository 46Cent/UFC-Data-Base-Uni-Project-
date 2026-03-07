```mermaid
erDiagram

    EVENT {
        string Name
        date Datum
        int Zuschauerzahl
        float Einnahmen
    }

    KAMPF {
        int ID
        int Rundenzahl
        string Ergebnisart
        int Siegrunde
        time Siegminute
        bool Titelkampf
    }

    KAEMPFER {
        string Name
        float Gewicht
        float Groesse
        float Reichweite
        date GebDatum
        float Groesse_Reichweite_Verhaeltnis
        string Auslage
        float SLpM
        float StrAcc
        float SApM
        float StrDef
        float TDAvg
        float TDAcc
        float TDDef
        float SubAvg
        string Gym
        string Background
    }

    GEWICHTSKLASSE {
        string Name
        float Maximalgewicht
        float Minimalgewicht
    }

    LAND {
        string Name
    }

    EVENT ||--o{ KAMPF : enthaelt
    KAMPF }o--|| EVENT : gehoert_zu

    KAEMPFER ||--o{ KAMPF : kaempft
    KAMPF }o--|| KAEMPFER : beinhaltet

    GEWICHTSKLASSE ||--o{ KAEMPFER : klassifiziert

    LAND ||--o{ EVENT : findet_statt_in
    LAND ||--o{ KAEMPFER : vertritt
