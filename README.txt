WebwinkelKeur OpenCart module
=============================

Deze module integreert de WebwinkelKeur sidebar module in uw webshop. De module 
kan eenvoudig worden geïnstalleerd. Gebruik daarvoor de onderstaande 
installatieinstructies.

De module is getest met OpenCart versies 1.5.4 - 1.5.6.4.

U kunt de module ook laten installeren door de ontwikkelaar. Neem daarvoor per 
e-mail contact op.

(C) 2013 Albert Peschar <albert@peschar.net>


Installatieinstructies
----------------------

    1. Upload de bestanden in de map upload/ naar de webserver.

    2. De module kan nu worden ingeschakeld in de administratieinterface.

    3. Vul uw webwinkel ID en API key in en configureer de module.

    4. Wilt u uitnodigingen verzenden, dan moet er een cronjob worden ingesteld.  
    De cronjob moet elke avond worden uitgevoerd en deze URL aanroepen:

      http://www.uw-webwinkel.nl/index.php?route=module/webwinkelkeur/cron

    Hiervoor kunt u de volgende regel in uw crontab plaatsen:

      30 23 * * * wget --quiet -O- 'http://www.uw-webwinkel.nl/index.php?route=module/webwinkelkeur/cron'

    Wanneer u de multistore ondersteuning gebruikt, dan moet de cronjob voor
    elke winkel worden ingesteld.

