@echo off

rem script:		@rgadguard, abbodi1406, whatever127
rem wimlib:		synchronicity
rem offlinereg:	erwan.l

title Lightweight Envelope UUPs -^> ISO - v240211j
echo Preparing...

if not exist "%cd%\bin\wimlib-imagex.exe" goto :eof
SET "dism=dism.exe"
IF /I "%PROCESSOR_ARCHITECTURE%" EQU "AMD64" (
	SET "wimlib=%cd%\bin\bin64\wimlib-imagex.exe"
	SET "dism=%cd%\bin\bin64\dism.exe"
	SET "imagex=%cd%\bin\bin64\imagex.exe"
) ELSE (
	SET "wimlib=%cd%\bin\wimlib-imagex.exe"
	SET "dism=%cd%\bin\dism.exe"
	SET "imagex=%cd%\bin\imagex.exe"
)

set psfnet=0
if exist "%SystemRoot%\Microsoft.NET\Framework\v4.0.30319\ngen.exe" set psfnet=1
if exist "%SystemRoot%\Microsoft.NET\Framework\v2.0.50727\ngen.exe" set psfnet=1
set "bootedit=%cd%\%rand%\temp\boot.txt"
set "ISOFOLDER=%cd%\%rand%\ISOFOLDER"
set "mountdir=%cd%\%rand%\temp\mount"
set "fold_def=%cd%"
set "multi_edition=0"
if /i [!multi_en!]==[ON] set "multi_edition=1"
set "update=0"
if /i [!update_en!]==[ON] set "update=1"
set "netfx=0"
if /i [!NetFx_en!]==[ON] set "netfx=1"
set "language=0"
if /i [!Lang_en!]==[ON] set "language=1"
set "clean_install=0"
if /i [!clean_en!]==[ON] set "clean_install=1"
set "compress_esd=0"
if /i [%2]==[ESD] set "compress_esd=1"
set "compress_swm=0"
if /i [%2]==[SWM] set "compress_swm=1"
set "ei=0"
set "fix11=0"
if /i [!fix11_en!]==[ON] set "fix11=1"
set "apps=0"
if /i [!apps_en!]==[ON] set "apps=1"
set "edge_install=0"
if /i [!edge_en!]==[ON] set "edge_install=1"
SET UUP=
SET ERRORTEMP=
SET "VOL=0"
SET "uups_esd_num=0"
set "uupa=0"
rmdir /s /q %ISOFOLDER%\ >nul 2>nul
rmdir /s /q %rand%\temp\ >nul 2>nul
mkdir %rand%\temp >nul 2>nul

for /f "tokens=1 delims=_" %%a in ("!file_main!") do set "ei=%%a"
if not [%1]==[] (if exist "%~1\*.esd" (set "UUP=%~1"&goto :check) else (set "fold=%~1"&goto :error_cmd))

:check
call :uup_esd %UUP%
if %uups_esd_num% equ 0 (
	echo.
	call :as
	echo %lang_error_found_files%
	call :as
	echo.
	echo %lang_exit%
	pause >nul
	goto :QUIT
)
if %uups_esd_num% gtr 1 set "uupa=2"
call :uups_esd 1
set WIMFILE=install.wim&goto :AIO

:uup_esd
if exist "%rand%\temp\*.txt" del /f /q "%rand%\temp\*.txt" >nul 2>&1
for /d %%A in (MetadataESD,Starter,StarterN,Cloud,CloudN,CloudE,CloudEN,CoreCountrySpecific,CoreSingleLanguage,Core,CoreN,ProfessionalCountrySpecific,ProfessionalSingleLanguage,Professional,ProfessionalN,ProfessionalEducation,ProfessionalWorkstation,Education,EducationN,Enterprise,EnterpriseN,EnterpriseEval,EnterpriseNEval,EnterpriseS,EnterpriseSN,EnterpriseSEval,EnterpriseSNEval,EnterpriseG,EnterpriseGN,PPIPro,IoTEnterprise,ServerAzureStackHCICor,ServerDatacenterCore,ServerDatacenter,ServerTurbineCore,ServerTurbine,ServerStandardCore,ServerStandard) do (
	dir /b %1\%%A_*.esd>>%rand%\temp\uups_esd.txt 2>nul
)
for /f "tokens=3 delims=: " %%i in ('find /v /n /c "" %rand%\temp\uups_esd.txt') do set uups_esd_num=%%i
exit /b

:AIO
set "MetadataESD=%UUP%\%uups_esd1%"&set "arch=%arch1%"&set "editionid=%edition1%"&set "langid=%langid1%"

:ISO
cls
call :PREPARE
call :convert
echo.
call :as
echo %lang_creating% Setup Media Layout . . .
call :as
IF EXIST %ISOFOLDER% rmdir /s /q %ISOFOLDER%\
mkdir %ISOFOLDER%
echo.
"%wimlib%" apply "%MetadataESD%" 1 %ISOFOLDER%\ >nul 2>&1
SET ERRORTEMP=%ERRORLEVEL%
IF %ERRORTEMP% NEQ 0 (echo.&echo %lang_error_apply%&PAUSE&GOTO :QUIT)
del %ISOFOLDER%\MediaMeta.xml >nul 2>&1
echo.
call :as
echo %lang_creating% boot.wim . . .
call :as
echo.
for /f "tokens=3 delims=<>" %%i in ('%imagex% /info "%MetadataESD%" 2 ^| findstr /i HIGHPART') do set "installhigh=%%i"
for /f "tokens=3 delims=<>" %%i in ('%imagex% /info "%MetadataESD%" 2 ^| findstr /i LOWPART') do set "installlow=%%i"
"%wimlib%" export "%MetadataESD%" 2 %ISOFOLDER%\sources\boot.wim --compress=LZX:15 --boot
SET ERRORTEMP=%ERRORLEVEL%
IF %ERRORTEMP% NEQ 0 (echo.&echo Errors were reported during export.&echo.&echo Press any key to exit.&pause >nul&GOTO :QUIT)
"%wimlib%" info %ISOFOLDER%\sources\boot.wim 1 --image-property LASTMODIFICATIONTIME/HIGHPART=%installhigh% --image-property LASTMODIFICATIONTIME/LOWPART=%installlow% 1>nul 2>nul
for /f "tokens=4,5,6,7,8,9 delims=: " %%G in ('%wimlib% info "%MetadataESD%" 2 ^| find "Creation Time"') do (set mmm=%%G&set yyy=%%L&set ddd=%%H&set "timeout=%%I:%%J:%%K"
	call :setmmm1 !mmm! 1	
)
for /f "tokens=5,6,7,8,9,10 delims=: " %%G in ('%wimlib% info "%MetadataESD%" 2 ^| find "Last Modification Time"') do (set mmm=%%G&set yyy=%%L&set ddd=%%H&set "timeout=%%I:%%J:%%K"
	call :setmmm1 !mmm! 2
)
for /f "tokens=3 delims=: " %%i in ('%wimlib% info "%ISOFOLDER%\sources\boot.wim" ^| findstr /c:"Image Count"') do set images=%%i
echo.
call :update %ISOFOLDER%\sources\boot.wim %update% 0 boot.wim 0 %clean_install% 0
copy /y %ISOFOLDER%\sources\boot.wim %rand%\temp\winre.wim >nul
"%wimlib%" info %ISOFOLDER%\sources\boot.wim 1 --image-property FLAGS=9 1>nul 2>nul
for /f "tokens=6 delims=[]. " %%G in ('ver') do set winbuild=%%G
call :BootPE
echo.
call :as
echo %lang_creating% %WIMFILE% . . .
call :as
echo.
for /f "tokens=5,6,7,8,9,10 delims=: " %%G in ('%wimlib% info "%MetadataESD%" 3 ^| find /i "Last Modification Time"') do (set mmm=%%G&set "isotime=%%H/%%L,%%I:%%J:%%K")
call :setdate %mmm%
for /L %%i in (1, 1, %uups_esd_num%) do (
	call :uups_esd %%i
	set "MetadataESD=%UUP%\!uups_esd%%i!"
	call :install %ISOFOLDER%^\sources^\ %%i
)

echo.
call :as
echo %lang_adding_winre% %WIMFILE% . . .
call :as
echo.
for /f "tokens=3 delims=: " %%i in ('%wimlib% info "%ISOFOLDER%\sources\install.wim" ^| findstr /c:"Image Count"') do set images=%%i
for /L %%i in (1, 1, %uups_esd_num%) do call :add_winre %%i %ISOFOLDER%^\sources^\
if /i %edge_install%==1 (
	echo.
	call :as
	echo %lang_adding_edge% %WIMFILE% . . .
	call :as
	echo.
	for /L %%i in (1, 1, %uups_esd_num%) do call :add_edge %%i %ISOFOLDER%^\sources^\
)
echo.
call :update %ISOFOLDER%\sources\install.wim %update% %netfx% install.wim %language% %clean_install% %apps%
if %multi_edition%==1 (
	call :as
	echo %lang_preparation_info% . . .
	call :as
	echo.
	echo.
	call bin\virtual.cmd
)
if /i %compress_esd%==0 (
	call :as
	echo %lang_optimate% %WIMFILE% . . .
	call :as
	echo.
	"%wimlib%" optimize %ISOFOLDER%\sources\%WIMFILE%
	echo.
) else (
	call :as
	echo %lang_compress_esd% %WIMFILE% . . .
	call :as
	echo.
	"%wimlib%" export %ISOFOLDER%\sources\%WIMFILE% all %ISOFOLDER%\sources\%WIMFILE:~0,-4%.esd --compress=LZMS:100 --solid
	del %ISOFOLDER%\sources\%WIMFILE% >nul 2>&1
	echo.
)
if /i %compress_swm%==1 (
	for %%i in (%ISOFOLDER%\sources\%WIMFILE%) do set "sizewim=%%~zi"
	set "sizewim=!sizewim:~0,-3!"
	if /i !sizewim! GTR 4293918 (
		"%wimlib%" split %ISOFOLDER%\sources\%WIMFILE% %ISOFOLDER%\sources\install.swm 4000
		del %ISOFOLDER%\sources\%WIMFILE% >nul 2>&1
		echo.
	)
)
call :as
echo %lang_creating% ISO . . .
call :as
if /i %ei%==multi (
	if exist "%ISOFOLDER%\sources\EI.CFG" (
		del %ISOFOLDER%\sources\EI.CFG >nul 2>&1
	)
	(echo [EditionID]
	echo.
	echo [Channel]
	echo Volume
	echo.
	echo [VL]
	echo 1)>%ISOFOLDER%\sources\EI.CFG
)
if defined diso set "isotime=%diso%"
bin\oscdimg -bootdata:2#p0,e,b"%ISOFOLDER%\boot\etfsboot.com"#pEF,e,b"%ISOFOLDER%\efi\Microsoft\boot\efisys.bin" -o -m -u2 -udfver102 -t%isotime% -g -l%DVDLABEL% %ISOFOLDER% %DVDISO%
SET ERRORTEMP=%ERRORLEVEL%
IF %ERRORTEMP% NEQ 0 (
	echo.
	echo %lang_error_iso_creation%
	echo.
	echo %lang_exit%
	pause >nul
	exit
)
rmdir /s /q %rand%\ 1>nul 2>nul
echo.
echo %lang_exit%
pause >nul
GOTO :QUIT

:PREPARE
"%wimlib%" info "%MetadataESD%" 3 | find /i "Display Name" 1>nul && (
	for /f "tokens=2* delims=: " %%i in ('%wimlib% info "%MetadataESD%" 3 ^| find /i "Display Name"') do set "_os=%%j"
) || (
	for /f "tokens=1* delims=: " %%i in ('%wimlib% info "%MetadataESD%" 3 ^| findstr /b "Name"') do set "_os=%%j"
)
for /f "tokens=4 delims=: " %%i in ('%wimlib% info "%MetadataESD%" 3 ^| find /i "Service Pack Build"') do set svcbuild=%%i
for /f "tokens=2 delims=: " %%i in ('%wimlib% info "%MetadataESD%" 3 ^| findstr /b "Build"') do set build=%%i
for /f "tokens=3 delims=: " %%i in ('%wimlib% info "%MetadataESD%" 3 ^| find /i "Major"') do set _ver1=%%i
for /f "tokens=3 delims=: " %%i in ('%wimlib% info "%MetadataESD%" 3 ^| find /i "Minor"') do set _ver2=%%i
"%wimlib%" extract "%MetadataESD%" 1 sources\ei.cfg --dest-dir=.\%rand%\temp --no-acls >nul 2>&1
type .\%rand%\temp\ei.cfg 2>nul | find /i "Volume" 1>nul && set VOL=1

"%wimlib%" extract "%MetadataESD%" 3 \Windows\System32\config\SOFTWARE --dest-dir=.\%rand%\temp --no-acls >nul
for /f "tokens=3 delims==: " %%a in ('"bin\offlinereg.exe .\%rand%\temp\SOFTWARE "Microsoft\Windows NT\CurrentVersion" getvalue InstallationType" 2^>nul') do if not errorlevel 1 (for /f "tokens=1-5 delims=." %%i in ('echo %%~a') do set _InstallationType=%%i)

if %update%==1 (
	"%aria2%" -x16 -s16 -R -c --allow-overwrite=true --auto-file-renaming=false -d"%rand%\temp" -o"BuildInfo.txt" "https://uup.rg-adguard.net/api/CU?updateid=%updateId%" >nul 2>&1
	for %%i in ("%rand%\temp\BuildInfo.txt") do (if /i %%~zi LEQ 10 (call :PREPARE_OLD_API) else (call :PREPARE_NEW_API))
) else (
	call :PREPARE_OLD_API
)

if %language%==1 (
	set /a tt1=tt+1
	set langid=multi!tt1!
	if /i !tt1! GEQ 4 (
		set "langid_file=multi!tt1!"
	) else (
		FOR /L %%j IN (1,1,!lang_num!) DO (
			if /i "!lang_ON_%%j!"=="DEF" (
				if defined langid_file (
					set "langid_file=!langid_file!_!lang_id_%%j!"
				) else (
					set "langid_file=!lang_id_%%j!"
				)
			)
			if /i "!lang_ON_%%j!"=="ON " (
				if defined langid_file (
					set "langid_file=!langid_file!_!lang_id_%%j!"
				) else (
					set "langid_file=!lang_id_%%j!"
				)
			)
		)
	)
) else (
	set langid_file=!langid!
)
if %netfx%==1 (
	set "langid_file=NetFx_!langid_file!"
)

if defined _label2 (set _label=%_label2%) else (set _label=%version%.%datetime%.%branch%_!_InstallationType!)
for %%b in (A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z) do set _label=!_label:%%b=%%b!
for %%b in (A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z) do set langid=!langid:%%b=%%b!
for %%b in (A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z) do set langid_file=!langid_file:%%b=%%b!

if /i %arch%==x86 set archl=X86
if /i %arch%==x64 set archl=X64
if /i %arch%==arm64 set archl=A64

if /i !fix11!==1 set "langid_file=%langid_file%_FIX"

if %multi_edition%==1 set DVDLABEL=CCSA_%archl%FRE_%langid%_DV5&set DVDISO=%_label%MULTICOMBINED_UUP_%archl%FRE_%langid_file%.ISO&exit /b
if %uupa%==2 (
	set DVDLABEL=CCSA_%archl%FRE_%langid%_DV5&set DVDISO=%_label%COMBINED_UUP_%archl%FRE_%langid_file%.ISO
	if /i %editionid:~0,6%==Server set DVDLABEL=SSS_%archl%FRE_%langid%_DV9&set DVDISO=%_label%_OEMRET_%archl%FRE_%langid_file%.ISO
	exit /b
)

if /i %editionid%==Starter set DVDLABEL=CSA_%archl%FRE_%langid%_DV5&set DVDISO=%_label%STARTER_OEM_%archl%FRE_%langid_file%.ISO
if /i %editionid%==StarterN set DVDLABEL=CSNA_%archl%FRE_%langid%_DV5&set DVDISO=%_label%STARTERN_OEM_%archl%FRE_%langid_file%.ISO
if /i %editionid%==Cloud set DVDLABEL=CWCA_%archl%FRE_%langid%_DV5&set DVDISO=%_label%CLOUD_OEM_%archl%FRE_%langid_file%.ISO
if /i %editionid%==CloudN set DVDLABEL=CWCNNA_%archl%FRE_%langid%_DV5&set DVDISO=%_label%CLOUDN_OEM_%archl%FRE_%langid_file%.ISO
if /i %editionid%==Cloude set DVDLABEL=CWCA_%archl%FRE_%langid%_DV5&set DVDISO=%_label%CLOUDE_OEM_%archl%FRE_%langid_file%.ISO
if /i %editionid%==CloudeN set DVDLABEL=CWCNNA_%archl%FRE_%langid%_DV5&set DVDISO=%_label%CLOUDEN_OEM_%archl%FRE_%langid_file%.ISO
if /i %editionid%==CoreCountrySpecific set DVDLABEL=CCHA_%archl%FRE_%langid%_DV5&set DVDISO=%_label%CHINA_OEM_%archl%FRE_%langid_file%.ISO
if /i %editionid%==CoreSingleLanguage set DVDLABEL=CSLA_%archl%FRE_%langid%_DV5&set DVDISO=%_label%SINGLELANGUAGE_OEM_%archl%FRE_%langid_file%.ISO
if /i %editionid%==Core set DVDLABEL=CCRA_%archl%FRE_%langid%_DV5&set DVDISO=%_label%CORE_OEMRET_%archl%FRE_%langid_file%.ISO
if /i %editionid%==CoreN set DVDLABEL=CCRNA_%archl%FRE_%langid%_DV5&set DVDISO=%_label%COREN_OEMRET_%archl%FRE_%langid_file%.ISO
if /i %editionid%==ProfessionalSingleLanguage set DVDLABEL=CPRSLA_%archl%FRE_%langid%_DV5&set DVDISO=%_label%PROSINGLELANGUAGE_OEM_%archl%FRE_%langid_file%.ISO
if /i %editionid%==ProfessionalCountrySpecific set DVDLABEL=CPRCHA_%archl%FRE_%langid%_DV5&set DVDISO=%_label%PROCHINA_OEM_%archl%FRE_%langid_file%.ISO
if /i %editionid%==Professional (IF %VOL%==1 (set DVDLABEL=CPRA_%archl%FREV_%langid%_DV5&set DVDISO=%_label%PROFESSIONALVL_VOL_%archl%FRE_%langid_file%.ISO) else (set DVDLABEL=CPRA_%archl%FRE_%langid%_DV5&set DVDISO=%_label%PRO_OEMRET_%archl%FRE_%langid_file%.ISO))
if /i %editionid%==ProfessionalN (IF %VOL%==1 (set DVDLABEL=CPRNA_%archl%FREV_%langid%_DV5&set DVDISO=%_label%PROFESSIONALNVL_VOL_%archl%FRE_%langid_file%.ISO) else (set DVDLABEL=CPRNA_%archl%FRE_%langid%_DV5&set DVDISO=%_label%PRON_OEMRET_%archl%FRE_%langid_file%.ISO))
if /i %editionid%==ProfessionalEducation (IF %VOL%==1 (set DVDLABEL=CPREA_%archl%FREV_%langid%_DV5&set DVDISO=%_label%PROFESSIONALEDUCATION_VOL_%archl%FRE_%langid_file%.ISO) else (set DVDLABEL=CPREA_%archl%FRE_%langid%_DV5&set DVDISO=%_label%PROEDUCATION_OEMRET_%archl%FRE_%langid_file%.ISO))
if /i %editionid%==ProfessionalEducationN (IF %VOL%==1 (set DVDLABEL=CPRENA_%archl%FREV_%langid%_DV5&set DVDISO=%_label%PROFESSIONALEDUCATIONN_VOL_%archl%FRE_%langid_file%.ISO) else (set DVDLABEL=CPRENA_%archl%FRE_%langid%_DV5&set DVDISO=%_label%PROEDUCATIONN_OEMRET_%archl%FRE_%langid_file%.ISO))
if /i %editionid%==ProfessionalWorkstation (IF %VOL%==1 (set DVDLABEL=CPRWA_%archl%FREV_%langid%_DV5&set DVDISO=%_label%PROFESSIONALWORKSTATION_VOL_%archl%FRE_%langid_file%.ISO) else (set DVDLABEL=CPRWA_%archl%FRE_%langid%_DV5&set DVDISO=%_label%PROWORKSTATION_OEMRET_%archl%FRE_%langid_file%.ISO))
if /i %editionid%==ProfessionalWorkstationN (IF %VOL%==1 (set DVDLABEL=CPRWNA_%archl%FREV_%langid%_DV5&set DVDISO=%_label%PROFESSIONALWORKSTATIONN_VOL_%archl%FRE_%langid_file%.ISO) else (set DVDLABEL=CPRWNA_%archl%FRE_%langid%_DV5&set DVDISO=%_label%PROWORKSTATIONN_OEMRET_%archl%FRE_%langid_file%.ISO))
if /i %editionid%==Education (IF %VOL%==1 (set DVDLABEL=CEDA_%archl%FREV_%langid%_DV5&set DVDISO=%_label%EDUCATION_VOL_%archl%FRE_%langid_file%.ISO) else (set DVDLABEL=CEDA_%archl%FRE_%langid%_DV5&set DVDISO=%_label%EDUCATION_RET_%archl%FRE_%langid_file%.ISO))
if /i %editionid%==EducationN (IF %VOL%==1 (set DVDLABEL=CEDNA_%archl%FREV_%langid%_DV5&set DVDISO=%_label%EDUCATIONN_VOL_%archl%FRE_%langid_file%.ISO) else (set DVDLABEL=CEDNA_%archl%FRE_%langid%_DV5&set DVDISO=%_label%EDUCATIONN_RET_%archl%FRE_%langid_file%.ISO))
if /i %editionid%==Enterprise set DVDLABEL=CENA_%archl%FREV_%langid%_DV5&set DVDISO=%_label%ENTERPRISE_VOL_%archl%FRE_%langid_file%.ISO
if /i %editionid%==EnterpriseN set DVDLABEL=CENNA_%archl%FREV_%langid%_DV5&set DVDISO=%_label%ENTERPRISEN_VOL_%archl%FRE_%langid_file%.ISO
if /i %editionid%==EnterpriseG set DVDLABEL=CEGA_%archl%FREV_%langid%_DV5&set DVDISO=%_label%ENTERPRISEG_VOL_%archl%FRE_%langid_file%.ISO
if /i %editionid%==EnterpriseGN set DVDLABEL=CEGNA_%archl%FREV_%langid%_DV5&set DVDISO=%_label%ENTERPRISEGN_VOL_%archl%FRE_%langid_file%.ISO
if /i %editionid%==EnterpriseEval set DVDLABEL=CEEA_%archl%FREV_%langid%_DV5&set DVDISO=%_label%ENTERPRISEEVAL_VOL_%archl%FRE_%langid_file%.ISO
if /i %editionid%==EnterpriseNEval set DVDLABEL=CEENA_%archl%FREV_%langid%_DV5&set DVDISO=%_label%ENTERPRISENEVAL_VOL_%archl%FRE_%langid_file%.ISO
if /i %editionid%==EnterpriseS set DVDLABEL=CESA_%archl%FREV_%langid%_DV5&set DVDISO=%_label%ENTERPRISES_VOL_%archl%FRE_%langid_file%.ISO
if /i %editionid%==EnterpriseSN set DVDLABEL=CESNA_%archl%FREV_%langid%_DV5&set DVDISO=%_label%ENTERPRISESN_VOL_%archl%FRE_%langid_file%.ISO
if /i %editionid%==EnterpriseSubscription set DVDLABEL=CESA_%archl%FREV_%langid%_DV5&set DVDISO=%_label%ENTERPRISESUBSCRIPTION_VOL_%archl%FRE_%langid_file%.ISO
if /i %editionid%==EnterpriseSubscriptionN set DVDLABEL=CESNA_%archl%FREV_%langid%_DV5&set DVDISO=%_label%ENTERPRISESUBSCRIPTIONN_VOL_%archl%FRE_%langid_file%.ISO
if /i %editionid%==EnterpriseSEval set DVDLABEL=CESEA_%archl%FREV_%langid%_DV5&set DVDISO=%_label%ENTERPRISESEVAL_VOL_%archl%FRE_%langid_file%.ISO
if /i %editionid%==EnterpriseSNEval set DVDLABEL=CESNEA_%archl%FREV_%langid%_DV5&set DVDISO=%_label%ENTERPRISESNEVAL_VOL_%archl%FRE_%langid_file%.ISO
if /i %editionid%==PPIPro set DVDLABEL=CPPIA_%archl%FRE_%langid%_DV5&set DVDISO=%_label%PPIPRO_OEM_%archl%FRE_%langid_file%.ISO
if /i %editionid%==ServerDatacenter set DVDLABEL=SSDC_%archl%FRE_%langid%_DV9&set DVDISO=%_label%DATACENTER_OEMRET_%archl%FRE_%langid_file%.ISO
if /i %editionid%==ServerDatacenterCore set DVDLABEL=SSDCC_%archl%FRE_%langid%_DV9&set DVDISO=%_label%DATACENTERCORE_OEMRET_%archl%FRE_%langid_file%.ISO
if /i %editionid%==ServerTurbine set DVDLABEL=SSDCA_%archl%FRE_%langid%_DV9&set DVDISO=%_label%DATACENTERAZUREE_OEMRET_%archl%FRE_%langid_file%.ISO
if /i %editionid%==ServerTurbineCore set DVDLABEL=SSDCAC_%archl%FRE_%langid%_DV9&set DVDISO=%_label%DATACENTERAZUREECORE_OEMRET_%archl%FRE_%langid_file%.ISO
if /i %editionid%==ServerStandard set DVDLABEL=SSS_%archl%FRE_%langid%_DV9&set DVDISO=%_label%STANDARD_OEMRET_%archl%FRE_%langid_file%.ISO
if /i %editionid%==ServerStandardCore set DVDLABEL=SSS_%archl%FRE_%langid%_DV9&set DVDISO=%_label%STANDARDCORE_OEMRET_%archl%FRE_%langid_file%.ISO
if /i %editionid%==ServerAzureStackHCICor set DVDLABEL=SASH_%archl%FRE_%langid%_DV9&set DVDISO=%_label%AZURESTACKHCICOR_OEMRET_%archl%FRE_%langid_file%.ISO
if defined branch exit /b

:PREPARE_OLD_API
"%wimlib%" extract "%MetadataESD%" 1 sources\SetupPlatform.dll --dest-dir=.\%rand%\temp --no-acls >nul 2>&1
bin\7z.exe l .\%rand%\temp\SetupPlatform.dll >.\%rand%\temp\version.txt 2>&1
for /f "tokens=4,5 delims=. " %%i in ('"findstr /B "FileVersion" .\%rand%\temp\version.txt" 2^>nul') do set version=%%i.%%j
for /f "tokens=7 delims=.) " %%i in ('"findstr /B "FileVersion" .\%rand%\temp\version.txt" 2^>nul') do set datetime=%%i
for /f "tokens=6 delims=.( " %%i in ('"findstr /B "FileVersion" .\%rand%\temp\version.txt" 2^>nul') do set branch=%%i
if /i %arch%==x86 (set _ss=x86) else (set _ss=amd64)
if /i %arch%==arm64 (set _ss=arm64)
"%wimlib%" extract "%MetadataESD%" 3 Windows\WinSxS\Manifests\%_ss%_microsoft-windows-coreos-revision* --dest-dir=.\%rand%\temp --no-acls >nul 2>&1
for /f "tokens=6,7 delims=_." %%i in ('dir /b /o:d .\%rand%\temp\*.manifest') do set revision=%%i.%%j
if not %version%==%revision% (
	set version=%revision%
	for /f "tokens=5,6,7,8,9,10 delims=: " %%G in ('%wimlib% info "%MetadataESD%" 3 ^| find /i "Last Modification Time"') do (set mmm=%%G&set yyy=%%L&set ddd=%%H-%%I%%J)
	call :setmmm !mmm!
)
set _label2=
if /i %branch%==WinBuild (
	for /f "tokens=3 delims==:" %%a in ('"bin\offlinereg.exe .\%rand%\temp\SOFTWARE "Microsoft\Windows NT\CurrentVersion" getvalue BuildLabEx" 2^>nul') do if not errorlevel 1 (for /f "tokens=1-5 delims=." %%i in ('echo %%~a') do set _label2=%%i.%%j.%%m.%%l_!_InstallationType!&set branch=%%l)
)
goto :eof

:PREPARE_NEW_API
for /f "tokens=1,2,3,4 delims=." %%a in ('type "%rand%\temp\BuildInfo.txt"') do (
	set version=%%b.%%c
	set branch=%%a
	set datetime=%%d
)
goto :eof

:BootPE
call :as
echo %lang_creating% boot.wim - 2 index. . .
call :as
echo.
if %language%==1 (
	for /f "delims=" %%a in ('dir /AD /b "%down_temp%"') do (
		set "put="
		set "lang_tt="
		if exist "%down_temp%\%%a\setup\sources" (
			if exist "%down_temp%\%%a\setup\sources\*-*" (
				for /f "delims=" %%c in ('dir /AD /b "%down_temp%\%%a\setup\sources"') do (
					set "put="
					bin\7z.exe e .\%down_temp%\%%a\setup\sources\%%c\setup.exe.mui -r version.txt -y -o.\%rand%\temp 1>nul 2>nul
					for /f "tokens=3 delims=, " %%i in ('"find "Translation" .\%rand%\temp\version.txt" 2^>nul') do call bin\langcode.cmd %%i
					echo %down_temp%\%%a\setup\sources\%%c > %down_temp%\size.dat
					for %%i in ("%down_temp%\size.dat") do set /a size_f=%%~zi-2
					call :fold_lang %down_temp%\%%a\setup\sources\%%c %put%
				)
			) else (
				bin\7z.exe e .\%down_temp%\%%a\setup\sources\setup.exe.mui -r version.txt -y -o.\%rand%\temp 1>nul 2>nul
				for /f "tokens=3 delims=, " %%i in ('"find "Translation" .\%rand%\temp\version.txt" 2^>nul') do call bin\langcode.cmd %%i
				for /f "delims=" %%c in ('dir /AD /b "%down_temp%\%%a\setup\sources"') do (
					set "put="
					echo %down_temp%\%%a\setup\sources > %down_temp%\size.dat
					for %%i in ("%down_temp%\size.dat") do set /a size_f=%%~zi-2
					call :fold_lang %down_temp%\%%a\setup\sources %put%
				)
			)
		)
	)
	if exist "%ISOFOLDER%\sources\lang.ini" (
		del %ISOFOLDER%\sources\lang.ini >nul 2>&1
	)
	echo.>%ISOFOLDER%\sources\lang.ini
	echo [Available UI Languages]>>%ISOFOLDER%\sources\lang.ini
	FOR /L %%j IN (1,1,!lang_num!) DO (
		if /i "!lang_ON_%%j!"=="DEF" (
			echo !lang_id_%%j! = ^3>>%ISOFOLDER%\sources\lang.ini
		)
	)
	FOR /L %%j IN (1,1,!lang_num!) DO (
		if /i "!lang_ON_%%j!"=="ON " (
			echo !lang_id_%%j! ^= ^2>>%ISOFOLDER%\sources\lang.ini
		)
	)
	echo.>>%ISOFOLDER%\sources\lang.ini
	echo [Fallback Languages]>>%ISOFOLDER%\sources\lang.ini
	FOR /L %%j IN (1,1,!lang_num!) DO (
		if /i "!lang_ON_%%j!"=="DEF" (
			echo !lang_id_%%j! ^= en-us>>%ISOFOLDER%\sources\lang.ini
		)
	)
)
"%wimlib%" extract %ISOFOLDER%\sources\boot.wim 1 \Windows\System32\config\SOFTWARE --dest-dir=%rand% --no-acls --no-attributes >nul
bin\offlinereg %rand%\SOFTWARE "Microsoft\Windows NT\CurrentVersion\WinPE" setvalue InstRoot X:\$windows.~bt\ >nul 2>&1
bin\offlinereg %rand%\SOFTWARE.new "Microsoft\Windows NT\CurrentVersion" setvalue SystemRoot X:\$windows.~bt\Windows >nul 2>&1
del /f /q %rand%\SOFTWARE >nul 2>&1
ren %rand%\SOFTWARE.new SOFTWARE
"%wimlib%" update %ISOFOLDER%\sources\boot.wim 1 --command="add '%rand%\SOFTWARE' '\Windows\System32\config\SOFTWARE'" 1>nul 2>nul

:BootWIM
"%wimlib%" extract "%MetadataESD%" 3 Windows\system32\xmllite.dll --dest-dir=%ISOFOLDER%\sources --no-acls --no-attributes >nul 2>&1
echo delete '^\Windows^\system32^\winpeshl.ini'>%bootedit%
echo add '%ISOFOLDER%^\setup.exe' '^\setup.exe'>>%bootedit%
echo add '%ISOFOLDER%^\sources^\inf^\setup.cfg' '^\sources^\inf^\setup.cfg'>>%bootedit%
set "_bkimg="
for %%# in (background_cli.bmp, background_svr.bmp, background_cli.png, background_svr.png) do if exist "%ISOFOLDER%\sources\%%#" set "_bkimg=%%#"
if defined _bkimg (
	echo add '%ISOFOLDER%^\sources^\%_bkimg%' '^\sources^\background.bmp'>>%bootedit%
	echo add '%ISOFOLDER%^\sources^\%_bkimg%' '^\Windows^\system32^\setup.bmp'>>%bootedit%
	echo add '%ISOFOLDER%^\sources^\%_bkimg%' '^\sources^\background.png'>>%bootedit%
	echo add '%ISOFOLDER%^\sources^\%_bkimg%' '^\Windows^\system32^\setup.png'>>%bootedit%
	echo add '%ISOFOLDER%^\sources^\%_bkimg%' '^\Windows^\system32^\winpe.jpg'>>%bootedit%
	echo add '%ISOFOLDER%^\sources^\%_bkimg%' '^\Windows^\system32^\winre.jpg'>>%bootedit%
)
for /f %%A in (bin\bootwim.txt) do (
	if exist "%ISOFOLDER%\sources\%%A" echo add '%ISOFOLDER%^\sources^\%%A' '^\sources^\%%A'>>%bootedit%
)
for /f %%A in (bin\bootmui.txt) do (
	for /f "delims=" %%i in ('dir /AD /b "%ISOFOLDER%\sources\*-*"') do (
		if exist "%ISOFOLDER%\sources\%%i\%%A" echo add '%ISOFOLDER%^\sources^\%%i^\%%A' '^\sources^\%%i^\%%A'>>%bootedit%
	)
)
"%wimlib%" export "%rand%\temp\winre.wim" 1 %ISOFOLDER%\sources\boot.wim "Microsoft Windows Setup (%arch%)" "Microsoft Windows Setup (%arch%)" --boot
"%wimlib%" update %ISOFOLDER%\sources\boot.wim 2 < %bootedit% 1>nul 2>nul
"%wimlib%" info %ISOFOLDER%\sources\boot.wim 2 --image-property FLAGS=2 1>nul 2>nul
if /i !fix11!==1 call :fix11 %arch%
if /i %update% equ 0 (
	"%wimlib%" info %ISOFOLDER%\sources\boot.wim 1 --image-property LASTMODIFICATIONTIME/HIGHPART=%installhigh% --image-property LASTMODIFICATIONTIME/LOWPART=%installlow% 1>nul 2>nul
	"%wimlib%" info %ISOFOLDER%\sources\boot.wim 2 --image-property LASTMODIFICATIONTIME/HIGHPART=%installhigh% --image-property LASTMODIFICATIONTIME/LOWPART=%installlow% 1>nul 2>nul
)
"%wimlib%" optimize %ISOFOLDER%\sources\boot.wim
del /f /q %ISOFOLDER%\sources\xmllite.dll >nul 2>&1
goto :eof

:convert
if exist "%UUP%\*.cab" (
	echo.
	call :as
	echo %lang_convert_cab% . . .
	call :as
	echo.
	if exist "%UUP%\*.xml.cab" if exist "%UUP%\Metadata\*" move /y "%UUP%\*.xml.cab" "%UUP%\Metadata\" 1>nul 2>nul
	if exist "%UUP%\*.*xbundle" call :appx_sort
	if exist "%UUP%\*.psf" (for /f "delims=" %%i in ('dir /b "%UUP%\*.psf"') do call :uups_psf %%i)
	if exist "%UUP%\*.cab" (for /f "delims=" %%i in ('dir /b "%UUP%\*.cab"') do call :uups_cab %%i)
rem	if exist "%UUP%\*.msu" (for /f "delims=" %%i in ('dir /b "%UUP%\*.msu"') do call :uups_msu %%i)
	if exist "%UUP%\*\*" (for /f "delims=" %%i in ('dir /AD /b "%UUP%\"') do call :uups_fol %%i)
	if exist "%UUP%\Metadata\*.xml.cab" copy /y "%UUP%\Metadata\*.xml.cab" "%UUP%\" 1>nul 2>nul
)
if exist "%down_temp%\*.cab" (
	echo.
	call :as
	echo %lang_convert_language% . . .
	call :as
	echo.
	set /a uups_down=1
	for /f "delims=" %%i in ('dir /b "%down_temp%\*.cab"') do call :uups_down %%i cab
	for /f "delims=" %%i in ('dir /b "%down_temp%\*.esd"') do call :uups_down %%i esd
)
goto :eof

:install
if /i %WIMFILE%==install.wim (
if exist "%rand%\temp\*.ESD" (
		"%wimlib%" export "%MetadataESD%" 3 %1%WIMFILE% --ref="%UUP%\*.esd" --ref="%rand%\temp\*.esd" --compress=maximum
	) else (
		"%wimlib%" export "%MetadataESD%" 3 %1%WIMFILE% --ref="%UUP%\*.esd" --compress=maximum
	)
)
if /i %WIMFILE%==install.esd (
	if exist "%rand%\temp\*.ESD" (
		"%wimlib%" export "%MetadataESD%" 3 %1%WIMFILE% --ref="%UUP%\*.esd" --ref="%rand%\temp\*.esd"
	) else (
		"%wimlib%" export "%MetadataESD%" 3 %1%WIMFILE% --ref="%UUP%\*.esd"
	)
)
SET ERRORTEMP=%ERRORLEVEL%
IF %ERRORTEMP% NEQ 0 (echo.&echo %lang_error_export%&PAUSE&GOTO :QUIT)
call :multi_edition_name_check !edition%2!
if defined desc (
	if /i !build! LSS 21950 set "desc=Windows 10 !desc!"
	if /i !build! GEQ 21950 set "desc=Windows 11 !desc!"
	"%wimlib%" info %1%WIMFILE% %2 "!desc!" "!desc!" --image-property DISPLAYNAME="!desc!" --image-property DISPLAYDESCRIPTION="!desc!" --image-property FLAGS="!edition%2!" 1>nul 2>nul
)
goto :eof

:add_winre
for /f "tokens=3 delims=<>" %%i in ('%imagex% /info "%2%WIMFILE%" %1 ^| findstr /i HIGHPART') do set "installhigh=%%i"
for /f "tokens=3 delims=<>" %%i in ('%imagex% /info "%2%WIMFILE%" %1 ^| findstr /i LOWPART') do set "installlow=%%i"
"%wimlib%" update %2%WIMFILE% %1 --command="add '%rand%\temp\winre.wim' '\windows\system32\recovery\winre.wim'" 1>nul 2>nul
if /i !fix11!==1 (
	"%wimlib%" extract %2%WIMFILE% %1 \Windows\System32\config\SOFTWARE --dest-dir=%rand% --no-acls 1>nul 2>nul
	reg load HKLM\%rand%_wSOFTWARE "%rand%\SOFTWARE" >nul 2>&1
	reg add "HKLM\%rand%_wSOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" /f /v BypassNRO /t REG_DWORD /d 1 >nul 2>&1
	reg unload HKLM\%rand%_wSOFTWARE >nul 2>&1
	"%wimlib%" update %2%WIMFILE% %1 --command="add '%rand%\SOFTWARE' '\Windows\System32\config\SOFTWARE'" 1>nul 2>nul
)
if /i %update% equ 0 "%wimlib%" info %2%WIMFILE% %1 --image-property LASTMODIFICATIONTIME/HIGHPART=%installhigh% --image-property LASTMODIFICATIONTIME/LOWPART=%installlow% 1>nul 2>nul
SET ERRORTEMP=%ERRORLEVEL%
IF %ERRORTEMP% NEQ 0 (echo.&echo %lang_error_export%&PAUSE&GOTO :QUIT)
goto :eof

:add_edge
if not exist "%rand%\temp\Edge" (
	for /f "delims=" %%i in ('dir /b "%UUP%\*Edge*.wim"') do "%wimlib%" apply "%UUP%\%%i" 1 "%rand%\temp\Edge" 1>nul 2>nul
	for /d %%A in (Edge,EdgeUpdate,EdgeWebView) do (
		reg load HKLM\%rand%_wSOFTWARE "%rand%\temp\Edge\%%A\%%A.dat" >nul 2>&1
		reg export "HKLM\%rand%_wSOFTWARE\REGISTRY\MACHINE\SOFTWARE" "%rand%\temp\%%A.reg" >nul 2>&1
		reg unload HKLM\%rand%_wSOFTWARE >nul 2>&1
		bin\gsar -w -s"HKEY_LOCAL_MACHINE\%rand%_wSOFTWARE\REGISTRY\MACHINE\SOFTWARE" -r"HKEY_LOCAL_MACHINE\%rand%_wSOFTWARE" -f "%rand%\temp\%%A.reg" "%rand%\temp\%%A.reg.tt" 1>nul 2>nul
		if not exist "%rand%\temp\%%A.reg.tt" bin\gsar -s"HKEY_LOCAL_MACHINE\%rand%_wSOFTWARE\REGISTRY\MACHINE\SOFTWARE" -r"HKEY_LOCAL_MACHINE\%rand%_wSOFTWARE" -f "%rand%\temp\%%A.reg" "%rand%\temp\%%A.reg.tt" 1>nul 2>nul
		erase /q  "%rand%\temp\%%A.reg" 1>nul 2>nul
		if exist "%rand%\temp\%%A.reg.tt" (
			move "%rand%\temp\%%A.reg.tt" "%rand%\temp\%%A.reg" 1>nul 2>nul
			erase /q "%rand%\temp\Edge\%%A\%%A.dat*" 1>nul 2>nul
			erase /a:sha /q "%rand%\temp\Edge\%%A\*" 1>nul 2>nul
		)
	)
)
set "edge_pr=Program Files (x86)"
if /i %arch%==x86 set "edge_pr=Program Files"
"%wimlib%" extract %2%WIMFILE% %1 \Windows\System32\config\SOFTWARE --dest-dir=%rand% --no-acls 1>nul 2>nul
for /d %%A in (Edge,EdgeUpdate,EdgeWebView) do (
	if exist "%rand%\temp\%%A.reg" (
		reg load HKLM\%rand%_wSOFTWARE "%rand%\SOFTWARE" >nul 2>&1
		reg import "%rand%\temp\%%A.reg" >nul 2>&1
		reg unload HKLM\%rand%_wSOFTWARE >nul 2>&1
	)
)
"%wimlib%" update %2%WIMFILE% %1 --command="add '%rand%\temp\Edge' '\!edge_pr!\Microsoft'" 1>nul 2>nul
"%wimlib%" update %2%WIMFILE% %1 --command="add '%rand%\SOFTWARE' '\Windows\System32\config\SOFTWARE'" 1>nul 2>nul
goto :eof

:update
set update_title=
set update_num=0
set integration=0
IF NOT EXIST "%rand%\temp\update_%4.txt" (
	if exist "%rand%\Updates\*" (
		for /f "tokens=* delims=" %%a in ('dir /b "%rand%\Updates\*"') do (
			if not exist "%rand%\Updates\%%a\update.mum" (
				move /y "%rand%\Updates\%%a" "%rand%\ISO_tmp" 1>nul 2>nul
				for /f "tokens=* delims=" %%b in ('dir /b "%rand%\ISO_tmp\*"') do (
					if exist "%ISOFOLDER%\sources\%%b" (
						xcopy "%rand%\ISO_tmp\%%b" "%ISOFOLDER%\sources\%%b" /H /R /O /X /Y >nul
					)
				)
			)
			if exist "%rand%\Updates\%%a\update.mum" (
				set updt=0
				for /f "usebackq delims=" %%i in (`find /n /v "" %rand%\Updates\%%a\update.mum ^| find "Package_for_ServicingStack"`) do (set "stc=%%a" && set updt=1)
				for /f "usebackq delims=" %%i in (`find /n /v "" %rand%\Updates\%%a\update.mum ^| find "Feature Update"`) do (set "fet1=%%a" && set updt=1)
				for /f "usebackq delims=" %%i in (`find /n /v "" %rand%\Updates\%%a\update.mum ^| find "Feature enablement"`) do (set "fet2=%%a" && set updt=1)
				for /f "usebackq delims=" %%i in (`find /n /v "" %rand%\Updates\%%a\update.mum ^| find "Package_for_OasisAsset"`) do (set "oasis=%%a" && set updt=1)
				for /f "usebackq delims=" %%i in (`find /n /v "" %rand%\Updates\%%a\update.mum ^| find "Package_for_RollupFix"`) do (set "cu=%%a" && set updt=1)
				for /f "usebackq delims=" %%i in (`find /n /v "" %rand%\Updates\%%a\update.mum ^| find "Package_for_DotNetRollup"`) do (set "netfxu=%%a" && set updt=1)
				if /i !updt! equ 0 (
					if [%4] equ [install.wim] (
						set "kbtmp=0"
						for /f "usebackq delims=" %%i in (`find /n /v "" %rand%\Updates\%%a\update.mum ^| find "Microsoft-Windows-ProfessionalEdition"`) do (set "kbtmp=1")
						if /i !kbtmp!==1 echo %%a>>%rand%\temp\update_%4.txt
					)
					if [%4] equ [boot.wim] (
						set "kbtmp=0"
						for /f "usebackq delims=" %%i in (`find /n /v "" %rand%\Updates\%%a\update.mum ^| find "WinPE"`) do (set "kbtmp=1")
						if /i !kbtmp!==1 echo %%a>>%rand%\temp\update_%4.txt
					)
				)
			)
		)
	)
	if [%4] equ [install.wim] (
		if defined stc (echo !stc!>>%rand%\temp\update_%4_str.txt)
		if defined netfxu (echo !netfxu!>>%rand%\temp\update_%4.txt)
		if defined fet1 (echo !fet1!>>%rand%\temp\update_%4.txt)
		if defined fet2 (echo !fet2!>>%rand%\temp\update_%4.txt)
		if defined cu (echo !cu!>>%rand%\temp\update_%4_cu.txt)
	) else (
		if defined stc (echo !stc!>>%rand%\temp\update_%4_str.txt)
		if defined cu (echo !cu!>>%rand%\temp\update_%4_cu.txt)
	)
	IF EXIST "%UUP%\*.msu" (
		for /f "tokens=* delims=" %%l in ('dir /b /a:-d "%UUP%\*.msu"') do (
			if not exist "%UUP%\%%~nl.cab" echo %%l>>%rand%\temp\update_%4.txt
		)
	)
	
	for /d %%F in (update_%4_str,update_%4,update_%4_cu) do (
		if exist "%rand%\temp\%%F.txt" (
			for /f "tokens=3 delims=: " %%# in ('find /v /n /c "" %rand%\temp\%%F.txt') do set "update_ntt=%%#"
			set /a update_num+=!update_ntt!
		)
	)
)
if /i %5 equ 1 (
	set integration=1
	set "update_title=%lang_integration% %lang_language%"
)
if /i %7 equ 1 (
	if [%4] equ [install.wim] (
		set integration=1
		if defined update_title (
			set "update_title=%update_title%, %lang_metroui%"
		) else (
			set "update_title=%lang_integration% %lang_metroui%"
		)
	)
)
if /i %update_num% neq 0 (
	if /i %2 equ 1 (
		set integration=1
		if defined update_title (
			set "update_title=%update_title%, %lang_update%"
		) else (
			set "update_title=%lang_integration% %lang_update%"
		)
	)
)
if /i %3 equ 1 (
	set integration=1
	if defined update_title (
		set "update_title=%update_title%, %lang_netfx%"
	) else (
		set "update_title=%lang_integration% %lang_netfx%"
	)
)
if /i %integration% equ 1 (
	call :as
	echo %update_title% %lang_to_image% %4 . . .
	call :as
	if not exist "%mountdir%" mkdir "%mountdir%"
	for /L %%i in (1, 1, !images!) do (
		call :as -
		echo %lang_mount% [%%i - !images!]:
		call :as -
		"%dism%" /English /mount-wim /WimFile:%1 /index:%%i /MountDir:%mountdir%
		if %5 equ 1 (
			for /f "tokens=* delims=" %%a in ('dir /b /a:d "%down_temp%"') do (
				"%dism%" /English /Image:"%mountdir%" /Add-Package /PackagePath:"%down_temp%\%%a"
			)
		)
		if [%4] equ [install.wim] (
			if %7 equ 1 (
				if exist "%UUP%\Apps\_AppsEditions.txt" (
					for /f "tokens=* delims=" %%# in ('type "%UUP%\Apps\_AppsEditions.txt"') do set "%%#"
					set "_appList="
					for /f "tokens=3 delims=: " %%# in ('%wimlib% info "%ISOFOLDER%\sources\install.wim" %%i ^| findstr /b "Edition"') do (
						for %%a in (Core,CoreCountrySpecific,Professional,EnterpriseS) do (
							if /i "%%#"=="%%a" set "_appList=!_appProf!"
						)
						for %%a in (CoreN,ProfessionalN,EnterpriseSN) do (
							if /i "%%#"=="%%a" set "_appList=!_appProN!"
						)
						for %%a in (ServerDatacenter,ServerStandard,ServerTurbine) do (
							if /i "%%#"=="%%a" set "_appList=!_appSFull!"
						)
						if /i [%%#]==[PPIPro] set "_appList=!_appTeam!"
					)
					if defined _appList (
						if exist "%UUP%\Apps\MSIXFramework\*" (
							call :as -
							echo %lang_metroui_setup% Framework:
							call :as -
							set appx=
							for /f "tokens=* delims=" %%# in ('dir /b /a:-d "%UUP%\Apps\MSIXFramework\*.*"') do (
								echo %%~n#
								set "appx=!appx! /DependencyPackagePath:^"%UUP%\Apps\MSIXFramework\%%#^""
								"%dism%" /English /Image:"%mountdir%" /Add-ProvisionedAppxPackage /PackagePath:"%UUP%\Apps\MSIXFramework\%%#" /SkipLicense >nul
							)
							echo.
						)
						
						call :as -
						echo %lang_metroui_setup% Apps:
						call :as -
						for %%# in (!_appList!) do call :appx_add "%%#"
						echo.
					)
				)
			)
		)
		if %2 equ 1 (
			call :as -
			echo %lang_update_setup%:
			call :as -
			echo.
			set "cul="
			for /d %%F in (update_%4_str,update_%4,update_%4_cu) do (
				IF EXIST "%rand%\temp\%%F.txt" (
					set "update_num="
					for /f "tokens=3 delims=: " %%# in ('find /v /n /c "" %rand%\temp\%%F.txt') do set "update_num=%%#"
					for /L %%k in (1, 1, %update_num%) do (
						for /f "tokens=2 delims=[]" %%l in ('find /n /v "" %rand%\temp\%%F.txt ^| find "[%%k]"') do (
							if exist "%rand%\Updates\%%l" (
								set upy=0
								if [%4] equ [install.wim] (
									for /f "tokens=3 delims=: " %%# in ('%wimlib% info "%ISOFOLDER%\sources\%4" %%i ^| findstr /b "Edition"') do set "tted=%%#"
									for /f "tokens=1 delims=" %%# in ('findstr /i /m /c:"Microsoft-Windows-!tted!Edition" "%rand%\Updates\%%l\update.mum"') do set upy=1
								)
								if [%4] equ [boot.wim] set upy=1
								
								if !upy! equ 1 (
									if "%%F" equ "update_%4_cu" set "cul=%%l.cab"
									echo %%l
									call :as _
									"%dism%" /English /Image:"%mountdir%" /Add-Package /PackagePath:"%rand%\Updates\%%l"
									call :as _
								) else (
									echo Update '%%l' - this edition "!tted!" does not support...
								)
							)
							IF EXIST "%UUP%\%%l" (
								set "cul=%%l"
								for /f "tokens=* delims=" %%l in ('dir /b /a:-d "%UUP%\%%l"') do (
									echo %%l
									call :as _
									"%dism%" /English /Image:"%mountdir%" /Add-Package /PackagePath:"%UUP%\%%l"
									call :as _
									echo.
								)
							)
						)
					)
					echo.
				)
			)
			
			reg load HKLM\%rand%_wSOFTWARE "%mountdir%\Windows\System32\config\SOFTWARE" >nul 2>&1
			for /f "tokens=3 delims= " %%i in ('REG QUERY "HKEY_LOCAL_MACHINE\!rand!_wSOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild') do set /a "curbuild=%%i"
			reg unload HKLM\!rand!_wSOFTWARE >nul 2>&1
		)
		if %6 equ 1 (
			call :as -
			echo %lang_clean_winsxs%:
			call :as -
			"%dism%" /English /Image:"%mountdir%" /Cleanup-Image /StartComponentCleanup /ResetBase
			echo.
		)
		if [%4] equ [install.wim] (
			if %3 equ 1 (
				call :as -
				echo %lang_enable_netfx35%:
				call :as -
				"%dism%" /English /Image:"%mountdir%" /enable-feature /featurename:NetFX3 /All /Source:"%ISOFOLDER%\sources\sxs" /LimitAccess
				echo.
			)
		)
		call :as -
		echo %lang_unmount%:
		call :as -
		"%dism%" /English /Unmount-Wim /MountDir:%mountdir% /commit
		call :Cudt "%ISOFOLDER%\sources\%4" %%i
		SET ERRORTEMP=%ERRORLEVEL%
		IF %ERRORTEMP% NEQ 0 (
			call :error_creating_edition
			set "MESSAGE=%lang_error_unmount%"&goto :E_MSG
		)
		for /f "skip=1 delims=" %%p in ('%wimlib% dir %1 %%i --path=Windows\WinSxS\ManifestCache 2^>nul') do "%wimlib%" update %1 %%i --command="delete '%%p'" 1>nul 2>nul
	)
	echo.
	if not [%4] equ [install.wim] (
		"%wimlib%" optimize %1
		echo.
	)
)
if defined curbuild (call :curbuild)
goto :eof

:CUdt
if not exist "%systemroot%\system32\wbem\wmic.exe" goto :eof
set "d=" && set "x="

if exist "%UUP%\%cul%" (
	for /f "skip=1 delims=" %%j in ('wmic datafile where "name='%UUP:\=\\%\\%cul%'" get LastModified') do (
		for /f %%k in ("%%~j") do (
			set sVar=%%~k
			set "d=!sVar:~0,4!-!sVar:~4,2!-!sVar:~6,2! !sVar:~8,2!:!sVar:~10,2!:!sVar:~12,2!"
			if /i "%~nx1" equ "install.wim" set "diso=!sVar:~4,2!/!sVar:~6,2!/!sVar:~0,4!,!sVar:~8,2!:!sVar:~10,2!:!sVar:~12,2!"
		)
	)
)

if defined d (
	for /f %%i in ('
		mshta vbscript:Execute("CreateObject(""Scripting.FileSystemObject"").GetStandardStream(1).Write(DateDiff(""s"",""1601-01-01 00:00:00"",""!d!"")&""0000000""):document.write():close()"^)
	') do (
		for /f %%j in ('
			mshta "javascript:new ActiveXObject("Scripting.FileSystemObject").GetStandardStream(1).Write((%%i).toString(16).toUpperCase());document.write();close()"
		') do (
			set x=%%j
		)
	)
)

if defined x "%wimlib%" info %1 %2 --image-property LASTMODIFICATIONTIME/HIGHPART=0x0%x:~,7% --image-property LASTMODIFICATIONTIME/LOWPART=0x%x:~7% --image-property CREATIONTIME/HIGHPART=0x0%x:~,7% --image-property CREATIONTIME/LOWPART=0x%x:~7% 1>nul 2>nul
goto :eof

:appx_add
set "_pfn=%UUP%\Apps\%~1"
if not exist "%_pfn%\License.xml" goto :eof
if not exist "%_pfn%\*.appx*" if not exist "%_pfn%\*.msix*" goto :eof
set "_main="
if not defined _main if exist "%_pfn%\*.msixbundle" for /f "tokens=* delims=" %%# in ('dir /b /a:-d "%_pfn%\*.msixbundle"') do set "_main=%%#"
if not defined _main if exist "%_pfn%\*.appxbundle" for /f "tokens=* delims=" %%# in ('dir /b /a:-d "%_pfn%\*.appxbundle"') do set "_main=%%#"
if not defined _main if exist "%_pfn%\*.appx" for /f "tokens=* delims=" %%# in ('dir /b /a:-d "%_pfn%\*.appx"') do set "_main=%%#"
if not defined _main if exist "%_pfn%\*.msix" for /f "tokens=* delims=" %%# in ('dir /b /a:-d "%_pfn%\*.msix"') do set "_main=%%#"
if not defined _main goto :eof
set "_stub="
if exist "%_pfn%\AppxMetadata\Stub\*.*x" set "_stub=/StubPackageOption:InstallStub"
echo %~1
"%dism%" /English /Image:"%mountdir%" /Add-ProvisionedAppxPackage /PackagePath:"%_pfn%\%_main%" /LicensePath:"%_pfn%\License.xml" /Region:"all" %_stub% >nul
SET ERRORTEMP=%ERRORLEVEL%
IF %ERRORTEMP% EQU 1726 call :appx_replay %~1
goto :eof

:appx_replay
if exist "%_pfn%\AppxMetadata\Stub\*%arch%.*x" echo %~1 - Error install - && exit /b

set "_main_replay="
set "_dependency_replay="
if exist "%_pfn%\AppxMetadata\Stub\*%arch%.*x" (
	for /f "tokens=* delims=" %%# in ('dir /b /a:-d "%_pfn%\AppxMetadata\Stub\*%arch%.*x"') do (
		set "_main_replay=AppxMetadata\Stub\%%#"
	)
)
if exist "%_pfn%\*%arch%*.*x" (
	for /f "tokens=* delims=" %%# in ('dir /b /a:-d "%_pfn%\*%arch%*.*x"') do (
		if defined _main_replay set "_dependency_replay=!_dependency_replay! /DependencyPackagePath:^"%_pfn%\%%#^""
		if not defined _main_replay set "_main_replay=%%#"
	)
)
if %language%==1 (
	FOR /L %%j IN (1,1,!lang_num!) DO (
		for %%L in (DEF,ON) do (
			if /i "!lang_ON_%%j!"=="%%L" (
				call :appx_lang !lang_id_%%j!
			)
		)
	)
) else (
	call :appx_lang !langid!
)
for %%L in (100,125,150,400) do call :appx_search %%L

echo %~1 - Replay install
"%dism%" /English /Image:"%mountdir%" /Add-ProvisionedAppxPackage /PackagePath:"%_pfn%\%_main_replay%" /LicensePath:"%_pfn%\License.xml" !_dependency_replay! /Region:"all" >nul
SET ERRORTEMP=%ERRORLEVEL%
IF %ERRORTEMP% NEQ 0 echo %~1 - Error install - 
goto :eof

:appx_lang
if /i "%1"=="ar-sa" call :appx_search ar
if /i "%1"=="bg-bg" call :appx_search bg
if /i "%1"=="cs-cz" call :appx_search cs
if /i "%1"=="da-dk" call :appx_search da
if /i "%1"=="de-de" call :appx_search de
if /i "%1"=="el-gr" call :appx_search el
if /i "%1"=="es-es" call :appx_search es
if /i "%1"=="es-mx" call :appx_search es
if /i "%1"=="et-ee" call :appx_search et
if /i "%1"=="fi-fi" call :appx_search fi
if /i "%1"=="fr-ca" call :appx_search fr
if /i "%1"=="fr-fr" call :appx_search fr
if /i "%1"=="he-il" call :appx_search he
if /i "%1"=="hi-in" call :appx_search hi
if /i "%1"=="hr-hr" call :appx_search hr
if /i "%1"=="hu-hu" call :appx_search hu
if /i "%1"=="it-it" call :appx_search it
if /i "%1"=="ja-jp" call :appx_search ja
if /i "%1"=="ko-kr" call :appx_search ko
if /i "%1"=="lt-lt" call :appx_search lt
if /i "%1"=="lv-lv" call :appx_search lv
if /i "%1"=="nb-no" call :appx_search nb
if /i "%1"=="nl-nl" call :appx_search nl
if /i "%1"=="pl-pl" call :appx_search pl
if /i "%1"=="pt-br" call :appx_search pt
if /i "%1"=="pt-pt" call :appx_search pt
if /i "%1"=="ro-ro" call :appx_search ro
if /i "%1"=="ru-ru" call :appx_search ru
if /i "%1"=="sk-sk" call :appx_search sk
if /i "%1"=="sl-si" call :appx_search sl
if /i "%1"=="sr-latn-rs" call :appx_search sr-latn
if /i "%1"=="sv-se" call :appx_search sv
if /i "%1"=="th-th" call :appx_search th
if /i "%1"=="tr-tr" call :appx_search tr
if /i "%1"=="uk-ua" call :appx_search uk
if /i "%1"=="zh-cn" call :appx_search zh-hans
if /i "%1"=="zh-tw" call :appx_search zh-hant
goto :eof

:appx_search
if not exist "%_pfn%\AppxMetadata\Stub\*.*x" (
	if exist "%_pfn%\*%1.*x" (
		for /f "tokens=* delims=" %%# in ('dir /b /a:-d "%_pfn%\*%1.*x"') do set "_dependency_replay=!_dependency_replay! /DependencyPackagePath:^"%_pfn%\%%#^""
	)
)
goto :eof

:curbuild
if /i [%DVDISO:~0,5%] neq [%curbuild%] set "DVDISO=%curbuild%%DVDISO:~5%"
if /i %curbuild% equ 18363 set DVDISO=!DVDISO:19H1=19H2!
goto :eof

:fix11
del /F /S /Q "%ISOFOLDER%\sources\appraiserres.dll" 1>nul 2>nul
copy /Y "bin\Fix11\appraiserres_%1.dll" "%ISOFOLDER%\sources\appraiserres.dll" 1>nul 2>nul
if not exist "%rand%\temp\boot\*" mkdir "%rand%\temp\boot"
set "tt1=%random%"
"%wimlib%" extract %ISOFOLDER%\sources\boot.wim 2 \Windows\System32\config\SYSTEM --dest-dir=%rand%\temp\boot --no-acls --no-attributes 1>nul 2>nul
reg load HKLM\!tt1!_wSYSTEM "%rand%\temp\boot\SYSTEM" 1>nul 2>nul
reg add "HKLM\!tt1!_wSYSTEM\Setup\LabConfig" /v "BypassCPUCheck" /t REG_DWORD /d "1" /f 1>nul 2>nul
reg add "HKLM\!tt1!_wSYSTEM\Setup\LabConfig" /v "BypassTPMCheck" /t REG_DWORD /d "1" /f 1>nul 2>nul
reg add "HKLM\!tt1!_wSYSTEM\Setup\LabConfig" /v "BypassSecureBootCheck" /t REG_DWORD /d "1" /f 1>nul 2>nul
reg add "HKLM\!tt1!_wSYSTEM\Setup\LabConfig" /v "BypassStorageCheck" /t REG_DWORD /d "1" /f 1>nul 2>nul
reg add "HKLM\!tt1!_wSYSTEM\Setup\LabConfig" /v "BypassRAMCheck" /t REG_DWORD /d "1" /f 1>nul 2>nul
reg add "HKLM\!tt1!_wSYSTEM\Setup\MoSetup" /v "AllowUpgradesWithUnsupportedTPMOrCPU" /t REG_DWORD /d "1" /f 1>nul 2>nul
reg unload HKLM\!tt1!_wSYSTEM 1>nul 2>nul
"%wimlib%" update %ISOFOLDER%\sources\boot.wim 2 --command "add '%rand%\temp\boot\SYSTEM' '\Windows\System32\config\SYSTEM'" 1>nul 2>nul
"%wimlib%" update %ISOFOLDER%\sources\boot.wim 2 --command "add 'bin\Fix11\appraiserres_%1.dll' '\sources\appraiserres.dll'" 1>nul 2>nul
if exist "%rand%\temp\boot\*" rmdir /s /q "%rand%\temp\boot"
goto :eof

:multi_edition_name_check
set desc=
if /i "%1" equ "Cloud" set "desc=S (Cloud)"
if /i "%1" equ "CloudN" set "desc=S N (Cloud N)"
if /i "%1" equ "Clode" set "desc=Lean"
if /i "%1" equ "CoreSingleLanguage" set "desc=Home Single Language"
if /i "%1" equ "CoreCountrySpecific" set "desc=Home China"
if /i "%1" equ "Core" set "desc=Home"
if /i "%1" equ "CoreN" set "desc=Home N"
if /i "%1" equ "Professional" set "desc=Pro"
if /i "%1" equ "ProfessionalN" set "desc=Pro N"
if /i "%1" equ "ProfessionalEducation" set "desc=Pro Education"
if /i "%1" equ "ProfessionalEducationN" set "desc=Pro Education N"
if /i "%1" equ "ProfessionalWorkstation" set "desc=Pro for Workstations"
if /i "%1" equ "ProfessionalWorkstationN" set "desc=Pro N for Workstations"
if /i "%1" equ "ProfessionalSingleLanguage" set "desc=Pro Single Language"
if /i "%1" equ "ProfessionalCountrySpecific" set "desc=Pro China Only"
if /i "%1" equ "PPIPro" set "desc=Team"
if /i "%1" equ "Education" set "desc=Education"
if /i "%1" equ "EducationN" set "desc=Education N"
if /i "%1" equ "Enterprise" set "desc=Enterprise"
if /i "%1" equ "EnterpriseN" set "desc=Enterprise N"
if /i "%1" equ "EnterpriseEval" set "desc=Enterprise Evaluation"
if /i "%1" equ "EnterpriseNEval" set "desc=Enterprise N Evaluation"
if /i "%1" equ "EnterpriseG" set "desc=Enterprise G"
if /i "%1" equ "EnterpriseGN" set "desc=Enterprise G N"
if /i "%1" equ "EnterpriseS" set "desc=Enterprise S"
if /i "%1" equ "EnterpriseSN" set "desc=Enterprise S N"
if /i "%1" equ "EnterpriseSEval" set "desc=Enterprise S Evaluation"
if /i "%1" equ "EnterpriseSNEval" set "desc=Enterprise S N Evaluation"
if /i "%1" equ "IoTEnterprise" set "desc=IoT Enterprise"
if /i "%1" equ "ServerRdsh" (
	set "desc=Enterprise for Remote Sessions"
	if /i !build! GEQ 17749 (
		if /i !build! LSS 18000 (
			set "desc=Enterprise for Virtual Desktops"
		)
	)
)
if /i "%1" equ "Starter" set "desc=Starter"
if /i "%1" equ "StarterN" set "desc=Starter N"
exit /b

:uups_down
set pack=%~n1
if exist "%down_temp%\%uups_down%" goto :eof
md %down_temp%\%uups_down%
if %2==cab (
	echo CAB ^> DIR ^(%pack%.cab^)
	expand.exe "%down_temp%\%pack%.cab" -f:* %down_temp%\%uups_down%\ >nul
	erase /s /q %down_temp%\%pack%.cab 1>nul 2>nul
)
if %2==esd (
	echo ESD ^> DIR ^(%pack%.esd^)
	"%wimlib%" apply "%down_temp%\%pack%.esd" 1 %down_temp%\%uups_down%\ >nul 2>&1
	erase /s /q %down_temp%\%pack%.esd 1>nul 2>nul
)
set /a uups_down+=1
goto :eof

:uups_cab
set pack=%~n1
for %%# in (Windows10.0-KB,Windows11.0-KB) do (
	if /i [%pack:~0,14%] equ [%%#] (
		call :ext_upd !pack!
		goto :eof
	)
)
if /i [%pack:~0,3%] equ [SSU] (
	call :ext_upd !pack!
	goto :eof
)
if exist "%CD%\%rand%\temp\%pack%.ESD" goto :eof
md %rand%\temp\1
echo CAB ^> DIR ^> ESD ^(%pack%.cab^)
expand.exe "%UUP%\%pack%.cab" -f:* %rand%\temp\1\ >nul
"%wimlib%" capture "%rand%\temp\1" "%rand%\temp\%pack%.ESD" --compress=LZX:15 --check --no-acls --norpfix "%pack%" "%pack%" >nul
rd /s /q %rand%\temp\1
goto :eof

:uups_msu
set pack=%~n1
if not exist "%rand%\Updates\%pack%" (
	mkdir "%rand%\Updates\tmp"
	bin\7z.exe x "%UUP%\%pack%.msu" -o"%rand%\Updates\tmp" 1>nul 2>nul
	erase /q %rand%\Updates\tmp\*.xml 1>nul 2>nul
	erase /q %rand%\Updates\tmp\*.txt 1>nul 2>nul
	erase /q %rand%\Updates\tmp\Des*.cab 1>nul 2>nul
	erase /q %rand%\Updates\tmp\one*.cab 1>nul 2>nul
	erase /q %rand%\Updates\tmp\WSUSSCAN.cab 1>nul 2>nul
	call :ext_upd_msu
	rmdir /s /q "%rand%\Updates\tmp" 1>nul 2>nul
)
goto :eof

:uups_psf
if /i %update%==0 goto :eof
set pack=%~n1
mkdir %rand%\PSF
expand.exe -f:*.psf.cix.xml "%UUP%\%pack%.cab" "%rand%\PSF" 1>nul 2>nul
if exist "%rand%\PSF\*.psf.cix.xml" (
	echo PSF ^> DIR ^(%1^)
	for /f %%# in ('dir /b "%rand%\PSF\*.psf.cix.xml"') do set psfx=%%#
	mkdir "%rand%\Updates\%pack%"
	expand.exe "%UUP%\%pack%.cab" -f:* -r "%rand%\Updates\%pack%" 1>nul 2>nul
	bin\PSFExtractor -m -v2 "%UUP%\%pack%.psf" "%rand%\PSF\!psfx!" "%rand%\Updates\%pack%" 1>nul 2>nul
	erase /q %rand%\Updates\%pack%\!psfx! 1>nul 2>nul
)
rmdir /s /q %rand%\PSF
goto :eof

:ext_upd
if /i %update%==0 goto :eof
if not exist "%rand%\Updates\%1" (
	echo CAB ^> DIR ^(%1^)
	mkdir "%rand%\Updates\%1"
	expand.exe "%UUP%\%1.cab" -f:* -r "%rand%\Updates\%1" 1>nul 2>nul
	if exist "%rand%\Updates\%1\*.cablist.ini" (
		for /f %%t in ('dir /b "%rand%\Updates\%1\*.cab"') do (
			expand %rand%\Updates\%1\%%t -f:* -r %rand%\Updates\%1 1>nul 2>nul
			erase /q %rand%\Updates\%1\%%t 1>nul 2>nul
		)
		erase /q %rand%\Updates\%1\*.cablist.ini 1>nul 2>nul
	)
)
goto :eof

:ext_upd_msu
if /i %update%==0 goto :eof
if exist "%rand%\Updates\tmp\*.wim" (
	for /f %%t in ('dir /b "%rand%\Updates\tmp\*.wim"') do (
		set "uname=%%t"
		echo WIM ^> DIR ^(!uname:~0,-4!^)
		mkdir %rand%\Updates\!uname:~0,-4!
		"%wimlib%" extract "%rand%\Updates\tmp\%%t" 1 --dest-dir="%rand%\Updates\!uname:~0,-4!" 1>nul 2>nul
		if exist "%rand%\Updates\tmp\!uname:~0,-4!.psf" (
			for /f %%v in ('dir /b "%rand%\Updates\tmp\!uname:~0,-4!.psf"') do (
				bin\PSFExtractor -m -v2 %rand%\Updates\tmp\%%v %rand%\Updates\!uname:~0,-4!\express.psf.cix.xml %rand%\Updates\!uname:~0,-4! 1>nul 2>nul
				erase /q %rand%\Updates\!uname:~0,-4!\express.psf.cix.xml 1>nul 2>nul
			)
		)
		erase /q %rand%\Updates\tmp\!uname:~0,-4!.*
	)
)
if exist "%rand%\Updates\tmp\*.cab" (
	for /f %%b in ('dir /b "%rand%\Updates\tmp\*.cab"') do (
		set "uname=%%b"
		echo CAB ^> DIR ^(!uname:~0,-4!^)
		mkdir %rand%\Updates\!uname:~0,-4!
		expand.exe "%rand%\Updates\tmp\%%b" -f:* "%rand%\Updates\!uname:~0,-4!" 1>nul 2>nul
		if exist "%rand%\Updates\tmp\!uname:~0,-4!.psf" (
			for /f %%v in ('dir /b "%rand%\Updates\tmp\!uname:~0,-4!.psf"') do (
				bin\PSFExtractor -m -v2 %rand%\Updates\tmp\%%v %rand%\Updates\!uname:~0,-4!\express.psf.cix.xml %rand%\Updates\!uname:~0,-4!
				erase /q %rand%\Updates\!uname:~0,-4!\express.psf.cix.xml 1>nul 2>nul
			)
		)
		if exist "%rand%\Updates\!uname:~0,-4!\*.cablist.ini" (
			for /f %%t in ('dir /b "%rand%\Updates\!uname:~0,-4!\*.cab"') do (
				expand %rand%\Updates\!uname:~0,-4!\%%t -f:* %rand%\Updates\!uname:~0,-4! 1>nul 2>nul
				erase /q %rand%\Updates\!uname:~0,-4!\%%t 1>nul 2>nul
			)
			erase /q %rand%\Updates\!uname:~0,-4!\*.cablist.ini 1>nul 2>nul
		)
		erase /q %rand%\Updates\tmp\!uname:~0,-4!.*
	)
)
goto :eof

:uups_fol
set pack=%1
if /i [%pack:~0,14%] equ [Windows10.0-KB] goto :eof
if /i [%pack:~0,14%] equ [Windows11.0-KB] goto :eof
if /i [%pack%] equ [Apps] goto :eof
if /i [%pack:~0,3%] equ [SSU] goto :eof
if /i [%1]==[Metadata] goto :eof
if exist "%CD%\%rand%\temp\%pack%.ESD" goto :eof
echo DIR ^> ESD ^(%pack%^)
"%wimlib%" capture "%UUP%\%pack%" "%rand%\temp\%pack%.ESD" --compress=LZX:15 --check --no-acls --norpfix "%pack%" "%pack%" >nul
goto :eof

:uups_esd
for /f "tokens=2 delims=[]" %%b in ('find /N /v "" %rand%\temp\uups_esd.txt ^| find "[%1]"') do set uups_esd=%%b
for /f "tokens=3 delims=: " %%i in ('%wimlib% info "%UUP%\%uups_esd%" 3 ^| findstr /b "Edition"') do set "edition%1=%%i"
for /f "tokens=3 delims=: " %%i in ('%wimlib% info "%UUP%\%uups_esd%" 3 ^| find /i "Default"') do set "langid%1=%%i"
for /f "tokens=2 delims=: " %%i in ('%wimlib% info "%UUP%\%uups_esd%" 3 ^| find /i "Architecture"') do set "arch%1=%%i"
for /f "tokens=2 delims=: " %%i in ('%wimlib% info "%UUP%\%uups_esd%" 3 ^| findstr /b "Build"') do set build%1=%%i
for /f "tokens=4 delims=: " %%i in ('%wimlib% info "%UUP%\%uups_esd%" 3 ^| find /i "Service Pack Build"') do set svcbuild%1=%%i
if /i [!langid%1!]==[] call :lang_index %1
if /i !arch%1!==x86_64 set "arch%1=x64"
if /i !arch%1!==ARM64 set "arch%1=arm64"
for /f "tokens=1* delims=: " %%i in ('%wimlib% info "%UUP%\%uups_esd%" 3 ^| findstr /b "Name"') do set "name=%%j"
set "name%1=!name! - !build%1!.!svcbuild%1! / !arch%1! / !langid%1!"
set "uups_esd%1=%uups_esd%"
goto :eof

:appx_sort
echo.
echo Parsing Apps CompDB . . .
echo.
pushd "!UUP!"
copy /y "!fold_def!\bin\CompDB_App.txt" . 1>nul 2>nul
for /f "delims=" %%# in ('dir /b /a:-d "*.AggregatedMetadata*.cab"') do set "_mdf=%%#"
if exist "_tmpMD\" rmdir /s /q "_tmpMD\" 1>nul 2>nul
mkdir "_tmpMD"
expand.exe -f:*TargetCompDB_* "%_mdf%" _tmpMD 1>nul
expand.exe -r -f:*.xml "_tmpMD\*.cab" _tmpMD 1>nul
for /f "delims=" %%# in ('dir /b /a:-d "_tmpMD\*TargetCompDB_App_*.xml" 2^>nul') do copy /y _tmpMD\%%# .\CompDB_App.xml 1>nul
if not exist "CompDB_App.xml" (
	echo.
	echo CompDB_App.xml file is not found, skip operation.
	rmdir /s /q "_tmpMD\" 1>nul 2>nul
	popd
	set _IPA=0
	goto :eof
)
type nul>AppsList.xml
>>AppsList.xml echo ^<Apps^>
>>AppsList.xml echo ^<Client^>
for %%# in (Core,CoreCountrySpecific,CoreSingleLanguage,Professional,ProfessionalEducation,ProfessionalWorkstation,Education,Enterprise,EnterpriseG,EnterpriseS,ServerRdsh,IoTEnterprise,IoTEnterpriseS,CloudEdition,CloudEditionL) do if exist _tmpMD\*CompDB_%%#_*.xml (
>>AppsList.xml (find /i "PreinstalledApps" _tmpMD\*CompDB_%%#_*.xml | find /v "-")
)
>>AppsList.xml echo ^</Client^>
>>AppsList.xml echo ^<CoreN^>
for %%# in (CoreN,ProfessionalN,ProfessionalEducationN,ProfessionalWorkstationN,EducationN,EnterpriseN,EnterpriseGN,EnterpriseSN,CloudEditionN,CloudEditionLN) do if exist _tmpMD\*CompDB_%%#_*.xml (
>>AppsList.xml (find /i "PreinstalledApps" _tmpMD\*CompDB_%%#_*.xml | find /v "-")
)
>>AppsList.xml echo ^</CoreN^>
>>AppsList.xml echo ^<Team^>
for %%# in (PPIPro) do if exist _tmpMD\*CompDB_%%#_*.xml (
>>AppsList.xml (find /i "PreinstalledApps" _tmpMD\*CompDB_%%#_*.xml | find /v "-")
)
>>AppsList.xml echo ^</Team^>
>>AppsList.xml echo ^<ServerAzure^>
for %%# in (AzureStackHCICor,TurbineCor) do if exist _tmpMD\*CompDB_Server%%#_*.xml (
>>AppsList.xml (find /i "PreinstalledApps" _tmpMD\*CompDB_Server%%#_*.xml | find /v "-")
)
>>AppsList.xml echo ^</ServerAzure^>
>>AppsList.xml echo ^<ServerCore^>
for %%# in (Standard,Datacenter) do if exist _tmpMD\*CompDB_Server%%#Core_*.xml (
>>AppsList.xml (find /i "PreinstalledApps" _tmpMD\*CompDB_Server%%#Core_*.xml | find /v "-")
)
>>AppsList.xml echo ^</ServerCore^>
>>AppsList.xml echo ^<ServerFull^>
for %%# in (Standard,Datacenter,Turbine) do if exist _tmpMD\*CompDB_Server%%#_*.xml (
>>AppsList.xml (find /i "PreinstalledApps" _tmpMD\*CompDB_Server%%#_*.xml | find /v "-")
)
>>AppsList.xml echo ^</ServerFull^>
>>AppsList.xml echo ^</Apps^>
rmdir /s /q "_tmpMD\" 1>nul 2>nul
type nul>_AppsEditions.txt
1>nul 2>nul powershell -ep unrestricted -nop -c "Set-Location -LiteralPath '!UUP!'; $f=[IO.File]::ReadAllText('.\CompDB_App.txt') -split ':embed\:.*';iex ($f[1])"
if exist "Apps\*_8wekyb3d8bbwe" move /y _AppsEditions.txt Apps\ 1>nul
del /f /q AppsList.xml CompDB_App.* 1>nul
popd
goto :eof

:lang_index
for /f "skip=1 delims=" %%i in ('%wimlib% dir "%UUP%\%uups_esd%" 1 --path=sources\sr-latn-rs 2^>nul') do set "langid%1=sr-latn-rs"
goto :eof

:fold_lang
dir "%1" /a-d 2>nul >nul && call :files_lang %1 %2
for /f "tokens=*" %%a in ('dir /b /ad "%1"') do (
	if /i [%2]==[] (set "put=%%a") else (set "put=%2\%%a")
	call :fold_lang %1\%%a !put!
)
exit /b

:files_lang
for /f "tokens=*" %%a in ('dir /b /a-d "%1"') do (
	set "fold_t2=%1\"
	FOR /L %%j IN (!size_f!,1,!size_f!) DO (
		if not exist "%ISOFOLDER%\sources\!fold_t2:~%%j!!lang_tt!" (
			mkdir "%ISOFOLDER%\sources\!fold_t2:~%%j!!lang_tt!"
		)
		copy /y "%1\%%a" "%ISOFOLDER%\sources\!fold_t2:~%%j!!lang_tt!\%%a" >nul
	)
)

:setdate
if /i %1==Jan set "isotime=01/%isotime%"
if /i %1==Feb set "isotime=02/%isotime%"
if /i %1==Mar set "isotime=03/%isotime%"
if /i %1==Apr set "isotime=04/%isotime%"
if /i %1==May set "isotime=05/%isotime%"
if /i %1==Jun set "isotime=06/%isotime%"
if /i %1==Jul set "isotime=07/%isotime%"
if /i %1==Aug set "isotime=08/%isotime%"
if /i %1==Sep set "isotime=09/%isotime%"
if /i %1==Oct set "isotime=10/%isotime%"
if /i %1==Nov set "isotime=11/%isotime%"
if /i %1==Dec set "isotime=12/%isotime%"
exit /b

:setmmm
if /i %1==Jan set "datetime=%yyy:~2%01%ddd%"
if /i %1==Feb set "datetime=%yyy:~2%02%ddd%"
if /i %1==Mar set "datetime=%yyy:~2%03%ddd%"
if /i %1==Apr set "datetime=%yyy:~2%04%ddd%"
if /i %1==May set "datetime=%yyy:~2%05%ddd%"
if /i %1==Jun set "datetime=%yyy:~2%06%ddd%"
if /i %1==Jul set "datetime=%yyy:~2%07%ddd%"
if /i %1==Aug set "datetime=%yyy:~2%08%ddd%"
if /i %1==Sep set "datetime=%yyy:~2%09%ddd%"
if /i %1==Oct set "datetime=%yyy:~2%10%ddd%"
if /i %1==Nov set "datetime=%yyy:~2%11%ddd%"
if /i %1==Dec set "datetime=%yyy:~2%12%ddd%"
exit /b

:setmmm1
if /i %1==Jan set "datetime%2=%ddd%-01-%yyy% %timeout%"
if /i %1==Feb set "datetime%2=%ddd%-02-%yyy% %timeout%"
if /i %1==Mar set "datetime%2=%ddd%-03-%yyy% %timeout%"
if /i %1==Apr set "datetime%2=%ddd%-04-%yyy% %timeout%"
if /i %1==May set "datetime%2=%ddd%-05-%yyy% %timeout%"
if /i %1==Jun set "datetime%2=%ddd%-06-%yyy% %timeout%"
if /i %1==Jul set "datetime%2=%ddd%-07-%yyy% %timeout%"
if /i %1==Aug set "datetime%2=%ddd%-08-%yyy% %timeout%"
if /i %1==Sep set "datetime%2=%ddd%-09-%yyy% %timeout%"
if /i %1==Oct set "datetime%2=%ddd%-10-%yyy% %timeout%"
if /i %1==Nov set "datetime%2=%ddd%-11-%yyy% %timeout%"
if /i %1==Dec set "datetime%2=%ddd%-12-%yyy% %timeout%"
exit /b

:as
if [%1]==[] echo ============================================================================
if [%1]==[_] echo ____________________________________________________________________________
if [%1]==[-] echo ----------------------------------------------------------------------------
exit /b

:error_cmd
cls
echo Error work script.
IF EXIST %rand%\ rmdir /s /q %rand%
pause>nul
goto :QUIT

:error_creating_edition
"%dism%" /English /Unmount-Image /MountDir:"%mountdir%" /Discard 1>nul 2>nul
rmdir /s /q "%mountdir%" 1>nul 2>nul
exit /b

:E_MSG
echo.
call :as
echo Error:
echo %MESSAGE%
echo.
echo.
echo %lang_exit%
pause >nul

:QUIT
IF EXIST %rand%\ rmdir /s /q %rand%
exit