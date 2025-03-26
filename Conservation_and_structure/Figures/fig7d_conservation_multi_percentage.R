
# install.packages("rstatix ")
# install.packages("ggpubr")
setwd("~/Google Drive2/Etudiants_Encadrement/2022_JC_Mouren/Benoit/3.analyses/conservation_odom")



df=read.table("conservation_odom_percentage2.tsv", row.names=1, header=TRUE)
m = as.matrix(df)



plot(df$EE, ylim=c(0,60), pch=19, col="red", xaxt="n", ylab="Percent shared with Hsap")
points(df$CRMs, pch=1)
points(df$CtrlNeg, pch=19, col="grey")
points(df$CtrlPos, pch=19, col="green")
points(df$Pairwise, pch=8, col="red")
axis(1, at=c(1,2,3,4), labels=row.names(df), lty=2)
legend("topright", inset =.02, legend=c("EE", "CRMs (Ballester et al.)", "Ctrl-","Ctrl+", "Pairwise"),
       col=c("red", "black", "grey","green","red"), pch=c(19,1,19,19,8), box.lty=0 ) 

#-----PLOT------ 
pdf("conservation_odom_percentage2.pdf", height = 5, width = 5)
plot(df$EE, ylim=c(0,60), pch=19, col="red", xaxt="n", ylab="Percent shared with Hsap")
points(df$CRMs, pch=1)
points(df$CtrlNeg, pch=19, col="grey")
points(df$CtrlPos, pch=19, col="green")
points(df$Pairwise, pch=8, col="red")
axis(1, at=c(1,2,3,4), labels=row.names(df), lty=2)
legend("topright", inset =.02, legend=c("EE", "CRMs (Ballester et al.)", "Ctrl-","Ctrl+", "Pairwise"),
       col=c("red", "black", "grey","green","red"), pch=c(19,1,19,19,8), box.lty=0 )
dev.off()
