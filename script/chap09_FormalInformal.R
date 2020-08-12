# chap09_FormalInformal

#######################################
# chapter09. 정형/ 비정형 데이터 처리
#######################################

## 1.1 Oracle 정형 데이터 처리

# 단계 1 : 사용자 로그인과 테이블 생성
# - sqlplus 명령문으로 접속 후 다읨 테이블 생성

"""
SQL>

create table test_table(
  id    varchar2(50) primary key,
  pass  varchar2(30) not null,
  name  varchar2(30) not null,
  age   number(2)
);

# 단계 2 : 레코드 추가와 조회하기
# SQL> insert into test_table values('hong','1234','홍길동',25);
# SQL> insert into test_table values('lee','1234','이순신',30);


"""

# Oracle 연동을 위한 R 패키지 설치

# 1) 패키지 설치
# RJDBC 패키지를 사용하기 위해서는 우선  java를 설치해야 한다.

install.packages("rJava")
install.packages("DBI")
install.packages("RJDBC")

# 2) 패키지 로딩
Sys.setenv(JAVA_HOME='C:/Program Files/Java/jre1.8.0_221')
library(rJava)
library(DBI)
library(RJDBC) # rjava에 의존적

# 3) oracle 연동

### oracle 11g Ex.
# driver
drv <- JDBC("oracle.jdbc.driver.OracleDriver",
            "C:/oraclexe/app/oracle/product/11.2.0/server/jdbc/lib/ojdbc6.jar")

# db 연동(driver, url, id, pwd)

conn<- dbConnect(drv,"jdbc:oracle:thin:@//localhost:1521/xe","scott","tiger")

# (1) 모든 레코드 검색
query <- "select * from test_table"
dbGetQuery(conn, query)

# (2) 조건 검색 - 나이가 30세 이상인 레코드만 출력
query <- "select * from test_table where age >=30"
result <- dbGetQuery(conn, query)
result
str(result)

# (3)정렬 조회 - 나이컬럼 기준 내림차순
query <- "select * from test_table order by age desc"
dbGetQuery(conn, query)

# (4) 레코드 삽입
query <- "insert into test_table values('kang','1234','강감찬',35)"
dbSendUpdate(conn,query)

# (5) 레코드 수정 - 데이터 '강감찬'의 나이를 40으로 수정.
query <- "update test_table set age=40 where name='강감찬' "
# ""안에 ""를 사용하면 오류남.
dbSendUpdate(conn, query)
query <- "select * from test_table"
dbGetQuery(conn, query)


# (6) 레코드 삭제 - 데이터 '홍길동' 레코드 삭제
query <- "delete from test_table where name='홍길동'"
dbSendUpdate(conn, query)  # RJDBC패키지가 제공.
query <- "select * from test_table"
dbGetQuery(conn, query)


# (7) db 연결 종료
dbDisconnect(conn) # DBI에서 제공


# 2. 비정형 데이터 처리 (텍스트 마이닝 분석)
# - 텍스트 마이닝(Text Mining) : 문자로 된 데이터에서 가치 있는 정보를 얻어 내는 분석기법.

## 2.1 토픽 분석
# - 텍스트 데이터를 대상으로 단어를 추출하고, 이를 단어사전과 비교하여 단어의 출현  빈도수를 분석하는 텍스트 마이닝 분석과정을 의미.
# - 또한 단어 구름(word cloud) 패키지를 적용하여 분석 결과를 시각화하는 과정도 포함.

# (1) 패키지 설치 및 준비
install.packages("KoNLP") # 원래 필요한 패키지
# - package ‘KoNLP’ is not available (for R version 4.0.1)

install.packages("https://cran.rstudio.com/bin/windows/contrib/3.4/KoNLP_0.80.1.zip",
                 repos = NULL)
# package ‘KoNLP’ successfully unpacked and MD5 sums checked - 설치 완료

# Sejong 설치 : KoNLP와 의존성 있는 현재 버전의 한글 사전 패키지 설치
install.packages("Sejong")
install.packages(c("hash","tau","RSQLite", "rJava", "devtools"))

library(Sejong)
library(hash)
library(tau)
library(RSQLite)
Sys.setenv(JAVA_HOME='C:/Program Files/Java/jre1.8.0_221')
library(rJava)
library(devtools)
library(KoNLP)

install.packages(c("wordcloud","tm"))
library(wordcloud) ; library(tm)


#(2) 텍스트 자료 가져오기 
getwd()
facebook <- file("C:/workspaces/bigdata-master/R/data/facebook_bigdata.txt", encoding = "UTF-8")

facebook_data <- readLines(facebook)
head(facebook_data) # 줄바꿈 단위로 데이터 생성
str(facebook_data) #chr [1:76]  // 76 페어러그랩 라인 생성


# (3) 세종 사전에 신규 단어 추가 
userDic <- data.frame(term = c("R 프로그래밍","페이스북","소셜네트워크","얼죽아"), tag='ncn')

# - 신규 단어 사전 추가 함수 
buildDictionary(ext_dic = 'sejong', user_dic = userDic)

# (4) 단어 추출을 위한 사용자 정의 함수
# - R 제공 함수 단어 추출 - Sejong 사전에 등록된 신규 단어 테스트 
paste(extractNoun("홍길동은 얼죽아를 최애로 생각하는, 빅테이터에 최대 관심을 가지고 있으면서, 페이스북이나 소셜네트워크로부터 생성 수집되어진 빅데이터 분석에 아주 많은 관심을 가지고 있어요."), collapse=" ") # extractNoun :: 명사 
# [1] "홍길동은 얼죽아 최애로 생각 빅테이터에 최대 관심 페이스북 소셜네트워크 생성 수집 빅데이터 분석 관심"

# 단어 추출을 위한 사용자 정의 함수 정의하기
# (1) 사용자 정의 함수 작성.
#                  - [문자 변환] -> [명사 단어 추출] -> [공백으로 합침]
exNouns <- function(x){
  paste(extractNoun(as.character(x)), collapse = " ")
}

# (2) exNouns 함수 이용 단어 추출 
facebook_nouns <- sapply(contents_pre, exNouns) # 명사단어 추출


# (5) 추출된 단어 대상 전처리
#   1단계 : 추출된 단어 이용 말뭉치 (corpus) 생성
myCorpus <- Corpus(VectorSource(facebook_nouns))
myCorpus

#  2단계 : 데이터 전처리 
myCorpusPrepro <- tm_map(myCorpus,removePunctuation) # 문장부호 제거 

myCorpusPrepro <- tm_map(myCorpusPrepro,removeNumbers) # 수치 제거 

myCorpusPrepro <- tm_map(myCorpusPrepro,tolower) # 소문자 변환 

myCorpusPrepro <- tm_map(myCorpusPrepro,removeWords, stopwords('english')) # 불용어 제거 (for, very, and, of, are)


# 전처리 결과 확인
inspect(myCorpusPrepro[1:5])
myCorpusPrepro[1:5]


# (6) 단어 선별 (2음절 ~ 8음절 사이 단어 선택) 하기.

# - corpus 객체를 대상으로 TermDocumentMatrix() 함수를 이용하여 분석에 필요한 단어 선별하고 단어/문서 행렬을 만든다.

# - 전처리 된 단어집에서 단어 선별 (2음절 ~ 8음절 사이 단어) 하기.
# - 한글 1음절은 2byte 에 저장 (2음절 = 4byte)


myCorpusPrepro_term <- TermDocumentMatrix(myCorpusPrepro,control = list(wordLengths=c(4,16))) # 텍스트를 숫자로 표현하는 대표직인 방법.

myCorpusPrepro_term # corpus 객체 정보

# matrix 자료구조를 data.frame 자료 구조로 변경 -> 자료구조 확정 짓기.
myTerm_df <- as.data.frame(as.matrix(myCorpusPrepro_term))
head(myTerm_df)

dim(myTerm_df) # 696  76

# (7) 단어 출현 빈도수 구하기. - 빈도수가 높은 순서대로 내림차순으로 데이터 정렬 
wordResult <- sort(rowSums(myTerm_df), decreasing = T)
wordResult[1:10]

#데이터     분석 빅데이터     처리     사용     수집   시스템     저장     결과     노드 
#    91       41       33       31       29       27       23       16       14       13 

# (8) 불필요한 단어 제거 시작.
# 1) 데이터 전처리 

myCorpusPrepro <- tm_map(myCorpus,removePunctuation) # 문장부호 제거 

myCorpusPrepro <- tm_map(myCorpusPrepro,removeNumbers) # 수치 제거 

myCorpusPrepro <- tm_map(myCorpusPrepro,tolower) # 소문자 변환 

mystopwords <- c(stopwords('english'), "사용","하기")

myCorpusPrepro <- tm_map(myCorpusPrepro,removeWords, mystopwords) # 불용어 제거 (for, very, and, of, are)

inspect(myCorpusPrepro[1:5])

# 2) 단어 선별 - 단어 길이 2~8 개 이상 단어 선별 .

myCorpusPrepro_term <- TermDocumentMatrix(myCorpusPrepro,control = list(wordLengths=c(4,16))) # 텍스트를 숫자로 표현하는 대표직인 방법.

myCorpusPrepro_term # corpus 객체 정보

# 3) matrix 자료구조를 data.frame 자료 구조로 변경 -> 자료구조 확정 짓기.

myTerm_df <- as.data.frame(as.matrix(myCorpusPrepro_term))

# 4)단어 출현 빈도수 구하기. - 빈도수가 높은 순서대로 내림차순으로 데이터 정렬 

wordResult <- sort(rowSums(myTerm_df), decreasing = T)
wordResult[1:20]
View(wordResult)
write.csv(wordResult,'wordResult.csv')

# (9) 단어 구름(word cloud) 시각화 -디자인 적용 전 
myName <- names(wordResult)
wordcloud(myName, wordResult)

# 단어 구름에 디자인 적용 (빈도수, 색상, 위치 , 회전 등)
# (1) 단어 이름과 빈도수로 data.frame 생성 
word.df <- data.frame(word = myName, freq = wordResult)
str(word.df)


?brewer.pal
# (2) 단어색상과 글꼴 지정 
pal <- brewer.pal(12, "Paired")
windowsFonts(malgun=windowsFonts("맑은 고딕"))

# (3) 단어 구름 시각화 
x11() # 별도의 창을 띄우는 함수 
wordcloud(word.df$word, word.df$freq, scale = c(5,1), min.freq = 3, random.order = F, rot.per = .1, colors = pal, family="malgun")

# 예시 2 ) 텍스트 파일 가져오기와 단어 추출하기 .
# 데이터 불러오기
txt <- readLines("hiphop.txt")
head(txt)
install.packages("stringr")
library(stringr)

# 특수문자 제거
txt1 <- str_replace_all(txt, "\\W"," ") # W(대문자) :: 특수문자 제외 
head(txt1)

# 가사에서 명사 추출 
nouns <- extractNoun(txt1)
head(nouns)

# 추출한 명사 list를 문자열 벡터로 변환 , 단어별 빈도표 생성 
wordcount <- table(unlist(nouns))
head(wordcount) ; tail(wordcount)

# 데이터 프레임으로 변환 
df_word <- as.data.frame(wordcount, stringsAsFactors = F) # 요인화 하지 말고 문자형 그대로 
head(df_word) ; tail(df_word)

# 변수명 수정 
names(df_word) <- c("word", "freq")
head(df_word) ; tail(df_word)

# 두 글자 이상 단어 추출  
install.packages("dplyr")
library(dplyr)

df_word <- filter(df_word, nchar(word) >= 2) # nchar -> length // 1글자 단어 제거 

top_20 <- df_word %>% arrange(desc(freq)) %>% head(20)

# 시각화
pal <- brewer.pal(8, "Dark2")

set.seed(1234)
wordcloud(words = word.df$word, freq = word.df$freq,
          min.freq = 2, max.words = 200,
          random.order = F, rot.per = .1,
          scale = c(4, 0.3),
          colors = pal) # rot.per :: 회전




# 2.2 연관어 분석
# : 연관규칙(Association Rule)을 적용하여 특정 단어와 연관성이 있는 단어들을 선별하여 네트워크 형태로 시각화 하는 과정 .


# 한글 처리를 위한 패키지 설치
# - 토픽분석 참조 .



# 1. 텍스트 파일 가져오기 
getwd()
setwd("C:/workspaces/bigdata-master/R/data")
marketing <- file("marketing.txt",encoding = "UTF-8")
marketing
head(marketing)
marketing2 <- readLines(marketing) # 줄 단위 데이터 생성 
head(marketing2)
str(marketing2) # chr [1:472]

# 2 .줄단위 단어 추출 
lword <- Map(extractNoun, marketing2) # 명사 단어 추출 
head(lword)
length(lword) # [1] 472

lword <- unique(lword) # lword line 에서 비어있는 block 제거 (전체 대상)
length(lword) # [1] 353

lword <- sapply(lword,unique) # unique :: 중복 텍스트들을 제거 해주는 역할 
length(lword) # [1] 353
str(lword) # List of 353

# 단어 필터링 함수 정의 - 길이가 2개 이상 4개 이하 사이의 문자 길이로 구성 된 단어만 필터링 
filter1 <- function(x){
  nchar(x) >=2 && nchar(x) <=4 && is.hangul(x)
}
filter2 <- function(x){
  Filter(filter1, x)
}

# 2) 줄 단위로 추출된 단어 전처리
lword <- sapply(lword,filter2) # 단어 길이가 1 이하 또는 5 이상 단어 제거.
head(lword,20)

# 트렌젝션 생성 
# - 트렌젝션 :: 연관분석에서 사용되는 데이터 처리 단위 
# - 연관분석을 위해서는 추출도니 단어를 대상으로 트랜젝션 형식으로 자료구조 변환

# 1) 연관 분석을 위한 패키지 설치 
install.packages("arules")
library(arules)

# 2) 트랜잭션 생성 
wordtran <- as(lword, "transactions") # 선처리 작업 

wordtran
#transactions in sparse format with
#353 transactions (rows) and
#2423 items (columns)

# 3) 교차표 작성 : crossTable() -> 교차테이블 함수 이용
wordtable <- crossTable(wordtran)
wordtable

# 4) 단어 간 연관 규칙 산출 
tranrules <- apriori(wordtran,parameter = list(support=0.25 , conf=0.05 ))
# writing ... [59 rule(s)] done [0.00s].

# 5) 연관 규칙 생성 결과 보기 
inspect(tranrules)

# 연관어 시각화
# 1) 연관 단어 시각화를 위해서 자료 구조 변경 
rules <- labels(tranrules, ruleSep =" ") # 연관규칙 레이블을 " " 로 분리
head(rules,20)
 
class(rules) #"character"

rules <- sapply(rules, strsplit, " ", USE.NAMES = F)
rules
class(rules) # list

# 3) 행 단위로 묶어서 matrix 로 반환
rulemat <- do.call("rbind", rules) # 행 단위로 묶음 
rulemat

# 연관어 시각화를 위한 igraph 패키지 설치
install.packages("igraph")
library(igraph)
# edgelist 보기 - 연관단어를 정점(vertex) 형태의 목록 제공
ruleg <- graph.edgelist(rulemat[c(12:59),],directed = F) # [c(1:11),] "{}" 제외 
ruleg

# edgelist 시각화 
x11()
plot.igraph(ruleg, vertex.label = V(ruleg)$name,
            vertex.label.cex =1.2 , vertex.label.color = 'black',
            vertex.size = 20, vertex.color = 'green',
            vertex.frame.color = 'blue')


##############################################
##2.2 연관어 분석
#     : 연관규칙(Association Rule)을 적용하여 특정 단어와 연관성이 있는 단어들을 선별하여 네트워크 형태로 시각화하는 과정.

# 한글 처리를 위한 패키지 설치
library(Sejong)
library(hash)
library(tau)
library(RSQLite)
Sys.setenv(JAVA_HOME='C:/Program Files/Java/jre1.8.0_221')
library(rJava)
library(devtools)
library(KoNLP)


# 1. 텍스트 파일 가져오기
marketing <- file("C:/workspaces/R/data/marketing.txt", encoding = "UTF-8")
#문장에 데이터를 가져오기 때문에 file을 사용. 
marketing #file로 읽어오면 데이터 형태로 보이는 것이 아님. 해서 라인단위로 읽어오는 함수가 필요 -> readLine(marketing)
marketing2 <- readLines(marketing) # 줄 단위 데이터 생성
marketing2

# 2. 줄 단위 단어 추출
lword <- Map(extractNoun, marketing2) #extractNoun: 명사를 추출하는 함수
length(lword) # 472 : 해당 라인별 크기가 472개 key값
View(lword)

lword <-  unique(lword) #하나의 줄에 구성된 단어가 같으면 중복 제거. 예) 한 줄에 "" 만 있는 데이터가 제거 됨 
length(lword) # 353

lword <- sapply(lword, unique) #sapply()는 인자로 sapply(data, function) 이 기본적으로 들어가며, 백터로 반환. unique(중복되어진 텍스트 제거 함수) 
length(lword) # 353 : 같은 라인에 중복 데이터 없어 그대로

str(lword)
#List of 353
#$ : chr [1:27] "<U+FEFF>근래에" "시장" "세계" "화"  -> 1~27개의 단어를 찾음

"""
# - 참조(unique())
c1 <-  rep(1:10, each=2)
c1 #1  1  2  2  3  3  4  4  5  5  6  6  7  7  8  8  9  9 10 10
c2 <-  rep(c(1,3,5,7,9), each=4) #1 1 1 1 3 3 3 3 5 5 5 5 7 7 7 7 9 9 9 9
c2
c3 <-  c(1,1,1,1,3,3,3,3,5,5,6,6,7,7,8,8,9,10,12,12)
c3
c123_df <- data.frame(cbind(c1,c2,c3))
c123_df

c12_unique <- unique(c123_df[,c("c1", "c2")])
c12_unique #입력으로 넣어준 대상이 두개 모두 같을 때 제외.

c123_unique <- unique(c123_df[,c("c1", "c2", "c3")])
c123_unique #모두가 같을 때 마지막 중복대상이 제거 됨

c123_unique_Last <- unique(c123_df[,c("c1", "c2", "c3")], fromLast =T)
c123_unique_Last #마지막에 중복된 데이터가 남음
"""

# 단어 필터링 함수 정의 - 길이가 2개 이상 4개 이하 사이의 문자 길이로 구성된 단어만 필터링.
filter1 <-  function(x){
  nchar(x) >= 2 && nchar(x) <= 4 && is.hangul(x)}
# 2~4 단어 중 세종 사전에 등록된 단어인지 체크 후 트루만 실행.

filter2 <- function(x){
  Filter(filter1, x) 
}

#   2) 줄 단위로 추출된 단어 전처리
lword <- sapply(lword, filter2) #단어 길이가 1이하 또는 5 이상인 단어 제거
lword

#  트랜잭션 생성 
#   - 트랜잭션 : 연관분석에서 사용되는 데이터 처리 단위.
#   - 연관분석을 위해서는 추출된 단어를 대상으로 트랜잭션 형식으로 자료구조 변환.

# 1) 연관 분석을 위한 패키지 설치
install.packages("arules") 
library(arules)

# 2) 트랜잭션 생성
wordtran <- as(lword, "transactions")
wordtran
#transactions in sparse format with
#353 transactions (rows) and
#2423 items (columns)

# 3) 교차표 작성 : dressTable() -> 교차테이블 함수를 이용.
wordtable <- crossTable(wordtran)
wordtable

# 4) 단어 간 연관 규칙 산출
tranrules <-  apriori(wordtran, parameter = list(support =0.25, conf=0.05))
# 지지도(support)와 신뢰도(confidence)를 지정하여 연관 규칙을 발견,
#writing ... [59 rule(s)] done [0.00s].

# 5) 연관 규칙 생성 결과 보기
inspect(tranrules)

# 연관어 시각화
# 1) 연관 단어 시각화를 위해서 자료 구조 변경
rules <-  labels(tranrules, ruleSep= " ") #연관 규칙 레이블을 " " 으로 분리

head(rules, 20)
class(rules) #"character"

# 2) 문자열로 묶인 연관 단어를 행렬 구조 변경.
rules <- sapply(rules, strsplit, " ", USE.NAMES = F)
rules
class(rules) # "list"

# 3) 행 단위로 묶어서 matrix로 반환
rulemat <-  do.call("rbind", rules)
rulemat
class(rulemat) #"matrix"
#연관 단어 시각화를 위해서는 연관규칙의 결과를 행렬구조(data.fram / matrix)로 변경해야 한다.

# 연관어 시각화를 위한 igraph 패키지 설치
install.packages("igraph")
library(igraph)

# edgelist 보기 - 연관 단어를 정점(vertex) 형태의 목록 제공
relueg <- graph.edgelist(rulemat[c(12:59),], directed = F) #[c(1:11)] "{}" 빈 값 제외
relueg

# edgelist 시각화
x11()
plot.igraph(relueg, vertex.label = V(relueg)$name,
            vertex.label.cex = 1.2, vertex.label.color ='black',
            vertex.size = 20, vertex.color ='green',
            vertex.frame.color='blue') 




# (2) url 요청
base_url <- "https://search.naver.com/search.naver?&where=news&query=%EB%B9%85%EB%8D%B0%EC%9D%B4%ED%84%B0&sm=tab_pge&sort=0&photo=0&field=0&reporter_article=&pd=0&ds=&de=&docid=&nso=so:r,p:all,a:all&mynews=0&cluster_rank=26&refresh_start=0&start="

cs_url <- "https://search.naver.com/search.naver?&where=news&query=%EC%B6%94%EC%84%9D&sm=tab_pge&sort=0&photo=0&field=0&reporter_article=&pd=0&ds=&de=&docid=&nso=so:r,p:all,a:all&mynews=0&cluster_rank=26&refresh_start=0&start="

# url 가져오기
urls <- NULL

for(x in 0:100){
  urls <- c(urls, paste(cs_url, x*10+1,sep=''))
}


urls
R.version
# (3) R 에서 HTML 불러오기 
library(xml2)
html <- read_html(urls[1])
html
?read_html
# (4) HTML 에서 필요한 부분 뽑아오기 
install.packages("rvest")
library(rvest)

htmlnode <- html_nodes(html,'ul.type01 > li > dl > dd > a') # 네이버 뉴스 링크
htmlnode
htmlattr <- html_attr(htmlnode, 'href') # url 주소값 추출

# 혹의 위의 (3)~(4) 과정을 
urls[1] %>% read_html() %>% html_nodes('ul.type01 > li > dl > dd > a') %>% html_attr('href')

# (5) 뉴스 기사 url 뽑아내기 
news_link <- NULL

for(url in urls){
  html <- read_html(url)
  news_link <- c(news_link, html %>% html_nodes('ul.type01 > li > dl > dd > a') %>%  html_attr('href'))
}

news_link

# (6) 뉴스 본문 / 제목 추출하기
contents <- NULL
title <- NULL

for(link in news_link){
  html <- read_html(link)
  # 제목
  title <- c(title, html %>% html_nodes('#articleTitle') %>% html_text()) # 파싱
  # 본문
  contents <- c(contents, html %>% html_nodes('._article_body_contents') %>% html_text())
}

contents_df <- as.data.frame(contents)
title_df <- as.data.frame(title)
news <- cbind(title_df,contents_df)
View(news)

# 전처리
# -gsub(패턴,교체문자,자료)
contents_pre <- gsub("[\r\n\t]",' ',contents) # 이스케이프 제거
contents_pre <- gsub("[[:punct:]]",' ',contents_pre) # 문장부호 제거
contents_pre <- gsub("[[:cntrl:]]",' ',contents_pre) # 특수문자 제거
contents_pre <- gsub("\\d+",' ',contents_pre) # 숫자 제거
contents_pre <- gsub("[a-z]+",' ',contents_pre) # 영문 소문자 제거
contents_pre <- gsub("[A-Z]+",' ',contents_pre) # 영문 대문자 제거
contents_pre <- gsub("\\s+",' ',contents_pre) # 2개 이상 공백 교체
head(contents_pre)















