source("src/Functions.R")
# Parameter
infile <- commandArgs(trailingOnly=TRUE)[1]
outfile <- commandArgs(trailingOnly=TRUE)[2]
trials <- as.numeric(commandArgs(trailingOnly=TRUE)[3])
r <- as.numeric(commandArgs(trailingOnly=TRUE)[4])
k <- as.numeric(commandArgs(trailingOnly=TRUE)[5])
K <- as.numeric(commandArgs(trailingOnly=TRUE)[6])

# Loading
load(infile)

# Mask Tensor
Ms <- kFoldMaskTensor(X, k=K, avoid.zero=TRUE, seeds=123)
M <- Ms[[k]]

# NTF
# Generated NaN sometimes, if the rank is not optimal
outList <- list()
for(i in seq(trials)){
	print(i)
	# Generated NaN sometimes, if the rank is not optimal
	count <- 1
	tmp <- try(1 + "1")
	while((class(tmp) == "try-error") && (count <= 10)){
		tmp <- try(NTF(X=X, M=M, rank=r, algorithm="KL",
			init="Random", num.iter=20, L2_A=1e-5))
		count <- count + 1
	}
	if(class(tmp) == "try-error"){
		stop("Unstable Rank Parameter!!!")
	}
	outList[[i]] <- tmp
}
error <- unlist(lapply(outList, function(x){
	rev(x$RecError)[1]
}))
target <- which(error == min(error))[1]
out <- outList[[target]]

# Output
save(out, file=outfile)
