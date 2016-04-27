library(imager)

# im<-load.image("img_34.jpg")
# plot(im)
# trippy<-imappend(list(im,im),"y")
# plot(trippy)



data<-read.csv("ts.csv")
data$img_name<-as.character(data$img_name)
data$label<-as.character(data$label)
data<-data[,-1]
xaxis<-range(data$x)

img_names<-matrix("_",nrow=40,ncol=50)
img_x<-matrix(0,nrow=40,ncol=50)
img_y<-matrix(0,nrow=50,ncol=50)

index<-order(data$x)
for (j in 1:50){
  t<-data[index[(j*40-39):(j*40)],]
  y_index<-order(t$y)
  for (i in 1:40){
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
for ( i in 1:40){
  for (j in 1:50){
    n<-n+1
    st<-paste(n,".jpg",sep="")
    im<-load.image(img_names[i,j])
    save.image(im,st)
  }
}

