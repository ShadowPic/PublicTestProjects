�T
<C:\src\PublicTestProjects\source\JtlToSql\JtlToSql\CsvJtl.cs
	namespace 	
JtlToSql
 
{ 
public 

class 
CsvJtl 
: 
IDisposable %
{		 
StreamReader

 
jtlFileReader

 "
;

" #
	CsvReader 
jtlResultsReader "
=# $
null% )
;) *
dynamic 
stashedFirstRow 
;  
bool 
firstLineRead 
= 
false "
;" #
long 
firstJsonTimeStamp 
=  !
$num" #
;# $
DateTime 
testStartTimeStamp #
;# $
public 
DateTime 
TestStartTime %
{ 	
get 
{ 
return 
testStartTimeStamp +
;+ ,
}- .
} 	
string 
pathToJtlFile 
; 
string 
testPlan 
; 
public 
string 
TestPlan 
{ 	
get 
{ 
return 
testPlan !
;! "
}# $
} 	
string 
testRun 
; 
public 
string 
TestRun 
{ 	
get 
{ 
return 
testRun  
;  !
}" #
} 	
public   
static   
string   
ExtractTestPlan   ,
(  , -
string  - 3
pathToJtlFile  4 A
)  A B
{!! 	
var"" 
	splitPath"" 
="" 
pathToJtlFile"" )
."") *
Split""* /
(""/ 0
$str""0 3
)""3 4
;""4 5
return## 
	splitPath## 
[## 
$num## 
]## 
;##  
}$$ 	
public%% 
static%% 
string%% 
ExtractTestRun%% +
(%%+ ,
string%%, 2
pathToJtlFile%%3 @
)%%@ A
{&& 	
var'' 
	splitPath'' 
='' 
pathToJtlFile'' )
.'') *
Split''* /
(''/ 0
$str''0 3
)''3 4
;''4 5
return(( 
	splitPath(( 
[(( 
	splitPath(( &
.((& '
Length((' -
-((. /
$num((0 1
]((1 2
;((2 3
})) 	
public++ 
CsvJtl++ 
(++ 
string++ 
pathToJtlFile++ *
=+++ ,
null++- 1
)++1 2
{,, 	
if-- 
(-- 
!-- 
string-- 
.-- 
IsNullOrEmpty-- %
(--% &
pathToJtlFile--& 3
)--3 4
)--4 5
{.. 
testPlan// 
=// 
ExtractTestPlan// *
(//* +
pathToJtlFile//+ 8
)//8 9
;//9 :
testRun00 
=00 
ExtractTestRun00 (
(00( )
pathToJtlFile00) 6
)006 7
;007 8
}11 
else22 
{33 
testPlan44 
=44 
$str44 )
;44) *
}55 
this66 
.66 
pathToJtlFile66 
=66  
pathToJtlFile66! .
;66. /
}88 	
void::  
AddCalculatedColumns:: !
(::! "
dynamic::" )
jtlRow::* 0
)::0 1
{;; 	
var<< 

jtlRowDict<< 
=<< 
jtlRow<< #
as<<$ &
IDictionary<<' 2
<<<2 3
string<<3 9
,<<9 :
object<<; A
><<A B
;<<B C
long== 
currentTimeStamp== !
===" #
long==$ (
.==( )
Parse==) .
(==. /
jtlRow==/ 5
.==5 6
	timeStamp==6 ?
)==? @
;==@ A
int>> 
elapsedMilliseconds>> #
=>>$ %
Convert>>& -
.>>- .
ToInt32>>. 5
(>>5 6
currentTimeStamp>>6 F
->>G H
firstJsonTimeStamp>>I [
)>>[ \
;>>\ ]

jtlRowDict?? 
.?? 
Add?? 
(?? 
$str?? )
,??) * 
ConvertJsonTimeStamp??+ ?
(??? @
currentTimeStamp??@ P
)??P Q
)??Q R
;??R S

jtlRowDict@@ 
.@@ 
Add@@ 
(@@ 
$str@@ &
,@@& '
elapsedMilliseconds@@( ;
)@@; <
;@@< =

jtlRowDictAA 
.AA 
AddAA 
(AA 
$strAA $
,AA$ %
thisAA& *
.AA* +
testRunAA+ 2
)AA2 3
;AA3 4

jtlRowDictBB 
.BB 
AddBB 
(BB 
$strBB %
,BB% &
thisBB' +
.BB+ ,
testPlanBB, 4
)BB4 5
;BB5 6

jtlRowDictCC 
.CC 
AddCC 
(CC 
$strCC -
,CC- .
$"CC/ 1
{CC1 2
jtlRowCC2 8
.CC8 9
labelCC9 >
}CC> ?
$strCC? A
{CCA B
thisCCB F
.CCF G
testRunCCG N
}CCN O
$strCCO P
"CCP Q
)CCQ R
;CCR S

jtlRowDictDD 
.DD 
AddDD 
(DD 
$strDD /
,DD/ 0
pathToJtlFileDD1 >
)DD> ?
;DD? @
}EE 	
privateGG 
DateTimeGG  
ConvertJsonTimeStampGG -
(GG- .
longGG. 2
jsonTimeStampGG3 @
)GG@ A
{HH 	
DateTimeII 
originII 
=II 
newII !
DateTimeII" *
(II* +
$numII+ /
,II/ 0
$numII1 2
,II2 3
$numII4 5
,II5 6
$numII7 8
,II8 9
$numII: ;
,II; <
$numII= >
,II> ?
$numII@ A
)IIA B
;IIB C
returnJJ 
originJJ 
.JJ 
AddMillisecondsJJ )
(JJ) *
jsonTimeStampJJ* 7
)JJ7 8
;JJ8 9
}KK 	
publicLL 
voidLL 
DisposeLL 
(LL 
)LL 
{MM 	
ifNN 
(NN 
jtlFileReaderNN 
!=NN 
nullNN "
)NN" #
jtlFileReaderNN# 0
.NN0 1
DisposeNN1 8
(NN8 9
)NN9 :
;NN: ;
jtlResultsReaderOO 
.OO 
DisposeOO $
(OO$ %
)OO% &
;OO& '
}QQ 	
publicSS 
dynamicSS 
	GetCsvRowSS  
(SS  !
)SS! "
{TT 	
ifUU 
(UU 
!UU 
firstLineReadUU 
)UU 
{VV 
firstLineReadWW 
=WW 
trueWW  $
;WW$ %
returnXX 
stashedFirstRowXX &
;XX& '
}YY 
dynamicZZ 
csvRowZZ 
=ZZ 
jtlResultsReaderZZ -
.ZZ- .
	GetRecordZZ. 7
<ZZ7 8
dynamicZZ8 ?
>ZZ? @
(ZZ@ A
)ZZA B
;ZZB C 
AddCalculatedColumns[[  
([[  !
csvRow[[! '
)[[' (
;[[( )
return\\ 
csvRow\\ 
;\\ 
}]] 	
public__ 
void__ 
InitJtlReader__ !
(__! "
StreamReader__" .
	jtlStream__/ 8
)__8 9
{`` 	
jtlResultsReaderaa 
=aa 
newaa "
	CsvReaderaa# ,
(aa, -
	jtlStreamaa- 6
,aa6 7
CultureInfoaa8 C
.aaC D
InvariantCultureaaD T
)aaT U
;aaU V
jtlResultsReaderbb 
.bb 
Readbb !
(bb! "
)bb" #
;bb# $
jtlResultsReadercc 
.cc 

ReadHeadercc '
(cc' (
)cc( )
;cc) *
jtlResultsReaderdd 
.dd 
Readdd !
(dd! "
)dd" #
;dd# $
stashedFirstRowee 
=ee 
jtlResultsReaderee .
.ee. /
	GetRecordee/ 8
<ee8 9
dynamicee9 @
>ee@ A
(eeA B
)eeB C
;eeC D
firstJsonTimeStampff 
=ff  
longff! %
.ff% &
Parseff& +
(ff+ ,
stashedFirstRowff, ;
.ff; <
	timeStampff< E
)ffE F
;ffF G
testStartTimeStampgg 
=gg   
ConvertJsonTimeStampgg! 5
(gg5 6
firstJsonTimeStampgg6 H
)ggH I
;ggI J 
AddCalculatedColumnshh  
(hh  !
stashedFirstRowhh! 0
)hh0 1
;hh1 2
}jj 	
publickk 
voidkk 
InitJtlReaderkk !
(kk! "
stringkk" (
jtlFileNamekk) 4
)kk4 5
{ll 	
jtlFileReadermm 
=mm 
newmm 
StreamReadermm  ,
(mm, -
jtlFileNamemm- 8
)mm8 9
;mm9 :
jtlResultsReadernn 
=nn 
newnn "
	CsvReadernn# ,
(nn, -
jtlFileReadernn- :
,nn: ;
CultureInfonn< G
.nnG H
InvariantCulturennH X
)nnX Y
;nnY Z
jtlResultsReaderoo 
.oo 
Readoo !
(oo! "
)oo" #
;oo# $
jtlResultsReaderpp 
.pp 

ReadHeaderpp '
(pp' (
)pp( )
;pp) *
jtlResultsReaderqq 
.qq 
Readqq !
(qq! "
)qq" #
;qq# $
stashedFirstRowrr 
=rr 
jtlResultsReaderrr .
.rr. /
	GetRecordrr/ 8
<rr8 9
dynamicrr9 @
>rr@ A
(rrA B
)rrB C
;rrC D
firstJsonTimeStampss 
=ss  
longss! %
.ss% &
Parsess& +
(ss+ ,
stashedFirstRowss, ;
.ss; <
	timeStampss< E
)ssE F
;ssF G
testStartTimeStamptt 
=tt   
ConvertJsonTimeStamptt! 5
(tt5 6
firstJsonTimeStamptt6 H
)ttH I
;ttI J 
AddCalculatedColumnsuu  
(uu  !
stashedFirstRowuu! 0
)uu0 1
;uu1 2
}ww 	
publicxx 
boolxx 
ReadNextCsvLinexx #
(xx# $
)xx$ %
{yy 	
returnzz 
jtlResultsReaderzz #
.zz# $
Readzz$ (
(zz( )
)zz) *
;zz* +
}{{ 	
}|| 
}}} ��
AC:\src\PublicTestProjects\source\JtlToSql\JtlToSql\JtlCsvToSql.cs
	namespace 	
JtlToSql
 
{		 
public

 

class

 
JtlCsvToSql

 
:

 
IDisposable

 *
{ 
string 
connectionString 
;  
SqlConnection 
sqlConnection #
;# $
	DataTable 
batchOfRows 
; 
string 
batchTableName 
= 
$str  .
;. /
public 
JtlCsvToSql 
( 
string !
connectionString" 2
)2 3
{ 	
this 
. 
connectionString !
=" #
connectionString$ 4
;4 5
this 
. 
sqlConnection 
=  
new! $
SqlConnection% 2
(2 3
connectionString3 C
)C D
;D E
this 
. 
sqlConnection 
. 
Open #
(# $
)$ %
;% &!
InitializeBatchOfRows !
(! "
)" #
;# $
} 	
private 
void !
InitializeBatchOfRows *
(* +
)+ ,
{ 	
batchOfRows 
= 
new 
	DataTable '
(' (
batchTableName( 6
)6 7
;7 8
batchOfRows 
. 
Columns 
.  
Add  #
(# $
new$ '

DataColumn( 2
(2 3
)3 4
{5 6

ColumnName7 A
=B C
$strD O
,O P
DataTypeQ Y
=Z [
Type\ `
.` a
GetTypea h
(h i
$stri w
)w x
}y z
)z {
;{ |
batchOfRows 
. 
Columns 
.  
Add  #
(# $
new$ '

DataColumn( 2
(2 3
)3 4
{5 6

ColumnName7 A
=B C
$strD M
,M N
DataTypeO W
=X Y
TypeZ ^
.^ _
GetType_ f
(f g
$strg u
)u v
}w x
)x y
;y z
batchOfRows 
. 
Columns 
.  
Add  #
(# $
new$ '

DataColumn( 2
(2 3
)3 4
{5 6
	MaxLength7 @
=A B
$numC F
,F G

ColumnNameH R
=S T
$strU \
,\ ]
DataType^ f
=g h
Typei m
.m n
GetTypen u
(u v
$str	v �
)
� �
}
� �
)
� �
;
� �
batchOfRows 
. 
Columns 
.  
Add  #
(# $
new$ '

DataColumn( 2
(2 3
)3 4
{5 6

ColumnName7 A
=B C
$strD R
,R S
DataTypeT \
=] ^
Type_ c
.c d
GetTyped k
(k l
$strl z
)z {
}| }
)} ~
;~ 
batchOfRows 
. 
Columns 
.  
Add  #
(# $
new$ '

DataColumn( 2
(2 3
)3 4
{5 6
	MaxLength7 @
=A B
$numC E
,E F

ColumnNameG Q
=R S
$strT e
,e f
DataTypeg o
=p q
Typer v
.v w
GetTypew ~
(~ 
$str	 �
)
� �
}
� �
)
� �
;
� �
batchOfRows   
.   
Columns   
.    
Add    #
(  # $
new  $ '

DataColumn  ( 2
(  2 3
)  3 4
{  5 6
	MaxLength  7 @
=  A B
$num  C F
,  F G

ColumnName  H R
=  S T
$str  U a
,  a b
DataType  c k
=  l m
Type  n r
.  r s
GetType  s z
(  z {
$str	  { �
)
  � �
}
  � �
)
  � �
;
  � �
batchOfRows!! 
.!! 
Columns!! 
.!!  
Add!!  #
(!!# $
new!!$ '

DataColumn!!( 2
(!!2 3
)!!3 4
{!!5 6

ColumnName!!7 A
=!!B C
$str!!D N
,!!N O
DataType!!P X
=!!Y Z
Type!![ _
.!!_ `
GetType!!` g
(!!g h
$str!!h w
)!!w x
}!!y z
)!!z {
;!!{ |
batchOfRows"" 
."" 
Columns"" 
.""  
Add""  #
(""# $
new""$ '

DataColumn""( 2
(""2 3
)""3 4
{""5 6
	MaxLength""7 @
=""A B
$num""C F
,""F G

ColumnName""H R
=""S T
$str""U e
,""e f
DataType""g o
=""p q
Type""r v
.""v w
GetType""w ~
(""~ 
$str	"" �
)
""� �
}
""� �
)
""� �
;
""� �
batchOfRows## 
.## 
Columns## 
.##  
Add##  #
(### $
new##$ '

DataColumn##( 2
(##2 3
)##3 4
{##5 6

ColumnName##7 A
=##B C
$str##D M
,##M N
DataType##O W
=##X Y
Type##Z ^
.##^ _
GetType##_ f
(##f g
$str##g v
)##v w
}##x y
)##y z
;##z {
batchOfRows$$ 
.$$ 
Columns$$ 
.$$  
Add$$  #
($$# $
new$$$ '

DataColumn$$( 2
($$2 3
)$$3 4
{$$5 6

ColumnName$$7 A
=$$B C
$str$$D K
,$$K L
DataType$$M U
=$$V W
Type$$X \
.$$\ ]
GetType$$] d
($$d e
$str$$e s
)$$s t
}$$u v
)$$v w
;$$w x
batchOfRows%% 
.%% 
Columns%% 
.%%  
Add%%  #
(%%# $
new%%$ '

DataColumn%%( 2
(%%2 3
)%%3 4
{%%5 6

ColumnName%%7 A
=%%B C
$str%%D O
,%%O P
DataType%%Q Y
=%%Z [
Type%%\ `
.%%` a
GetType%%a h
(%%h i
$str%%i w
)%%w x
}%%y z
)%%z {
;%%{ |
batchOfRows&& 
.&& 
Columns&& 
.&&  
Add&&  #
(&&# $
new&&$ '

DataColumn&&( 2
(&&2 3
)&&3 4
{&&5 6

ColumnName&&7 A
=&&B C
$str&&D P
,&&P Q
DataType&&R Z
=&&[ \
Type&&] a
.&&a b
GetType&&b i
(&&i j
$str&&j x
)&&x y
}&&z {
)&&{ |
;&&| }
batchOfRows'' 
.'' 
Columns'' 
.''  
Add''  #
(''# $
new''$ '

DataColumn''( 2
(''2 3
)''3 4
{''5 6

ColumnName''7 A
=''B C
$str''D P
,''P Q
DataType''R Z
=''[ \
Type''] a
.''a b
GetType''b i
(''i j
$str''j x
)''x y
}''z {
)''{ |
;''| }
batchOfRows(( 
.(( 
Columns(( 
.((  
Add((  #
(((# $
new(($ '

DataColumn((( 2
(((2 3
)((3 4
{((5 6
	MaxLength((7 @
=((A B
$num((C F
,((F G

ColumnName((H R
=((S T
$str((U Z
,((Z [
DataType((\ d
=((e f
Type((g k
.((k l
GetType((l s
(((s t
$str	((t �
)
((� �
}
((� �
)
((� �
;
((� �
batchOfRows)) 
.)) 
Columns)) 
.))  
Add))  #
())# $
new))$ '

DataColumn))( 2
())2 3
)))3 4
{))5 6

ColumnName))7 A
=))B C
$str))D M
,))M N
DataType))O W
=))X Y
Type))Z ^
.))^ _
GetType))_ f
())f g
$str))g u
)))u v
}))w x
)))x y
;))y z
batchOfRows** 
.** 
Columns** 
.**  
Add**  #
(**# $
new**$ '

DataColumn**( 2
(**2 3
)**3 4
{**5 6

ColumnName**7 A
=**B C
$str**D N
,**N O
DataType**P X
=**Y Z
Type**[ _
.**_ `
GetType**` g
(**g h
$str**h v
)**v w
}**x y
)**y z
;**z {
batchOfRows++ 
.++ 
Columns++ 
.++  
Add++  #
(++# $
new++$ '

DataColumn++( 2
(++2 3
)++3 4
{++5 6

ColumnName++7 A
=++B C
$str++D R
,++R S
DataType++T \
=++] ^
Type++_ c
.++c d
GetType++d k
(++k l
$str++l }
)++} ~
}	++ �
)
++� �
;
++� �
batchOfRows,, 
.,, 
Columns,, 
.,,  
Add,,  #
(,,# $
new,,$ '

DataColumn,,( 2
(,,2 3
),,3 4
{,,5 6

ColumnName,,7 A
=,,B C
$str,,D O
,,,O P
DataType,,Q Y
=,,Z [
Type,,\ `
.,,` a
GetType,,a h
(,,h i
$str,,i w
),,w x
},,y z
),,z {
;,,{ |
batchOfRows-- 
.-- 
Columns-- 
.--  
Add--  #
(--# $
new--$ '

DataColumn--( 2
(--2 3
)--3 4
{--5 6
	MaxLength--7 @
=--A B
$num--C F
,--F G

ColumnName--H R
=--S T
$str--U ^
,--^ _
DataType--` h
=--i j
Type--k o
.--o p
GetType--p w
(--w x
$str	--x �
)
--� �
}
--� �
)
--� �
;
--� �
batchOfRows.. 
... 
Columns.. 
...  
Add..  #
(..# $
new..$ '

DataColumn..( 2
(..2 3
)..3 4
{..5 6
	MaxLength..7 @
=..A B
$num..C F
,..F G

ColumnName..H R
=..S T
$str..U _
,.._ `
DataType..a i
=..j k
Type..l p
...p q
GetType..q x
(..x y
$str	..y �
)
..� �
}
..� �
)
..� �
;
..� �
batchOfRows// 
.// 
Columns// 
.//  
Add//  #
(//# $
new//$ '

DataColumn//( 2
(//2 3
)//3 4
{//5 6
	MaxLength//7 @
=//A B
$num//C F
,//F G

ColumnName//H R
=//S T
$str//U g
,//g h
DataType//i q
=//r s
Type//t x
.//x y
GetType	//y �
(
//� �
$str
//� �
)
//� �
}
//� �
)
//� �
;
//� �
batchOfRows00 
.00 
Columns00 
.00  
Add00  #
(00# $
new00$ '

DataColumn00( 2
(002 3
)003 4
{005 6

ColumnName007 A
=00B C
$str00D M
,00M N
DataType00O W
=00X Y
Type00Z ^
.00^ _
GetType00_ f
(00f g
$str00g u
)00u v
}00w x
)00x y
;00y z
}22 	
public44 
void44 
Dispose44 
(44 
)44 
{55 	
sqlConnection66 
.66 
Close66 
(66  
)66  !
;66! "
sqlConnection77 
.77 
Dispose77 !
(77! "
)77" #
;77# $
batchOfRows88 
.88 
Dispose88 
(88  
)88  !
;88! "
}99 	
public;; 
void;; 
	AddJtlRow;; 
(;; 
dynamic;; %
csvRow;;& ,
);;, -
{<< 	
DataRow>> 
dataRow>> 
=>> 
batchOfRows>> )
.>>) *
NewRow>>* 0
(>>0 1
)>>1 2
;>>2 3
dataRow?? 
[?? 
$str?? 
]??  
=??! "
Int64??# (
.??( )
Parse??) .
(??. /
csvRow??/ 5
.??5 6
	timeStamp??6 ?
)??? @
;??@ A
dataRow@@ 
[@@ 
$str@@ 
]@@ 
=@@  
Int32@@! &
.@@& '
Parse@@' ,
(@@, -
csvRow@@- 3
.@@3 4
elapsed@@4 ;
)@@; <
;@@< =
dataRowAA 
[AA 
$strAA 
]AA 
=AA 
csvRowAA %
.AA% &
labelAA& +
;AA+ ,
intBB 
tossBB 
;BB 
dataRowCC 
[CC 
$strCC "
]CC" #
=CC$ %
Int32CC& +
.CC+ ,
TryParseCC, 4
(CC4 5
csvRowCC5 ;
.CC; <
responseCodeCC< H
,CCH I
outCCJ M
tossCCN R
)CCR S
?CCT U
Int32CCV [
.CC[ \
ParseCC\ a
(CCa b
csvRowCCb h
.CCh i
responseCodeCCi u
)CCu v
:CCw x
-CCy z
$numCCz {
;CC{ |
dataRowDD 
[DD 
$strDD  
]DD  !
=DD" #
csvRowDD$ *
.DD* +

threadNameDD+ 5
;DD5 6
dataRowEE 
[EE 
$strEE 
]EE 
=EE  !
csvRowEE" (
.EE( )
dataTypeEE) 1
;EE1 2
dataRowFF 
[FF 
$strFF 
]FF 
=FF  
csvRowFF! '
.FF' (
successFF( /
;FF/ 0
dataRowGG 
[GG 
$strGG $
]GG$ %
=GG& '
csvRowGG( .
.GG. /
failureMessageGG/ =
;GG= >
dataRowHH 
[HH 
$strHH 
]HH 
=HH 
Int32HH $
.HH$ %
ParseHH% *
(HH* +
csvRowHH+ 1
.HH1 2
bytesHH2 7
)HH7 8
;HH8 9
dataRowII 
[II 
$strII 
]II  
=II! "
Int32II# (
.II( )
ParseII) .
(II. /
csvRowII/ 5
.II5 6
	sentBytesII6 ?
)II? @
;II@ A
dataRowJJ 
[JJ 
$strJJ  
]JJ  !
=JJ" #
Int32JJ$ )
.JJ) *
ParseJJ* /
(JJ/ 0
csvRowJJ0 6
.JJ6 7

grpThreadsJJ7 A
)JJA B
;JJB C
dataRowKK 
[KK 
$strKK  
]KK  !
=KK" #
Int32KK$ )
.KK) *
ParseKK* /
(KK/ 0
csvRowKK0 6
.KK6 7

allThreadsKK7 A
)KKA B
;KKB C
dataRowLL 
[LL 
$strLL 
]LL 
=LL 
csvRowLL #
.LL# $
URLLL$ '
;LL' (
dataRowMM 
[MM 
$strMM 
]MM 
=MM  
Int32MM! &
.MM& '
ParseMM' ,
(MM, -
csvRowMM- 3
.MM3 4
LatencyMM4 ;
)MM; <
;MM< =
dataRowNN 
[NN 
$strNN 
]NN 
=NN  !
Int32NN" '
.NN' (
ParseNN( -
(NN- .
csvRowNN. 4
.NN4 5
IdleTimeNN5 =
)NN= >
;NN> ?
dataRowOO 
[OO 
$strOO "
]OO" #
=OO$ %
csvRowOO& ,
.OO, -
UtcTimeStampOO- 9
;OO9 :
dataRowPP 
[PP 
$strPP 
]PP  
=PP! "
ConvertPP# *
.PP* +
ToInt32PP+ 2
(PP2 3
csvRowPP3 9
.PP9 :
	ElapsedMSPP: C
)PPC D
;PPD E
dataRowQQ 
[QQ 
$strQQ 
]QQ 
=QQ  
csvRowQQ! '
.QQ' (
TestRunQQ( /
;QQ/ 0
dataRowRR 
[RR 
$strRR 
]RR 
=RR  !
csvRowRR" (
.RR( )
TestPlanRR) 1
;RR1 2
dataRowSS 
[SS 
$strSS &
]SS& '
=SS( )
csvRowSS* 0
.SS0 1
LabelPlusTestRunSS1 A
;SSA B
dataRowTT 
[TT 
$strTT 
]TT 
=TT  
Int32TT! &
.TT& '
ParseTT' ,
(TT, -
csvRowTT- 3
.TT3 4
ConnectTT4 ;
)TT; <
;TT< =
batchOfRowsUU 
.UU 
RowsUU 
.UU 
AddUU  
(UU  !
dataRowUU! (
)UU( )
;UU) *
}WW 	
publicYY 
voidYY 
CommitBatchYY 
(YY  
)YY  !
{ZZ 	
SqlBulkCopyOptions[[ 
sqlBulkCopyOptions[[ 1
=[[2 3
new[[4 7
SqlBulkCopyOptions[[8 J
([[J K
)[[K L
;[[L M
using]] 
SqlBulkCopy]] 
bulkCopy]] &
=]]' (
new]]) ,
SqlBulkCopy]]- 8
(]]8 9
this]]9 =
.]]= >
sqlConnection]]> K
)]]K L
;]]L M
bulkCopy^^ 
.^^  
DestinationTableName^^ )
=^^* +
$str^^, >
;^^> ?
bulkCopy__ 
.__ 
ColumnMappings__ #
.__# $
Add__$ '
(__' (
$str__( 3
,__3 4
$str__5 @
)__@ A
;__A B
bulkCopy`` 
.`` 
ColumnMappings`` #
.``# $
Add``$ '
(``' (
$str``( 1
,``1 2
$str``3 <
)``< =
;``= >
bulkCopyaa 
.aa 
ColumnMappingsaa #
.aa# $
Addaa$ '
(aa' (
$straa( /
,aa/ 0
$straa1 8
)aa8 9
;aa9 :
bulkCopybb 
.bb 
ColumnMappingsbb #
.bb# $
Addbb$ '
(bb' (
$strbb( 6
,bb6 7
$strbb8 F
)bbF G
;bbG H
bulkCopycc 
.cc 
ColumnMappingscc #
.cc# $
Addcc$ '
(cc' (
$strcc( 9
,cc9 :
$strcc; L
)ccL M
;ccM N
bulkCopydd 
.dd 
ColumnMappingsdd #
.dd# $
Adddd$ '
(dd' (
$strdd( 4
,dd4 5
$strdd6 B
)ddB C
;ddC D
bulkCopyee 
.ee 
ColumnMappingsee #
.ee# $
Addee$ '
(ee' (
$stree( 2
,ee2 3
$stree4 >
)ee> ?
;ee? @
bulkCopyff 
.ff 
ColumnMappingsff #
.ff# $
Addff$ '
(ff' (
$strff( 1
,ff1 2
$strff3 <
)ff< =
;ff= >
bulkCopygg 
.gg 
ColumnMappingsgg #
.gg# $
Addgg$ '
(gg' (
$strgg( 8
,gg8 9
$strgg: J
)ggJ K
;ggK L
bulkCopyhh 
.hh 
ColumnMappingshh #
.hh# $
Addhh$ '
(hh' (
$strhh( /
,hh/ 0
$strhh1 8
)hh8 9
;hh9 :
bulkCopyii 
.ii 
ColumnMappingsii #
.ii# $
Addii$ '
(ii' (
$strii( 3
,ii3 4
$strii5 @
)ii@ A
;iiA B
bulkCopyjj 
.jj 
ColumnMappingsjj #
.jj# $
Addjj$ '
(jj' (
$strjj( 4
,jj4 5
$strjj6 B
)jjB C
;jjC D
bulkCopykk 
.kk 
ColumnMappingskk #
.kk# $
Addkk$ '
(kk' (
$strkk( 4
,kk4 5
$strkk6 B
)kkB C
;kkC D
bulkCopyll 
.ll 
ColumnMappingsll #
.ll# $
Addll$ '
(ll' (
$strll( -
,ll- .
$strll/ 4
)ll4 5
;ll5 6
bulkCopymm 
.mm 
ColumnMappingsmm #
.mm# $
Addmm$ '
(mm' (
$strmm( 1
,mm1 2
$strmm3 <
)mm< =
;mm= >
bulkCopynn 
.nn 
ColumnMappingsnn #
.nn# $
Addnn$ '
(nn' (
$strnn( 2
,nn2 3
$strnn4 >
)nn> ?
;nn? @
bulkCopyoo 
.oo 
ColumnMappingsoo #
.oo# $
Addoo$ '
(oo' (
$stroo( 1
,oo1 2
$stroo3 <
)oo< =
;oo= >
bulkCopypp 
.pp 
ColumnMappingspp #
.pp# $
Addpp$ '
(pp' (
$strpp( 1
,pp1 2
$strpp3 <
)pp< =
;pp= >
bulkCopyqq 
.qq 
ColumnMappingsqq #
.qq# $
Addqq$ '
(qq' (
$strqq( 2
,qq2 3
$strqq4 >
)qq> ?
;qq? @
bulkCopyrr 
.rr 
ColumnMappingsrr #
.rr# $
Addrr$ '
(rr' (
$strrr( 6
,rr6 7
$strrr8 F
)rrF G
;rrG H
bulkCopyss 
.ss 
ColumnMappingsss #
.ss# $
Addss$ '
(ss' (
$strss( 3
,ss3 4
$strss5 @
)ss@ A
;ssA B
bulkCopytt 
.tt 
ColumnMappingstt #
.tt# $
Addtt$ '
(tt' (
$strtt( :
,tt: ;
$strtt< N
)ttN O
;ttO P
bulkCopyvv 
.vv 
WriteToServervv "
(vv" #
batchOfRowsvv# .
)vv. /
;vv/ 0
batchOfRowsww 
.ww 
Clearww 
(ww 
)ww 
;ww  
}xx 	
publiczz 
staticzz 
boolzz "
ReportAlreadyProcessedzz 1
(zz1 2
stringzz2 8
testPlanzz9 A
,zzA B
stringzzC I
testRunzzJ Q
,zzQ R
stringzzS Y
connectionStringzzZ j
)zzj k
{{{ 	
using|| 
SqlConnection|| 
testRunsConnection||  2
=||3 4
new||5 8
SqlConnection||9 F
(||F G
connectionString||G W
)||W X
;||X Y
testRunsConnection}} 
.}} 
Open}} #
(}}# $
)}}$ %
;}}% &
using~~ 

SqlCommand~~ 
checkForReport~~ +
=~~, -
new~~. 1

SqlCommand~~2 <
(~~< =
)~~= >
{ 
CommandText
�� 
=
�� 
$str
�� .
,
��. /

Connection
�� 
=
��  
testRunsConnection
�� /
,
��/ 0
CommandType
�� 
=
�� 
CommandType
�� )
.
��) *
StoredProcedure
��* 9
}
�� 
;
�� 
int
�� 
reportExists
�� 
=
�� 
$num
��  
;
��  !
checkForReport
�� 
.
�� 

Parameters
�� %
.
��% &
Add
��& )
(
��) *
new
��* -
SqlParameter
��. :
(
��: ;
)
��; <
{
��= >
ParameterName
��? L
=
��M N
$str
��O Y
,
��Y Z
DbType
��[ a
=
��b c
DbType
��d j
.
��j k
String
��k q
,
��q r
Value
��s x
=
��y z
testRun��{ �
}��� �
)��� �
;��� �
checkForReport
�� 
.
�� 

Parameters
�� %
.
��% &
Add
��& )
(
��) *
new
��* -
SqlParameter
��. :
(
��: ;
)
��; <
{
��= >
ParameterName
��? L
=
��M N
$str
��O Z
,
��Z [
DbType
��\ b
=
��c d
DbType
��e k
.
��k l
String
��l r
,
��r s
Value
��t y
=
��z {
testPlan��| �
}��� �
)��� �
;��� �
checkForReport
�� 
.
�� 

Parameters
�� %
.
��% &
Add
��& )
(
��) *
new
��* -
SqlParameter
��. :
(
��: ;
)
��; <
{
��= >
ParameterName
��? L
=
��M N
$str
��O ^
,
��^ _
	Direction
��` i
=
��j k 
ParameterDirection
��l ~
.
��~ 
Output�� �
,��� �
DbType��� �
=��� �
DbType��� �
.��� �
Int32��� �
,��� �
}��� �
)��� �
;��� �
checkForReport
�� 
.
�� 
ExecuteNonQuery
�� *
(
��* +
)
��+ ,
;
��, -
reportExists
�� 
=
�� 
(
�� 
int
�� 
)
��  
checkForReport
��  .
.
��. /

Parameters
��/ 9
[
��9 :
$str
��: I
]
��I J
.
��J K
Value
��K P
;
��P Q
return
�� 
reportExists
�� 
>
��  !
$num
��" #
;
��# $
}
�� 	
public
�� 
void
�� 
	AddReport
�� 
(
�� 
string
�� $
testPlan
��% -
,
��- .
string
��/ 5
testRun
��6 =
,
��= >
DateTime
��? G
testStartTime
��H U
)
��U V
{
�� 	
CommitBatch
�� 
(
�� 
)
�� 
;
�� 
using
�� 

SqlCommand
�� 
spAddReport
�� (
=
��) *
new
��+ .

SqlCommand
��/ 9
(
��9 :
)
��: ;
{
�� 

Connection
�� 
=
�� 
this
�� !
.
��! "
sqlConnection
��" /
,
��/ 0
CommandText
�� 
=
�� 
$str
�� +
,
��+ ,
CommandType
�� 
=
�� 
CommandType
�� )
.
��) *
StoredProcedure
��* 9
}
�� 
;
�� 
spAddReport
�� 
.
�� 

Parameters
�� "
.
��" #
Add
��# &
(
��& '
new
��' *
SqlParameter
��+ 7
(
��7 8
)
��8 9
{
��: ;
ParameterName
��< I
=
��J K
$str
��L V
,
��V W
DbType
��X ^
=
��_ `
DbType
��a g
.
��g h
String
��h n
,
��n o
Value
��p u
=
��v w
testRun
��x 
}��� �
)��� �
;��� �
spAddReport
�� 
.
�� 

Parameters
�� "
.
��" #
Add
��# &
(
��& '
new
��' *
SqlParameter
��+ 7
(
��7 8
)
��8 9
{
��: ;
ParameterName
��< I
=
��J K
$str
��L W
,
��W X
DbType
��Y _
=
��` a
DbType
��b h
.
��h i
String
��i o
,
��o p
Value
��q v
=
��w x
testPlan��y �
}��� �
)��� �
;��� �
spAddReport
�� 
.
�� 

Parameters
�� "
.
��" #
Add
��# &
(
��& '
new
��' *
SqlParameter
��+ 7
(
��7 8
)
��8 9
{
��: ;
ParameterName
��< I
=
��J K
$str
��L X
,
��X Y
DbType
��Z `
=
��a b
DbType
��c i
.
��i j
DateTime
��j r
,
��r s
Value
��t y
=
��z {
testStartTime��| �
}��� �
)��� �
;��� �
spAddReport
�� 
.
�� 
ExecuteNonQuery
�� '
(
��' (
)
��( )
;
��) *
}
�� 	
public
�� 
void
�� 
DeleteReport
��  
(
��  !
string
��! '
testPlan
��( 0
,
��0 1
string
��2 8
testRun
��9 @
)
��@ A
{
�� 	
using
�� 

SqlCommand
�� 
spAddReport
�� (
=
��) *
new
��+ .

SqlCommand
��/ 9
(
��9 :
)
��: ;
{
�� 

Connection
�� 
=
�� 
this
�� !
.
��! "
sqlConnection
��" /
,
��/ 0
CommandText
�� 
=
�� 
$str
�� .
,
��. /
CommandType
�� 
=
�� 
CommandType
�� )
.
��) *
StoredProcedure
��* 9
,
��9 :
CommandTimeout
�� 
=
��  
$num
��! $
}
�� 
;
�� 
spAddReport
�� 
.
�� 

Parameters
�� "
.
��" #
Add
��# &
(
��& '
new
��' *
SqlParameter
��+ 7
(
��7 8
)
��8 9
{
��: ;
ParameterName
��< I
=
��J K
$str
��L V
,
��V W
DbType
��X ^
=
��_ `
DbType
��a g
.
��g h
String
��h n
,
��n o
Value
��p u
=
��v w
testRun
��x 
}��� �
)��� �
;��� �
spAddReport
�� 
.
�� 

Parameters
�� "
.
��" #
Add
��# &
(
��& '
new
��' *
SqlParameter
��+ 7
(
��7 8
)
��8 9
{
��: ;
ParameterName
��< I
=
��J K
$str
��L W
,
��W X
DbType
��Y _
=
��` a
DbType
��b h
.
��h i
String
��i o
,
��o p
Value
��q v
=
��w x
testPlan��y �
}��� �
)��� �
;��� �
spAddReport
�� 
.
�� 
ExecuteNonQuery
�� '
(
��' (
)
��( )
;
��) *
}
�� 	
}
�� 
}�� 