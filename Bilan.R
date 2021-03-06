
#Using dataset from the library hflights, 
#Usefull R libraries for this script : dplyr, ggplot and hflights 


library(dplyr)
library(ggplot2)
library(hflights)

##We are going to look at the average delay by month and by day of the week that are having planes from this dataset. 


a <- hflights %>% 
	group_by(Year, Month, DayOfWeek) %>% 
	mutate(tot_delay = ArrDelay + DepDelay) %>% 
	summarise(AVG_delay = mean(tot_delay, na.rm = TRUE))


p <- ggplot(data = a, aes(x = DayOfWeek, y = AVG_delay, colour = factor(Month))) + geom_point()
p

# ----------------------------------




Delay_per_flight <- hflights %>%
	select(ArrDelay, DepDelay, FlightNum) %>%
	mutate(tot_delay= ArrDelay + DepDelay) %>%
	group_by(FlightNum) %>%
	summarise(avg_delay_per_flight = mean(tot_delay, na.rm = TRUE))
head(Delay_per_flight)

Distance_per_flight <- hflights %>%
	select(Distance, FlightNum) %>%
	group_by(FlightNum) %>%
	summarise(Distance_avg = mean(Distance, na.rm = TRUE))
head(Distance_per_flight)

tot <- Delay_per_flight
tot[, "Distance_per_flight"] <- Distance_per_flight[, "Distance_avg"]


ggplot(data = tot, aes(Distance_per_flight,avg_delay_per_flight)) + geom_point(size = 2, colour="#14B4C9") + xlim(0,2000) + ylim(-50, 250)


#-----------------

Data_airtime_by_dest <- hflights %>%
	group_by(Dest) %>%
	summarise(avg_airtime_by_Dest = mean(ActualElapsedTime, na.rm= TRUE))

avg_distance_by_dest <- hflights %>%
	group_by(Dest) %>%
	summarise(avg_dis = mean(Distance, na.rm = TRUE))


head(Data_airtime_by_dest  %>% arrange(avg_airtime_by_Dest))

c <- Data_airtime_by_dest 
c[, "avg_distance"] <- avg_distance_by_dest %>% select(avg_dis)

ggplot(data = c, aes(x=avg_airtime_by_Dest, y= avg_distance )) + geom_point(colour = "#6666ff")

# ----------------------------------

Avg_delay_each_month <- hflights %>%
	mutate(total_delay = ArrDelay + DepDelay) %>%
	group_by(Month) %>%
	summarise(delay_ = mean(total_delay, na.rm = TRUE))


d<- ggplot(data = Avg_delay_each_month, aes(Month, delay_)) + geom_bar(stat="identity", fill = "#ccffff", colour = "black") 
d


# ----------------------------------


#All Month of the year
aplus <- hflights %>%
	group_by(DayOfWeek, Month) %>%
	tally()

ggplot(data = aplus, aes(x = DayOfWeek, y= n, colour = factor(Month))) + geom_point() + geom_line()

#Without July and August 
aplusbis <- aplus %>%
	filter (Month<7 | Month>8)
ggplot(data = aplusbis, aes(x = DayOfWeek, y= n, colour = factor(Month))) + geom_point() + geom_line()


# ----------------------------------



a <- hflights %>% filter(Cancelled == 1) %>% group_by(CancellationCode) %>% select(CancellationCode, Distance) %>% summarise(avg_dist = mean(Distance, na.rm = TRUE))

ggplot(data = a, aes(x = CancellationCode, y = avg_dist)) + geom_bar(stat="identity", fill="#6666ff", colour="black")

# ----------------------------------


b <- hflights %>% group_by(Origin) %>% summarise(avg_delay_dep_dest = mean(DepDelay, na.rm = TRUE))
head(b)
ggplot(data = b, aes(x = Origin, y= avg_delay_dep_dest)) + xlab("Airport Origin") + ylab("Average Depart Delay") + geom_bar(stat="identity", fill="#14B4C9", colour="black")















