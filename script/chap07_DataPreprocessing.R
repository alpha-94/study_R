#chap07_DataPreprocessing

#################################
# chapter07. 데이터 전처리 
#################################

# - 자료분석에 필요한 데이터를 대상으로 불필요한 데이터를 처리하는 필터링과 전처리 방법에 대해서 알아본다.

# 1. EDA(Exploratory data Analysis) - 탐색적 자료 분석
# : 수집한 자료를 다양한 각도에서 관찰하고 이해하는 과정으로 그래프나 통계적 방법을 이용해서 자료를 직관적으로 파악하는 과정 

# 1.1 데이터 셋 보기

# 데이터 가져오기 
getwd()
setwd( "C:/workspaces/bigdata-master/R/data")

dataset <- read.csv("dataset.csv", header = T)
head(dataset) # 300 entries, 7 total columns By View data

# 1) 데이터 조회
#     - 탐색적 데이터 분석을 위한 데이터 조회 

# 전체 데이터 보기
print(dataset) # 콘솔창 출력
View(dataset) # utils package 뷰어창 출력 

# 데이터의 앞부분과 뒷부분 보기
head(dataset) # 상위 6개 (default :: 6 rows)
tail(dataset) # 하위 6개 (default :: 6 rows)

# 1.2 데이터 셋 구조 보기

# 데이터 셋 구조 
names(dataset) # 변수명 (컬럼명)
attributes(dataset) #   $names / $class / $row.names(행의 이름이 없기 때문에 디폴트로 순서 출력)
str(dataset) # 데이터 구조보기 :: 자료구조 / 관측치(행) / 컬럼(열) / 컬럼별 자료형

# 1.3 데이터 셋 조회
dataset$age # 데이터 셋 접근 방법
dataset$resident

length(dataset) # 7 : 컬럼의 개수
length(dataset$age) # 300 : 특정 컬럼을 지정하면 레코드(행)의 개수

# 조회 결과 변수 저장
x <- dataset$gender
y <- dataset$price

# 산점도 형태로 변수 조회 
plot(x, y) # 성별과 가격분포 - 극단치 발견 

plot(dataset$price)

#["컬럼명"] 형식으로 특정변수 조회
dataset["gender"]#dataset$gender
dataset["price"]

# [색인(index)] 데이터 셋 조회 // 색인 = 컬럼 인덱스
dataset[2] # 두번째 컬럼 (gender) - 출력형태 :: 열중심!
dataset[6] # price
dataset[3,] # 3행 전체 
dataset[,3] # 3열 전체

# 두개 이상의 [색인(index)] 형식으로 변수 조회
dataset[c("price","job")] # 컬럼명 직접 명시
dataset[c(2,6)] # gender , price 색인 명시

dataset[c(1,2,3)] # resident gender job
dataset[c(1:3)]
dataset[1:3]

dataset[c(2,4:6,3,1)] # gender age position  price job resident 기본 저장 순서가 아님 커스텀이 가능함 

dataset[-c(2)] # dataset[c(1, 3:7)] # resident job age position  price survey

#dataset 의 특정 행/열을 조회하는 경우
dataset[, c(2:4)]
dataset[c(2:4),]
dataset[-c(1:100),]

# 결측치(NA) 처리 

# 2.1 결측치 확인

# summary() 요약 기술 통계량
summary(dataset$price) # NA's  ::  30 

# 2.2 격측치 제거

#sum() 함수에서 제공되는 속성 이용 
sum(dataset$price, na.rm = T) #  2362.9

# 결측 데이터 제거 함수 이용
price2 <- na.omit(dataset$price)
sum(price2)
length(price2) # 270 // NA :: 30 개 이기 때문에 !

# 2.3 결측치 대체 

# 결측치를 0으로 대체하기
x <- dataset$price # price vector 백터 생성
head(x)
dataset$price2 <- ifelse(!is.na(x), x, 0) # 컬럼 새로 추가 
View(dataset)
sum(dataset$price2)

# 결측치를 평균을 대체하기
x <- dataset$price # price vector 백터 생성
head(x)
dataset$price3 <- ifelse(!is.na(x), x, round(mean(x,na.rm = T),2)) #  mean(x,na.rm = T) = 8.75
View(dataset)
sum(dataset$price3)

# 3. 이상치(극단치) 처리

# 3.1 범주(catalog)형 변수 이상치 처리 - 이산변수

# 범주형 변수의 이상치 확인
table(dataset$gender) # 빈도수 체크 
# 0   1   2   5 // 요인(범주)
# 2 173 124   1 // 요인(범주) 빈도수
# 1,2 의 값이 아닌 0,5 데이터의 이상치 발견

pie(table(dataset$gender)) # 파이차트

# subset() 함수를 이용한 데이터 정제
dataset <-  subset(dataset,gender==1 | gender==2) 
# 무조건 다른 값으로 대체하는 개념을 적용하기 보단 성별의 경우 임의의 값을 지정할 경우 데이터 셋의 값이 왜곡(무의미의 값)될 가능성이 있다. 
# 그래서 값을 대체하기 보단 레코드가 3개밖에 없으니 그냥 삭제 

length(dataset$gender) # 297
pie(table(dataset$gender))

# 3.2 연속형 변수의 이상치 처리
dataset <- read.csv('dataset.csv', header = T)
str(dataset)
plot(dataset$price)
summary(dataset$price)

# price 변수의 데이터 정제와 시각화 
dataset2 <- subset(dataset, price >=2  & price <=8)
length(dataset2$price) # 300 중에서 251개 필터
stem(dataset2$price) # 줄기와 잎 도표

# The decimal point is at the |
#2 | 133                                  (2.0~2.4)
#2 |                                      (2.5~2.9)   이런식으로  .0 부터 .9 까지의 개수 출력
#3 | 0000003344
#3 | 55555888999
#4 | 000000000000000111111111222333334444
#4 | 566666777777889999
#5 | 00000000000000000011111111111222222222333333344444
#5 | 55555555566667777778888899
#6 | 00000000000000111111112222222222222333333333333333344444444444
#6 | 55557777777788889999
#7 | 000111122
#7 | 777799

# age 변수에서 NA 발견 -> 정수형 연속변수
summary(dataset2$age) # NA's - 16개
boxplot(dataset2$age)

# 4. 코딩 변경 

# 4.1 가독성을 위한 코딩 변경 
table(dataset2$resident)
#  1   2   3   4   5 
#111  47  27  15  34 

dataset2$resident2[dataset2$resident ==1]<- '1. 서울특별시' 
dataset2$resident2[dataset2$resident ==2]<- '2. 인천광역시' 
dataset2$resident2[dataset2$resident ==3]<- '3. 대전광역시' 
dataset2$resident2[dataset2$resident ==4]<- '4. 대구광역시' 
dataset2$resident2[dataset2$resident ==5]<- '5. 시구군' 

dataset2[c('resident','resident2')]
View(dataset2)

# job 컬럼을 대상으로 코딩 변경하기
dataset2$job2[dataset2$job == 1] <- '공무원'
dataset2$job2[dataset2$job == 2] <- '회사원'
dataset2$job2[dataset2$job == 3] <- '개인사업'

dataset2[c('job','job2')]

# 4.2 척도 변경을 위한 코딩 변경 

# 나이(age) 변수[연속형 변수] 를 연령층 (청년,중년,장년)[이산형 변수] 으로 코딩 변경하기 
dataset2$age2[dataset2$age <= 30] <- "청년층"
dataset2$age2[dataset2$age > 30 & dataset2$age <= 55] <- "중년층"
dataset2$age2[dataset2$age > 55 ] <- "장년층"

# 4.3 역코딩을 위한 코딩 변경
survey <- dataset2$survey
csurvey <- 6-survey
barplot(table(survey),col = rainbow(5),ylim = c(0,130)) # 시각화
barplot(table(csurvey),col = rainbow(5),ylim = c(0,130)) # 시각화

dataset2$survey2 <- csurvey
mean(dataset2$survey2, na.rm = T) # 3.358566

# 5. 탐색적 분석을 위한 시각화 

# 5.1 범주형 VS 범주형 
new_data <- read.csv("new_data.csv",header = T)
View(new_data)

#resident(범주) vs gender(범주) 데이터 분포 시각화

## 성별에 따른 거주지역 분포 현황 
resident_gender <- table(new_data$resident2, new_data$gender2)
resident_gender # 빈도수 교차분석 ! 

barplot(resident_gender, horiz = F, beside = T, col = rainbow(5), xlim = c(0,80),
        legend = row.names(resident_gender), main = "성별에 따른 거주지역 분포 현황")

## 거주지에 따른 성별의 분포 현황 
gender_resident <- table(new_data$gender2,new_data$resident2)
gender_resident

barplot(gender_resident, horiz = F, beside = T, col = rainbow(2), ylim = c(0,80),
        legend = row.names(gender_resident), main = "거주지에 따른 성별의 분포 현황")

# 5.2 연속형 vs 범주형

# 나이 (age/연속형) vs 직업(job2 / 범주형) 데이터 분포 시각화
install.packages("lattice") # chap08
library(lattice)

# 직업 유형에 따른 나이 분포 형황
densityplot( ~age, data = new_data, groups = job2,
             plot.points = T , auto.key = T)
# plot.points = F :: 밀도점 표시 여부를 하지 않는다
# auto.key = T :: 범레의 출력 여부.

# 5.3 연속 vs 범주 vs 범주

# price(연속형) vs gender(범주형) vs position(범주형) 데이터 분포 시각화

# (1) 성별에 따른 직급별 구매비용 분포 현황 분석 
densityplot( ~price | factor(gender2),data = new_data ,
             groups = position2,
             plot.points =T, auto.key = T)


# (2) 직급에 따른 성별 구매비용 분포 현황 분석
densityplot( ~price | factor(position2),data = new_data ,
             groups = gender2,
             plot.points =T, auto.key = T)

# 5.4 연속형 vs 연속형 vs 범주형

# price (연속) vs age(연속) vs gender2(범주)
xyplot(price ~ age |factor(gender2), data = new_data)

# 6. 파생변수

# 6.1 더미(dummy) 형식으로 파생변수 생성

# 데이터 파일 가져오기
getwd()
setwd("C:/workspaces/bigdata-master/R/data")

user_data <- read.csv('user_data.csv', header = T)

View(user_data)
table(user_data$house_type)

# 1   2   3   4 
#32  47  21 300 


#더미변수 생성
# 주택유형(단독주택(1), 빌라(2)) : 0, 아파트 유형(아파트(3),오피스텔(4)) : 1
house_type2 <- ifelse(user_data$house_type==1 | user_data$house_type==2, 0, 1)
house_type2[1:10]

#파생변수 추가
user_data$house_type2 <- house_type2

# 6.2 1:N -> 1:1 관계로 파생변수 생성

# 고객 식별번호(user_id) vs 상품유형(product_type) 간의 1:5 -> 1:1 파생변수 생성

# 데이터 파일 가져오기
pay_data <- read.csv('pay_data.csv', header = T)

str(pay_data)

table(pay_data$product_type)

library(reshape2)
product_type <- dcast(pay_data, user_id~product_type,sum,na.rm = T)
View(product_type)

# 컬럼명 수정
names(product_type) <- c('user_id','식료품(1)','생필품(2)','의류(3)','잡화(4)','기타(5)')

# 고객별 지불유형에 따른 구매상품 개수 파생변수 생성
pay_price <- dcast(pay_data, user_id~pay_method,length)

View(pay_price)

# 6.3 파생변수 합치기

# 고객정보 테이블에서 파생변수 추가
library(plyr)
user_pay_data <- join(user_data,product_type, by = 'user_id')

user_pay_data

# 병합된 데이터를 대상으로 고객별 지불 유형에 다른 구메ㅐ상품 개수 병합하기
user_pay_data<-join(user_pay_data, pay_price,by = 'user_id')

# 7. 표본 샘플링

#7-1 정제(cleaning) 데이터 저장하기
write.csv(user_pay_data, "cleanData.csv",quote = F, row.names = F)

data <- read.csv('cleanData.csv',header = T)

nrow(data)
choice1<- sample(nrow(data),30)
choice1
data[choice1,1]

# 50~data 길이 사이에서 30개 무작위 추출

choice2 <- sample(50:nrow(data),30)
choice2

# 다양한 범위를 지정해서 무작위 샘플링
choice3 <- sample(c(10:50, 80:150,160:190),30)
choice3

#iris 데이터 셋을 대상으로 7:3 비율로 데이터 셋 생성.
data("iris")
dim(iris) # 150   5

idx <- sample(1:nrow(iris), nrow(iris) * 0.7)

training <- iris[idx,] # 학습 데이터 셋

testing <- iris[-idx,] # (트레이닝 idx 제외한 나머지) 검정 데이터 셋

dim(training) # 105   5
dim(testing) #  45  5

# 7.3 교차 검정 샘플링 
#   - 평가의 신뢰도를 높이기 위해 동일한 데이터 셋을 N등분 하여 N-1개의 학습 데이터 모델을 생성하고,나머지 1개를 검정데이터로 이용하여 모델을 평가하는 방식.

# 데이터 셋을 대상으로 K겹(fold) 교차 검정 데이터 셋 생성.

name <- c('a','b','c','d','e','f')
score <- c(90, 85, 70, 85, 60, 74)

df <- data.frame(Name=name,Score=score)

df

# 교차 검정을 위한 패키지 설치
install.packages("cvTools")
library(cvTools)

cross <- cvFolds(n=6,K = 3,R = 1,type = "random") # n = 샘플 갯수 , K = k겹으로 지정, 

cross

#$ subsets: int [1:6, 1] 6  1  4  |  2  5  3
#$ which  : int [1:6]    1  2  3  |  1  2  3
#                       k1,k2,k3    k1,k2,k3
#                 k1 = (6,2) (1,3,4,5)  33% / 66% -> (1-[3(n)/6(k) = N]) / ([3(n)/6(k) = N])
#                 k2 = (1,5) (2,3,4,6)  33% / 66%
#                 k3 = (4,3) (1,2,5,6)  33% / 66%

str(cross)


# which 를 이용하여 subsets 데이터 참조
cross$subsets[cross$which==1, 1] # k=1 인 경우
cross$subsets[cross$which==2, 1] # k=2 인 경우
cross$subsets[cross$which==3, 1] # k=3 인 경우
r <- 1 # 회전수
K <- 1:3 # 3겹 (fold)
for(k in K){
        datas_idx <- cross$subsets[cross$which==k,r]
        cat('k=',k,'검정데이터 \n')
        print(df[datas_idx,])
        
        cat('훈련데이터 \n')
        print(df[-datas_idx,])
}















