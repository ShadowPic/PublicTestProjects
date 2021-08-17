·¿
NC:\src\PublicTestProjects\source\JtlToSql\FileJtlToSql\ConsoleHostedService.cs
	namespace 	
FileJtlToSql
 
{ 
public 

class  
ConsoleHostedService %
:& '
IHostedService( 6
{ 
public 
class 
Options 
{ 	
[ 
Option 
( 
$str 
, 
Required  (
=) *
false+ 0
,0 1
HelpText2 :
=; <
$str= M
)M N
]N O
public 
string 
TestPlan "
{# $
get% (
;( )
set* -
;- .
}/ 0
[ 
Option 
( 
$str 
, 
Required '
=( )
false* /
,/ 0
HelpText1 9
=: ;
$str< P
)P Q
]Q R
public 
string 
TestRun !
{" #
get$ '
;' (
set) ,
;, -
}. /
} 	
private 
readonly 
ILogger  
logger! '
;' (
private 
readonly $
IHostApplicationLifetime 1
_appLifetime2 >
;> ?
public  
ConsoleHostedService #
(# $
ILogger 
<  
ConsoleHostedService (
>( )
logger* 0
,0 1$
IHostApplicationLifetime   $
appLifetime  % 0
)  0 1
{!! 	
this"" 
."" 
logger"" 
="" 
logger""  
;""  !
_appLifetime## 
=## 
appLifetime## &
;##& '
}$$ 	
CancellationToken%% #
commonCancellationToken%% 1
;%%1 2
public&& 
Task&& 

StartAsync&& 
(&& 
CancellationToken&& 0
cancellationToken&&1 B
)&&B C
{'' 	
_appLifetime(( 
.(( 
ApplicationStarted(( +
.((+ ,
Register((, 4
(((4 5
(((5 6
)((6 7
=>((8 :
{)) 
Task** 
.** 
Run** 
(** 
async** 
(**  
)**  !
=>**" $
{++ #
commonCancellationToken,, +
=,,, -
cancellationToken,,. ?
;,,? @
var--  
commandLineArguments-- ,
=--- .
Environment--/ :
.--: ;
GetCommandLineArgs--; M
(--M N
)--N O
;--O P
_.. 
=.. 
CommandLine.. #
...# $
Parser..$ *
...* +
Default..+ 2
...2 3
ParseArguments..3 A
<..A B
Options..B I
>..I J
(..J K 
commandLineArguments..K _
).._ `
.// 
WithParsedAsync// (
(//( )
RunWithOptions//) 7
)//7 8
;//8 9
}22 
)22 
;22 
}33 
)33 
;33 
return55 
Task55 
.55 
CompletedTask55 %
;55% &
}66 	
async88 
Task88 
RunWithOptions88 !
(88! "
Options88" )
options88* 1
)881 2
{99 	
Console:: 
.:: 
	WriteLine:: 
(:: 
$str:: 1
)::1 2
;::2 3
if;; 
(;; 
options;; 
.;; 
TestPlan;;  
!=;;! #
null;;$ (
&&;;) +
options;;, 3
.;;3 4
TestRun;;4 ;
!=;;< >
null;;? C
);;C D
{<< %
DeleteReportsFromDatabase== )
(==) *
testPlan==* 2
:==2 3
options==4 ;
.==; <
TestPlan==< D
,==D E
testRun==F M
:==M N
options==O V
.==V W
TestRun==W ^
)==^ _
;==_ `
_appLifetime>> 
.>> 
StopApplication>> ,
(>>, -
)>>- .
;>>. /
return?? 
;?? 
}@@ 
tryBB 
{CC 
boolDD 
runOnceAndStopDD #
=DD$ %
falseDD& +
;DD+ ,
boolEE  
alreadyGotTheResultsEE )
=EE* +
falseEE, 1
;EE1 2
whileGG 
(GG 
!GG #
commonCancellationTokenGG /
.GG/ 0#
IsCancellationRequestedGG0 G
&&GGH J
!GGK L
runOnceAndStopGGL Z
)GGZ [
{HH 
runOnceAndStopII "
=II# $
EnvironmentII% 0
.II0 1"
GetEnvironmentVariableII1 G
(IIG H
$strIIH X
)IIX Y
!=IIZ \
nullII] a
?IIb c
boolIId h
.IIh i
ParseIIi n
(IIn o
EnvironmentIIo z
.IIz {#
GetEnvironmentVariable	II{ ë
(
IIë í
$str
IIí ¢
)
II¢ £
)
II£ §
:
II• ¶
false
IIß ¨
;
II¨ ≠
varJJ 
sqlConnectionStringJJ +
=JJ, -
EnvironmentJJ. 9
.JJ9 :"
GetEnvironmentVariableJJ: P
(JJP Q
$strJJQ g
)JJg h
;JJh i
varKK #
storageConnectionStringKK /
=KK0 1
EnvironmentKK2 =
.KK= >"
GetEnvironmentVariableKK> T
(KKT U
$strKKU j
)KKj k
;KKk l
loggerLL 
.LL 
LogInformationLL )
(LL) *
$strLL* n
)LLn o
;LLo p
QueueClientMM 
queueClientMM  +
=MM, -
newMM. 1
QueueClientMM2 =
(MM= >#
storageConnectionStringMM> U
,MMU V
$strMMW j
.MMj k
ToLowerMMk r
(MMr s
)MMs t
)MMt u
;MMu v
queueClientNN 
.NN  
CreateIfNotExistsNN  1
(NN1 2
)NN2 3
;NN3 4
ifOO 
(OO 
queueClientOO #
.OO# $
ExistsOO$ *
(OO* +
)OO+ ,
)OO, -
{PP 
loggerQQ 
.QQ 
LogInformationQQ -
(QQ- .
$strQQ. S
)QQS T
;QQT U
loggerRR 
.RR 
LogInformationRR -
(RR- .
$strRR. e
)RRe f
;RRf g
ifSS 
(SS 
(SS 
queueClientSS (
.SS( )
PeekMessagesSS) 5
(SS5 6
)SS6 7
.SS7 8
ValueSS8 =
.SS= >
LengthSS> D
==SSE G
$numSSH I
)SSI J
&&SSK M
!SSN O 
alreadyGotTheResultsSSO c
)SSc d
{TT  
AddResultsToTheQueueUU 0
(UU0 1
queueClientUU1 <
,UU< =#
storageConnectionStringUU> U
,UUU V
sqlConnectionStringUUW j
)UUj k
;UUk l 
alreadyGotTheResultsVV 0
=VV1 2
trueVV3 7
;VV7 8
}WW 
SendResultsToSqlXX (
(XX( )
queueClientXX) 4
:XX4 5
queueClientXX6 A
,XXA B#
storageConnectionStringXXC Z
:XXZ [#
storageConnectionStringXX\ s
,XXs t 
sqlConnectionString	XXu à
:
XXà â!
sqlConnectionString
XXä ù
)
XXù û
;
XXû ü
}YY 
ifZZ 
(ZZ 
!ZZ 
runOnceAndStopZZ '
)ZZ' (
{[[ 
logger\\ 
.\\ 
LogInformation\\ -
(\\- .
$str\\. K
)\\K L
;\\L M
await]] 
Task]] "
.]]" #
Delay]]# (
(]]( )
$num]]) .
,]]. /#
commonCancellationToken]]0 G
)]]G H
;]]H I
}^^ 
}__ 
logger`` 
.`` 
LogInformation`` %
(``% &
$str``& 7
)``7 8
;``8 9
}aa 
catchbb 
(bb 
	Exceptionbb 
exbb 
)bb  
{cc 
loggerdd 
.dd 
LogErrordd 
(dd  
exdd  "
,dd" #
$strdd$ :
)dd: ;
;dd; <
throwee 
;ee 
}ff 
finallygg 
{hh 
_appLifetimejj 
.jj 
StopApplicationjj ,
(jj, -
)jj- .
;jj. /
}kk 
}ll 	
voidnn  
AddResultsToTheQueuenn !
(nn! "
QueueClientnn" -
queueClientnn. 9
,nn9 :
stringnn; A#
storageConnectionStringnnB Y
,nnY Z
stringnn[ a
sqlConnectionStringnnb u
)nnu v
{oo 	
loggerpp 
.pp 
LogInformationpp !
(pp! "
$strpp" Y
)ppY Z
;ppZ [
loggerrr 
.rr 
LogInformationrr !
(rr! "
$strrr" J
)rrJ K
;rrK L
BlobContainerClientss "
jmeterResultsContainerss  6
=ss7 8
newss9 <
BlobContainerClientss= P
(ssP Q#
storageConnectionStringssQ h
,ssh i
$strssj y
)ssy z
;ssz {
foreachtt 
(tt 
vartt !
jmeterResultsBlobItemtt .
intt/ 1"
jmeterResultsContainertt2 H
.ttH I
GetBlobsttI Q
(ttQ R
)ttR S
)ttS T
{uu 
ifvv 
(vv !
jmeterResultsBlobItemvv )
.vv) *
Namevv* .
.vv. /
EndsWithvv/ 7
(vv7 8
$strvv8 E
,vvE F
StringComparisonvvG W
.vvW X
OrdinalIgnoreCasevvX i
)vvi j
)vvj k
{ww 
stringxx 
testPlanxx #
=xx$ %
CsvJtlxx& ,
.xx, -
ExtractTestPlanxx- <
(xx< =!
jmeterResultsBlobItemxx= R
.xxR S
NamexxS W
)xxW X
;xxX Y
stringyy 
testRunyy "
=yy# $
CsvJtlyy% +
.yy+ ,
ExtractTestRunyy, :
(yy: ;!
jmeterResultsBlobItemyy; P
.yyP Q
NameyyQ U
)yyU V
;yyV W
loggerzz 
.zz 
LogInformationzz )
(zz) *
$"zz* ,
$strzz, A
{zzA B
testRunzzB I
}zzI J
$strzzJ Y
{zzY Z
testPlanzzZ b
}zzb c
$str	zzc Ç
"
zzÇ É
)
zzÉ Ñ
;
zzÑ Ö
if{{ 
({{ 
!{{ 
JtlCsvToSql{{ $
.{{$ %"
ReportAlreadyProcessed{{% ;
({{; <
testPlan{{< D
,{{D E
testRun{{F M
,{{M N
sqlConnectionString{{O b
){{b c
){{c d
{|| 
logger}} 
.}} 
LogInformation}} -
(}}- .
$"}}. 0
$str}}0 P
{}}P Q
testRun}}Q X
}}}X Y
$str}}Y h
{}}h i
testPlan}}i q
}}}q r
$str	}}r Ü
"
}}Ü á
)
}}á à
;
}}à â
logger~~ 
.~~ 
LogInformation~~ -
(~~- .
$"~~. 0
$str~~0 7
{~~7 8!
jmeterResultsBlobItem~~8 M
.~~M N
Name~~N R
}~~R S
"~~S T
)~~T U
;~~U V
var #
resultsJtlBlobPathBytes 3
=4 5
Encoding6 >
.> ?
UTF8? C
.C D
GetBytesD L
(L M!
jmeterResultsBlobItemM b
.b c
Namec g
)g h
;h i
queueClient
ÄÄ #
.
ÄÄ# $
SendMessage
ÄÄ$ /
(
ÄÄ/ 0
Convert
ÄÄ0 7
.
ÄÄ7 8
ToBase64String
ÄÄ8 F
(
ÄÄF G%
resultsJtlBlobPathBytes
ÄÄG ^
)
ÄÄ^ _
)
ÄÄ_ `
;
ÄÄ` a
}
ÅÅ 
}
ÇÇ 
}
ÉÉ 
}
ÑÑ 	
void
ÜÜ 
SendResultsToSql
ÜÜ 
(
ÜÜ 
QueueClient
ÜÜ )
queueClient
ÜÜ* 5
,
ÜÜ5 6
string
ÜÜ7 =%
storageConnectionString
ÜÜ> U
,
ÜÜU V
string
ÜÜW ]!
sqlConnectionString
ÜÜ^ q
)
ÜÜq r
{
áá 	
while
àà 
(
àà 
queueClient
àà 
.
àà 
PeekMessages
àà +
(
àà+ ,
)
àà, -
.
àà- .
Value
àà. 3
.
àà3 4
Length
àà4 :
>
àà; <
$num
àà= >
)
àà> ?
{
ââ 
logger
ää 
.
ää 
LogInformation
ää %
(
ää% &
$str
ää& A
)
ääA B
;
ääB C
QueueMessage
åå 
[
åå 
]
åå 
retrievedMessages
åå 0
=
åå1 2
queueClient
åå3 >
.
åå> ?
ReceiveMessages
åå? N
(
ååN O
)
ååO P
;
ååP Q
if
çç 
(
çç 
retrievedMessages
çç %
==
çç& (
null
çç) -
||
çç. 0
retrievedMessages
çç1 B
.
ççB C
Length
ççC I
==
ççJ L
$num
ççM N
)
ççN O
{
éé 
logger
èè 
.
èè 
LogInformation
èè )
(
èè) *
$str
èè* C
)
èèC D
;
èèD E
}
ëë 
else
íí 
{
ìì 
string
îî  
resultsJtlBlobPath
îî -
=
îî. /
null
îî0 4
;
îî4 5
string
ïï 
csvFileName
ïï &
=
ïï' (
$"
ïï) +
{
ïï+ ,
Guid
ïï, 0
.
ïï0 1
NewGuid
ïï1 8
(
ïï8 9
)
ïï9 :
}
ïï: ;
$str
ïï; ?
"
ïï? @
;
ïï@ A
try
ññ 
{
óó  
resultsJtlBlobPath
òò *
=
òò+ ,
Encoding
òò- 5
.
òò5 6
UTF8
òò6 :
.
òò: ;
	GetString
òò; D
(
òòD E
Convert
òòE L
.
òòL M
FromBase64String
òòM ]
(
òò] ^
retrievedMessages
òò^ o
[
òòo p
$num
òòp q
]
òòq r
.
òòr s
Body
òòs w
.
òòw x
ToStringòòx Ä
(òòÄ Å
)òòÅ Ç
)òòÇ É
)òòÉ Ñ
;òòÑ Ö
logger
ôô 
.
ôô 
LogInformation
ôô -
(
ôô- .
$"
ôô. 0
$str
ôô0 <
{
ôô< = 
resultsJtlBlobPath
ôô= O
}
ôôO P
"
ôôP Q
)
ôôQ R
;
ôôR S

BlobClient
öö "

blobClient
öö# -
=
öö. /
new
öö0 3

BlobClient
öö4 >
(
öö> ?%
storageConnectionString
öö? V
,
ööV W
$str
ööX g
,
öög h 
resultsJtlBlobPath
ööi {
)
öö{ |
;
öö| }

blobClient
õõ "
.
õõ" #

DownloadTo
õõ# -
(
õõ- .
csvFileName
õõ. 9
)
õõ9 :
;
õõ: ;
queueClient
ùù #
.
ùù# $
DeleteMessage
ùù$ 1
(
ùù1 2
retrievedMessages
ùù2 C
[
ùùC D
$num
ùùD E
]
ùùE F
.
ùùF G
	MessageId
ùùG P
,
ùùP Q
retrievedMessages
ùùR c
[
ùùc d
$num
ùùd e
]
ùùe f
.
ùùf g

PopReceipt
ùùg q
)
ùùq r
;
ùùr s
logger
ûû 
.
ûû 
LogInformation
ûû -
(
ûû- .
$"
ûû. 0
$str
ûû0 A
{
ûûA B 
resultsJtlBlobPath
ûûB T
}
ûûT U
"
ûûU V
)
ûûV W
;
ûûW X
using
†† 
var
†† !
csvJtl
††" (
=
††) *
new
††+ .
CsvJtl
††/ 5
(
††5 6 
resultsJtlBlobPath
††6 H
)
††H I
;
††I J
logger
°° 
.
°° 
LogInformation
°° -
(
°°- .
$str
°°. R
)
°°R S
;
°°S T
using
¢¢ 
var
¢¢ !
jtlCsvToSql
¢¢" -
=
¢¢. /
new
¢¢0 3
JtlCsvToSql
¢¢4 ?
(
¢¢? @!
sqlConnectionString
¢¢@ S
)
¢¢S T
;
¢¢T U
csvJtl
££ 
.
££ 
InitJtlReader
££ ,
(
££, -
csvFileName
££- 8
)
££8 9
;
££9 :
if
§§ 
(
§§ 
!
§§ 
JtlCsvToSql
§§ (
.
§§( )$
ReportAlreadyProcessed
§§) ?
(
§§? @
csvJtl
§§@ F
.
§§F G
TestPlan
§§G O
,
§§O P
csvJtl
§§Q W
.
§§W X
TestRun
§§X _
,
§§_ `!
sqlConnectionString
§§a t
)
§§t u
)
§§u v
{
•• 
logger
¶¶ "
.
¶¶" #
LogInformation
¶¶# 1
(
¶¶1 2
$"
¶¶2 4
$str
¶¶4 [
{
¶¶[ \
csvJtl
¶¶\ b
.
¶¶b c
TestPlan
¶¶c k
}
¶¶k l
$str
¶¶l z
{
¶¶z {
csvJtl¶¶{ Å
.¶¶Å Ç
TestRun¶¶Ç â
}¶¶â ä
"¶¶ä ã
)¶¶ã å
;¶¶å ç
jtlCsvToSql
ßß '
.
ßß' (
DeleteReport
ßß( 4
(
ßß4 5
csvJtl
ßß5 ;
.
ßß; <
TestPlan
ßß< D
,
ßßD E
csvJtl
ßßF L
.
ßßL M
TestRun
ßßM T
)
ßßT U
;
ßßU V
logger
®® "
.
®®" #
LogInformation
®®# 1
(
®®1 2
$str
®®2 Q
)
®®Q R
;
®®R S
int
©© 
i
©©  !
=
©©" #
$num
©©$ %
;
©©% &
while
™™ !
(
™™" #
csvJtl
™™# )
.
™™) *
ReadNextCsvLine
™™* 9
(
™™9 :
)
™™: ;
)
™™; <
{
´´ 
var
¨¨  #
csvRow
¨¨$ *
=
¨¨+ ,
csvJtl
¨¨- 3
.
¨¨3 4
	GetCsvRow
¨¨4 =
(
¨¨= >
)
¨¨> ?
;
¨¨? @
try
≠≠  #
{
ÆÆ  !
if
ØØ$ &
(
ØØ' (
i
ØØ( )
>
ØØ* +
$num
ØØ, 1
)
ØØ1 2
{
∞∞$ %
logger
±±( .
.
±±. /
LogInformation
±±/ =
(
±±= >
$"
±±> @
$str
±±@ K
{
±±K L
i
±±L M
}
±±M N
$str
±±N _
{
±±_ `
csvJtl
±±` f
.
±±f g
TestRun
±±g n
}
±±n o
"
±±o p
)
±±p q
;
±±q r
jtlCsvToSql
≤≤( 3
.
≤≤3 4
CommitBatch
≤≤4 ?
(
≤≤? @
)
≤≤@ A
;
≤≤A B
i
≥≥( )
=
≥≥* +
$num
≥≥, -
;
≥≥- .
}
¥¥$ %
jtlCsvToSql
µµ$ /
.
µµ/ 0
	AddJtlRow
µµ0 9
(
µµ9 :
csvRow
µµ: @
)
µµ@ A
;
µµA B
i
∂∂$ %
++
∂∂% '
;
∂∂' (
}
∑∑  !
catch
∏∏  %
(
∏∏& '
	Exception
∏∏' 0
e
∏∏1 2
)
∏∏2 3
{
ππ  !
logger
ππ" (
.
ππ( )

LogWarning
ππ) 3
(
ππ3 4
$"
ππ4 6
$str
ππ6 D
{
ππD E
e
ππE F
.
ππF G
ToString
ππG O
(
ππO P
)
ππP Q
}
ππQ R
"
ππR S
)
ππS T
;
ππT U
}
ππV W
}
∫∫ 
logger
ªª "
.
ªª" #
LogInformation
ªª# 1
(
ªª1 2
$str
ªª2 p
)
ªªp q
;
ªªq r
jtlCsvToSql
ºº '
.
ºº' (
	AddReport
ºº( 1
(
ºº1 2
csvJtl
ºº2 8
.
ºº8 9
TestPlan
ºº9 A
,
ººA B
csvJtl
ººC I
.
ººI J
TestRun
ººJ Q
,
ººQ R
csvJtl
ººS Y
.
ººY Z
TestStartTime
ººZ g
)
ººg h
;
ººh i
}
ΩΩ 
else
ææ 
{
øø 
logger
¿¿ "
.
¿¿" #
LogInformation
¿¿# 1
(
¿¿1 2
$"
¿¿2 4
$str
¿¿4 A
{
¿¿A B
csvJtl
¿¿B H
.
¿¿H I
TestRun
¿¿I P
}
¿¿P Q
$str
¿¿Q `
{
¿¿` a
csvJtl
¿¿a g
.
¿¿g h
TestPlan
¿¿h p
}
¿¿p q
$str¿¿q è
"¿¿è ê
)¿¿ê ë
;¿¿ë í
}
¡¡ 
}
√√ 
catch
ƒƒ 
(
ƒƒ 
	Exception
ƒƒ $
e
ƒƒ% &
)
ƒƒ& '
{
≈≈ 
logger
∆∆ 
.
∆∆ 
LogError
∆∆ '
(
∆∆' (
e
∆∆( )
.
∆∆) *
ToString
∆∆* 2
(
∆∆2 3
)
∆∆3 4
)
∆∆4 5
;
∆∆5 6
logger
«« 
.
«« 

LogWarning
«« )
(
««) *
$"
««* ,
$str
««, V
{
««V W 
resultsJtlBlobPath
««W i
}
««i j
"
««j k
)
««k l
;
««l m
var
»» %
resultsJtlBlobPathBytes
»» 3
=
»»4 5
Encoding
»»6 >
.
»»> ?
UTF8
»»? C
.
»»C D
GetBytes
»»D L
(
»»L M 
resultsJtlBlobPath
»»M _
)
»»_ `
;
»»` a
queueClient
…… #
.
……# $
SendMessage
……$ /
(
……/ 0
Convert
……0 7
.
……7 8
ToBase64String
……8 F
(
……F G%
resultsJtlBlobPathBytes
……G ^
)
……^ _
)
……_ `
;
……` a
}
   
finally
ÀÀ 
{
ÃÃ 
File
ÕÕ 
.
ÕÕ 
Delete
ÕÕ #
(
ÕÕ# $
csvFileName
ÕÕ$ /
)
ÕÕ/ 0
;
ÕÕ0 1
}
ŒŒ 
}
œœ 
}
–– 
}
—— 	
private
”” 
void
”” '
DeleteReportsFromDatabase
”” .
(
””. /
String
””/ 5
testPlan
””6 >
,
””> ?
string
””@ F
testRun
””G N
)
””N O
{
‘‘ 	
var
÷÷ !
sqlConnectionString
÷÷ #
=
÷÷$ %
Environment
÷÷& 1
.
÷÷1 2$
GetEnvironmentVariable
÷÷2 H
(
÷÷H I
$str
÷÷I _
)
÷÷_ `
;
÷÷` a
logger
ŸŸ 
.
ŸŸ 
LogInformation
ŸŸ !
(
ŸŸ! "
$str
ŸŸ" F
)
ŸŸF G
;
ŸŸG H
using
⁄⁄ 
var
⁄⁄ 
jtlCsvToSql
⁄⁄ !
=
⁄⁄" #
new
⁄⁄$ '
JtlCsvToSql
⁄⁄( 3
(
⁄⁄3 4!
sqlConnectionString
⁄⁄4 G
)
⁄⁄G H
;
⁄⁄H I
if
€€ 
(
€€ 
JtlCsvToSql
€€ 
.
€€ $
ReportAlreadyProcessed
€€ 2
(
€€2 3
testPlan
€€3 ;
,
€€; <
testRun
€€= D
,
€€D E!
sqlConnectionString
€€F Y
)
€€Y Z
)
€€Z [
{
‹‹ 
logger
›› 
.
›› 
LogInformation
›› %
(
››% &
$"
››& (
$str
››( 1
{
››1 2
testRun
››2 9
}
››9 :
$str
››: I
{
››I J
testPlan
››J R
}
››R S
$str
››S f
"
››f g
)
››g h
;
››h i
jtlCsvToSql
ﬁﬁ 
.
ﬁﬁ 
DeleteReport
ﬁﬁ (
(
ﬁﬁ( )
testPlan
ﬁﬁ) 1
,
ﬁﬁ1 2
testRun
ﬁﬁ3 :
)
ﬁﬁ: ;
;
ﬁﬁ; <
logger
ﬂﬂ 
.
ﬂﬂ 
LogInformation
ﬂﬂ %
(
ﬂﬂ% &
$"
ﬂﬂ& (
$str
ﬂﬂ( :
{
ﬂﬂ: ;
testRun
ﬂﬂ; B
}
ﬂﬂB C
$str
ﬂﬂC R
{
ﬂﬂR S
testPlan
ﬂﬂS [
}
ﬂﬂ[ \
$str
ﬂﬂ\ o
"
ﬂﬂo p
)
ﬂﬂp q
;
ﬂﬂq r
}
‡‡ 
else
·· 
logger
‚‚ 
.
‚‚ 

LogWarning
‚‚ !
(
‚‚! "
$"
‚‚" $
$str
‚‚$ -
{
‚‚- .
testRun
‚‚. 5
}
‚‚5 6
$str
‚‚6 E
{
‚‚E F
testPlan
‚‚F N
}
‚‚N O
$str
‚‚O f
"
‚‚f g
)
‚‚g h
;
‚‚h i
}
„„ 	
public
ÂÂ 
Task
ÂÂ 
	StopAsync
ÂÂ 
(
ÂÂ 
CancellationToken
ÂÂ /
cancellationToken
ÂÂ0 A
)
ÂÂA B
{
ÊÊ 	
return
ÁÁ 
Task
ÁÁ 
.
ÁÁ 
CompletedTask
ÁÁ %
;
ÁÁ% &
}
ËË 	
}
ÈÈ 
}ÍÍ ó
AC:\src\PublicTestProjects\source\JtlToSql\FileJtlToSql\Program.cs
	namespace 	
FileJtlToSql
 
{ 
class 	
Program
 
{ 
private 
static 
async 
Task !
Main" &
(& '
string' -
[- .
]. /
args0 4
)4 5
{ 	
await 
Host 
.  
CreateDefaultBuilder +
(+ ,
args, 0
)0 1
. 
ConfigureServices 
( 
(  
hostContext  +
,+ ,
services- 5
)5 6
=>7 9
{ 
services 
. 
AddHostedService )
<) * 
ConsoleHostedService* >
>> ?
(? @
)@ A
;A B
} 
) 
. 
RunConsoleAsync 
( 
) 
; 
} 	
} 
} 