@echo off
setlocal EnableDelayedExpansion

if not exist "%waifu2x_path%\waifu2x-caffe-cui.exe" (
	echo Error. Can not find waifu2x
) else (
	set /p f_path="Enter path to folder containing video files. Leave blank if they are in current folder (Example: D:\videos): "
	if [!f_path!]==[] set "f_path=%~dp0"
	cd "!f_path!"
	set "cur_path=%~dp0"
	
	:inpext
	set /p ext="Enter the extension of video files (Example: mp4): "
	if [!ext!]==[] goto :inpext

	:inpres
	echo.
	echo Resolutions:
	echo 1.    144p    176x144
	echo 2.    240p    320x240
	echo 3.    360p    480x360
	echo 4.    480p    640x480
	echo 5.    720p    1280x720
	echo 6.    1080p   1920x1080
	echo 7.    4K      3840x2160
	echo 8.    8K      7680x4320
	set /p res="Select a resolution (Example: 1): "

	if [!res!]==[1] (
		set "w=176"
		set "h=144"
	) else if [!res!]==[2] (
		set "w=320"
		set "h=240"
	) else if [!res!]==[3] (
		set "w=480"
		set "h=360"
	) else if [!res!]==[4] (
		set "w=640"
		set "h=480"
	) else if [!res!]==[5] (
		set "w=1280"
		set "h=720"
	) else if [!res!]==[6] (
		set "w=1920"
		set "h=1080"
	) else if [!res!]==[7] (
		set "w=3840"
		set "h=2160"
	) else if [!res!]==[8] (
		set "w=7680"
		set "h=4320"
	) else (
		echo Wrong Input. Try again.
		goto :inpres
	)
	echo Your selected resolution is !w!x!h!
	echo.

	if exist "*.!ext!" (
		if not exist "temp" mkdir temp > nul
		if not exist "temp" (
			echo Error. Unable to create temp folder for prcessing.
		) else (
			for /r %%i in ("*.!ext!") do (
				if not exist "temp" mkdir temp > nul
				del /q temp\*.* > nul

				rem Extracting frames and audio
				echo Extracting frames from %%~nxi
				ffmpeg -y -threads 4 -i "%%i" -loglevel -8 temp\%%d_frame.png > nul
				echo Extracting audio from %%~nxi
				ffmpeg -y -i "%%i" -loglevel -8 -vn -acodec copy temp\audio.aac > nul
				ffprobe -v error -select_streams v:0 -show_entries stream=avg_frame_rate -of default=noprint_wrappers=1:nokey=1 "%%i" > temp\fps.txt
				cd temp
				set /p fps=<fps.txt
				del /q fps.txt > nul
				cd ..
				echo Frame rate is: !fps!

				echo.
				rem Converting frames:
				if exist "temp\*frame.png" (
					rem Count total extracted frames:
					set cnt=0
					for %%k in (temp\*frame.png) do set /a cnt+=1

					echo Total frames counted: !cnt!

					rem Main process in conversion:
					cd temp
					echo.
					set cnvrtd=0
					mkdir converted
					for /r %%j in ("*frame.png") do (
						"%waifu2x_path%\waifu2x-caffe-cui.exe" -n 3 -w !w! -h !h! -i "%%j" -o converted\%%~nj_CONVERTED.png > nul
						del /q "%%j" > nul
						set /a cnvrtd+=1
						echo Converted frame: !cnvrtd! of !cnt!
					)
					
					move "converted\*" ".\" > nul
					rmdir converted
					cd ..
					
					rem Combining frames and audio to new video
					echo.
					if not exist "output" mkdir output
					echo Generating %%~ni_CONV.mp4 in output folder
					if not exist "temp\audio.aac" (
						ffmpeg -y -r !fps! -s !w!x!h! -i temp\%%d_frame_CONVERTED.png -loglevel -8 -vcodec libx264 "output\%%~ni_CONV.mkv" > nul
					) else (
						ffmpeg -y -r !fps! -s !w!x!h! -i temp\%%d_frame_CONVERTED.png -i temp\audio.aac -loglevel -8 -vcodec libx264 -acodec copy "output\%%~ni_CONV.mkv" > nul
					)
				) else echo Error. Unable to find frames
			)
		)
	) else echo Unable to find any file with extension: !ext!

	if exist "temp" rmdir /s /q temp > nul
	cd "!cur_path!"
)

echo.
echo Done
pause > nul