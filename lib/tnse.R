library(datasets)
library(tsne)
library(readr)
library(dplyr)

# find the defective point
# data<-read.csv("train_imgs_selected_features.csv",header=T)
# center<-filter(test,img_name=="img_100000.jpg")
# test<-read.csv("test_imgs_selected_features.csv",header=T)
# set.seed(32)
# test_data<-test[sample(1:79726,2000),]
# test_data<-rbind(center,test_data)
# 

data<-read.csv("train_imgs_selected_features.csv")
colors = rainbow(length(unique(data$label)))
names(colors) = unique(data$label)
data<-data[sample(1:22424,2000),]
ecb = function(x,y){ plot(x,t='n'); text(x,labels=data$label, col=colors[data$label]) }
tsne_iris = tsne(data[,1:593], epoch_callback = ecb, perplexity=30)


# 
# tsne_iris = tsne(test_data[,1:593], epoch_callback = NULL, perplexity=50)
# 
# plot(tsne_iris[,1],tsne_iris[,2],pch=20,col="lightblue")
# points(tsne_iris[1,1],tsne_iris[1,2],col="red",pch=19)
# 
# 
# axis<-tsne_iris
# axis<-cbind(axis,as.character(test_data$img_name))
# 
# 
# d<-data.frame(axis)
# names(d)<-c("x","y","img_name")
# d$x<-as.numeric(as.character(d$x))
# d$y<-as.numeric(as.character(d$y))
# d$img_name<-as.character(d$img_name)
# center_x<-d[1,"x"]
# center_y<-d[1,"y"]
# seleted<-filter(d,(d$x-center_x)^2+(d$y-center_y)^2<=100/2 )
# seleted$img_name
# 
# 
# ###
# write.csv(d,file="ts.csv")
# 
# plot(x=d$x,y=d$y,col=colors[data$label])
# 
# data<-read.csv("ts.csv")
# data<-data[,-1]
# plot(data$x,data$y)
# 
# center<-data[2,]
# select<-filter(data, (x-center$x)^2+(y-center$y)^2<100)
# write.csv(select,file="timeseries_woman.csv")
# 
# center<-data[4,]
# select<-filter(data, (x-center$x)^2+(y-center$y)^2<100)
