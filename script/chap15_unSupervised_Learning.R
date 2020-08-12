# chap15_unSupervised_Learning

##################################################
## Chapter15-1. 군집 분석(Clustering Analysis)
##################################################

## 1. 유클리디안 거리
# 유클리디안 거리(Euclidean distance)는 두 점 사이의 거리를 계산하는 방법으로, 이 거리를 이용하여 유클리드 공간을 정의한다.
# 비지도 학습의 핵심 :: 데이터 간 유사성을 찾아야 하고, 그 유사성을 찾기위해 리코딩을 해야하며, 각 데이터간의 영향도, 중요도, 적용의 비율성을 찾는다. 
# 거리가 가까운 것들로부터 군집을 생성 (계층적 군집분석)


# [실습] 유클리디안 거리 계산법

# 단계 1 : matrix 객체 생성
x <- matrix(1:9, nrow=3, byrow = T) 
x

# 단계 2 : 유클리디안 거리 생성 
dist <- dist(x, method="euclidean") # method 생략가능 default :: euclidean
dist
#           1         2
# 2  5.196152          
# 3 10.392305  5.196152

?dist # dist {stats}


# (3) 유클리드 거리 계산식의 R코드

# 1행과 2행 변량의 유클리드 거리 구하기
sqrt(sum((x[1,] - x[2, ])^2)) # 5.196152
# 1행과 3행 변량의 유클리드 거리 구하기
sqrt(sum((x[1,] - x[3, ])^2)) # 10.3923


## 2. 계층적 군집분석(탐색적 분석)

# [실습] 유클리디안 거리를 이용한 군집화

# 단계 1 : 군집분석(Clustering)분석을 위한 패키지 설치
install.packages("cluster") 
library(cluster) 

# 단계 2 :  데이터 셋 생성
x <- matrix(1:9, nrow=3, by=T) 
x

# 단계 3 : matrix 대상 유클리드 거리 생성 함수
dist <- dist(x, method="euclidean") # method 생략가능
dist

# 단계 4 : 유클리드 거리 matrix를 이용한 클러스터링
hc <- hclust(dist) # 클러스터링 적용
hc
# 단계 5 : 클러스터 시각화 
x11()
plot(hc) # 1과2 군집(클러스터) 형성


# [실습] 신입사원 면접시험 결과 군집분석

# 단계 1 : 데이터 셋 가져오기
getwd()
setwd("C:/workspaces/bigdata-master/R/data")
interview <- read.csv("interview.csv", header=TRUE)
names(interview)
View(interview)

# 단계 2 : 유클리디안 거리 계산 
interview_df <- interview[c(2:7)]
View(interview_df)
idist<- dist(interview_df) # no, 종합점수, 합격여부 제거 
head(idist)
# 단계 3 : 계층적 군집분석
hc <- hclust(idist)
hc

# 단계 4 : 군집분석 시각화
x11()
plot(hc, hang=-1) # 덴드로그램에서 음수값을 제거할 수 있음.

# 단계 5 :  군집 단위 테두리 생성 
rect.hclust(hc, k=3, border="red") # 3개 그룹 선정, 선 색 지정

## [실습] 군집별 특징 보기 

# 단계 1 : 각 그룹별 서브셋 만들기
g1<- subset(interview, no==108| no==110| no==107| no==112 | no==115)
g2<- subset(interview, no==102| no==101| no==104| no==106 | no==113)
g3<- subset(interview, no==105| no==114| no==109| no==103 | no==111)


# 단계 2 : 그룹 요약통계량  
table(g1$합격여부)
table(g2$합격여부)
table(g3$합격여부)
summary(g1) # 불합격:5, 자격증 없음.
summary(g2) # 합격:5, 자격증 있음.
summary(g3) # 불합격:5, 자격증 없음+있음.


##  3. 군집 수 자르기
# [실습] iris 데이터 셋을 대상으로 군집 수 자르기 

# 단계 1 : 유클리드안 거리 계산 
idist<- dist(iris[1:4]) # dist(iris[, -5])

# 계층형 군집분석(클러스터링)
hc <- hclust(idist)
hc
plot(hc, hang=-1)
rect.hclust(hc, k=4, border="red") # 4개 그룹수 

# 단계 2 :  군집 수 자르기
ghc<- cutree(hc, k=3) # stats 패키지 제공
ghc #  150개(그룹을 의미하는 숫자(1~3) 출력)

# 단계 3 : iris에서 ghc 컬럼 추가
iris$ghc <- ghc
#head(iris)
View(iris)
table(iris$ghc) # ghc 빈도수
head(iris,60) # ghc 칼럼 확인 
tail(iris,60)
iris

# 단계 4 : 요약통계량 구하기
g1 <- subset(iris, ghc==1)
summary(g1[1:4])

g2 <- subset(iris, ghc==2)
summary(g2[1:4])

g3 <- subset(iris, ghc==3)
summary(g3[1:4])


## 4. 비계층적 군집분석 

#[실습] ggplot2 패키지에서 제공되는 diamonds 데이터 셋을 대상으로 계층적 군집분석으로 시각화하는 군집 수를 파악한 후 k-means 알고리즘에 군집수를 적용하여 군집별로 시각화하는 방법.

# 단계 1 : 군집분석에 사용할 변수 추출 
install.packages("ggplot2", dependencies = T)
library(ggplot2)
data(diamonds)
dim(diamonds) # [1] 53940    10
t <- sample(1 : nrow(diamonds),1000) # 1000개 데이터 샘플링 
test <- diamonds[t, ] # 1000개 표본 추출
dim(test) # [1] 1000 10

head(test) # 검정 데이터
mydia <- test[c("price","carat", "depth", "table")] # 4개 칼럼만 선정
head(mydia)

# 단계 2 : 계층적 군집분석(탐색적 분석)
# 이전단계 사용할 때 dist 함수 이용 후 데이터 넣었을때  default :: euclidean
result <- hclust(dist(mydia), method="average") # 평균거리 이용 
result

# 군집 방법(Cluster method) 
# method = "complete" : 완전결합기준(최대거리 이용) <- default(생략시)
# method = "single" : 단순결합기준(최소거리 이용) 
# method = "average" : 평균결합기준(평균거리 이용) 

plot(result, hang=-1) # hang : -1 이하 값 제거

# 단계 3 :  비계층적 군집분석
result2 <- kmeans(mydia, 3) # 3개 군집 수 적용.
names(result2) # cluster 칼럼 확인 

result2$cluster # 각 케이스에 대한 소속 군집수(1,2,3)
table(result2$cluster)
result2$centers # 각 군집 중앙값

# 원형데이터에 군집수 추가
mydia$cluster <- result2$cluster
head(mydia) # cluster 칼럼 확인 

# 단계 4 :  변수 간의 상관계수 보기 
cor(mydia[,-5], method="pearson") # 상관계수 보기 
plot(mydia[,-5])

 # 상관계수 색상 시각화 
install.packages('mclust')
install.packages('corrgram')
library(mclust)
library(corrgram) # 상관성 시각화 
corrgram(mydia[,-5]) # 색상 적용 - 동일 색상으로 그룹화 표시
corrgram(mydia[,-5], lower.panel = panel.conf) # 수치(상관계수) 추가(위쪽upper , lower)


# 단계 5 : 비계층적 군집시각화
plot(mydia$carat, mydia$price, col=mydia$cluster)
# 중심점 표시 추가 
points(result2$centers[,c("carat", "price")], col=c(3,1,2), pch=8, cex=5)



#################################################
## Chapter15-2. 연관 분석(Association Analysis)
#################################################
# -연관분석은 군집분석에 의해서 그룹핑된 cluster를 대상으로 해당
#  그룹에 대한 특성을 분석하는 방법으로 장바구니 분석으로 알려짐.
# -즉 유사한 개체들을 클러스터로 그룹화하여 각 집단의 특성 파악.
# -대용량 데이터베이스에서는 전체 데이터를 유사한 클러스터로 
#  묶어서 관찰 및 분석하는 것이 더 효율적이다.

# 특징
# - 데이터베이스에서 사건의 연관규칙을 찾는 무방향성 데이터마이닝 기법                                            
# - 무방향성(x -> y변수 없음) -> 비지도 학습에 의한 패턴 분석 방법
# - 사건과 사건 간 연관성(관계)를 찾는 방법(예:기저귀와 맥주)
# - A와 B 제품 동시 구매 패턴(지지도)
# - A 제품 구매 시 B 제품 구매 패턴(신뢰도)
# - A 제품과 B 제픔간의 상관성(향상도)


# 예) 장바구니 분석 : 장바구니 정보를 트랜잭션(상품 거래 정보)이라고 하며,
# 트랜잭션 내의 연관성을 살펴보는 분석기법
# 분석절차 : 거래내역 -> 품목 관찰 -> 상품 연관성에 대한 규칙(Rule) 발견

# 활용분야
# - 대형 마트, 백화점, 쇼핑몰 등에서 고객의 장바구니에 들어있는 품목 간의 관계를 탐구하는 용도
# ex) 고객들은 어떤 상품들을 동시에 구매하는가?
#   - 맥주를 구매한 고객은 주로 어떤 상품을 함께 구매하는가?

# - 대형 마트,백화점, 쇼핑몰 판매자 -> 고객 대상 상품추천, 마케팅
# 1) 고객 대상 상품추천 및 상품정보 발송  
#     -> ex) A고객에 대한 B 상품 쿠폰 발송
# 2) 텔레마케팅를 통해서 패키지 상품 판매 기획 및 홍보 
# 3) 상품 진열 및 show window 상품 display


## 1. 연관규칙 평가 척도

# 연관규칙의 평가 척도
# 1. 지지도(support) : 전체자료에서 A를 구매한 후 B를 구매하는 거래 비율 
#  A->B 지지도 식 
#  -> A와 B를 포함한 거래수 / 전체 거래수
#  -> n(A, B) : 두 항목(A,B)이 동시에 포함되는 거래수
#  -> n : 전체 거래 수

# 2. 신뢰도(confidence) : A가 포함된 거래 중에서 B를 포함한 거래의 비율(조건부 확률)
# A->B 신뢰도 식
#  -> A와 B를 포함한 거래수 / A를 포함한 거래수

# 3. 향상도(Lift) : 하위 항목들이 독립에서 얼마나 벗어나는지의 정도를 측정한 값
# 향상도 식
#  -> 신뢰도 / B가 포함될 거래율
# 분자와 분모가 동일한 경우 : Lift == 1, A와 B가 독립(상관없음)
# 분자와 분모가 동일한 경우 : Lift != 1, x와 y가 독립이 아닌 경우(상관있음)


# [실습]  트랜잭션 객체를 대상으로 연관규칙 생성 

# 단계 1 : 연관분석을 위한 패키지 설치
install.packages("arules")
library(arules) #read.transactions()함수 제공

# 단계 2 : 트랜잭션(transaction) 객체 생성
getwd()
setwd("C:/workspaces/bigdata-master/R/data")
tran<- read.transactions("tran.txt", format="basket", sep=",") # 트랜잭션 객체 생성.
tran      # 6개의 트랜잭션과 5개의 항목(상품) 생성.

# 단계 3 : 트랜잭션 데이터 보기
inspect(tran)

# 단계 4 : 규칙(rule) 발견
rule<- apriori(tran, parameter = list(supp=0.3, conf=0.1)) # writing ... [16 rule(s)] done [0.00s]. 높으면 높을수록 규칙을 까다롭게 설정 
inspect(rule) # 규칙 보기
rule<- apriori(tran, parameter = list(supp=0.1, conf=0.1)) # writing ... [35 rule(s)] done [0.00s]. 낮으면 낮을수록 규칙을 더 많이 찾음 
inspect(rule) # 규칙 보기


## 2. 트랜잭션 객체 생성 

# [실습]  single 트랜잭션 객체 생성 
stran <- read.transactions("demo_single",format="single",cols=c(1,2)) 
# single : 트랜잭션 구분자(Transaction ID)에 의해서 상품(item)이 대응된 경우이고, basket : 여러 개의 상품(item)으로 구성된 경우(Transaction ID 없이 여러 상품으로만 구성된 경우)
# cols : single인 경우 읽을 컬럼 수 지정(basket은 생략)
inspect(stran)

# [실습] 중복 트랜잭션 제거

# 단계 1 : 트랜잭션 데이터 가져오기
stran2<- read.transactions("single_format.csv", format="single", sep=",", cols=c(1,2), rm.duplicates=T) # sep:각 상품(item)을 구분하는 구분자 지정.

# 단계 2 : 트랜잭션과 상품 수 확인
stran2
inspect(stran2)

# 단계 3 : 요약 통계 제공 
summary(stran2) # 248개 트랜잭션에 대한 기술통계 제공
inspect(stran2) # 트랜잭션 확인 


# [실습] 규칙 발견(생성)

# 단계 1 : 규칙 생성하기 
astran2 <- apriori(stran2) # supp=0.1, conf=0.8와 동일함 
#astran2 <- apriori(stran2, parameter = list(supp=0.1, conf=0.8))
astran2 # set of 102 rules
attributes(astran2)

# 단계 2 : 발견된 규칙 보기 
inspect(astran2)

# 단계 3 : 상위 6개 향상도 내림차순으로 정렬하여 출력 
inspect(head(sort(astran2, by="lift")))


# [실습] basket 트랜잭션 객체 생성
btran <- read.transactions("demo_basket",format="basket",sep=",") # 트랜잭션 구분자(Transaction ID) 없이 상품으로만 구성된 데이터 셋을 대상으로 트랜잭션 객체를 생성할 경우 format="basket" 속성 지정.
inspect(btran) # 트랜잭션 데이터 보기


## 3. 연관규칙 시각화

# [실습] Adult 데이터 셋 가져오기
data(Adult) # arules에서 제공되는 내장 데이터 로딩
str(Adult) # Formal class 'transactions' , 48842(행)
Adult

# [실습] 트랜잭션 관련 정보보기
attributes(Adult)# 트랜잭션의 변수와 범주 보기
data(AdultUCI)
str(AdultUCI) # 'data.frame':	48842 obs. of  2 variables:
names(AdultUCI)

# [실습]  Adult 데이터 셋의 요약 통계량 보기 

# 단계 1 : data.frame 형식으로 보기
adult <- as(Adult, 'data.frame')
str(adult)  
head(adult)

# 단계 2 : 요약 통계량
summary(Adult)


# [실습] 신뢰도 80%, 지지도 10% 적용된 연관규칙 발견   
ar<- apriori(Adult, parameter = list(supp=0.1, conf=0.8)) #6137 rule(s) deafult

# [실습] 다양한 신뢰도와 지지도 적용  예 

# 단계 1 : 지지도를 20%로 높인 경우 1,306개 규칙 발견
ar1<- apriori(Adult, parameter = list(supp=0.2)) 

# 단계 2 : 지지도 20%, 신뢰도 95% 높인 경우 348개 규칙 발견
ar2<- apriori(Adult, parameter = list(supp=0.2, conf=0.95)) # 신뢰도 높임

# 단계 3 : 지지도 30%, 신뢰도 95% 높인 경우 124개 규칙 발견
ar3<- apriori(Adult, parameter = list(supp=0.3, conf=0.95)) # 신뢰도 높임

# 단계 4 :  지지도 35%, 신뢰도 95% 높인 경우 67 규칙 발견
ar4<- apriori(Adult, parameter = list(supp=0.35, conf=0.95)) # 신뢰도 높임

# 단계 5 :  지지도 40%, 신뢰도 95% 높인 경우 36 규칙 발견
ar5<- apriori(Adult, parameter = list(supp=0.4, conf=0.95)) # 신뢰도 높임


# [실습] 규칙 결과보기

# 단계 1 : 상위 6개 규칙 보기
inspect(head(ar5)) 

# 단계 2 :  confidence(신뢰도) 기준 내림차순 정렬 상위 6개 출력
inspect(head(sort(ar5, decreasing=T, by="confidence")))

# 단계 3 :  lift(향상도) 기준 내림차순 정렬 상위 6개 출력
inspect(head(sort(ar5, by="lift"))) 


# [실습] 연관규칙 시각화

# 단계 1 : 패키지 설치 
install.packages("arulesViz") 
library(arulesViz) 

# 단계 2 : 연관규칙 시각화
plot(ar3, method='graph', control=list(type='items'))


# [실습] Groceries 데이터 셋으로 연관분석하기

# 단계 1 :  Groceries 데이터 셋 가져오기
library(arules)
data("Groceries")  # 식료품점 데이터 로딩
str(Groceries) # Formal class 'transactions' [package "arules"] with 4 slots
Groceries

# 단계 2 : data.frame으로 형 변환
Groceries.df<- as(Groceries, "data.frame")
head(Groceries.df)

# 단계 3 : 지지도 0.001, 신뢰도 0.8 적용 규칙 발견(410 rule(s))
rules <- apriori(Groceries, parameter=list(supp=0.001, conf=0.8))
inspect(rules) 

# 단계 4 : 규칙을 구성하는 왼쪽(LHS) -> 오른쪽(RHS)의 item 빈도수 보기 
library(arulesViz)
plot(rules, method="grouped")

# [실습] 최대 길이 3이하 규칙 생성
rules <- apriori(Groceries, parameter=list(supp=0.001, conf=0.80, maxlen=3))
# writing ... [29 rule(s)] done [0.00s].
inspect(rules) # 29개 규칙

# [실습] confidence(신뢰도) 기준 내림차순으로 규칙 정렬
rules <- sort(rules, decreasing=T, by="confidence")
inspect(rules) 

# [실습] 발견된 규칙 시각화
library(arulesViz) # rules값 대상 그래프를 그리는 패키지
plot(rules, method="graph", control=list(type="items"))


