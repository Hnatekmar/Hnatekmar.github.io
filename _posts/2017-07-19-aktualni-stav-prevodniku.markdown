---
layout: post
title: "Aktuální stav převodníku"
tags:
 - jdf2gtfs
---
Převodník je v současné době schopen načíst JDF verze 1.11 do databáze a částečně je jej schopná převést do gtfs s tím, že k samotnému převodu je potřeba vyřešit 2 věci.
* Zatím jsem nenašel způsob jakým zjistit pořádí zastávky v JDF (což je vyžadované políčko v gtfs)
* Je potřeba aplikaci napojit na něco, co zjistí lokaci zastávky (uvažuji nad openstreetmaps)

Po úspěšném zprovoznění bude potřeba trochu učesat api a nahrát celou aplikaci do mavenu, abych jí pak mohl používat jako závislost.
