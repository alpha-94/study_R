# chap14_Supervised_Learning

#################################################
## Chapter14. 회귀분석(Regression Analysis)
#################################################

## 1. 단순 회귀분석

# 연구가설 : 제품 적절성은 제품 만족도에 정(正)의 영향을 미친다.
# 연구모델 : 제품 적절성(독립변수) -> 제품 만족도(종속변수)

# 단순선형회귀 모델 생성  
# 형식) lm(formula = y ~ x 변수, data) # x:독립, y 종속, data=data.frame

getwd()
setwd("C:/workspaces/bigdata-master/R/data")
product <- read.csv("product.csv", header=TRUE)
View(product)
str(product) # 'data.frame':  264 obs. of  3 variables:

y = product$제품_만족도 # 종속변수
x = product$제품_적절성 # 독립변수
df <- data.frame(x, y)

# 회귀모델 생성 
l
result.lm <- lm(formula=y ~ x, data=df)


# 회귀분석의 절편과 기울기 
result.lm # 회귀계수 
#(Intercept-절편)      x(기울기)
#          0.7789         0.7393  
# Y = 0.7393X + 0.7789



# [실습] 모델의 적합값과 잔차 보기 
names(result.lm)
fitted.values(result.lm)[1:2]
#       1        2 
#3.735963 2.996687 

head(df, 1) # x=4, y=3
Y = 0.7789 + 0.7393 * 4  
Y # 3.7361 - 회귀방정식에 의해서 계산된 적합값 

# 오차(잔차:error) = Y관측값 - Y적합값 
3-3.735963  # -0.735963

residuals(result.lm)[1:2] # 모델의 잔차 출력 
-0.7359630 + 3.735963 # 잔차+적합값=관측값 

# [실습] 선형회귀분석 모델 시각화[오류 확인]
# x,y 산점도 그리기
x11()
plot(formula=y ~ x, data=df)
# 회귀분석
result.lm <- lm(formula=y ~ x, data=df)
# 회귀선 
abline(result.lm, col='red')

# [실습] 선형회귀분석 결과 보기
summary(result.lm)


## 2. 다중 회귀분석 

# - 여러 개의 독립변수 -> 종속변수에 미치는 영향 분석 X1,X2, ... , Xn
# 연구가설 : 음료수 제품의 적절성(x1)과 친밀도(x2)는 제품 만족도(y)에 정(正)의 영향을 미친다.
# 연구모델 : 제품 적절성(x1), 제품 친밀도(x2) -> 제품 만족도(y)

product <- read.csv("product.csv", header=TRUE)

# 적절성 + 친밀도 -> 만족도  
y = product$제품_만족도 # 종속변수
x1 = product$제품_친밀도 # 독립변수2
x2 = product$제품_적절성 # 독립변수1
df <- data.frame(x1, x2, y)

result.lm <- lm(formula=y ~ x1 + x2, data=df)

# 계수 확인 
result.lm
# 0.66731(y절편)      0.09593(x1)  0.68522(x2)  
# y = 0.09593 * x1 +  0.68522 * x2 + 0.66731;

# 다중공선성 문제 체크 
install.packages("car")
library(car)

vif(result.lm) # x1, x2 < 10 미만인지 체크.


# 다중회귀 분석 결과 보기 
summary(result.lm)


## - 다중공선성 문제 해결과 모델 성능평가

# [실습] 다중공선성 문제 확인

# (1) 패키지 설치 및 데이터 로딩 
# install.packages("car")
# library(car)
data(iris)

# (2) iris 데이터 셋으로 다중회귀분석
fit <- lm(formula=Sepal.Length ~ Sepal.Width+Petal.Length+Petal.Width, data=iris)
vif(fit) # 다중공선성
#Sepal.Width Petal.Length  Petal.Width 
#   1.270815    15.097572    14.234335 
sqrt(vif(fit))>2 # root(VIF)가 2 이상인 것은 다중공선성 문제 의심 

# (3) iris 변수 간의 상관계수 구하기
cor(iris[,-5]) # 변수간의 상관계수 보기(Species 제외) 
# x변수들끼리 계수값이 높을 수도 있다. -> 해당 변수 제거(모형 수정) <- Petal.Width

# [실습] 데이터 셋 생성과 회귀모델 생성

# (1) 학습데이터와 검정데이터 분류
x <- sample(1:nrow(iris), 0.7*nrow(iris)) # 전체중 70%만 추출
train <- iris[x, ] # 학습데이터 추출
test <- iris[-x, ] # 검정데이터 추출

# (2) 변수 제거 및 다중회귀분석 - Petal.Width 변수를 제거한 후 회귀분석 
# - 학습데이터 이용 모델 생성 
model <- lm(formula=Sepal.Length ~ Sepal.Width + Petal.Length, data=train)

# (3) 회귀방정식 도출 
model 
head(train, 1)
Y = 2.5860 + 0.6422 * 3.6 + 0.4893 * 6.1
Y # 7.22478

# (4) 예측치 생성 - predict()함수
# - 회귀분석 결과를 대상으로 회귀방정식을 적용한 새로운 값 예측(Y값)
pred <- predict(model, test)# x변수만 test에서 찾아서 값 예측
pred # test 데이터 셋의 y 예측치(회귀방정식 적용) 
test$Sepal.Length # test 데이터 셋의 y 관측치  
length(pred) # 45개 벡터

# (5) 회귀모델 평가 
cor(pred, test$Sepal.Length)
summary(pred); summary(test$Sepal.Length)


## 3. 로지스틱 회귀분석(Logistic Regression) 

# 목적 : 일반 회귀분석과 동일하게 종속변수와 독립변수 간의 관계를 나타내어 향후 예측 모델을 생성하는데 있다.

# 차이점 : 종속변수가 범주형 데이터를 대상으로 하며 입력 데이터가 주어졌을 때 해당 데이터의 결과가 특정 분류로 나눠지기 때문에 분류분석 방법으로 분류된다.

# 유형 : 이항형(종속변수가 2개 범주-Yes/No), 다항형(종속변수가 3개 이상 범주-iris 꽃 종류)

# 다항형 로지스틱 회귀분석 : nnet, rpart 패키지 이용 
# a : 0.6,  b:0.3,  c:0.1 -> a 분류 

# 분야 : 의료, 통신, 기타 데이터마이닝

# 선형회귀분석 vs 로지스틱 회귀분석 
# 1. 로지스틱 회귀분석 결과는 0과 1로 나타난다.(이항형)
# 2. 정규분포 대신에 이항분포를 따른다.
# 3. 로직스틱 모형 적용 : 변수[-무한대, +무한대] -> 변수[0,1]사이에 있도록 하는 모형 
#    -> 로짓변환 : 출력범위를 [0,1]로 조정
# 4. 종속변수가 2개 이상인 경우 더미변수(dummy variable)로 변환하여 0과 1를 갖도록한다.
#    예) 혈액형 A인 경우 -> [1,0,0,0] AB(1) -> A,B,O(0) one/hot encoding


# 단계1. 데이터 가져오기
weather = read.csv("weather.csv", stringsAsFactors = F) 
dim(weather)  # 366  15
head(weather)
View(weather)
str(weather)

# chr 컬럼, Date, RainToday 칼럼 제거 
weather_df <- weather[, c(-1, -6, -8, -14)]
str(weather_df)

# RainTomorrow 칼럼 -> 로지스틱 회귀분석 결과(0,1)에 맞게 더미변수 생성      
weather_df$RainTomorrow[weather_df$RainTomorrow=='Yes'] <- 1
weather_df$RainTomorrow[weather_df$RainTomorrow=='No'] <- 0
weather_df$RainTomorrow <- as.numeric(weather_df$RainTomorrow)
View(weather_df) # head(weather_df)
str(weather_df)
summary(weather_df)
length(weather_df$MinTemp)
weather_df <- na.omit(weather_df)

#  단계2.  로지스틱 회귀분석(Logistic Regression)
idx <- sample(1:nrow(weather_df), nrow(weather_df)*0.7)
train <- weather_df[idx, ]
test <- weather_df[-idx, ]


#  단계3.  로지스틱  회귀모델 생성 : 학습데이터 
weater_model <- glm(RainTomorrow ~ ., data = train, family = 'binomial')
weater_model 
summary(weater_model) 


# 단계4. 로지스틱  회귀모델 예측치 생성  
# newdata=test : 새로운 데이터 셋, type="response" : 0~1 확률값으로 예측 
pred <- predict(weater_model, newdata=test, type="response")  
pred 
summary(pred)
str(pred)

# 예측치 : 0과 1로 변환(0.5)
result_pred <- ifelse(pred >= 0.5, 1, 0)
result_pred
table(result_pred)

# 단계5. 모델 평가 : 분류정확도  
table(result_pred, test$RainTomorrow) # 00 :89 / 01 : 9 / 10 : 4 / 11 : 8 --> 11 과 00 이 맞춘 값 10,01 은 빗나간 값 

# 모델의 분류정확도 
(80+13) / (80+12+4+13) # 0.853211 = 85.3%
(89 + 8) /(89+9+4+8) # 0.8818182 = 88.1%

# 단계6. ROC Curve를 이용한 모델 평가
# Receiver Operating Characteristic
install.packages("ROCR")
library(ROCR)

# ROCR 패키지 제공 함수 : prediction() -> performance
pr <- prediction(pred, test$RainTomorrow)
pr
prf <- performance(pr, measure = "tpr", x.measure = "fpr")
plot(prf)


## 4. 분류분석(Decision Tree)

# - 종속변수(y변수) 존재
# - 종속변수 : 예측에 Focus을 두는 변수
# - 비 모수 검정 : 선형성, 정규성, 등분산성 가정 필요없음
# - 단점 : 유의수준 판단 기준 없음(추론 기능 없음)
# - 규칙(Rule)을 기반으로 의사결정트리 생성


## 1. party 패키지 적용 분류분석

## [실습1] ctree 함수 이용 의사결정트리 생성하기

# 단계1 : part패키지 설치
install.packages("party")
library(party) # ctree() 제공

# 단계2 : airquality 데이터 셋 로딩
library(datasets)
str(airquality)

# 단계3 : formula 생성
formula <-  Temp ~ Solar.R +  Wind + Ozone

# 단계4 : 분류모델 생성 : formula를 이용하여 분류모델 생성 
air_ctree <- ctree(formula, data=airquality)
air_ctree

# 단계5  : 분류분석 결과
plot(air_ctree)

# 분류조건 subset 작성/확인 
result <- subset(airquality, Ozone <= 37 & Wind > 15.5)
summary(result$Temp)


## [실습2] 학습데이터와 검정데이터 샘플링으로 분류분석하기 

#단계1 : 학습데이터와 검증데이터 샘플링
set.seed(1234) # 메모리에 시드값 적용 - 동일값 생성 
idx <- sample(1:nrow(iris), nrow(iris) * 0.7) 
train <- iris[idx,] 
test <- iris[-idx,]  

# 단계2 : formula 생성 
#  -> 형식) 변수 <- 종속변수 ~ 독립변수
formula <- Species ~ Sepal.Length+Sepal.Width+Petal.Length+Petal.Width 

#단계3 : 학습데이터 이용 분류모델 생성(ctree()함수 이용)
iris_ctree <- ctree(formula, data=train) # 학습데이터로 분류모델(tree) 생성
iris_ctree # Petal.Length,Petal.Width 중요변수

#단계4 : 분류모델 플로팅
# plot() 이용 - 의사결정 트리로 결과 플로팅
plot(iris_ctree, type="simple") 
plot(iris_ctree) # 의사결정트리 해석

result <- subset(train, Petal.Length > 1.9 & Petal.Width <= 1.6 & Petal.Length > 4.6)
result$Species
length(result$Species) # 8
table(result$Species)
#setosa versicolor  virginica 
#     0          5          3 

#단계5 : 분류모델 평가 

# (1) 모델 예측치 생성과 혼돈 매트릭스 생성 
pred <- predict(iris_ctree, test) # 45
pred # Y변수의 변수값으로 예측 

table(pred, test$Species)
#pred         setosa versicolor virginica
#setosa         16          0         0   <- missing : 0
#versicolor      0         15         1   <- missing : 1
#virginica       0          1        12   <- missing : 1

# (2) 분류정확도 
(16+15+12) / nrow(test) # 0.956

