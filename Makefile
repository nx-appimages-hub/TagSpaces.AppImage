# Copyright 2020 Alex Woroschilow (alex.woroschilow@gmail.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
PWD:=$(shell pwd)


all: clean

	mkdir 	--parents $(PWD)/build/Boilerplate.AppDir/tagspaces
	apprepo --destination=$(PWD)/build appdir boilerplate libatk1.0-0 libatk-bridge2.0-0 libgtk-3-0 libffi7
	echo '' 																		>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' 																		>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'LD_LIBRARY_PATH=$${LD_LIBRARY_PATH}:$${APPDIR}/tagspaces' 				>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'export LD_LIBRARY_PATH=$${LD_LIBRARY_PATH}' 								>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' 																		>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' 																		>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'UUC_VALUE=`cat /proc/sys/kernel/unprivileged_userns_clone 2> /dev/null`' 	>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo ''										 									>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' 																		>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' 																		>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'if [ -z "$${UUC_VALUE}" ]' 												>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '    then' 																>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '        exec $${APPDIR}/tagspaces/tagspaces --no-sandbox "$${@}"' 		>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '    else' 																>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '        exec $${APPDIR}/tagspaces/tagspaces "$${@}"' 						>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '    fi' 																	>> $(PWD)/build/Boilerplate.AppDir/AppRun

	wget --output-document=$(PWD)/build/TagSpaces.AppImage "https://www.tagspaces.org/downloads/tagspaces-linux64.AppImage"
	chmod +x $(PWD)/build/TagSpaces.AppImage
	cd $(PWD)/build && $(PWD)/build/TagSpaces.AppImage --appimage-extract
	
	cp --force --recursive 	$(PWD)/build/squashfs-root/usr/share/* 		$(PWD)/build/Boilerplate.AppDir/share
	cp --force --recursive 	$(PWD)/build/squashfs-root/usr/lib/* 		$(PWD)/build/Boilerplate.AppDir/lib64	
	cp --force --recursive 	$(PWD)/build/squashfs-root/* 				$(PWD)/build/Boilerplate.AppDir/tagspaces

	rm -rf $(PWD)/build/Boilerplate.AppDir/tagspaces/usr
	rm -rf $(PWD)/build/Boilerplate.AppDir/tagspaces/AppRun 		| true	
	rm -rf $(PWD)/build/Boilerplate.AppDir/tagspaces/*.desktop 		| true	
	rm -rf $(PWD)/build/Boilerplate.AppDir/tagspaces/*.svg 			| true	
	rm -rf $(PWD)/build/Boilerplate.AppDir/tagspaces/*.png 			| true		
	rm -rf $(PWD)/build/Boilerplate.AppDir/*.desktop 				| true
	rm -rf $(PWD)/build/Boilerplate.AppDir/*.svg 					| true
	rm -rf $(PWD)/build/Boilerplate.AppDir/*.png 					| true

	cp --force --recursive $(PWD)/AppDir/*.desktop 	$(PWD)/build/Boilerplate.AppDir 	| true
	cp --force --recursive $(PWD)/AppDir/*.svg 		$(PWD)/build/Boilerplate.AppDir 	| true
	cp --force --recursive $(PWD)/AppDir/*.png 		$(PWD)/build/Boilerplate.AppDir 	| true

	export ARCH=x86_64 && $(PWD)/bin/appimagetool.AppImage $(PWD)/build/Boilerplate.AppDir $(PWD)/TagSpaces.AppImage
	chmod +x $(PWD)/TagSpaces.AppImage

clean:
	rm -rf $(PWD)/build

