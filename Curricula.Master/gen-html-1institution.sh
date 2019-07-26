#!/bin/csh
# DEPRECATED !!!! it is already contained inside compile1institution.sh

date > out/time-DS-UTEC.txt
#--BEGIN-FILTERS--
set institution=UTEC
setenv CC_Institution UTEC
set filter=UTEC
setenv CC_Filter UTEC
set version=final
setenv CC_Version final
set area=DS
setenv CC_Area DS
set CurriculaParam=DS-UTEC
#--END-FILTERS--
set curriculamain=curricula-main
setenv CC_Main $curriculamain
set current_dir = `pwd`
set UnifiedMain=unified-curricula-main
#set UnifiedMain = `echo $FullUnifiedMainFile | sed s/.tex//`

set Country=Peru
set OutputTexDir=../Curricula.out/Peru/DS-UTEC/cycle/2020-I/Plan2020/tex
set OutputHtmlDir=../Curricula.out/html/Peru/DS-UTEC/Plan2020
set OutputScriptsDir=../Curricula.out/Peru/DS-UTEC/cycle/2020-I/Plan2020/scripts

./scripts/process-curricula.pl DS-UTEC
../Curricula.out/Peru/DS-UTEC/cycle/2020-I/Plan2020/scripts/gen-eps-files.sh DS UTEC Peru Espanol
./scripts/update-page-numbers.pl DS-UTEC 
./scripts/gen-graph.sh DS UTEC Peru Espanol big
rm unified-curricula-main* 
./scripts/gen-html-main.pl DS-UTEC

latex unified-curricula-main
bibtex unified-curricula-main
latex unified-curricula-main
latex unified-curricula-main

dvips -o unified-curricula-main.ps unified-curricula-main.dvi
ps2pdf unified-curricula-main.ps unified-curricula-main.pdf
rm unified-curricula-main.ps unified-curricula-main.dvi

rm -rf ../Curricula.out/html/Peru/DS-UTEC/Plan2020
mkdir -p ../Curricula.out/html/Peru/DS-UTEC/Plan2020
mkdir ../Curricula.out/html/Peru/DS-UTEC/Plan2020/figs
cp ./in/lang.Espanol/figs/pdf.jpeg cp ./in/lang.Espanol/figs/star.gif cp ./in/lang.Espanol/figs/none.gif ../Curricula.out/html/Peru/DS-UTEC/Plan2020/figs/.

latex2html \
-t "Curricula DS-UTEC" \
-dir "../Curricula.out/html/Peru/DS-UTEC/Plan2020/" -mkdir \
-toc_stars -local_icons -show_section_numbers \
-address "Generado por <A HREF='http://socios.spc.org.pe/ecuadros/'>Ernesto Cuadros-Vargas</A> <ecuadros AT spc.org.pe>,               <A HREF='http://www.spc.org.pe/'>Sociedad Peruana de Computaci&oacute;n-Peru</A>,               <A HREF='http://www.utec.edu.pe/'>Universidad de Ingenier&iacute;a y Tecnolog&iacute;a, Lima-Per&uacute;</A><BR>              basado en el modelo de la Computing Curricula de               <A HREF='http://www.computer.org/'>IEEE-CS</A>/<A HREF='http://www.acm.org/'>ACM</A>" \
unified-curricula-main
#-split 3 -numbered_footnotes -images_only -timing -html_version latin1 \

./scripts/update-analytic-info.pl DS-UTEC

#../Curricula.out/Peru/DS-UTEC/cycle/2020-I/Plan2020/tex/scripts/gen-syllabi.sh
mkdir ../Curricula.out/html/Peru/DS-UTEC/Plan2020/syllabi
cp ../Curricula.out/Peru/DS-UTEC/cycle/2020-I/Plan2020/tex/syllabi/* ../Curricula.out/html/Peru/DS-UTEC/Plan2020/syllabi/*

#Redundant withcompile1institution
# ./scripts/$area-$institution-gen-silabos

beep
beep

