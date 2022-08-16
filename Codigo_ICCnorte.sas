filename temp '/home/u61679794/trabalho/Amostra_ICCnorte.xlsx';
proc import datafile = temp
 out  = dados
 dbms=xlsx
    replace;
    getnames=YES;
run;

data dados;
set dados;
if (missing(Perfil)) then Cotas='Não';
else if (not missing(Perfil)) then Cotas='Sim';
else Cotas=.;
run;

ods graphics / reset width=598px height=452px imagemap;
ods html path='/home/u61679794/trabalho/graficos'(url=NONE) image_dpi=500;
ods graphics on /attrpriority=none imagename="genero" imagefmt=png noborder;
title 'Gráfico de barras do gênero dos entrevistados';
proc sgplot data=genero_filtrado pctlevel = group;
	vbar Gênero / group=Cotas groupdisplay=cluster seglabel;
	xaxis discreteorder=data;
	yaxis grid;
run;

proc sort data=dados out=dados; by Idade; run;

data dados1;
set dados;
if (Idade eq "Até 18 anos") then tag=1;
else if (Idade eq "19 a 24 anos") then tag=2;
else if (Idade eq "25 a 29 anos") then tag=3;
else if (Idade eq "30 a 34 anos") then tag=4;
else if (Idade eq "35 a 39 anos") then tag=5;
else if (Idade eq "40 a 44 anos") then tag=6;
else if (Idade eq "Acima de 44 anos") then tag=7;
else tag=.;
run;

proc format;
     value Idade 1="Até 18 anos"
                   2="19 a 24 anos"
                   3="25 a 29 anos"
                   4="30 a 34 anos"
                   5="35 a 39 anos"
                   6="40 a 44 anos"
                   7="Acima de 44 anos";
run;
proc sort data=dados1 out=dados1; by tag; run;

ods graphics / reset width=598px height=452px imagemap;
ods html path='/home/u61679794/trabalho/graficos'(url=NONE) image_dpi=500;
ods graphics on /attrpriority=none imagename="idade" imagefmt=png noborder;

title 'Gráfico de barras da faixa etária dos entrevistados';

proc sgplot data=dados1 pctlevel = group;
	vbar Idade / group=Cotas groupdisplay=cluster seglabel;
	xaxis discreteorder=data;
	yaxis grid;
run;

data dados2;
set dados;
if (Renda eq "Até 1 salário mínimo") then tag=1;
else if (Renda eq "1 a 2 salários mínimos") then tag=2;
else if (Renda eq "2 a 5 salários mínimos") then tag=3;
else if (Renda eq "5 a 10 salários mínimos") then tag=4;
else if (Renda eq "Mais de 10 salários mínimos") then tag=5;
else if (Renda eq "Não sei/não quero responder") then tag=6;
else tag=.;
run;

proc format;
     value Renda 1="Até 1 salário mínimo"
                   2="1 a 2 salários mínimos"
                   3="2 a 5 salários mínimos"
                   4="5 a 10 salários mínimos"
                   5="Mais de 10 salários mínimos"
                   6="Não sei/não quero responder";
run;
proc sort data=dados2 out=dados2; by tag; run;

ods graphics / reset width=598px height=452px imagemap;
ods html path='/home/u61679794/trabalho/graficos'(url=NONE) image_dpi=500;
ods graphics on /attrpriority=none imagename="renda" imagefmt=png noborder;
title 'Gráfico de barras da renda dos entrevistados';
proc sgplot data=dados2 pctlevel = group;
	vbar Renda / group=Cotas groupdisplay=cluster;
	xaxis discreteorder=data;
	yaxis grid;
run;

ods graphics / reset width=598px height=452px imagemap;
ods html path='/home/u61679794/trabalho/graficos'(url=NONE) image_dpi=500;
ods graphics on /attrpriority=none imagename="presidente" imagefmt=png noborder;

title 'Intenção de voto para presidente por uso de cotas ou não';
	PROC SGPLOT DATA = dados pctlevel = group;
	HBAR Presidente /  CATEGORYORDER=respdesc GROUP=Cotas GROUPDISPLAY=cluster CLUSTERWIDTH=0.6;
run; 

ods graphics / reset width=598px height=452px imagemap;
ods html path='/home/u61679794/trabalho/graficos'(url=NONE) image_dpi=500;
ods graphics on /attrpriority=none imagename="governador" imagefmt=png noborder;

title 'Intenção de voto para governador por uso de cotas ou não';
	PROC SGPLOT DATA = dados ;
	HBAR Governador /CATEGORYORDER=respdesc GROUP=Cotas GROUPDISPLAY=cluster CLUSTERWIDTH=0.6;
run; 

proc sql noprint;
	create table genero_filtrado as select * from dados 
		where(put('Gênero'n, $13.) NE 'Não Binário' AND put('Gênero'n, $13.) NE 
		'Outros');
run;

ods graphics / reset width=598px height=452px imagemap;
ods html path='/home/u61679794/trabalho/graficos'(url=NONE) image_dpi=500;
ods graphics on /attrpriority=none imagename="pres_genero_cotas" imagefmt=png noborder;

title 'Intenção de voto para presidente segundo gênero e uso de cotas';
	PROC SGPANEL DATA = genero_filtrado ; PANELBY Gênero / novarname onepanel ;
	HBAR Presidente / CATEGORYORDER=respdesc GROUP=Cotas GROUPDISPLAY=cluster CLUSTERWIDTH=0.6;
run; 

ods graphics / reset width=598px height=452px imagemap;
ods html path='/home/u61679794/trabalho/graficos'(url=NONE) image_dpi=500;
ods graphics on /attrpriority=none imagename="gov_genero_cotas" imagefmt=png noborder;

title 'Intenção de voto para governador segundo gênero e uso de cotas';
	PROC SGPANEL DATA = genero_filtrado pctlevel = group; PANELBY Gênero / novarname onepanel ;
	HBAR Governador / CATEGORYORDER=respdesc GROUP=Cotas GROUPDISPLAY=cluster CLUSTERWIDTH=0.6;
run; 

ods graphics / reset width=598px height=452px imagemap;
ods html path='/home/u61679794/trabalho/graficos'(url=NONE) image_dpi=500;
ods graphics on /attrpriority=none imagename="pres_renda_cotas" imagefmt=png noborder;

title 'Intenção de voto para presidente segundo renda e uso de cotas';
	PROC SGPANEL DATA = dados2 ;format tag Renda.; PANELBY tag / novarname onepanel ;
	HBAR Presidente /  CATEGORYORDER=respdesc GROUP=Cotas GROUPDISPLAY=cluster;
run;

ods graphics / reset width=598px height=452px imagemap;
ods html path='/home/u61679794/trabalho/graficos'(url=NONE) image_dpi=500;
ods graphics on /attrpriority=none imagename="gov_renda_cotas" imagefmt=png noborder;

title 'Intenção de voto para governador segundo renda e uso de cotas';
	PROC SGPANEL DATA = dados2 pctlevel = group ;format tag Renda.; PANELBY tag / novarname onepanel ;
	HBAR Governador /  CATEGORYORDER=respdesc GROUP=Cotas GROUPDISPLAY=cluster;
run;

ods graphics / reset width=598px height=452px imagemap;
ods html path='/home/u61679794/trabalho/graficos'(url=NONE) image_dpi=500;
ods graphics on /attrpriority=none imagename="pres_idade_cotas" imagefmt=png noborder;

title 'Intenção de voto para presidente segundo faixa etária e uso de cotas';
	PROC SGPANEL DATA = dados1 ;format tag Idade.; PANELBY tag / novarname onepanel ;
	HBAR Presidente /  CATEGORYORDER=respdesc GROUP=Cotas GROUPDISPLAY=cluster;
run;

ods graphics / reset width=598px height=452px imagemap;
ods html path='/home/u61679794/trabalho/graficos'(url=NONE) image_dpi=500;
ods graphics on /attrpriority=none imagename="gov_idade_cotas" imagefmt=png noborder;

title 'Intenção de voto para governador segundo faixa etária e uso de cotas';
	PROC SGPANEL DATA = dados1 pctlevel = group ;format tag Idade.; PANELBY tag / novarname onepanel ;
	HBAR Governador /  CATEGORYORDER=respdesc GROUP=Cotas GROUPDISPLAY=cluster;
run;


ods graphics off;
ods html close;

/* Testes para AAs */
proc sql noprint;
	create table amostra_simples as select * from genero_filtrado where(Cotas EQ 'Não');
quit;

PROC FREQ DATA= amostra_simples Order=FREQ;
TABLES Presidente*Gênero / CHISQ NOROW NOPERCENT OUT=PRES_GEN OUTPCT;
TABLES Governador*Gênero / CHISQ NOROW NOPERCENT OUT=GOV_GEN OUTPCT;
run;

PROC FREQ DATA= amostra_simples Order=FREQ;
TABLES Presidente*Idade / CHISQ NOROW NOPERCENT OUT=PRES_IDADE OUTPCT;
TABLES Governador*Idade / CHISQ NOROW NOPERCENT OUT=GOV_IDADE OUTPCT;
run;

PROC PRINT DATA= PRES_IDADE;
run;

PROC FREQ DATA= amostra_simples Order=FREQ;
TABLES Presidente*Renda / CHISQ NOROW NOPERCENT OUT=PRES_RENDA OUTPCT;
TABLES Governador*Renda / CHISQ NOROW NOPERCENT OUT=GOV_RENDA OUTPCT;
run;

/* Testes para Amostra Extratificada */
proc sql noprint;
	create table amostra_extratifica as select * from genero_filtrado where(Cotas EQ 'Sim');
quit;

PROC FREQ DATA= amostra_extratifica Order=FREQ;
TABLES Presidente*Gênero / CHISQ NOROW NOPERCENT OUT=PRES OUTPCT;
TABLES Governador*Gênero / CHISQ NOROW NOPERCENT OUT=GOV OUTPCT;
run;

PROC FREQ DATA= amostra_extratifica Order=FREQ;
TABLES Presidente*Idade / CHISQ NOROW NOPERCENT OUT=PRES OUTPCT;
TABLES Governador*Idade / CHISQ NOROW NOPERCENT OUT=GOV OUTPCT;
run;

PROC FREQ DATA= amostra_extratifica Order=FREQ;
TABLES Presidente*Renda / CHISQ NOROW NOPERCENT OUT=PRES OUTPCT;
TABLES Governador*Renda / CHISQ NOROW NOPERCENT OUT=GOV OUTPCT;
run;


/* Calculo dos Intervalos de confiança */
PROC FREQ DATA= dados Order=FREQ;
TABLES Presidente*Cotas / CHISQ NOROW NOPERCENT OUT=PRES OUTPCT;
TABLES Governador*Cotas / CHISQ NOROW NOPERCENT OUT=GOV OUTPCT;
run;	

DATA PRES_IC; set PRES (drop= COUNT PERCENT PCT_ROW);
E=1.96*SQRT(PCT_COL*(100-PCT_COL)/443);
lim_inf = PCT_COL-E;
lim_sup = PCT_COL+E;
IF lim_inf <0 then lim_inf = 0;
run;

DATA GOV_IC; set GOV (drop= COUNT PERCENT PCT_ROW);
E=1.96*SQRT(PCT_COL*(100-PCT_COL)/443);
lim_inf = PCT_COL-E;
lim_sup = PCT_COL+E;
IF lim_inf <0 then lim_inf = 0;
run;

PROC SORT DATA=PRES_IC;
by COTAS;
run;

PROC SORT DATA=GOV_IC;
by COTAS;
run;





