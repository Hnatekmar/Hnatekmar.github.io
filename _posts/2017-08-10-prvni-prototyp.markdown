---
layout: post
title: "První prototyp"
tags:
---
Během posledních pár dnů jsem implementoval první [prototyp](https://akela.mendelu.cz/~xhnatek/Diplomka/Prototyp1/) generátoru, který se mi dneska podařilo uvést do stavu, kdy je schopný generovat heatmapu na základě dojezdu k dané pozici.

![Heatmapa nad Brnem](http://i.imgur.com/1MJ5JTF.png)

Mapa reáguje na kliknutí vygenerování mřížky 10x10, kde hodnota každého bodu představuje čas za který se lze do něj dostat z počátečního bodu (toho, který byl specifikován kliknutím).

# Použité technologie
Prototyp využívá [API dojezdů googlu](https://developers.google.com/maps/documentation/javascript/distancematrix), které je omezené počtem možných dotazů (2 500 za den), ačkoliv lze limit navýšit ale toto už je placené (0.50 $ za 1000 dotazů), takže není bohužel použitelné pro aplikaci samotnou ale lze jej využít jako refernční implementaci a na testování výsledků dalších prototypů.

Pro vykreslování heatmapy používám knihovnu [Heatmap.js](https://github.com/pa7/heatmap.js), která je zdarma pro nekomenční použití.

# Nutná vylepšení
Je nutné zdůraznit, že se zatím jedná jen o první iteraci, kterou bude třeba ještě trochu vylepšit, než jí bude možné prohlásit za hotovou.

- Možnost specifikovat čas se kterým bude heatmapa počítat
- Zařídit, aby se heatmapa vykreslovala jako celek ve přiblížení
- Zobrazit místo výchozího bodu po kliknutí na mapu
- Možnost specifikovat dosah heatmapy kruhovým výběrem
- Lepší UI (možnost přepínaní mezi autem a MHD)

# Závěr
V příští iteraci se pokusím opravit pár položek ze sekce Nutná vylepšení a poté se zaměřím na implementaci vlastního řešení výpočtu času dojezdu.
