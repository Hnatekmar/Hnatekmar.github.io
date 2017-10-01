# Na čem jsem dělal
- Snažil jsem se úspěšně zrychlit stávající implementaci. S použitím různých triků, jako je předpočítána tabulka vzdáleností, rychlejší sql dotazy atd.. se mi podařilo zrychlit dotaz z předchozího postu ze 14 s na 4 s
- V rámci zrychlení jsem take zkoumal možnosti grafové databáze neo4j ale nakonec jsem jí z časových důvodu opustil
- Také jsem napsal prototyp v jazyce scala, který je popsaný níže
- Přemýšlel jsem nad alternativními způsoby zjišťování následníků zastávek
# Současný stav projektu
V současné době mám rozdělané 2 protototypy a to:

- Prototyp používající dříve zmiňované procedůry v sql s tím, že jsem je zpřístupnil s pomocí projektu [postgrest](https://postgrest.com/)
- Aplikaci napsanou ve Scale, která implementuje vyhledávání s pomocí Dijkstrova algoritmu a komunikuje opět s pomocí rest api.

Aplikace ve scale je krapet rychlejší (poslední měření ukazovalo cca. 1 s rozdíl mezi sql) a teď už také trochu vyvinutější, proto budu popisovat hlavně ji.

# Jak to funguje
Klient (upravený první prototyp) komunikuje s pomocí rest api na které se klient dotazuje s pomocí ajax requestu na ```/heatmap/```, který vrátí heatmapu reprezentovanou polem bodů s jejích intenzitou, klient ji pak jenom vykreslí.
Hlavní problém současné implementace je to, že výpočet trvá (v závislosti na bodě zvoleném na mapě) strašně dlouho.

# Další kroky 
Samozřejmě se budu v nejbližší době snažit zlepšit rychlost výpočtu, kromě toho bych však se rád také zaměřil na následující věci:
- Lepší UI (možnost zadat čas i datum)
- Vyčistit sql a ověřit, zda vše správně funguje
Po odprezentování prototypu, který do té doby snad jíž bude fungovat správně bych se rád zaměřil na přepis aplikace do nějáké permanentnější podoby (rozchození pod wilfly, ...)
