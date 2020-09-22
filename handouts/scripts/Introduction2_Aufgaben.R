#Aufgabe 1 im Skript:
urlfile="https://swift.dkrz.de/v1/dkrz_a5a4d477-007a-4a5f-8c5e-16156bbc5646/FE/intro2.zip?temp_url_sig=41aee2394b0bda97f2b78e0cf8701b18782dbe6d&temp_url_expires=2020-07-21T11:44:04Z"


#Aufgabe 2 im Skript:
n=5
 for (i in 1:n){
   LC=subset(LandCover,i)
   png(paste0('plots/intro2/LC',i,'.png'))
   plot(LC)
   dev.off()
 }


#Aufgabe 3 im Skript:
EuroInSchweizerFranken <- function(Euro, Wechselkurs=1.13) {
                    # F?gen Sie hier die Berechnung ein:
                    SchweizerFranken <- Euro * Wechselkurs
                    
                    return(SchweizerFranken)
                   }










