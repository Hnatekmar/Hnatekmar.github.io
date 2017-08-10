<div class = "mermaid">
gantt
    title Roadmapa projektu

    section Blog
	    Rozchození :done, 2017-07-14, 1d
	    Úpravy šablony / závislosti :done, 2017-07-15, 1d
            Sepsání úvodního obsahu :done, 2017-07-16, 3d	

    section Převodník
	    Načítání jdfs   :done, a1 , 2017-07-01, 10d
	    Převod do gtfs  :a2, after a1, 15d
	    Refactoring :a3, after a2, 10d
	    Publikování na sonatypu :a4, after a3, 2d

    section Generátor mapových vrstev 
	    Návrh algoritmu :b1, after a4, 5d
	    Prototypování :b1, after a4, 5d
            Implementace :b2, after b1, 20d
</div>
Dostupné zdroje dat:
{% capture x %}
- JDF
	- [Dokumentace](http://www.drevari.sk/akcia/1432~002b0d7bbe1d.pdf)
	- [Data](ftp://ftp.cisjr.cz/JDF/JDF.zip)
{% endcapture %}{{ x | markdownify }}
