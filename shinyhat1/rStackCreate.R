#function to create a raster stack from a list of matrices
#andy south 26/3/14
rStackCreate <- function( matrixList )
{
  library(raster)
  listRast <- lapply( matrixList, raster)
  rasterStack <- stack(listRast)
  invisible(rasterStack)
}