# chap06_DataHandling

#################################
# chapter06.데이터 조작
#################################

## 1. plyr 패키지 활용
# - 두개 이상의 데이터프레임을 대상으로 key 값을 이용하여 하나의 패키지로 병합(merge) 하거나 집단변수를 기준으로
#   데이터프레임의 변수에 함수를 적용하여 요약집계 결과를 제공하는 패키지.

# 1.1 데이터 병합
install.packages('plyr') # 패키지 설치
library(plyr)

# 병합할 데이터 프레임 셋 만들기
x <- data.frame(id = c(1, 2, 3, 4, 5),
                height=c(160, 171, 173, 162, 165))
y <- data.frame(id=c(5, 4, 1, 3, 2),
                weight=c(55, 73, 60, 57, 80))

z <- join(x, y, by = 'id') # id 컬럼으로 조인
z

z2 <- merge(x, y, by = 'id')
z2

# 왼쪽(left) 조인하기
x <- data.frame(id = c(1, 2, 3, 4, 6),
                height=c(160, 171, 173, 162, 165))
y <- data.frame(id=c(5, 4, 1, 3, 2),
                weight=c(55, 73, 60, 57, 80))

left <- join(x, y, by='id') # id 컬럼으로 조인 (왼쪽을 기준 :: NA(결측치 :: 누락된 값 , 비어있는 값))//오라클 outer join 과 동일 
# type -> left 디폴트값 
left

#내부(inner) 조인하기 

x <- data.frame(id = c(1, 2, 3, 4, 6),
                height=c(160, 171, 173, 162, 165))
y <- data.frame(id=c(5, 4, 1, 3, 2),
                weight=c(55, 73, 60, 57, 80))

inner <- join(x, y, by='id', type = 'inner') # type='inner' : 값이 있는 것만 조인 .
inner

ineer_merge <- merge(x, y, by='id') # inner 조인으로 병합 
ineer_merge

#전체(full) 조인하기

x <- data.frame(id = c(1, 2, 3, 4, 6),
                height=c(160, 171, 173, 162, 165))
y <- data.frame(id=c(5, 4, 1, 3, 2),
                weight=c(55, 73, 60, 57, 80))

full <- join(x, y, by='id', type = 'full') # type='full' : 모든 항목을 조인.
full

# key 값으로 병합하기
x <- data.frame(key1=c(1,1,2,2,3),
                key2=c('a','b','c','d','e'),
                val1=c(10,20,30,40,50))

y <- data.frame(key1=c(3,2,2,1,1),
                key2=c('e','d','c','b','a'),
                val1=c(500,400,300,200,100))

xy <- join(x,y,by = c('key1','key2'))
xy

#1-2 그룹별 기술 통계량 구하기

# (1) tapply() 함수 이용

# iris 데이터 셋을 대상으로 tapply() 함수 적용하기 
head(iris)
names(iris) # "Sepal.Length" "Sepal.Width"  "Petal.Length" "Petal.Width"  "Species"  
unique(iris$Species) # 꽃의 종류 보기 - 3가지 // 중복데이터 제외 + levels 포함 

# tapply(적용 데이터 , 그룹핑 데이터(factor별), 함수)
avg_tply <- tapply(iris$Sepal.Length,iris$Species,mean) # 평균 
avg_tply
#setosa versicolor  virginica 
#5.006      5.936      6.588 

tapply(iris$Sepal.Length,iris$Species,sd) #표준편차 
#setosa versicolor  virginica 
#0.3524897  0.5161711  0.6358796

# (2) ddply() 함수 이용
# 꽃의 종류별(species)로 꽃받침 길이의 평균 구하기 
avg_df <- ddply(iris, .(Species),summarise,
                avg = mean(Sepal.Length))
avg_df

str(avg_df) # 'data.frame':	3 obs. of  2 variables:
str(avg_tply)

#꽃의 종(Species) 으로 여러개의 함수 적용하기 
a <- ddply(iris, .(Species),summarise,
                avg = mean(Sepal.Length),
                std =sd(Sepal.Length),
                max = max(Sepal.Length),
                min = min(Sepal.Length))

str(a) # 'data.frame':	3 obs. of  5 variables:

#round() 함수 적용하여 반올림 처리하기 . 

b <- ddply(iris, .(Species),summarise,
           avg = round(mean(Sepal.Length),2),
           std =round(sd(Sepal.Length),2),
           max = max(Sepal.Length),
           min = min(Sepal.Length))

b

## 2. dplyr 패키지 활용 
# - 기존 plyr 패키지는 R 언어로 개발되었으나 , dplyr 패키지는 C++ 언어로 개발되어 처리속도를 개선

install.packages(c("dplyr","hflights"))
library(dplyr)
library(hflights)
hflights
str(hflights) # 227496 obs. of  21 variables:

############## hflights 데이터셋 ######################
# 2011년도 미국 휴스턴에서 출발하는 모든 비행기의
# 이착륙 기록이 수록된 것으로 227,496건의 이착륙 기록에
# 대해 21개 항목을 수집한 데이터
#######################################################

# 2.1 콘솔 창의 크기에 맞게 데이터 추출
hflights_df <- tbl_df(hflights) # 현재 키워져 있는 콘솔 화면 만큼 데이터 출력 // 안나온 컬럼은 주석형으로 보여줌(데이터는 항상 10개 출력)
hflights_df
#A tibble: 227,496 x 21
#콘솔에 보이지 않는 내용 출력 ... with 227,486 more rows, and 2 more variables: CancellationCode <chr>, Diverted <int>

# 2.2 조건에 맞는 데이터 필터링 

# hflights_df를 대상으로 1월 2 일 데이터 추출하기 .
# AND - ',' , '&'로 사용
filter(hflights_df, Month==1 & DayofMonth ==2)
filter(hflights_df, Month==1 , DayofMonth ==2)
                                              #전체 데이터 출력하는건 뒤에가서 배움 
# (668 + 10) by 21

#1월 혹은 2월 데이터 추출
# OR - '|'로 사용 
filter(hflights_df, Month==1 | Month==2)
#(36,028 + 10) by 21

# 2.3 컬럼으로 데이터 정렬 
#년, 월, 출발시간, 도착시간 순으로 오름차순 정렬 
arrange(hflights_df, Year, Month, DepTime, ArrTime)

#년, 월, 출발시간, 도착시간 순으로 내림차순 정렬 
arrange(hflights_df, Year, Month, desc(DepTime), ArrTime)

# 2.4 컬럼으로 데이터 검색
# hflights_df에서 년, 월, 출발시간, 도착시간 컬럼 검색하기 .
# 오라클 select 
select(hflights_df, Year, Month, DepTime, ArrTime) # 특정 컬럼 데이터 선택 

#컬럼의 범위 지정하기 . 
select(hflights_df, Year:ArrTime)

# 컬럼의 범위 제외 :: Year 부터 DayOfWeek 제외 = '-' (마이너스) 이용하여 제외 하기 
select(hflights_df, -(Year:DayOfWeek))

# 2.5 데이터 셋에 컬럼 추가 

# 출발 지연 시간(ArrDelay)과 도착 지연 시간(DepDelay)과의 차이를 계산하는 컬럼 추가 (파생변수)
mutate(hflights_df, gain = ArrDelay - DepDelay,
       gain_per_hour = gain/(AirTime/60))

# mutate() 함수 의해서 초가된 컬럼 보기 # round()는 내가 넣은거 
select(mutate(hflights_df, gain = ArrDelay - DepDelay,
              gain_per_hour = round(gain/(AirTime/60),0)),
       Year, Month, ArrDelay, DepDelay, gain, gain_per_hour)

# 2.6 요약 통계치 계산
# 비행시간 평균 계산하기

summarise(hflights_df,avgAirTime = mean(AirTime, na.rm = T)) # na 값이 들어가 있어서 T 로 지정함

# 데이터 셋의 관측치(레코드 데이터) 길이, 출발 지연시간과 평균 구하기. - n() => row 값
summarise(hflights_df, cnt = n(), delay = mean(DepDelay, na.rm = T))

# 도착시간 (ArrTime)의 표준편차와 분산 계산하기
summarise(hflights_df, arrTimeSd = sd(ArrTime, na.rm = T),
          arrTimeVer = var(ArrTime, na.rm = T))

# 2.7 집단변수 대상 그룹화

# 집단변수를 이용하여 그룹화하기
species <- group_by(iris, Species) # 범주별 그룹핑 하기 
str(species)

planes <- group_by(hflights_df, TailNum) # TailNum(항공기 일련번호)
delay <- summarise(planes, count = n(), dist = mean(Distance, na.rm = T),
                   delay = mean(ArrDelay, na.rm = T)) # n() 비행기 갯수
delay
delay <- filter(delay, count > 20, dist < 2000)
delay

library(ggplot2)
ggplot(delay, aes(dist, delay)) +
  geom_point(aes(size=count), alpha = 1/2) +
  geom_smooth()+
  scale_size_area()

# 파이프(pipe)연산자 이용하기 
getwd()
setwd("C:/workspaces/bigdata-master/R/data")

exam <- read.csv("csv_exam.csv")
exam

# filter()
# %>% :: 파이프(pipe) 연산자 cmd + shift + m
exam %>% filter(class==1)

#select()
exam %>% select(class, math, english)

# class 가 1인 행만 추출한 다음 english 추출 (순차적 추출)
exam %>% filter(class == 1) %>% select(english)
#   (1) 클래스 1 추출 -> (2) 그 중에서 영어 추출

# 혹은 
exam %>%
  filter(class == 1) %>%
  select(english)

#ERROR
#exam
#%>% filter(class == 1)
#%>% select(english)

# 과목별 총점과 총점 기준 정렬해서 상위 6개 데이터만을 출력 .
exam %>% 
  mutate(total = math+english+science) %>% 
  arrange(desc(total)) %>% 
  head()

## 3. reshape2 패키지 활용 (reshape.ver 2)

# 3.1 긴 형식을 넓은 형식으로 변경 

# 패키지 설치
install.packages("reshape2")
library(reshape2)

data <- read.csv("data.csv")
data
View(data)

# 긴 형식 -> 넓은 형식으로 변경
wide <- data %>% dcast(Customer_ID ~ Date, sum) # wide <- dcast(data,Customer_ID ~ Date, sum)
wide

# 파일 저장 및 읽기
getwd()
setwd("C:/workspaces/bigdata-master/R/output")

write.csv(wide, 'wide.csv',row.names = F)

wide_read <- read.csv('wide.csv')
colnames(wide_read) <- c('id','day1','day2','day3','day4','day5','day6','day7')
wide_read

# 3.2 넓은 형식을 긴 형식으로 변경 

# melt() 함수 이용
long <- wide_read %>% melt(id = 'id')
long 

# 컬럼명 수정
colnames(long) <- c('id', 'day', 'buyCnt')
head(long)

# reshape2 패키지의 smiths 데이터 셋 구조 변경하기
data("smiths")
smiths

# wide -> long 
long <- smiths %>%  melt(id = 1:2)
long

# long -> wide
wide <- long %>% dcast(subject+time ~ ...)
wide

# 3.3 3차원 배열 형식으로 변경
data("airquality") # New York의 대기에 대한 질
head(airquality) # 153 obs. of  6 variables:

# 컬럼명 대문자 일괄 변경
names(airquality) <- toupper(names(airquality)) # 컬럼명 대문자 변경 toupper()
head(airquality)

# 월과 일의 컬럼으로 나머지 4개 컬럼을 묶어서 긴 형식으로 변경
air_melt <- airquality %>% melt(id = c('MONTH','DAY'),na.rm = T)
head(air_melt) # MONTH DAY variable value


# 일과 월 컬럼으로 variable 컬럼을 3차원 형식으로 분류
names(air_melt) <- tolower(names(air_melt)) # 컬럼명 소문자 변경
air_acast <- air_melt %>% acast(day~month~variable) # 3차원 구조 변경 
View(air_acast) # x~y~z 행 ( x ) / 열 ( y.z ) 형태
class(air_acast) # "array"

# 월 단위 variable(대기관련 컬럼) 컬럼 합계
air_melt %>% acast(month~variable, sum)

























