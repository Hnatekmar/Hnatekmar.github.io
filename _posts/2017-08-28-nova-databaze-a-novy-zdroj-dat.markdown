---
layout: post
title: "Nová databáze a nový zdroj dat"
tags:
---
# Postup za poslední dva týdny
Poslední dva týdny jsem strávil přechodem na databázi Postgre z původní H2.

Postgre jsem zvolil především proto, že narozdíl od H2 podporuje definici vlastních procedůr, které se budou určitě hodit pro implementaci samotného algoritmu. Další výhoda je, že postgre podobně jako H2 obsahuje rozšíření pro zpracování geoegrafických dat.
 
Přechod zahrnoval mírnou úpravu převodníku tak, aby byl schopný pracovat s postgre (hlavně načítání csv, které je v postgre odlišné od H2) a až na pár drobných problémů s kódováním vše šlo docela dobře.

# Problém
Nicméně jsem se zasekl na propojení samotných zastávek v jdf s jejích pozicemi na mapě. JDF je totiž neobsahuje, takže je nutné najít nějáký externí zdroj dat. Našel jsem hned dva a to export dat z projektu openstreetmap, který pokrýval celou republiku a oficiální data z geoportálu Jihočeského kraje. Bohužel jsem zjistil, že neexistuje žádný spolehlivý způsob, jak je propojit. Formát by sice měl obsahovat tabulku označníky, která propojuje zastávky s jejích unikátním identifikátorem ale tato tabulka je zatím nepovinná a nelze na ní tedy spoléhat. Napadlo mě zkusit je propojit pomocí názvu a pak omezit s pomocí obce (zjistit, zda leží v dané obci) s tím, že by názvy zastávek v rámci obce měly být unikátní. Bohužel ani tento postup nefungoval, protože názvy zastávek v JDF se neshodovaly s názvy zastávek v žádném z výše uvedených zdrojů.

# Řešení
Ve světle těchto okolností a s ohledem na blížící se deadline koncem září jsem se rozhodl použít alternativní zdroj dat a to [Pražské jízdní řády v GTFS](http://transitfeeds.com/p/praha/801/20170814). GTFS totiž jíž obsahuje pozice zastávek navíc existuje několik programů, které umožní snadný import do databází, takže jsem je nemusel implementovat narozdíl od JDF.

# Aktuální stav
Aktuálně mám databázi s naimportovanými daty z gtfs. Importer naštěstí vzal v potaz i geografická data, takže mi nic nebrání posunout se posunout k samotné implementaci.

# Plán
Dalším logickým krokem bude implementace samotného algoritmu. Nejprve je potřeba napsat kód, který najde nejkratší cestu z jedné zastávky na druhou. Poté napsat dotaz, který najde nejbližší zastávk(u/y) v okolí bodu na mapě. Dále potřeba napsat procedůru, která najde nejbližší zastávk(u/y) ve dvou bodech, nalezne nejkratší cestu mezi nimi a vrátí délku cesty. Tuto proceduru pak plánuju vystavit přes nějáke REST api, abych se mohl snadno dotazovat přes javascript.
