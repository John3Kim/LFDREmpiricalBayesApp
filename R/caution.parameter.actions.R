caution.parameter.actions <- function (x1, x2, l1 = 4, l2 = 1) {
   # l1 and l2 are our definition of the loss values. 
   # Take l1 = 4 and l2 = 1 as default values.
   # x1 and x2 are vectors of two different reference classes 
    
   notEqualLen <- length(x1) != length(x2)
   lossValZeroNeg <- (l1 <= 0) || (l2 <= 0)
   
   if(notEqualLen){
       #Vectors must be of equal length
      stop("Number of inputted values of the first reference class must equal
           to that of the second one.")
   }

   if(lossValZeroNeg){
      stop("Loss values must be greater than 0.")
   }

   for(i in 1:length(x1)){
      lfdrOutOfBounds <- (x1[i] < 0 || x1[i] > 1)||(x2[i] < 0 || x2[i] > 1)
      
      if(lfdrOutOfBounds){
         stop("Each LFDR value inputted in the reference classes must be a value 
              between 0 and 1.")
      }
   } 

   x <- cbind(x1,x2)
   infx <- rowMins(x)
   supx <- rowMaxs(x)          
   l <- length(infx)
   CG1 <- CG0 <- CG0.5 <- c()
  
   for (i in 1:l){
      CGM1Case <- l1*supx[i] <= l2*(1-infx[i])
      CGM0Case <- l1*infx[i] <= l2*(1-supx[i])
      CGMHalfCase <- l1*(supx[i]+infx[i]) <= l2*(2-supx[i]-infx[i])
           
      ifelse(CGM1Case, CGM1_ZeroOne <- 1, CGM1_ZeroOne <- 0)
      ifelse(CGM0Case, CGM0_ZeroOne <- 1, CGM0_ZeroOne <- 0)
      ifelse(CGMHalfCase, CGM0.5_ZeroOne <- 1, CGM0.5_ZeroOne <- 0)
      
      CG1 <- c(CG1,CGM1_ZeroOne)
      CG0 <- c(CG0,CGM0_ZeroOne)
      CG0.5 <- c(CG0.5,CGM0.5_ZeroOne)
   }

   return(list(CGM1_ZeroOne = CG1, CGM0_ZeroOne = CG0, CGM0.5_ZeroOne = CG0.5))
}
