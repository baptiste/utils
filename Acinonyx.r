library(Acinonyx)

## idev()
## ggplot2::qplot(1,1)


m <- matrix(rnorm(20 * 1e3), ncol=20)
x <- seq.int(nrow(m))

# create a container (implicitly creates a new window)
a = icontainer(frame=c(0,0,400,300))

# create some random plots off-screen (window=FALSE)

p = iplot(x, m[,1], window=FALSE, frame=c(0,0,200,300),
        flags=c("fix.left","fix.top","fix.bottom"))
ilines(x, m[,1])
q = iplot(x, m[,1], window=FALSE, frame=c(200,0,200,300),
        flags=c("fix.right","fix.top","fix.bottom"))
## q$xlim = c(20, 50)
# add the plots to the container and redraw
redraw(a + p + q)

