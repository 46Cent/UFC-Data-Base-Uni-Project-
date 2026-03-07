```
erDiagram
    LAND ||--o{ EVENT : "findet statt in"
    LAND ||--o{ KAEMPFER : "vertritt"
    EVENT ||--|{ KAMPF : "enthält"
    GEWICHTSKLASSE ||--|{ KAMPF : "findet statt in"
    KAEMPFER ||--|{ KAMPF : "kämpft in"

    LAND {
        string Name PK
    }

    EVENT {
        string Name PK
        date Datum
        int Zuschauerzahl
        float Einnahmen
    }

    KAMPF {
        int ID PK
        int Rundenzahl
        string Ergebnisart
        int Siegrunde
        int Siegminute
        boolean Titelkampf
        string Card_Typ "Main- / Undercard"
    }

    KAEMPFER {
        string Name PK
        float Gewicht
        float Groesse
        float Reichweite
        date GebDatum
        float Groesse_Reichweite_Verhaeltnis
        string Auslage
        float SLpM
        float Str_Acc
        float SApM
        float Str_Def
        float TD_Avg
        float TD_Acc
        float TD_Def
        float Sub_Avg
        string Gym
        string Background
    }

    GEWICHTSKLASSE {
        string Name PK
        float Maximalgewicht
        float Minimalgewicht
    }
