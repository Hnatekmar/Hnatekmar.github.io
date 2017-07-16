<div class = "mermaid">
gantt
    title Roadmapa projektu

    section Převodník
	    Načítání jdfs   :done, a1 , 2017-07-01, 10d
	    Převod do gtfs  :a2, after a1, 10d
	    Refactoring :a3, after a2, 10d
	    Publikování na sonatypu :a4, after a3, 2d

    section Generátor mapových vrstev 
	    Návrh algoritmu :b1, after a4, 5d
	    Prototypování :b1, after a4, 5d
            Implementace :b2, after b1, 10d
</div>
