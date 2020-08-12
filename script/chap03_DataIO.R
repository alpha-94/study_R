# chap03_DataIO

#############################################
# chapter03. 데이터 입출력
#############################################

# 1. 데이터 불러오기

## 1-1 . 키보드 입력

# 키보드 숫자 입력하기
num <- scan() # 문자 입력 시 :: scan()은 'a real'를 입력받아야 하는데, '홍길동'를 받았습니다
num

# 합계 구하기
sum(num)

# 키보드 문자 입력하기
name <- scan(what = character())
name

#편집기 이용 데이터 프레임 만들기
df <- data.frame() # 빈 데이터 프레임 생성
df <- edit(df)
df

##1-2 로컬 파일 가져오기

#read.table() 함수 이용
# - 컬럼명이 없는 파일 불러오기
getwd()
setwd("C:/workspaces/bigdata-master/R/data")
student <- read.table(file = "student.txt")
student
mode(student);class(student)

names(student) <- c('번호', '이름', '키', '몸무게')
student

# - 컬럼명이 있는 파일 불러오기
student1 <- read.table(file = "student1.txt", header = T)
student1

# - 탐색기를 통해서 파일 선택하기
student1 <- read.table(file.choose(), header = T)
student1

# - 구분자가 있는 경우 (세미콜론, 탭)
student2 <- read.table(file ="student2.txt", sep = ";",header = T)
student2

# - 결측치(온전치 못한 데이터) 를 처리하여 파일 불러오기
student3 <- read.table(file ="student3.txt",header = T, na.strings = "-") # 문자열 -> NA 처리 
student3 # 나중에 NA 를 전처리 할 때 필요함 

# - csv 파일 형식 불러오기 read.csv
student4 = read.csv(file = "student4.txt", na.strings = "-")
student4 # NA 형식이 <NA> 로 표현 

# - read.xlsx() 함수 이용 => 엑셀데이터 읽어오기 
# 패키지 설치 + 자바 실행 환경 설정!!!
install.packages("rJava") #자바의 환경을 만들어주기
install.packages("xlsx") # 이 패키지는 자바로 기본 세팅 되어있음
Sys.setenv(JAVA_HOME='C:/Program Files/Java/jre1.8.0_221') # 자바 path 설정

# 관련 패키지 메모리 로드
library(rJava)
library(xlsx)

#엑셀 파일 가져오기
studentex<-read.xlsx(file.choose(), sheetIndex = 1, encoding = "UTF-8")
studentex


## 1-3 인터넷에서 파일 가져오기

# 단계1 : 세계 GDP 순위 데이터 가져오기
GDP_ranking <- read.csv('http://databank.worldbank.org/data/download/GDP.csv', encoding = "UTF-8")
GDP_ranking
head(GDP_ranking, 10)
dim(GDP_ranking)

# 데이터를 가공하기 위해 불필요한 행과 열을 제거한다.
GDP_ranking2 <- GDP_ranking[-c(1:4),c(1,2,4,5)]
head(GDP_ranking2)

#상위 16개 국가 선별
GDP_ranking16<-head(GDP_ranking2, 16)

#데이터 프레임을 구성하는 4개의 열에 대한 이름을 지정한다.
names(GDP_ranking16) <- c('Code','Ranking','Nation','GDP')
GDP_ranking16


#단계 2 : 세계 GDP 상위 16위 국가 막대 차트 시각화
gdp <- GDP_ranking16$GDP
gdp
nation <- GDP_ranking16$Nation
nation
num_gdp<-as.numeric(str_replace_all(gdp, ',', ''))
num_gdp

GDP_ranking16$GDP <-num_gdp

#막대차트 시각화
barplot(GDP_ranking16$GDP, col = rainbow(16), xlab = '국가(nation)', ylab = '단위(달러)', names.arg = nation)

##1-2. 웹문서 가져오기 
#2010년 ~ 2015년도 미국의 주별 1인당 소득 자료 가져오기.
#"https://ssti.org/blog/useful-stats-capita-personal-income-state-2010-2015"
#파일을 다운로드 받는 것이 아닌, HTML내 테이블(반정형 데이터)을 읽어오기

# 단계1 : XML / httr 패키지 설치
install.packages("XML")
install.packages("httr")
library(XML)
library(httr)

# 단계2 : 미국의 주별 1인당 소득 자료 가져오기. # 소스코드 가져오기 
url <- "https://ssti.org/blog/useful-stats-capita-personal-income-state-2010-2015"

get_url <- GET(url) #httr 패키지에서 제공하는 GET함수에 주소변수를 추가하여 변수 생성
args(GET) # 리스트로 기본 리턴
get_url$content #16진수 출력 . 
rawToChar(get_url$content) #html 태그 변환 : R의 base패키지에서 제공하는 함수. 16진수 데이터를 우리가 이해할 수 있는 문자열(HTML)로 변환 <table> 단을 가져옴 
html_cont <- readHTMLTable(rawToChar(get_url$content), stringAsFactors=F) 
#순서의 의미를 적용하고 싶으면 Factor 를 이용 팩터형으로 가져올 것인지 아님 문자열 자체로 가져올건지의 세팅 매개변수 //T 일경우 직관의 개념 
#XML패키지에서 제공하는 함수. HTML에서 테이블을 찾아 테이블을 구현

mode(html_cont) ; class(html_cont) # list # list # 키벨류 형태 
str(html_cont) # 52 obs. of  7 variables:

html_cont <- as.data.frame(html_cont) # data.frame 형 변환 

head(html_cont)

# 단계 4 :: 컬럼명을 수정한 후 뒷부분 6개 관측치 보기
names(html_cont) <- c("State","y2010","y2011","y2012","y2013","y2014","y2015")


tail(html_cont)



# 2. 데이터 저장하기
## 2-1 화면 (콘솔) 출력
### 1) cat() 함수 # System.out.print과 같은 기능
x <- 10
y <- 20
z <- x*y
cat("x*y의 결과는", z, "입니다.\n") # \n 줄바꿈  JAVA는 + 로 구분하지만 R 은 , 으로 구분.

# 2> print() 함수
print(z) # 변수 또는 수식만 가능 // 문자열과 함께 사용이 불가능하다 
print(z * 10)
#print("x * y = " , z) # error :: print.default("x * y = ", z) : invalid printing digits 200

## 2-2. 파일에 데이터 저장 
### 1) sink()함수 이용한 파일 저장
getwd()
setwd("C:/workspaces/bigdata-master/R/output")

library(RSADBE)
data("Severity_Counts") # Severity_Counts 데이터 셋 가져오기
mode(Severity_Counts) ;class(Severity_Counts)
Severity_Counts

sink("severity.txt") # 저장할 파일 open

#sink("C:/workspaces/bigdata-master/R/output/severity.txt") setwd 지정 안했을 경우 

severity <- Severity_Counts
severity # 콘솔에 출력 되지 않고 파일에 저장 ! 
sink() # 오픈된 파일 close ( 아무것도 입력값을 넣지 않는 경우 )

### 2) write.table() 함수 이용 하기 // read.table() 읽어오기
# 탐색기를 이용하여 데이터 가져오기

studentx<-read.xlsx(file.choose(),sheetIndex = 1, encoding = "UTF-8")
studentx
#기본 속성으로 저장 - 행이름과 따옴표가 붙는다. 1,2,3,4,5 이런식으로 붙어 있음 
write.table(studentx,"stdt.txt")

# 'row.names=F' 속성을 이용해서 행이름 제거 저장
write.table(studentx,"stdt2.txt", row.names = F)

# 'quote=F' 속성을 이용해서 따옴표를 제거하여 저장
write.table(studentx,"stdt3.txt", quote = F)

#행이름 제거 + 따옴표 제거
write.table(studentx,"stdt4.txt", quote = F, row.names = F)

html_cont
write.table(html_cont, "GNP_United_States.txt",row.names = F)

GNP_US <- read.table("GNP_United_States.txt",sep = "",header = T)
GNP_US

### 3) rwite.xlsx() 함수 이용 파일 저장 - 엑셀 파일로 저장
library(rJava)
library(xlsx) # excel data 입출력 함수 제공

st.df <- read.xlsx(file.choose(),sheetIndex = 1, encoding = "UTF-8")
st.df 
write.xlsx(st.df, "studenttx.xlsx")


### 4) write.csv() 함수 이용 파일 저장
# -data.frame 형식의 데이터를 csv 형식으로 저장.

write.csv(st.df,"stdf.csv",row.names=F,quote=F)






