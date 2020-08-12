# chap04_control

###################################################
# chapter04-1. 연산자 / 제어문 ( 조건문과 반복문 )
###################################################

###############
## 1. 연산자
###############

# 산술연산자
num1 <- 100 # 피연산자1
num2 <- 20  # 피연산자2

result <- num1 + num2  # 덧셈
result
result <- num1 - num2  # 뺄셈
result
result <- num1 * num2  # 곱셈
result
result <- num1 / num2  # 나눗셈
result

result <- num1 %% num2  # 나머지 연산자
result

result <- num1^2   # 제곱연산자(num1 ** 2)
result

result <- num1^num2   # 100의 20승(10의 40승과 동일한 결과)
result   # [1] 1e+40 -> 1 * 10^40


# 비교(관계) 연산자
# (1) 동등비교
boolean <- num1 == num2 # 두 변수의 값이 같은지 비교 
boolean
boolean <- num1 != num2 # 두 변수의 값이 다른지 비교 
boolean

# (2) 크기비교
boolean <- num1 > num2 
boolean
boolean <- num1 >= num2 
boolean
boolean <- num1 < num2 
boolean
boolean <- num1 <= num2 
boolean

# 논리 연산자 java 는 && / || 로 
logical <- num1 >= 50 & num2 <= 10
logical

logical <- num1 >= 50 | num2 <= 10
logical

#xor (하나라도 다르면 : T / 비교자들이 같으면 : F)
x <- TRUE; y <- FALSE
xor(x, y)
x <- TRUE; y <- TRUE
xor(x, y)
x <-F ; y<-F
xor(x, y)


logical <- num1 >= 50
logical

logical <- !(num1 >= 50)
logical


###############################
## 2. 조건문
###############################

# 1) if()
x <- 10
y <- 5
z <- x * y
z

#if(조건식){ 산술/비교/논리 연산자 
#    실행문1 <- 참
#}else{
#    실행문1 <- 거짓
#}

if(x*y > 40){ # 산술 > 비교 > 논리
  cat("x*y의 결과는 40이상입니다.\n")  # \n :줄바꿈
  cat("x*y = ", z, '\n')
  print(z)
}else{
  cat("x*y의 결과는 40미만입니다. x*y=", z, "\n")
}


# 학점 구하기
score <- scan()
score

if(score >= 90){ # 조건식1
  result = "A학점"
}else if(score >= 80){ # 조건식1
  result = "B학점"
}else if(score >= 70){ # 조건식2
  result = "C학점"
}else if(score >= 60){ # 조건식3
  result = "D학점"
}else{
  result = "F학점"
}

cat("당신의 학점은 ", result) # 당신의 학점은?
print(result)

# 2) ifelse(조건, 참, 거짓) - 3항 연산자 기능 
score <- c(78,95,85,65)
score
ifelse(score > 80, "우수","노력") # java :: ? 조건 : 참 : 거짓 ;

# ifelse() 응용
getwd()
setwd("C:/workspaces/bigdata-master/R/data")

excel<-read.csv("excel.csv",header = T)
excel

q1 <- excel$q1 # q1 변수값 추출
ifelse(q1>=3,sqrt(q1),q1) # 3보다 큰경우 sqrt() 함수 적용 .
ifelse(q1>=2 & q1 <=4,q1^2,NA)


# 3) switch 문
#   형식 > switch(비교구문, 실행구문1, 실행구문2, 실행구문N,...)
switch("name", id="hong",pwd="1234",age=25,name="홍길동")

empname <- scan(what ="")
empname # "kim"

switch(empname, hong=250, lee=300, kim=200, kang=400) # 200

# 4) which 문
#   - which() 괄호 내의 조건에 해당하는 위치(인덱스) 를 출력한다.
#   - 벡터에서 사용 -> index 값을 리턴 .

name <- c("kim", "lee", "choi", "park")
which(name == "choi") # 3(index)


# 데이터 프레임에서 사용
no <- c(1:5)
name <- c("홍길동", "이순신", "강감찬", "유관순", "김유신")
score <- c(85,78,89,90,74)

exam <-data.frame(학번 =no , 이름 =name, 성적=score)
exam
which(exam$이름 == "유관순")

###############
## 4. 반복문
###############
# 1) 반복문 - for(변수 in 값 ) {표현 식}

i <- c(1:10)
i


d <- numeric() # 빈 벡터 (숫자)

for(n in i){ # 10회 반복
  print(n*10)
  print(n)
  d[n] <-n*2
  print(d[n])
}

d

for (n in i) {
  if(n %% 2 !=0){
    print(n) ## %% :: 나머지값 - 홀수만 출력 
  }
}

for (n in i) {
  if(n %% 2 ==0){
    next # 다음문장 스킵 -> 반복문 계속(java :: continue)
  } else{
    print(n) ## %% :: 나머지값 - 홀수만 출력 
  }
}


# 벡터 데이터 사용 예
score <- c(85,95,90)
name <- c("홍길동", "이순신", "강감찬")

i <- 1 # 첨자로 사용되는 변수
for (s in score) {
  cat(name[i],"->",s,"\n")
  i <- i+1
  }

# 반복문 - while(조건){표현식}
i =0;

while (i < 10) {
  i <- i+1
  print(i)
}


###################################################
# chapter04-2. 사용자 정의 함수와 내장 함수
###################################################

## 1. 사용자 정의 함수 

# 함수 정의 형식
# 변수 <- funtion([매개변수]){
#         함수의 실행문
#         }


#함수 호출
# - 변수([매개변수])

# 매개변수가 없는 함수 예
f1 <- function(){
  cat("매개변수가 없는 함수")
}

f1()

#매개변수가 있는 함수 예
f2 <- function(x){
  cat("x의 값 = ",x,"\n")
  print(x)
}

f2(3) # 실인수

f2(c(1:10))


# 리턴 값이 있는 함수 예


f3 <- function(x,y){
      return (x+y) # 결과 반환
}

add<-f3(2,3) # 호출이 되어지는 순간 실행문 내 메모리 없어짐 
add


# 기술 통계량을 계산하는 함수 정의
#파일 불러오기
getwd()
setwd("C:/workspaces/bigdata-master/R/data")

test<-read.csv("test.csv",header = T)
head(test)

# A 컬럼 요약 통계량, 빈도수 구하기.
summary(test) # 요약 통계량
table(test$A) # 요인형 결과값 -> 각 항목별 빈도수 (EX> 설문에 의한 만족도 조사)
max(test$A)
min(test$A)

length(test) # 5 :: 컬럼의 개수 


# 각 컬럼 단위 요약 통계량과 빈도수 구하기.
data_pro <- function(x){
    for (idx in 1:length(x)) {
      cat(idx, "번째 컬럼의 빈도분석 결과")
      print(table(x[idx]))
      cat('\n')
    }
    for (idx in 1:length(x)) {
      f<- table(x[idx])
      cat(idx, '번째 컬럼의 빈도수 최대값 / 최소값 \n')
      cat("max=",max(f),"min=",min(f),' \n')
    }
}

data_pro(test)

# 분산과 표준편차 구하는 함수 정의 
z <- c(7,5,12,9,15,6) # x 변량 생성
var_sd <- function(x){
  var <- sum((x-mean(x))^2)/(length(x)-1) # 표분의 분산 (편차)^2의 총합 / 변량의 개수
  sd <- sqrt(var) # 표준편차
  cat('표준분산 :: ',var,'\n' ) 
  cat('표본 표준편차 :: ', sd , '\n')
  }

var_sd(z)


# 결측치 (NA :: 유효하지 않은 값) 처리 
data <- c(10, 20, 5, 4, 40, 7, NA, 6, 3, NA, 2, NA)

data
mean(data) # 하나라도 값이 NA 면 :: NA 
mean(data, na.rm = T) # na.rm :: NA 처리 // T : NA 값 제외 , F :: NA가 있으면 NA 로 처리 

# 구구단 출력 함수 
gugudan <- function(i,j){
  for (x in i) {
    cat("==",x,"단 == \n")
    for (y in j) {
      cat(x, "*", y , " = ",x*y, "\n")
    }
    
    cat("\n")
    }
}

i <- c(2:9) #단수 지정
j <- c(1:9) # 단수와 곱해지는 수 지정

gugudan(i,j)


# 결측치 데이터 처리 함수 

na <- function(x){
  # 1차 :: NA 제거 
  print(x)
  print(mean(x,na.rm = T))
  
  # 2차 :: NA 를 0으로 대체 
  data<- ifelse(!is.na(x),x,0) # NA 일 경우 0으로 대체
  print(mean(data))
  
  #3차 :: NA 를 평균으로 대체 (가장 일반적으로 NA 를 처리하는 경우 ! )
  data2 <- ifelse(!is.na(x),x,round(mean(x,na.rm = T),2)) # 평균으로 대체
  print(data2)
  print(mean(data2))
}

 
na(data)

#결측치를 무조건 제거하면 정확한 통계량을 얻을 수 없으며, 데이터가 손실될 수 있다.

## 2. 주요 내장 함수

# 행단위, 컬럼단위 합계와 평균 구하기.

#단계 1 :: 데이터 셋 불러오기 

library(RSADBE)
data("Bug_Metrics_Software")
class(Bug_Metrics_Software)

Bug_Metrics_Software[,,1] # 제품 출시 전
Bug_Metrics_Software[,,2] # 제품 출시 후

# 단계 2 :: 소프트웨어 발표 전 행단위 합계와 평균 구하기 
rowSums(Bug_Metrics_Software[,,1]) # 행단위 합계
rowMeans(Bug_Metrics_Software[,,1]) # 행단위 평균

# 단계 3 :: 소프트웨어 발표 전의 열단위 합계와 평균 구하기
colSums(Bug_Metrics_Software[,,1])
colMeans(Bug_Metrics_Software[,,1])

#기술 통계량 관련 내장 함수 사용 예

seq(-2,2,by=.2) # (시작값,끝값,그때의 증가 카운트 값(0.2간격으로 데이터 증가))
vec <- 1:10
vec

min(vec)
max(vec)
range(vec) # 최소 ~ 최대 값 안의 범위 
mean(vec)
median(vec) # 데이터 중간값 
sum(vec)
sd(rnorm(10)) # 표준편차 구하기.
table(vec) # 빈도수 

#난수와 확률 분포 관계
#단계 1 :: 정규분포 (연속형)의 난수 생성 
n <- 1000
r <- rnorm(n, mean = 0, sd = 1)
hist(r) # 대칭성

# 단계 2 :: 균등분포 (연속형)의 난수 생성 
n <- 1000
r2 <- runif(n, min =0,max = 1) # 0< r2 <1
hist(r2)

# 단계 3 :: 이항분포 (이산형) 난수 생성

n<-20
rbinom(n,1,prob = 1/2) #(n , 이산변량값(0부터 X값 까지) , 확률값)

rbinom(n,2,0.5)
rbinom(n,10,0.5)

n<-1000
rbinom(n,5,prob = 1/6)

#단계 4 :: 종자값 (seed) 으로 동일한 난수 생성.
rnorm(5,mean=0,sd=1)

set.seed(123)
rnorm(5,mean = 0,sd=1)

set.seed(345)
rnorm(5,mean = 0,sd=1)

# 수학 관련 내장함수 사용 예 
vec <- 1:10
prod(vec) # 각 숫자의 곱
factorial(4)
abs(-5)
sqrt(16)

log(10) # 10의 자연로그 (밑수가 e )
log10(10) # 10의 일반 로그 ( 밑수가 10 )

#집합연산 관련 내장 함수 사용 예
x <- c(1,3,5,7,9)
y <- c(3,7)

union(x,y) # 합집합
setequal(x,y) # 동일한지에 대한 논리
intersect(x,y) # 교집합 
setdiff(x,y) # 차집합
x %in% y # x가 집합 y 에 포함되어있는지 테스트


















