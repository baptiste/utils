


d <- data.frame(x=seq(1, 1000),
                y = jitter(20000*cos(seq.int(1000)/ 1000), a=3))
id <- sample(seq.int(nrow(d)), 5)
d[id, 'y'] <- runif(length(id), 10, 1000)*d[id, 'y']
par(mfrow=c(2, 1))
plot(d, t="l")

## diffs <- diff(d[, 'y'])
## ids <- which(abs(diffs) > 100 * median(abs(diffs)))
## points(d[ids, 1], d[ids, 2], col="red")
## d[ids, "y"] <- approx(d[-ids, "x"], d[-ids, "y"], d[ids, "x"])$y
## plot(d, t="l")





despike_spectrum <- function(d, x = "wavenumber", y="value", threshold=100){

  n <- nrow(d)
  diffs <- abs(diff(d[, y]))
  id <-  which(abs(diffs) > 100 * median(abs(diffs)))
    
  if(!length(id))
    return(d)
  print(paste(id, sep=", "))
  d[id, y] <- approx(d[-id, x], d[-id, y], d[id, x])$y
  
  invisible(d)
}


d2 <- despike_spectrum(d, "x", "y")
plot(d2, t="l")

