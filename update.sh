#!/bin/bash
git pull
for i in meta-clang meta-odroid meta-openembedded meta-qt5 meta-rust openembedded-core
do
	echo "Updating ${i}"
	cd ${i}
	git checkout sumo
	git pull --all
	cd ..
	git add ${i}
done
for i in meta-browser
do
	echo echo "Updating ${i}"
	cd ${i}
	git checkout master
	git pull --all
	cd ..
	git add ${i}
done
git commit -m "Update all submodules"
