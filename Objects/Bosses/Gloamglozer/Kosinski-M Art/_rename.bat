@Echo off
for %%f in (*.kosm, *.kos, *.nem, *.eni) do (rename "%%f" "%%~nf.bin")
pause