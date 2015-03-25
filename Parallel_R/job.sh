bash
#!/bin/bash                                                                     

export OMP_NUM_THREADS=$NSLOT

R CMD BATCH --no-save GLMParallel.R
