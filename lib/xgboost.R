library(Matrix)
library(xgboost)
library(data.table)

# loading data
data<- fread('./output/train_imgs_unpack.csv')
test<- fread('./output/test_imgs_unpack.csv')
data<- as.data.frame(data)
test<- as.data.frame(test)
select_feature<- read.csv('./output/feature_select.csv')
#select data

new_data<- data[,as.vector(select_feature$feature)]
new_data$label<- data$label
data<- new_data

img_name<- test$img_name
new_data1<- test[,as.vector(select_feature$feature)]
test<- new_data1

#transfer data into matrix form

train_matrix<-data.matrix(data[,1:593])
train_matrix<-Matrix(train_matrix, sparse = TRUE)

test_matrix<-data.matrix(test)
test_matrix<-Matrix(test_matrix, sparse = TRUE)
# train_data<-xgb.DMatrix(train_matrix)

# get label
target<-rep(-1,dim(data)[1])

for (i in 1:dim(data)[1]){
     t<-data$label[i]
     if (t=="c8") { target[i]=1
     }else {target[i]=0}
}

for (i in 1:dim(data)[1]){
    t<-data$label[i]
    if (t=="c0") { target[i]=0
    } else if (t=="c1") { target[i]=1
    } else if (t=="c2") { target[i]=2
    } else if (t=="c3") { target[i]=3
    } else if (t=="c4") { target[i]=4
    } else if (t=="c5") { target[i]=5
    } else if (t=="c6") { target[i]=6
    } else if (t=="c7") { target[i]=7
    } else if (t=="c8") { target[i]=8
    } else if (t=="c9") { target[i]=9
    } else {target[i]=NA}
}

rm(i)
rm(t)

# set parameters for xgboost
para_final<-list(  max.depth = 9, eta = 0.3, min_child_weight = 1, subsample = 1,colsample_bytree = 0.9,
                   objective = "multi:softprob",num_class=10, gamma=0.4)

# apply xgboost model
model_final<-xgboost(data =train_matrix,label=target,params = para_final,booster="gbtree",eval_metric="mlogloss",
                     nrounds=60,set.seed=27,missing = NA,early.stop.round = 50,maximize=F)

# make prediction

prediction<- predict(model_final, test_matrix)
result<- matrix(prediction, ncol = 10, byrow = T)
result<- data.frame(result)
names(result)<- c("c0","c1","c2","c3","c4","c5","c6","c7","c8","c9") 
submission <- cbind(img=img_name,result)

submission <- submission[order(submission$img),]
write.csv(submission, file = "./output/submission.csv")


###########################################################################
# select important feature
importance_matrix <-xgb.importance(colnames(train_matrix), model = model_final)
# xgb.plot.importance(importance_matrix[1:50])
feature_importance<-data.frame(feature=importance_matrix$Feature,gain=importance_matrix$Gain)
m<-mean(feature_importance$gain)
feature_select<-feature_importance[which(feature_importance$gain>=m),]

save(model_final,feature_select,feature_importance,file="model.RData")
