library(datasets)
library(tsne)
library(readr)
library(dplyr)
library(imager)

data<-read.csv("playground.csv")
data<-data[,-2]
st<-strsplit(as.character(data[,1]),"/")
img_name<-rep(" ",105)
for (i in 1:105){
  img_name[i]<-st[[i]][10]
}

axis0 = tsne(data[,2:4097], epoch_callback = NULL, perplexity=20,initial_dims=4096,max_iter=5000)

axis<-cbind(axis0,img_name)
axis<-axis[sample(1:105,100),]
axis<-as.data.frame(axis)
names(axis)<-c("x","y","img_name")
axis$x<-as.numeric(as.character(axis$x))
axis$y<-as.numeric(as.character(axis$y))
axis$img_name<-as.character(axis$img_name)

img_names<-matrix("_",nrow=10,ncol=10)
img_x<-matrix(0,nrow=10,ncol=10)
img_y<-matrix(0,nrow=10,ncol=10)

index<-order(axis$x)

for (j in 1:10){
  t<-axis[index[(j*10-9):(j*10)],]
  y_index<-order(t$y)
  for (i in 1:10){
    img_names[i,j]<-t[y_index[i],"img_name"] 
    img_x[i,j]<-t[y_index[i],"x"] 
    img_y[i,j]<-t[y_index[i],"y"]
  }
}

# for (i in 1:40){
#   for (j in 1:50){
#     im<-load.image(img_names[i,j])
#     if (j==1) { images<-im} else{
#       images<-imappend(list(images,im),"x")
#     }
#     
#   }
#   if (i==1){ all_images<-images} else {
#     all_images<-imappend(list(all_images,images),"y")
#   }
#   rm(images)
# }


n<-0
for ( i in 1:10){
  for (j in 1:10){
    n<-n+1
    st<-paste(n,".jpg",sep="")
    im<-load.image(img_names[i,j])
    save.image(im,st)
  }
}
