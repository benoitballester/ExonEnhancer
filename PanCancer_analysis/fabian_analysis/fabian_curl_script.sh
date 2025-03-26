printf "($(date +%T)) Submitting " && \
FABIANID=$( curl -sLD - -o /dev/null \
-F "mode=vcf" \
-F "filename=@$1" \
-F "genome=hg19" \
-F "tfs_filter=all" \
-F "models_filter=tffm_d" \
-F "models_filter=tffm_fo" \
-F "dbs_filter=jaspar2022" \
-F "dbs_filter=cisbp_1.02" \
-F "dbs_filter=HOCOMOCOv11" \
-F "dbs_filter=hPDI" \
-F "dbs_filter=jolma2013" \
-F "dbs_filter=SwissRegulon" \
-F "dbs_filter=UniPROBE" \
https://www.genecascade.org/fabian/analyse.cgi \
| grep -m 1 "Location: " | grep -o "\([0-9]\+_[0-9]\+\)" ) && \
i=1; until curl -sfo fabian.$1_${FABIANID}.zip \
https://www.genecascade.org/temp/QE/FABIAN/${FABIANID}/fabian.data.zip; \
do printf "\r($(date +%T)) Waiting for $FABIANID"; \
[ $i == 30 ] && sleep $i || sleep $((i++)); done && \
printf "\r($(date +%T)) Saved file fabian.$1_${FABIANID}.zip\n"

unzip -qq fabian.$1_${FABIANID}.zip -d /home/mouren/Data/variants/tcga_MC3/fabian/result
mv /home/mouren/Data/variants/tcga_MC3/fabian/result/fabian.data /home/mouren/Data/variants/tcga_MC3/fabian/fabian/result/$1_fabian_result.tsv
rm fabian.$1_${FABIANID}.zip
