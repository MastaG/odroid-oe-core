#!/bin/bash
git pull
for i in bitbake meta-clang meta-odroid meta-openembedded openembedded-core meta-browser meta-selinux
do
	echo "Updating ${i}"
	cd ${i}
	git checkout master
	git pull --all
	cd ..
	git add ${i}
done
git commit -m "Update all submodule"
