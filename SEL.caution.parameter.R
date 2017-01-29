SEL.caution.parameter<- function (x1,x2) {
  
  equalLen <- length(x1) != length(x2)
  if(equalLen){
    stop("Vectors must be of equal length.")
  }

  for(i in 1:length(x1)){
    lfdrOutOfBounds <- (x1[i] < 0 || x1[i] > 1)||(x2[i] < 0 || x2[i] > 1)
    
    if(lfdrOutOfBounds){
      stop("Each index in vector x1 or x2 must contain a value between 0
           and 1.")
    }
  }

  x <- cbind(x1,x2)
  infx <- rowMaxs(x)
  supx <- rowMins(x)
  CG1 <- CG0.5 <- c()
  
  for (i in 1: length(x1)){
    if (supx[i] <= 0.5){
      CGM1SEL <- 1-supx[i]
      CGM0.5SEL <- 1-infx[i]
    }else if (infx[i] > 0.5){
      CGM1SEL <- 1-infx[i]
      CGM0.5SEL <- 1-supx[i]
    }else {
      CGM1SEL <- 0.5
      k <- infx[i]+supx[i]
      
      ifelse(k <= 1, CGM0.5SEL <- 1-infx[i], CGM0.5SEL <- 1-supx[i])
    }
    CG1 <- c(CG1, CGM1SEL)
    CG0.5 <- c(CG0.5, CGM0.5SEL)
  }
  
  CG0 <- 1-(x1+x2)/2
  return(list(CGM1SEL = CG1, CGM0SEL = CG0, CGM0.5SEL = CG0.5))
}
