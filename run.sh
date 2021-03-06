#!/bin/bash

###################################  passo 1 #################################################
#passagem do passo 1 para forma fst
python compact2fst.py 1_s-z.txt > ugly-1_s-z.txt
python compact2fst.py 1_x-s.txt > ugly-1_x-s.txt
python compact2fst.py 1_x-z.txt > ugly-1_x-z.txt

#compilacao dos mini passos para formato fst
fstcompile --isymbols=syms.txt --osymbols=syms.txt ugly-1_s-z.txt | fstarcsort > 1_s-z.fst
fstcompile --isymbols=syms.txt --osymbols=syms.txt ugly-1_x-s.txt | fstarcsort > 1_x-s.fst
fstcompile --isymbols=syms.txt --osymbols=syms.txt ugly-1_x-z.txt | fstarcsort > 1_x-z.fst

#compose dos fsts do passo 1#
fstcompose 1_s-z.fst 1_x-s.fst > 1_aux1.fst
fstcompose 1_aux1.fst 1_x-z.fst > passo1.fst

###################################  passo 2 ##################################################
#passagem do passo 2 para forma fst
python compact2fst.py 2_ch-x.txt > ugly-2_ch-x.txt
python compact2fst.py 2_lh-2.txt > ugly-2_lh-2.txt
python compact2fst.py 2_nh-3.txt > ugly-2_nh-3.txt
python compact2fst.py 2_rr-4.txt > ugly-2_rr-4.txt
python compact2fst.py 2_ss-s.txt > ugly-2_ss-s.txt

#compilacao dos mini passos para formato fst
fstcompile --isymbols=syms.txt --osymbols=syms.txt ugly-2_ch-x.txt | fstarcsort > 2_ch-x.fst
fstcompile --isymbols=syms.txt --osymbols=syms.txt ugly-2_lh-2.txt | fstarcsort > 2_lh-2.fst
fstcompile --isymbols=syms.txt --osymbols=syms.txt ugly-2_nh-3.txt | fstarcsort > 2_nh-3.fst
fstcompile --isymbols=syms.txt --osymbols=syms.txt ugly-2_rr-4.txt | fstarcsort > 2_rr-4.fst
fstcompile --isymbols=syms.txt --osymbols=syms.txt ugly-2_ss-s.txt | fstarcsort > 2_ss-s.fst

#compose dos fsts do passo 2#
fstcompose 2_ch-x.fst 2_lh-2.fst > 2_aux1.fst
fstcompose 2_aux1.fst 2_nh-3.fst > 2_aux2.fst
fstcompose 2_aux2.fst 2_rr-4.fst > 2_aux3.fst
fstcompose 2_aux3.fst 2_ss-s.fst > passo2.fst

###################################  passo 3 ##################################################
#passagem do passo 3 para forma fst
python compact2fst.py 3_c-s.txt > ugly-3_c-s.txt
python compact2fst.py 3_g-j.txt > ugly-3_g-j.txt
python compact2fst.py 3_h-0.txt > ugly-3_h-0.txt
python compact2fst.py 3_q-k.txt > ugly-3_q-k.txt
python compact2fst.py 3_r-4.txt > ugly-3_r-4.txt
python compact2fst.py 3_x-ks.txt > ugly-3_x-ks.txt
python compact2fst.py 3_z-s.txt > ugly-3_z-s.txt

#compilacao dos mini passos para formato fst
fstcompile --isymbols=syms.txt --osymbols=syms.txt ugly-3_c-s.txt | fstarcsort > 3_c-s.fst
fstcompile --isymbols=syms.txt --osymbols=syms.txt ugly-3_g-j.txt | fstarcsort > 3_g-j.fst
fstcompile --isymbols=syms.txt --osymbols=syms.txt ugly-3_h-0.txt | fstarcsort > 3_h-0.fst
fstcompile --isymbols=syms.txt --osymbols=syms.txt ugly-3_q-k.txt | fstarcsort > 3_q-k.fst
fstcompile --isymbols=syms.txt --osymbols=syms.txt ugly-3_r-4.txt | fstarcsort > 3_r-4.fst
fstcompile --isymbols=syms.txt --osymbols=syms.txt ugly-3_x-ks.txt | fstarcsort > 3_x-ks.fst
fstcompile --isymbols=syms.txt --osymbols=syms.txt ugly-3_z-s.txt | fstarcsort > 3_z-s.fst

#compose dos fsts do passo 3#
fstcompose 3_c-s.fst 3_g-j.fst > 3_aux1.fst
fstcompose 3_aux1.fst 3_h-0.fst > 3_aux2.fst
fstcompose 3_aux2.fst 3_q-k.fst > 3_aux3.fst
fstcompose 3_aux3.fst 3_r-4.fst > 3_aux4.fst
fstcompose 3_aux4.fst 3_x-ks.fst > 3_aux5.fst
fstcompose 3_aux5.fst 3_z-s.fst > passo3.fst

###################################  passo 4 ##################################################
python compact2fst.py 4_vogais.txt > ugly-4_vogais.txt
fstcompile --isymbols=syms.txt --osymbols=syms.txt ugly-4_vogais.txt | fstarcsort > passo4.fst


# compose final (passo 1 2 3 e 4) #
fstcompose passo1.fst passo2.fst > final1.fst
fstcompose final1.fst passo3.fst > final2.fst
fstcompose final2.fst passo4.fst > transdutorFinal.fst

#Teste para diferentes nomes
for i in rei carvalho dziergwa mamede coheur nuno luisa; do
	python word2fst.py $i > w-$i.txt
	fstcompile --isymbols=syms.txt --osymbols=syms.txt w-$i.txt | fstarcsort > w-$i.fst
	fstcompose w-$i.fst transdutorFinal.fst | fstproject --project_output | fstrmepsilon > $i.fst
	fstdraw --isymbols=syms.txt --osymbols=syms.txt -portrait $i.fst | dot -Tpdf > $i.pdf
done


