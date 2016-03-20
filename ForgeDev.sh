#!/bin/bash

function all(){
	read -r -p "Forge Run folder: " forgerun
	read -r -p "Mod(s): " arr
	cd $forgerun
	echo -e "\n############################"
	echo Updating $forgerun
	echo -e "############################" 
	echo -e "\n############################"
	echo Updating build.gradle
	sed -i '28 s|.*|version = "1.9-'$ver'-1.9"|' build.gradle
	echo -e "############################\n" 
	bash gradlew setupDecompWorkspace

	for a in ${arr[@]}
	do 
	echo -e "\n############################"
	echo Updating $a
	echo -e "############################" 
	cd ../$a
	echo -e "\n############################"
	echo Updating build.gradle
	sed -i '28 s|.*|version = "1.9-'$ver'-1.9"|' build.gradle
	echo -e "############################\n" 
	bash gradlew setupDecompWorkspace
	done
}

function single(){
	read -r -p "Mod: " arr
	cd $arr
	echo -e "\n############################"
	echo Updating $arr
	echo -e "############################" 
	
	echo -e "\n############################"
	echo Updating build.gradle
	sed -i '28 s|.*|version = "1.9-'$ver'-1.9"|' build.gradle
	echo -e "############################\n" 
	bash gradlew setupDecompWorkspace
}

function setup(){
	read -r -p "Mod: " dir
	read -r -p "Packet name: " name
	if [[ ! -e $dir ]]; then
		echo -e "\n############################"
		echo Creating $dir
		mkdir $dir
		echo -e "############################" 
		cp -r blankforgeproject/* $dir
		cd $dir
		
		lower=${dir,,}
		
		echo -e "\n############################"
		echo Updating build.gradle
		sed -i '28 s|.*|version = "1.9-'$ver'-1.9"|' build.gradle
		sed -i '24 s|group= "com.yourname.modid"|group= "com.'$name'.'$lower'"|' build.gradle
		sed -i '25 s|archivesBaseName = "modid"|archivesBaseName = "'$lower'"|' build.gradle
		echo -e "############################" 
		
		echo -e "\n############################"
		echo Injecting build.gradle
		echo "jar {
}

task deobfJar(type: Jar) {
    from sourceSets.main.output
    classifier = 'deobf'
}

build.dependsOn deobfJar" >> build.gradle
		echo -e "############################" 
		
		echo -e "\n############################"
		echo Creating packet directory
		mkdir -p src/main/java/com/$name/$lower
		mkdir -p src/main/resources/$name/$lower/{blockstates,lang,models,textures/{blocks,items,misc}}
		echo -e "############################\n" 
		
		bash gradlew setupDecompWorkspace
		echo "${dir,,}"
	elif [[ ! -d $dir ]]; then
		echo "$dir already exists" 1>&2
	fi
	
}

function update(){
read -r -p "Do you want to update all mods and forge run? [y/n] " input
case $input in
        yes|Yes|y)
                all
                ;;
        no|n)
                single
                ;;
esac
}

read -r -p "Forge Version: " ver
read -r -p "Do you want to setup a new mod? [y/n] " setu
case $setu in
        yes|Yes|y)
                setup
                ;;
        no|n)
                update
                ;;
esac



echo -e "\n\nDone... Now safe to close"
sleep 1
echo "Auto Closing in 5 sec"
sleep 1
echo "Auto Closing in 4 sec"
sleep 1
echo "Auto Closing in 3 sec"
sleep 1
echo "Auto Closing in 2 sec"
sleep 1
echo "Auto Closing in 1 sec"
sleep 1