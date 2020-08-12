# chap05_DataVisualization

#################################
# chapter05.데이터 시각화
#################################


# 이산변수와 연속변수 시각화 

# 1. 이산변수 (discrete quantitative data) 시각화
#   - 정수 단위로 나누어 측정할 수 있는 변수 .

# 1) 막대차트 시각화 - barplot() 함수 이용 !
#     (1) 세로 막대차트

# 막대차트 데이터 생성
chart_data <- c(305, 450, 320, 460, 330, 480, 380, 520)
names(chart_data) <- c("2019 1Q","2020 1Q","2019 2Q","2020 2Q","2019 3Q","2020 3Q","2019 4Q","2020 4Q")

str(chart_data)
chart_data

#세로 막대 차트
?barplot
barplot(chart_data, ylim = c(0, 600), col = rainbow(8),
        main = "2019년도 vs 2020년도 분기별 매출현황 비교")

barplot(chart_data, ylim = c(0, 600), col = rainbow(length(chart_data)),
        xlab = "연도별 분기현황" ,ylab = "매출액::만원",
        main = "2019년도 vs 2020년도 분기별 매출현황 비교")


#barplot(height, width = 1, space = NULL,
#        names.arg = NULL, legend.text = NULL, beside = FALSE,
#        horiz = FALSE, density = NULL, angle = 45,
#        col = NULL, border = par("fg"),
#        main = NULL, sub = NULL, xlab = NULL, ylab = NULL,
#        xlim = NULL, ylim = NULL, xpd = TRUE, log = "",
#        axes = TRUE, axisnames = TRUE,
#        cex.axis = par("cex.axis"), cex.names = par("cex.axis"),
#        inside = TRUE, plot = TRUE, axis.lty = 0, offset = 0,
#        add = FALSE, ann = !add && par("ann"), args.legend = NULL, ...)

#     (2) 가로 막대차트

barplot(chart_data, xlim = c(0, 600), col = rainbow(length(chart_data)),
        xlab = "매출액::만원", ylab = "연도별 분기현황" ,
        main = "2019년도 vs 2020년도 분기별 매출현황 비교",
        horiz = T)

barplot(chart_data, xlim = c(0, 600), col = rainbow(length(chart_data)),
        xlab = "매출액::만원", ylab = "연도별 분기현황" ,
        main = "2019년도 vs 2020년도 분기별 매출현황 비교",
        horiz = T, space =1.5, cex.names=0.8)#캐릭터 익스팬션(디폴트 1)


#red 와 blue 생상 4회 반복
barplot(chart_data,xlim = c(0,600),
        xlab = "매출액::만원", ylab = "연도별 분기현황" ,
        main = "2019년도 vs 2020년도 분기별 매출현황 비교",
        horiz = T, space =1.5, cex.names=0.8,
        col=rep(c("green","yellow"),4)) # 2번은 빨강 , 4번은 파랑
# col=rep(c(2,4),) :: 검은색 1, 빨간색 2, 초록색 3, 파란색 4, 하늘색 5, 자주색 6,노란색 7

#누적 막대 차트
data("VADeaths")
VADeaths

str(VADeaths)
mode(VADeaths);class(VADeaths)

#개별차트와 누적차트 그리기


#누적차트
par(mfrow=c(1,2))

barplot(VADeaths, col = rainbow(5),
        main = "미국 버지니아주 하위계층 사망 비율",
        )

legend(3.8,200, c("50-54","55-59","60-64","65-69","70-74"),cex = 0.8,fill = rainbow(5))


#개별차트

barplot(VADeaths, col = rainbow(5),
        main = "미국 버지니아주 하위계층 사망 비율",
        beside = T
        )

legend(19,71, c("50-54","55-59","60-64","65-69","70-74"),cex = 0.8,fill = rainbow(5))

# 2) 점 차트 시각화 - dotchart() 이용 !
?dotchart

#dotchart(x, labels = NULL, groups = NULL, gdata = NULL, offset = 1/8,
#         ann = par("ann"), xaxt = par("xaxt"), frame.plot = TRUE, log = "",
#         cex = par("cex"), pt.cex = cex,
#         pch = 21, gpch = 21, bg = par("bg"),
#         color = par("fg"), gcolor = par("fg"), lcolor = "gray",
#         xlim = range(x[is.finite(x)]),
#         main = NULL, xlab = NULL, ylab = NULL, ...)

par(mfrow=c(1,1)) # 1행 1열 원복

dotchart(chart_data, color = c("blue","red"),
         xlab = "매출액(단위 :: 만원)", 
         cex = 1.2, main = "분기별 판매현황 점 차트 시각화",
         labels = names(chart_data))

# names(chart_data) <- c()

dotchart(chart_data, color = c("black","red"),
         xlab = "매출액(단위 :: 만원)", 
         cex = 1.2, main = "분기별 판매현황 점 차트 시각화",
         labels = names(chart_data),
         lcolor = "blue", pch = 2:3
         )
# pch(plotting character) : 원 (1) , 삼각형(2), +모양 (3)
# cex(character expansion) : 레이블과 점의 크기 확대 역할 . (디폴트 = 1)

# 3) 원형 차트 시각화 - pie() 함수
?pie
#pie(x, labels = names(x), edges = 200, radius = 0.8,
#    clockwise = FALSE, init.angle = if(clockwise) 90 else 0,
#    density = NULL, angle = 45, col = NULL, border = NULL,
#    lty = NULL, main = NULL, ...)

pie(chart_data, labels = names(chart_data), clockwise = T,
    border = 'blue', col = rainbow(8), cex = 1.2)
title("2019~2020년도 분기별 매출 현황")
# title() - barplot(main = "")과 같은 형태

# 1. 연속변수 (continuous quantitative data) 시각화
#   - 시간, 길이 등과 같은 연속성을 가진 변수.

# 1) 상자 그래프 시각화 - boxplot() 함수 이용
#   : 요약정보를 사각화 하는데 효과적. 특히 데이터의 분포 정도와 이상치 발견을 목적으로 하는 경우 유용.

boxplot(VADeaths,range = 0)
# range = 0 :: 최소값과 최대값을 점선으로 연결하는 역할 . 

abline(h = 37, lty = 4, col = 'red')
# lty ::1(직선) ,2(굵은 점선) ,3(얇은 점선), 4(-.-.-모양)

summary(VADeaths)

# 2) 히스토그램 
#   -측정값의 범위(구간)를 그래프의 x 축으로 놓고, 범위에 속하는 측정값의 빈도수를 y 축으로 나타낸 그래프 형태.

data("iris")
head(iris)
table(iris$Species)
#setosa versicolor  virginica 
#50         50         50 

names(iris)
# "Sepal.Length"(꽃받침 길이) "Sepal.Width"(꽃받침 너비)  "Petal.Length"(꽃잎 길이) "Petal.Width"(꽃잎 너비)  "Species"(종류)

summary(iris$Sepal.Length)
summary(iris$Sepal.Width)

par(mfrow=c(1,1))

hist(iris$Sepal.Width, xlab = "꽃받침의 너비",
     col="green", xlim = c(2.0,4.5), ylim = c(0,40),
     main = "Iris 꽃받침 너비의 histogram")

hist(iris$Sepal.Length, xlab = "꽃받침의 길이",
     col="mistyrose", xlim = c(4.0,8.0), ylim = c(0,40),
     main = "Iris 꽃받침 길이의 histogram")

#확률 밀도로 히스토그램 그리기 - 연속형 변수의 확률 .
hist(iris$Sepal.Width, xlab = "꽃받침 너비", 
     col='mistyrose',xlim=c(2.0,4.5),
     main = "Iris 꽃받침 너비 histogram", freq = F)

#밀도를 기준으로 line 그리기 
lines(density(iris$Sepal.Width), col="blue")

# 정규분포곡선 추가 
#   - 분포곡선 :: 빈도수의 값을 선으로 연결하여 얻어진 곡선.
x <- seq(2.0, 4.5, 0.1)
length(x)
x

curve(dnorm(x,
            mean = mean(iris$Sepal.Width),
            sd = sd(iris$Sepal.Width)),
      col = 'red',add = T
      )

# 3) 산점도 시각화 - plot() 함수 이용 ! 
#   - 두 개 이상의 변수들 사이의 분포를 점으로 표시한 차트를 의미.

#기본 산점도 시각화
price <- runif(10, min = 1,max = 100) # 1부터 100 까지 10개의 난수를 생성
plot(price)

#대각선 추가
par(new = T) # 차트 추가
line_chart <- c(1:100)
line_chart

plot(line_chart,type = 'l', col = 'red', axes = F,ann = F)

#텍스트 추가
text(70,80,"대각선 추가",col = "blue", cex = 1.2)

######################################################################## mine
getwd() #"C:/workspaces/bigdata-master/R/script"
pdf("C:/workspaces/bigdata-master/R/output/plot_line_chart.pdf")
dev.off()
#############################################################################



#type 속성으로 그리기
par(mfrow = c(2,2))
plot(price, type = 'l') # 실선
plot(price, type = 'o') # 원형과 실선
plot(price, type = 'h') # 직선
plot(price, type = 's') # 꺾은선

# pch 속성으로 그리기
plot(price, type = 'o', pch =5)   # 빈 사각형
plot(price, type = 'o', pch =15)  # 채워진 사각형
plot(price, type = 'o', pch =20)  # 채워진 원형

plot(price, type = 'o', pch =20 , col = 'blue')
plot(price, type = 'o', pch =20 , col = 'orange', cex = 3.0)
plot(price, type = 'o', pch =20 , col = 'orange', cex = 3.0 , lwd = 3) # line width

# 4) 중첩 자료 시각화 

#중복된 자료의 수 만큼 점의 크기 확대하기

par(mfrow=c(1,1)) # 1 by 1 

# 두개의 벡터 객체
x <- c(1, 2, 3, 4, 2, 4)
y <- rep(2, 6)
x;y

# 교차 테이블 작성
table(x) ; table(y)
table(x,y)

# 산점도 시각화 
plot(x,y)


# 데이터 프레임 생성
xy.df <- as.data.frame(table(x,y))
xy.df

# 좌표에 중복된 수 만큼 점 확대
plot(x,y,pch=15, col='blue',
     xlab = "x 벡터 원소",
     ylab = "y 벡터 원소",
     cex = 0.8 * xy.df$Freq
     )

# galton 데이터 셋 대상 중복 자료 시각화 

# galton 데이터 셋 가져오기
library(UsingR)
data("galton")
head(galton)
str(galton) # 'data.frame':	928 obs. of  2 variables:
class(galton) # "data.frame"

# 데이터프레임으로 변환 (프리퀀시 ! )
galtonData <- as.data.frame(table(galton$child,galton$parent)) # 중복 빈도수 출력 
head(galtonData)
str(galtonData) # 'data.frame':	154 obs. of  3 variables:

# 컬럼 단위 추출
names(galtonData) <- c("child", "parent","Freq") # 컬럼 이름 지정 
head(galtonData)

parent <- as.numeric(galtonData$parent)
child <- as.numeric(galtonData$child)

#점의 크기 확대 
plot(parent,child, pch = 21, col = 'blue', bg= 'green',
     xlab = "parent", ylab = "child",
     cex = 0.2 * galtonData$Freq)

# 5) 변수 간의 비교 시각화
# iris 4개 변수의 상호 비교
attributes(iris) # $names $class $row.names
data("iris")
?pairs

# matrix 또는 data.frame의 numeric 컬럼을 대상으로 변수들 사이의 비교 결과를 행렬구조의 분산된 그래프로 제공
pairs(iris[,1:4]) # 1:4 => "Sepal.Length" "Sepal.Width"  "Petal.Length" "Petal.Width"

#꽃의 종류가 "virginica" 와 "setosa", "versicolor" 를 종별 대상으로 4개 변수 상호 비교
pairs(iris[iris$Species=="virginica", 1:4])
pairs(iris[iris$Species=="setosa", 1:4])
pairs(iris[iris$Species=="versicolor", 1:4])

# 3차원 산점도 시각화 
# 패키지 설치 및 로딩
install.packages("scatterplot3d")
library(scatterplot3d)

# Factor 의 levels 보기 # 순서 있는 요인 , 순서 없는 요인
levels(iris$Species) # "setosa" "versicolor" "virginica" (각각 50개씩)

# 붓꽃의 종류별 분류 
iris_setosa <-iris[iris$Species == 'setosa',]
iris_versicolor <-iris[iris$Species == 'versicolor',]
iris_virginica <-iris[iris$Species == 'virginica',]

# 3차원의 형태 틀 생성 - scatterplot3d(밑변 , 오른쪽변 컬럼명, 왼쪽변 컬럼명, type)
d3 <- scatterplot3d(iris$Petal.Length, iris$Sepal.Length, iris$Sepal.Width, type = 'n') 
# type :: h -> 수직선 , p-> 점 , l -> 선 , n -> 

# 3차원 산점도 시각화 
d3$points3d(iris_setosa$Petal.Length,
            iris_setosa$Sepal.Length,
            iris_setosa$Sepal.Width,
            bg = 'orange',
            pch = 21) # 타원 산점도 

d3$points3d(iris_versicolor$Petal.Length,
            iris_versicolor$Sepal.Length,
            iris_versicolor$Sepal.Width,
            bg = 'blue',
            pch = 23) # 마름모 산점도 

d3$points3d(iris_virginica$Petal.Length,
            iris_virginica$Sepal.Length,
            iris_virginica$Sepal.Width,
            bg = 'green',
            pch = 25) # 역삼각형 산점도 




























