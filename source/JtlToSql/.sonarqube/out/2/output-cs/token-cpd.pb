��
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
GetEnvironmentVariable	II{ �
(
II� �
$str
II� �
)
II� �
)
II� �
:
II� �
false
II� �
;
II� �
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
sqlConnectionString	XXu �
:
XX� �!
sqlConnectionString
XX� �
)
XX� �
;
XX� �
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
$str	zzc �
"
zz� �
)
zz� �
;
zz� �
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
$str	}}r �
"
}}� �
)
}}� �
;
}}� �
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
�� #
.
��# $
SendMessage
��$ /
(
��/ 0
Convert
��0 7
.
��7 8
ToBase64String
��8 F
(
��F G%
resultsJtlBlobPathBytes
��G ^
)
��^ _
)
��_ `
;
��` a
}
�� 
}
�� 
}
�� 
}
�� 	
void
�� 
SendResultsToSql
�� 
(
�� 
QueueClient
�� )
queueClient
��* 5
,
��5 6
string
��7 =%
storageConnectionString
��> U
,
��U V
string
��W ]!
sqlConnectionString
��^ q
)
��q r
{
�� 	
while
�� 
(
�� 
queueClient
�� 
.
�� 
PeekMessages
�� +
(
��+ ,
)
��, -
.
��- .
Value
��. 3
.
��3 4
Length
��4 :
>
��; <
$num
��= >
)
��> ?
{
�� 
logger
�� 
.
�� 
LogInformation
�� %
(
��% &
$str
��& A
)
��A B
;
��B C
QueueMessage
�� 
[
�� 
]
�� 
retrievedMessages
�� 0
=
��1 2
queueClient
��3 >
.
��> ?
ReceiveMessages
��? N
(
��N O
)
��O P
;
��P Q
if
�� 
(
�� 
retrievedMessages
�� %
==
��& (
null
��) -
||
��. 0
retrievedMessages
��1 B
.
��B C
Length
��C I
==
��J L
$num
��M N
)
��N O
{
�� 
logger
�� 
.
�� 
LogInformation
�� )
(
��) *
$str
��* C
)
��C D
;
��D E
}
�� 
else
�� 
{
�� 
string
��  
resultsJtlBlobPath
�� -
=
��. /
null
��0 4
;
��4 5
string
�� 
csvFileName
�� &
=
��' (
$"
��) +
{
��+ ,
Guid
��, 0
.
��0 1
NewGuid
��1 8
(
��8 9
)
��9 :
}
��: ;
$str
��; ?
"
��? @
;
��@ A
try
�� 
{
��  
resultsJtlBlobPath
�� *
=
��+ ,
Encoding
��- 5
.
��5 6
UTF8
��6 :
.
��: ;
	GetString
��; D
(
��D E
Convert
��E L
.
��L M
FromBase64String
��M ]
(
��] ^
retrievedMessages
��^ o
[
��o p
$num
��p q
]
��q r
.
��r s
Body
��s w
.
��w x
ToString��x �
(��� �
)��� �
)��� �
)��� �
;��� �
logger
�� 
.
�� 
LogInformation
�� -
(
��- .
$"
��. 0
$str
��0 <
{
��< = 
resultsJtlBlobPath
��= O
}
��O P
"
��P Q
)
��Q R
;
��R S

BlobClient
�� "

blobClient
��# -
=
��. /
new
��0 3

BlobClient
��4 >
(
��> ?%
storageConnectionString
��? V
,
��V W
$str
��X g
,
��g h 
resultsJtlBlobPath
��i {
)
��{ |
;
��| }

blobClient
�� "
.
��" #

DownloadTo
��# -
(
��- .
csvFileName
��. 9
)
��9 :
;
��: ;
queueClient
�� #
.
��# $
DeleteMessage
��$ 1
(
��1 2
retrievedMessages
��2 C
[
��C D
$num
��D E
]
��E F
.
��F G
	MessageId
��G P
,
��P Q
retrievedMessages
��R c
[
��c d
$num
��d e
]
��e f
.
��f g

PopReceipt
��g q
)
��q r
;
��r s
logger
�� 
.
�� 
LogInformation
�� -
(
��- .
$"
��. 0
$str
��0 A
{
��A B 
resultsJtlBlobPath
��B T
}
��T U
"
��U V
)
��V W
;
��W X
using
�� 
var
�� !
csvJtl
��" (
=
��) *
new
��+ .
CsvJtl
��/ 5
(
��5 6 
resultsJtlBlobPath
��6 H
)
��H I
;
��I J
logger
�� 
.
�� 
LogInformation
�� -
(
��- .
$str
��. R
)
��R S
;
��S T
using
�� 
var
�� !
jtlCsvToSql
��" -
=
��. /
new
��0 3
JtlCsvToSql
��4 ?
(
��? @!
sqlConnectionString
��@ S
)
��S T
;
��T U
csvJtl
�� 
.
�� 
InitJtlReader
�� ,
(
��, -
csvFileName
��- 8
)
��8 9
;
��9 :
if
�� 
(
�� 
!
�� 
JtlCsvToSql
�� (
.
��( )$
ReportAlreadyProcessed
��) ?
(
��? @
csvJtl
��@ F
.
��F G
TestPlan
��G O
,
��O P
csvJtl
��Q W
.
��W X
TestRun
��X _
,
��_ `!
sqlConnectionString
��a t
)
��t u
)
��u v
{
�� 
logger
�� "
.
��" #
LogInformation
��# 1
(
��1 2
$"
��2 4
$str
��4 [
{
��[ \
csvJtl
��\ b
.
��b c
TestPlan
��c k
}
��k l
$str
��l z
{
��z {
csvJtl��{ �
.��� �
TestRun��� �
}��� �
"��� �
)��� �
;��� �
jtlCsvToSql
�� '
.
��' (
DeleteReport
��( 4
(
��4 5
csvJtl
��5 ;
.
��; <
TestPlan
��< D
,
��D E
csvJtl
��F L
.
��L M
TestRun
��M T
)
��T U
;
��U V
logger
�� "
.
��" #
LogInformation
��# 1
(
��1 2
$str
��2 Q
)
��Q R
;
��R S
int
�� 
i
��  !
=
��" #
$num
��$ %
;
��% &
while
�� !
(
��" #
csvJtl
��# )
.
��) *
ReadNextCsvLine
��* 9
(
��9 :
)
��: ;
)
��; <
{
�� 
var
��  #
csvRow
��$ *
=
��+ ,
csvJtl
��- 3
.
��3 4
	GetCsvRow
��4 =
(
��= >
)
��> ?
;
��? @
try
��  #
{
��  !
if
��$ &
(
��' (
i
��( )
>
��* +
$num
��, 1
)
��1 2
{
��$ %
logger
��( .
.
��. /
LogInformation
��/ =
(
��= >
$"
��> @
$str
��@ K
{
��K L
i
��L M
}
��M N
$str
��N _
{
��_ `
csvJtl
��` f
.
��f g
TestRun
��g n
}
��n o
"
��o p
)
��p q
;
��q r
jtlCsvToSql
��( 3
.
��3 4
CommitBatch
��4 ?
(
��? @
)
��@ A
;
��A B
i
��( )
=
��* +
$num
��, -
;
��- .
}
��$ %
jtlCsvToSql
��$ /
.
��/ 0
	AddJtlRow
��0 9
(
��9 :
csvRow
��: @
)
��@ A
;
��A B
i
��$ %
++
��% '
;
��' (
}
��  !
catch
��  %
(
��& '
	Exception
��' 0
e
��1 2
)
��2 3
{
��  !
logger
��" (
.
��( )

LogWarning
��) 3
(
��3 4
$"
��4 6
$str
��6 D
{
��D E
e
��E F
.
��F G
ToString
��G O
(
��O P
)
��P Q
}
��Q R
"
��R S
)
��S T
;
��T U
}
��V W
}
�� 
logger
�� "
.
��" #
LogInformation
��# 1
(
��1 2
$str
��2 p
)
��p q
;
��q r
jtlCsvToSql
�� '
.
��' (
	AddReport
��( 1
(
��1 2
csvJtl
��2 8
.
��8 9
TestPlan
��9 A
,
��A B
csvJtl
��C I
.
��I J
TestRun
��J Q
,
��Q R
csvJtl
��S Y
.
��Y Z
TestStartTime
��Z g
)
��g h
;
��h i
}
�� 
else
�� 
{
�� 
logger
�� "
.
��" #
LogInformation
��# 1
(
��1 2
$"
��2 4
$str
��4 A
{
��A B
csvJtl
��B H
.
��H I
TestRun
��I P
}
��P Q
$str
��Q `
{
��` a
csvJtl
��a g
.
��g h
TestPlan
��h p
}
��p q
$str��q �
"��� �
)��� �
;��� �
}
�� 
}
�� 
catch
�� 
(
�� 
	Exception
�� $
e
��% &
)
��& '
{
�� 
logger
�� 
.
�� 
LogError
�� '
(
��' (
e
��( )
.
��) *
ToString
��* 2
(
��2 3
)
��3 4
)
��4 5
;
��5 6
logger
�� 
.
�� 

LogWarning
�� )
(
��) *
$"
��* ,
$str
��, V
{
��V W 
resultsJtlBlobPath
��W i
}
��i j
"
��j k
)
��k l
;
��l m
var
�� %
resultsJtlBlobPathBytes
�� 3
=
��4 5
Encoding
��6 >
.
��> ?
UTF8
��? C
.
��C D
GetBytes
��D L
(
��L M 
resultsJtlBlobPath
��M _
)
��_ `
;
��` a
queueClient
�� #
.
��# $
SendMessage
��$ /
(
��/ 0
Convert
��0 7
.
��7 8
ToBase64String
��8 F
(
��F G%
resultsJtlBlobPathBytes
��G ^
)
��^ _
)
��_ `
;
��` a
}
�� 
finally
�� 
{
�� 
File
�� 
.
�� 
Delete
�� #
(
��# $
csvFileName
��$ /
)
��/ 0
;
��0 1
}
�� 
}
�� 
}
�� 
}
�� 	
private
�� 
void
�� '
DeleteReportsFromDatabase
�� .
(
��. /
String
��/ 5
testPlan
��6 >
,
��> ?
string
��@ F
testRun
��G N
)
��N O
{
�� 	
var
�� !
sqlConnectionString
�� #
=
��$ %
Environment
��& 1
.
��1 2$
GetEnvironmentVariable
��2 H
(
��H I
$str
��I _
)
��_ `
;
��` a
logger
�� 
.
�� 
LogInformation
�� !
(
��! "
$str
��" F
)
��F G
;
��G H
using
�� 
var
�� 
jtlCsvToSql
�� !
=
��" #
new
��$ '
JtlCsvToSql
��( 3
(
��3 4!
sqlConnectionString
��4 G
)
��G H
;
��H I
if
�� 
(
�� 
JtlCsvToSql
�� 
.
�� $
ReportAlreadyProcessed
�� 2
(
��2 3
testPlan
��3 ;
,
��; <
testRun
��= D
,
��D E!
sqlConnectionString
��F Y
)
��Y Z
)
��Z [
{
�� 
logger
�� 
.
�� 
LogInformation
�� %
(
��% &
$"
��& (
$str
��( 1
{
��1 2
testRun
��2 9
}
��9 :
$str
��: I
{
��I J
testPlan
��J R
}
��R S
$str
��S f
"
��f g
)
��g h
;
��h i
jtlCsvToSql
�� 
.
�� 
DeleteReport
�� (
(
��( )
testPlan
��) 1
,
��1 2
testRun
��3 :
)
��: ;
;
��; <
logger
�� 
.
�� 
LogInformation
�� %
(
��% &
$"
��& (
$str
��( :
{
��: ;
testRun
��; B
}
��B C
$str
��C R
{
��R S
testPlan
��S [
}
��[ \
$str
��\ o
"
��o p
)
��p q
;
��q r
}
�� 
else
�� 
logger
�� 
.
�� 

LogWarning
�� !
(
��! "
$"
��" $
$str
��$ -
{
��- .
testRun
��. 5
}
��5 6
$str
��6 E
{
��E F
testPlan
��F N
}
��N O
$str
��O f
"
��f g
)
��g h
;
��h i
}
�� 	
public
�� 
Task
�� 
	StopAsync
�� 
(
�� 
CancellationToken
�� /
cancellationToken
��0 A
)
��A B
{
�� 	
return
�� 
Task
�� 
.
�� 
CompletedTask
�� %
;
��% &
}
�� 	
}
�� 
}�� �
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