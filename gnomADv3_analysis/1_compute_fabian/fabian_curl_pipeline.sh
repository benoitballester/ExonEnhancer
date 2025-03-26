read -r input_string

printf "($(date +%T)) Submitting " && \
FABIANID=$( curl -sLD - -o /dev/null \
-F "mode=vcf" \
-F "filename=@$1" \
-F "genome=hg38" \
-F "tfs_filter=names" \
-F "tfs_filter_names_tb=$input_string" \
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

# -F "models_filter=pwm" \

#do the same with enhd_fabian

unzip -qq fabian.$1_${FABIANID}.zip -d /home/mouren/Data/variants/fabian/fabian_pipeline/tmp
mv /home/mouren/Data/variants/fabian/fabian_pipeline/tmp/fabian.data /home/mouren/Data/variants/fabian/fabian_pipeline/fabian_result/$1_fabian_result.tsv
rm fabian.$1_${FABIANID}.zip
