#!/bin/bash
git pull
for i in bitbake meta-browser meta-odroid meta-openembedded meta-qt5 meta-rust openembedded-core
do
	echo "Updating ${i}"
	cd ${i}
	git checkout master
	git pull --all
	cd ..
	git add ${i}
done
git commit -m "Update all submodule"
cd meta-clang
git fetch upstream
git merge --commit upstream/master
