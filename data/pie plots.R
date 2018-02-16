#  Pie chart
###Data Prep#####
crime_clean<-read.csv("crime_clean.csv")

felony<-crime_clean[crime_clean$LAW_CAT_CD=="FELONY",]
mis<-crime_clean[crime_clean$LAW_CAT_CD=="MISDEMEANOR",]
vio<-crime_clean[crime_clean$LAW_CAT_CD=="VIOLATION",]

library(plyr)
table(felony$OFNS_DESC)

c_f<-as.data.frame(count(felony,"OFNS_DESC"))
c_m<-as.data.frame(count(mis,"OFNS_DESC"))
c_v<-as.data.frame(count(vio,"OFNS_DESC"))

top10_c_f<-head((c_f[order(c_f$freq,decreasing =TRUE),]),n=10)

top10_c_m<-head((c_m[order(c_f$freq,decreasing =TRUE),]),n=10)

top10_c_v<-head((c_v[order(c_f$freq,decreasing =TRUE),]),n=20)

###Plotting#####
library(ggplot2)
bpf<-ggplot(top10_c_f, aes(x="", y=freq, fill=OFNS_DESC))+
  geom_bar(width = 1, stat = "identity")
pie_f <- bpf + coord_polar("y", start=0)+ggtitle("Distribution of felony crimes")+
  labs(y="frequency",fill='Crimes')

bpm<-ggplot(top10_c_m, aes(x="", y=freq, fill=OFNS_DESC))+
  geom_bar(width = 1, stat = "identity")
pie_m <- bpm + coord_polar("y", start=0)+ggtitle("Distribution of Misdemeanour crimes")+
  labs(y="frequency",fill='Crimes')

bpv<-ggplot(top10_c_v, aes(x="", y=freq, fill=OFNS_DESC))+
  geom_bar(width = 1, stat = "identity")
pie_v <- bpv + coord_polar("y", start=0)+ggtitle("Distribution of Violation crimes")+
  labs(y="frequency",fill='Crimes')

## Full plot ##
full<-as.data.frame(count(crime_clean,"LAW_CAT_CD"))
bp_full<-ggplot(full, aes(x="", y=freq, fill=LAW_CAT_CD))+
  geom_bar(width = 1, stat = "identity")
pie_full<-bp_full+coord_polar("y",start = 0)+ggtitle("Distribution of Crimes by Law categorization")+
  labs(y="frequency",fill='Crimes')+panel_border()

###Putting all plots together####

install.packages("gridExtra")
library(gridExtra)
grid.arrange(pie_full,pie_f,pie_m,pie_v)

