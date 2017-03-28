@echo off

set SIGNTOOL="C:\Program Files (x86)\Windows Kits\10\bin\x64\signtool.exe"

set keyname=%1
if "%keyname%" == "" goto usage
echo "Key name is " %1
for %%A in (Balloon NetKVM pvpanic viorng vioscsi vioserial viostor) do (
  for %%B in (Win10 Win8 Win7) do (
    call %SIGNTOOL% sign /v /s PrivateCertStore /n %%1 /t http://timestamp.verisign.com/scripts/timestamp.dll %%A/Install/%%B/amd64/*.sys 
    if %ERRORLEVEL% NEQ 0 goto signfail 
    call %SIGNTOOL% sign /v /s PrivateCertStore /n %%1 /t http://timestamp.verisign.com/scripts/timestamp.dll %%A/Install/%%B/amd64/*.cat 
    if %ERRORLEVEL% NEQ 0 goto signfail 
  )
)

:usage
echo "Usage: %0 <key name>"
exit /b

:signfail
echo "Failed to sign something"
