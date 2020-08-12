# chap01_Basic : 주석문 기호

#############################################
# chapter01. R 설치와 개요
#############################################

# 주요 단축키
# -script 실행 : ctrl + Enter, ctrl +r
# -script 저장 : ctrl + s

print("hello,R!!!") # ctrl + enter


#패키지와 session 보기
# R package 보기
available.packages()
dim(available.packages()) #15786    17

#R Session 보기
sessionInfo()

#설치된 패키지 목록 확인
installed.packages()

#패키지 사용법
#install.packages("stringr")#인스톨 시 "" 넣어줘야함
library(stringr) #메모리 삽입시엔 "" 생략 가능
search()

#패키지 제거
#remove.packages("stringr")

#데이터 셋 보기
data()


#기본 데이터 셋으로 히스토그램 그리기

#단계 1 :: 빈도수 (frequency)를 기준으로 히스토그램 그리기.
hist(Nile)

#단계 2 :: 밀도 (density) 를 기준으로 히스토그램 그리기.
hist(Nile, freq = FALSE)

#단계 3 :: 단계 2 의 결과에 분포곡선(line)을 추가.
lines(density(Nile))

#히스토그램을 파일에 저장하기.
par(mfrow=c(1,1))# c(x,y) x행 y열 대로 그래프 저장
                 # plots 영역에 1개 그래프 표시
pdf("C:/workspaces/bigdata-master/R/output/batch.pdf")
hist(rnorm(20)) # 난수에 대한 히스토그램을 그리기.
dev.off()


## 변수와 자료형

# 변수 사용 예
age <- 25
print(age)
age
age <- 35
age

# 변수.멤버 형태로 변수 선언 예 
goods.model <- "lg-320" #상품 모델명.
goods.name <- "냉장고"
goods.price <- 850000
goods.desc <- "동급 최고의 품질/사양"

#대소문자 구별 
val1 <- 50
Val1 <- 100
val1
Val1

#숫자로 시작 불가능
#100num <- 50 #Error

#자료형 // JAVA에서만 사용했던 자료형 키워드를 변수로 선언 가능
int <- 20 #숫자형(정수)
double<-3.14 #.숫자형(실수)
string <-"홍길동" #문자형
boolean <- TRUE #반드시 대문자로만 약속이 되어져 있음 T 또는 F 로 사용 가능
boolean

boolean <- 3.14
boolean

#자료형 확인 is 함수군
is.numeric(int) # T
is.numeric(string) # F
is.integer(int) # F : 정수값도 부동 소숫점으로 관리.
is.double(int) # T : 주의!

#자료형 변환 as 함수군
castInt <-as.integer(int) # as 자료형 변환 시 values 표현할 때 20L 로 표현
is.integer(castInt) # T :: 실수형에서 정수형으로 형변환 해주었기 때문
is.numeric(castInt) # T

is.numeric(double) # T
is.double(double) # T

is.character(string) # T
is.character(int) # F

boolean <- TRUE
is.character(boolean) # F : boolean이 진리값이 담겨져 있을때
is.character("boolean") # T : ""안에 문자열로 취급
is.logical(boolean) # T

x <- c(1, 2, 3)
x # 1 2 3

# 숫자 원소를 문자 원소로 형변환
y <- c(1, 2, "3")
y # "1" "2" "3"

result <- x * 3
result # 3 6 9

#y * 5 Error 이항연산자에 수치가 아닌 인수입니다

y.castInt <-as.integer(y)
result <- y.castInt * 5
result

# 스칼라 변수 사용 예
name <- "홍길동"
name

# 벡터 변수 사용 예 ==컴바인 함수 이용
x <- c(1,2,3)
x # 1 2 3

# 복소수형 자료 생성과 형변환
z <- 5.3 - 3i
Re(z) # 복소수형 안에 실수형만 꺼내오고 싶으면
Im(z) # 복소수형 안에 복소수형만 꺼내오고 싶으면
is.complex(z) # T
as.complex(5.3) # 5.3+0i



# 스칼라 변수의 자료형
mode(int) # "numeric"
mode(string) # "character"
mode(boolean) # "logical"

# 문자 벡터와 그래프 생성
gender <- c('man','woman','woman','man','man')
gender

mode(gender) # "character"

#plot(gender) # error :: plot() 함수는 숫자 자료만을 대상으로 그래프를 생성할 수 있음.

#요인형 변환
# as.factor() 함수 이용 범주(요인)형 변환
Ngender <- as.factor(gender)
Ngender # Levels: man woman 
table(Ngender)


#Factor형 변수로 차트 그리기
plot(Ngender) # 알파벳 순으로

# 도메인 ? 성별의 컬럼 안에 남 / 녀 남녀 이 두가지가 도메인
# 즉 범주(levels)는 도메인을 의미
# 그 범주를 카운트 해서 factor 형으로 변환

mode(Ngender) # "numeric"
class(Ngender) # 자료 구조에 대한 정보 반환 / "factor"
is.factor(Ngender) # T

#factor() 함수 이용 Factor형 변환
args(factor)
# 함수 안에 변수를 받아올때 순서도 상관 없으며 반드시 값이 들어오는 값을 제외하고 생략 가능
# 단 ! 매개변수를 지정하지 않으면 순서대로 진행이 되기 때문에 순서에 상관이 없으려면 매개변수를 반드시 지정!
# x = character() ::x 의 값(임의의 변수값)이 없으면 캐릭터()의 값으로 초기화
# levels ::반드시 전달, 필수 요소, 만약 값이 없으면 디폴트값으로 as.character(x)로 초기화
# labels = levels :: labels가 없으면 levels 값으로 초기화
# exclude = NA  
# ordered = is.ordered(x) '...' 이란 :: 가변인자변수
# nmax = NA
Ogender <- factor(x =gender, levels = c('woman','man'))
Ogender

#도움말 보기
help("factor")
?factor
?sum # sum(..., na.rm = FALSE)

#함수 파라메터 보기
args(sum)

#함수 사용 예제 보기
example(sum)

#순서없는 요인과 순서 있는 요인형 변수로 차트 그리기
par(mfrow=c(1,2))
plot(Ngender)
plot(Ogender)

# 작업 공간 지정
getwd()
setwd("C:/workspaces/bigdata-master/R/script")








