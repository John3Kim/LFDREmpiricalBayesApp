caution.threshold <- function(l1,l2){ 
    
    lossValZeroNeg <- (l1 <= 0) || (l2 <= 0) 
    
    if(lossValZeroNeg){
        stop("Loss values must be greater than 0.")
    }
    
    threshold = (l2/(l1+l2))
    return(threshold)
}