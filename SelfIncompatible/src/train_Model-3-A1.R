source("src/Functions.R")

# Arguments
args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile1 <- args[2]
outfile2 <- args[3]

# Loading
load(infile)

# Parameter
r1 <- 3
r3 <- 4

params <- new("CoupledMWCAParams",
    # Data-wise setting
    Xs=list(X1=LRTensor),
    mask=list(X1=NULL),
    weights=list(X1=1),
    # Common Factor Matrices
    common_model=list(X1=list(I1="A1", I2="A2", I3="A3")),
    common_initial=list(A1=NULL, A2=NULL, A3=NULL),
    common_algorithms=list(A1="mySVD", A2="mySVD", A3="mySVD"),
    common_iteration=list(A1=30, A2=0, A3=30),
    common_decomp=list(A1=TRUE, A2=FALSE, A3=TRUE),
    common_fix=list(A1=FALSE, A2=FALSE, A3=FALSE),
    common_dims=list(A1=r1, A2=dim(LRTensor)[2], A3=r3),
    common_transpose=list(A1=FALSE, A2=FALSE, A3=FALSE),
    common_coretype="Tucker",
    # Other option
    specific=FALSE,
    thr=1e-10,
    viz=FALSE,
    verbose=TRUE)

# Tensor Decomposition
res <- CoupledMWCA(params)

# Reshape
X <- t(res@common_factors$A1)

# Save
save(res, file=outfile1)
write.csv(X, file=outfile2)
