caution.parameter.actions<- function (x1,x2,l1=4,l2=1) {
   # l1 and l2 are our definition of the loss values. Take l1=4 and l2=1
   # x1 and x2 are vectors of two different reference classes 
    
   threshold <- l2/(l1+l2)      # threshold for deriving the Bayes actions

   equalLen <- length(x1) != length(x2)
   lossValNegative <- (l1 <= 0) || (l2 <= 0)
   
   if(equalLen){
      stop("Error: Vectors must be of equal length.")
   }

   if(lossValNegative){
      stop("Error: Loss values must be greater than 0.")
   }

   for(i in 1:length(x1)){
      lfdrOutOfBounds <- (x1[i] < 0 || x1[i] > 1)||(x2[i] < 0 || x2[i] > 1)
      
      if(lfdrOutOfBounds){
         stop("Error: Each index in vector x1 or x2 must contain a value 
              between 0 and 1.")
      }
   } 

   x <- cbind(x1,x2)
   infx <- rowMins(x)          # infimum of LFDRs for each variant
   supx <- rowMaxs(x)          # supremum of LFDRs for each variant
   l <- length(infx)
   CG1 <- CG0 <- CG0.5 <- c()
  
   for (i in 1:l){
      
      CGM1Case <- l1*supx[i] <= l2*(1-infx[i])
      CGM0Case <- l1*infx[i] <= l2*(1-supx[i])
      CGMHalfCase <- l1*(supx[i]+infx[i]) <= l2*(2-supx[i]-infx[i])
           
      ifelse(CGM1Case, CGM1ZeroOne <- 1, CGM1ZeroOne <- 0)
      ifelse(CGM0Case, CGM0ZeroOne <- 1, CGM0ZeroOne <- 0)
      ifelse(CGMHalfCase, CGM0.5ZeroOne <- 1, CGM0.5ZeroOne <- 0)
      
      CG1 <- c(CG1,CGM1ZeroOne)
      CG0 <- c(CG0,CGM0ZeroOne)
      CG0.5 <- c(CG0.5,CGM0.5ZeroOne)
   }

   cat("\nThreshold: ", threshold, "\n\n")
   return(list(CGM1ZeroOne = CG1,CGM0ZeroOne = CG0,CGM0.5ZeroOne = CG0.5))
}
