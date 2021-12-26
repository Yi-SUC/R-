install.packages("GD")     
library(GD)                
#��ȡ�ļ�
inputdata <- read.csv("C:/Users/User/Desktop/det/testdata.csv", header = TRUE, sep = ",")  
head(inputdata)
#GD�������ṩ���ּල��ɢ�����������д���Կռ����ݽ�����ɢ������
discmethod <- c("equal","natural","quantile","geometric","sd")   
#�ռ�������ɢ���ֳ�3~7�࣬��Ȼ�����Լ�����ʵ������޸�
discitv <- c(4:7)
#odc1 <- optidisc(Y~X1,data = inputdata,discmethod,discitv)#��Y~X1��ָ��X1����
odc1 <- optidisc(Y~.,data = inputdata,discmethod,discitv)#(Y~.)��ʾ���б���
odc1
plot(odc1)

##-----����̽��-----##

#1��һ���������
g1 <- gd(Y~X1,data = inputdata)# �Ա���X1�������Y��Ӱ��
g1
plot(g1)
#2������������
g2 <- gd(Y~. ,data = inputdata[,1:3])#[,1:3]��ʾ����ǰ3�У������������ѡȡ���������������
g2
plot(g2)
#3�����������������ڵĶ����
discmethod <- c("equal","natural","quantile","geometric","sd")
discitv <- c(4:7)
data.ndvi <- inputdata
data.continuous <- data.ndvi[,c(1,2:7)]#��ȡ�����Ա�����1��ʾ��1�е������Y��2:7��ʾ�Ա�����2�е���7��
odc1 <- optidisc(Y~ ., data = data.continuous,discmethod, discitv)
data.continuous <- do.call(cbind, lapply(1:2, function(x)
data.frame(cut(data.continuous[, -1][, x], unique(odc1[[x]]$itv), include.lowest = TRUE))))
data.ndvi[, 2:7] <- data.continuous
g3 <- gd(Y ~ ., data = data.ndvi)
g3
plot(g3)

##-----����̽��-----##

#1��һ���������
rm1 <- riskmean(Y ~ X1+X2, data = data.ndvi)# �Ա���X1�������Y��Ӱ��
rm1
plot(rm1)
#2������������
rm2 <- riskmean(Y~. ,data = data.ndvi)
rm2
plot(rm2)
#3�����������������ڵĶ����
gr1 <- gdrisk(Y~X1+X2,data = data.ndvi)#��ʾ����
gr1
plot(gr1)

gr2 <- gdrisk(Y~., data = data.ndvi)
gr2
plot(gr2)

##-----����̽��-----##

# categorical explanatory variables
gi1 <- gdinteract(Y ~ X1+X2, data = data.ndvi)
gi1
plot(gi1)
# multiple variables inclusing continuous variables
gi2 <- gdinteract(Y~. , data = data.ndvi)
gi2
plot(gi2)

##-----��̬̽��-----##

# categorical explanatory variables
ge1 <- gdeco(Y ~ X1 + X2, data = data.ndvi)
ge1
# multiple variables inclusing continuous variables
gd3 <- gdeco(Y~., data = data.ndvi)
gd3
plot(gd3)

##-----�ռ�߶�Ӱ�����-----##

ndvilist <- list(ndvi_20, ndvi_30, ndvi_40, ndvi_50)
su <- c(20,30,40,50) ## sizes of spatial units
## "gdm" function
gdlist <- lapply(ndvilist, function(x){
  gdm(NDVIchange ~ Climatezone + Mining + Tempchange + GDP, 
      continuous_variable = c("Tempchange", "GDP"),
      data = x, discmethod = "quantile", discitv = 6)
})
sesu(gdlist, su) ## size effects of spatial units
discmethod <- c("equal","natural","quantile")
discitv <- c(4:6)


##-----һ������ĸ�̽��-----##

#"gdm"function
# ����X1\X2 �Ƿ�������������������������á���
# ����X3\X4 �����������������¡���ˮ��������GDP��
ndvigdm <- gdm(Y~X1 + X2 + X3 + X4 + X5 + X6,
               continuous_variable = c("X1","X2","X3","X4","X5","X6"), ##ѡȡ��������
               data = inputdata,
               discmethod = discmethod,discitv = discitv)
ndvigdm
plot(ndvigdm)



