#!/bin/bash
for i in bitbake meta-browser meta-clang meta-odroid meta-openembedded meta-qt5 meta-rust openembedded-core
do
	echo "Updating ${i}"
	cd ${i}
	git checkout master
	git pull --all
	cd ..
done
git add bitbake meta-browser meta-clang meta-odroid meta-openembedded meta-qt5 meta-rust openembedded-core
git commit -m "Update all submodule"
