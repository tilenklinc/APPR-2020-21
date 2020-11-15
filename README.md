# Analiza podatkov s programom R, 2020/21
### Avtor: Tilen Klinc

*Repozitorij z gradivi pri predmetu APPR v študijskem letu 2020/21*

* [![Shiny](http://mybinder.org/badge.svg)](http://mybinder.org/v2/gh/tilenklinc/APPR_projektna/master?urlpath=shiny/APPR-2020-21/projekt.Rmd) Shiny
* [![RStudio](http://mybinder.org/badge.svg)](http://mybinder.org/v2/gh/tilenklinc/APPR_projektna/master?urlpath=rstudio) RStudio

## Analiza delniških trgov

Za področje raziskave pri predmetu analiza podatkov v programu R sem si izbral analizo delniškega trga, pri čemer se bom primarno osredotočal na gibanje in predikcijo gibanja posamezne delnice (Apple/Nvidia/Amazon/Microsoft) in s tem preveril, če je delnica primerna za investicijo ali ne.

Tekom svojega projekta bom primerjal še stopnje rasti različnih delnic in izračunal delež tržne kapitalizacije v primerjavi z državnim BDP-jem. Ker je v globaliziranem svetu 21. stoletja obstoječa velika razlika med državami in posamezniki, sem se odločil še za primerjavo tržne kapitalizacije po državah.

#### Potek dela:
1. Pridobitev podatkov s spleta (1. del)  
    1.1. Izris price chart-a  
    1.2. Izris moving average-a (*Bollinger Band chart*)  
    1.3. Primerajva rasti z drugimi velikimi delnicami  
    1.4. Predikcija spremembe cen  
2. Pridobitev podatkov s spleta (2. del)  
    2.1. Pregled in izris velikosti tržne kapitalizacije po državah  
    2.2. Izračun deležv in izris ...
    
### Grupiranje:
* Pregled tabele S&P500 oziroma S&P350, ki prikazuje top 500/350 podjetji v ZDA/EU.
* Pri grupiranju podatki pregledani po različnih modelih npr. CAPM(*model, ki opiše povezavo med sistematičnim tveganjem in pričakovano stopnjo donosa*).


#### *Viri:*
* [Tržna kapitaliazacija po državah](https://data.worldbank.org/indicator/CM.MKT.LCAP.CD?name_desc=true)
* [Podatki o delnicah](https://finance.yahoo.com/?guccounter=1&guce_referrer=aHR0cHM6Ly93d3cuZ29vZ2xlLmNvbS8&guce_referrer_sig=AQAAAHUZl6qKCy7-uHn2P3_u2szy0esOsxzYfZj6oBmPSdpchEzC7fncHVFeor3SnDmfnckXFBG79Kxj4dqwWHzDFCFiTwdcxuP0cYW8VUB1qhbTEE5Uk-M1mDF5E3Eb5qojnsy1BhnjC8TQ40RWYjXdME5uVwwcHSycNrE3rtHrRp_N) \
<span style="font-size:9px;">Podatke iz strani *WorldBank* lahko pridobimo v .xls/.xml/.csv obliki, podatke iz *Yahoo* ali *Google Finance* pa pridobimo direktno s pomočjo API.</span>  
* [Rpaket](https://medium.com/@panda061325/stock-clustering-with-time-series-clustering-in-r-63fe1fabe1b6)  

## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`.
Ko ga prevedemo, se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`.
Podatkovni viri so v mapi `podatki/`.
Zemljevidi v obliki SHP, ki jih program pobere,
se shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `rgdal` - za uvoz zemljevidov
* `rgeos` - za podporo zemljevidom
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `readr` - za branje podatkov
* `rvest` - za pobiranje spletnih strani
* `tidyr` - za preoblikovanje podatkov v obliko *tidy data*
* `dplyr` - za delo s podatki
* `gsubfn` - za delo z nizi (čiščenje podatkov)
* `ggplot2` - za izrisovanje grafov
* `mosaic` - za pretvorbo zemljevidov v obliko za risanje z `ggplot2`
* `maptools` - za delo z zemljevidi
* `tmap` - za izrisovanje zemljevidov
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)

## Binder

Zgornje [povezave](#analiza-podatkov-s-programom-r-202021)
omogočajo poganjanje projekta na spletu z orodjem [Binder](https://mybinder.org/).
V ta namen je bila pripravljena slika za [Docker](https://www.docker.com/),
ki vsebuje večino paketov, ki jih boste potrebovali za svoj projekt.

Če se izkaže, da katerega od paketov, ki ji potrebujete, ni v sliki,
lahko za sprotno namestitev poskrbite tako,
da jih v datoteki [`install.R`](install.R) namestite z ukazom `install.packages`.
Te datoteke (ali ukaza `install.packages`) **ne vključujte** v svoj program -
gre samo za navodilo za Binder, katere pakete naj namesti pred poganjanjem vašega projekta.

Tako nameščanje paketov se bo izvedlo pred vsakim poganjanjem v Binderju.
Če se izkaže, da je to preveč zamudno,
lahko pripravite [lastno sliko](https://github.com/jaanos/APPR-docker) z želenimi paketi.

Če želite v Binderju delati z git,
v datoteki `gitconfig` nastavite svoje ime in priimek ter e-poštni naslov
(odkomentirajte vzorec in zamenjajte s svojimi podatki) -
ob naslednjem zagonu bo mogoče delati commite.
Te podatke lahko nastavite tudi z `git config --global` v konzoli
(vendar bodo veljale le v trenutni seji).
