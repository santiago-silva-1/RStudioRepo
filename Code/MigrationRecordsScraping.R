#Web Scraping Complete Irish Famine Dataset
#Santiago Silva 
#February 13, 2021

# set working directory
WORK.DIR = "Downloads"
setwd(WORK.DIR)

People5=read.csv("PeopleWhoMigratedpart5.csv")

install.packages("openxlsx")
library(openxlsx)
library(rvest)
library(dplyr)
library(xlsx)
library(MASS)


#use Rselenium
#install.packages("Rselenium")
library(RSelenium)
rD=RSelenium::rsDriver(port = 8430L, browser =("firefox"))
#that starts an remote Rselenium driver
#a firefox window should open
#need Java on the computer
#might need to change port number
remDr=rD$client
remDr$navigate("https://aad.archives.gov/aad/display-partial-records.jsp?dt=180&sc=17169%2C17170%2C17172%2C17189%2C17177%2C17180%2C17190%2C17181&cat=all&tf=F&bc=sl%2Cfd&q=&as_alq=&as_anq=&as_epq=&as_woq=&nfo_17169=V%2C20%2C1900&op_17169=0&txt_17169=&nfo_17170=V%2C19%2C1900&op_17170=0&txt_17170=&nfo_17172=N%2C3%2C1900&cl_17172=&nfo_17189=N%2C3%2C1900&cl_17189=&nfo_17177=V%2C20%2C1900&op_17177=0&txt_17177=&nfo_17180=N%2C3%2C1900&cl_17180=&nfo_17190=N%2C8%2C1900&cl_17190=&nfo_17181=D%2C10%2C1846&op_17181=8&txt_17181=1%2F12%2F1846&txt_17181=12%2F31%2F1851&rpp=50")
#the website we want to scrape data from should load in the firefox windown R opened
#we started a remote server

#first work on page one only
lastname=remDr$findElements("css selector", "tbody td:nth-child(2)")
LastName=unlist(lapply(lastname, function(x){x$getElementText()}))
LastName=LastName[5:54]
LastName

firstname=remDr$findElements("css selector", "tbody td:nth-child(3)")
FirstName=unlist(lapply(firstname, function(x){x$getElementText()}))
FirstName

age=remDr$findElements("css selector", "tbody td:nth-child(4)")
Age=unlist(lapply(age, function(x){x$getElementText()}))
Age

nativecountrycode=remDr$findElements("css selector", "tbody td:nth-child(5)")
NativeCtryCode=unlist(lapply(nativecountrycode, function(x){x$getElementText()}))
NativeCtryCode

destination=remDr$findElements("css selector", "tbody td:nth-child(6)")
Destination=unlist(lapply(destination, function(x){x$getElementText()}))
Destination

portofembark =remDr$findElements("css selector", "tbody td:nth-child(7)")
PortofEmbark=unlist(lapply(portofembark , function(x){x$getElementText()}))
PortofEmbark

manifestinum =remDr$findElements("css selector", "tbody td:nth-child(8)")
ManifestNum=unlist(lapply(manifestinum , function(x){x$getElementText()}))
ManifestNum

arrivaldate=remDr$findElements("css selector", "tbody td:nth-child(9)")
ArrivalDate=unlist(lapply(arrivaldate, function(x){x$getElementText()}))
ArrivalDate

Migrationpage1=data.frame(LastName=LastName,FirstName=FirstName , Age= Age, NativeCountryCode= NativeCtryCode,
                          Destination= Destination, PassengerPortOfEmbarkationCode= PortofEmbark, 
                          ManifestIdentificationNumber=ManifestNum , 
                          PassengerArrivalDate=ArrivalDate )
View(Migrationpage1)
#page one done

#switching pages
firstnextpage <- remDr$findElement(using = 'css selector',".width720 a")
firstnextpage$clickElement()


#now do for all 75 pages

####build loop

library(RSelenium)
rD=RSelenium::rsDriver(port = 8011L, browser =("firefox"))
#that starts an remote Rselenium driver
#a firefox window should open
#need Java on the computer
#might need to change port number
remDr=rD$client

remDr$navigate("https://aad.archives.gov/aad/display-partial-records.jsp?dt=180&sc=17169%2C17170%2C17172%2C17189%2C17177%2C17180%2C17190%2C17181&cat=all&tf=F&bc=sl%2Cfd&q=&as_alq=&as_anq=&as_epq=&as_woq=&nfo_17169=V%2C20%2C1900&op_17169=0&txt_17169=&nfo_17170=V%2C19%2C1900&op_17170=0&txt_17170=&nfo_17172=N%2C3%2C1900&cl_17172=&nfo_17189=N%2C3%2C1900&cl_17189=&nfo_17177=V%2C20%2C1900&op_17177=0&txt_17177=&nfo_17180=N%2C3%2C1900&cl_17180=&nfo_17190=N%2C8%2C1900&cl_17190=&nfo_17181=D%2C10%2C1846&op_17181=8&txt_17181=1%2F12%2F1846&txt_17181=12%2F31%2F1851&rpp=50&mtch=604596&pg=7200&rpp=50")

#figure out how the page changes, 12092 pages total
#IrishFamine8=data.frame()
for (page_result in seq(from =8990 , to= 9600, by=1)) {
 link= paste0("https://aad.archives.gov/aad/display-partial-records.jsp?dt=180&sc=17169%2C17170%2C17172%2C17189%2C17177%2C17180%2C17190%2C17181&cat=all&tf=F&bc=sl%2Cfd&q=&as_alq=&as_anq=&as_epq=&as_woq=&nfo_17169=V%2C20%2C1900&op_17169=0&txt_17169=&nfo_17170=V%2C19%2C1900&op_17170=0&txt_17170=&nfo_17172=N%2C3%2C1900&cl_17172=&nfo_17189=N%2C3%2C1900&cl_17189=&nfo_17177=V%2C20%2C1900&op_17177=0&txt_17177=&nfo_17180=N%2C3%2C1900&cl_17180=&nfo_17190=N%2C8%2C1900&cl_17190=&nfo_17181=D%2C10%2C1846&op_17181=8&txt_17181=1%2F12%2F1846&txt_17181=12%2F31%2F1851&rpp=50&mtch=604596&pg=", page_result ,"&rpp=50")
 remDr$navigate(link)
 
Sys.sleep(4.2)

lastname=remDr$findElements("css selector", "tbody td:nth-child(2)")
LastName=unlist(lapply(lastname, function(x){x$getElementText()}))
LastName=LastName[5:54]


firstname=remDr$findElements("css selector", "tbody td:nth-child(3)")
FirstName=unlist(lapply(firstname, function(x){x$getElementText()}))


age=remDr$findElements("css selector", "tbody td:nth-child(4)")
Age=unlist(lapply(age, function(x){x$getElementText()}))


nativecountrycode=remDr$findElements("css selector", "tbody td:nth-child(5)")
NativeCtryCode=unlist(lapply(nativecountrycode, function(x){x$getElementText()}))


destination=remDr$findElements("css selector", "tbody td:nth-child(6)")
Destination=unlist(lapply(destination, function(x){x$getElementText()}))


portofembark =remDr$findElements("css selector", "tbody td:nth-child(7)")
PortofEmbark=unlist(lapply(portofembark , function(x){x$getElementText()}))


manifestinum =remDr$findElements("css selector", "tbody td:nth-child(8)")
ManifestNum=unlist(lapply(manifestinum , function(x){x$getElementText()}))


arrivaldate=remDr$findElements("css selector", "tbody td:nth-child(9)")
ArrivalDate=unlist(lapply(arrivaldate, function(x){x$getElementText()}))


IrishFamine8=rbind(IrishFamine8 , data.frame(LastName=LastName,FirstName=FirstName , Age= Age, NativeCountryCode= NativeCtryCode,
                                       Destination= Destination, PassengerPortOfEmbarkationCode= PortofEmbark, 
                                       ManifestIdentificationNumber=ManifestNum , 
                                       PassengerArrivalDate=ArrivalDate ,stringsAsFactors = FALSE))
print(paste("Page:", page_result, (dim(IrishFamine8))))
}
dim(IrishFamine8)
tail(IrishFamine8)
#sum(dim(IrishFamine1)-dim(IrishFamine2))
#missing 50 obs from IrishFamine1
#missing 900 observations from IrishFamine2
#800 extra obs in Irishfamine5
#missing 1800 obs from Irishfamine6
#extra 9200 obs in irishfamine 7, all picked up before page 7754
#missing 250 obs in irishfamine 8

#IrishFamine1 goes from page 1 to 1200
#IrishFamine2 goes from page 1201 to 2400, 
#IrishFamine3 goes from page 2401 to 3600,
#IrishFamine4 goes from page 3601 to 4800,
#IrishFamine5 goes from page 4801 to 6000,
#IrishFamine6 goes from page 6001 to 7200,
#IrishFamine7 goes from page 7201 to 8400,
#IrishFamine8 goes from page 8401 to 9600,




#need to add last page manually because it has 20 observations, not 50 like the other pages
lastname=remDr$findElements("css selector", "tbody td:nth-child(2)")
LastName=unlist(lapply(lastname, function(x){x$getElementText()}))
LastName=LastName[5:23]
LastName

firstname=remDr$findElements("css selector", "tbody td:nth-child(3)")
FirstName=unlist(lapply(firstname, function(x){x$getElementText()}))
FirstName

age=remDr$findElements("css selector", "tbody td:nth-child(4)")
Age=unlist(lapply(age, function(x){x$getElementText()}))
Age

nativecountrycode=remDr$findElements("css selector", "tbody td:nth-child(5)")
NativeCtryCode=unlist(lapply(nativecountrycode, function(x){x$getElementText()}))
NativeCtryCode

destination=remDr$findElements("css selector", "tbody td:nth-child(6)")
Destination=unlist(lapply(destination, function(x){x$getElementText()}))
Destination

portofembark =remDr$findElements("css selector", "tbody td:nth-child(7)")
PortofEmbark=unlist(lapply(portofembark , function(x){x$getElementText()}))
PortofEmbark

manifestinum =remDr$findElements("css selector", "tbody td:nth-child(8)")
ManifestNum=unlist(lapply(manifestinum , function(x){x$getElementText()}))
ManifestNum

arrivaldate=remDr$findElements("css selector", "tbody td:nth-child(9)")
ArrivalDate=unlist(lapply(arrivaldate, function(x){x$getElementText()}))
ArrivalDate


Migration=rbind(Migration , data.frame(LastName=LastName,FirstName=FirstName , Age= Age, NativeCountryCode= NativeCtryCode,
                                       Destination= Destination, PassengerPortOfEmbarkationCode= PortofEmbark, 
                                       ManifestIdentificationNumber=ManifestNum , 
                                       PassengerArrivalDate=ArrivalDate ,stringsAsFactors = FALSE))
dim(Migration)
View(Migration)
#dataset complete

#close the server, this will close the firefox window we were working on
remDr$close()

#export

write.xlsx(IrishFamine1, "PeopleWhoMigrated.xlsx")
write.xlsx2(IrishFamine3, "PeopleWhoMigratedpart3.xlsx")
openxlsx::write.xlsx(IrishFamine8, file = "PeopleWhoMigratedpart8.xlsx")

?write

