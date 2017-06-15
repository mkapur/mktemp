##><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><><><
## Stock Assessment Input File for BSPSP
## Developed by Henning Winker & Felipe Carvalho (Cape Town/Hawaii)  
##><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>


# required packages
#Just in case
# library(gplots)
# library(coda)
#library(jagsUI) ### THIS IS NEW
# library(rjags)
# library(R2jags)
library("fitdistrplus")
#Just in case
#detach("package:jagsUI", unload=TRUE)
#detach("package:R2jags", unload=TRUE)
#dev.off()


# Set Working directory file
# File = "C:/Work/Research/LargePelagics/ASSESSMENTS/SMA_ICCAT/BSPSP_report"
File = "C:/Users/M Kapur/Dropbox/BSPSP"
# Set Assessment
assessment = "SMA_NA"


# Choose Sceanrio name for creating a seperate folCder

# S1: Base-Case

Scenarios = c("Base-Case")

for(s in 1:1){
Scenario = Scenarios[s] 

# Choose model type: 
# 1: Schaefer
# 2: Schaefer with Depensation (CMSY: Froese et al. 2016)  
# 3: Fox
# 4: Fox with Depensation (CMSY: Froese et al. 2016)
  Model = 1  # model

  Mod.names = c("Schaefer","Schaefer.RecImp","Fox","Fox.RecImp","Pella")[Model]

  #  Set shape (> 0, with 1.001 ~ Fox and 2 = Schaefer)
  shape = FALSE # set to False for using Models 1-4 
  
  
  setwd(paste(File))
  # Load assessment data
  # cpue = read.csv(paste0(assessment,"/cpue",assessment,".csv"))#
  # se =  read.csv(paste0(assessment,"/se",assessment,".csv"))# use 0.001 if not available 
  # catch = read.csv(paste0(assessment,"/catch",assessment,".csv"))
  cpue = read.csv(paste0(File,"/cpue",assessment,".csv"))#
  se =  read.csv(paste0(File,"/se",assessment,".csv"))# use 0.001 if not available 
  catch = read.csv(paste0(File,"/catch",assessment,".csv"))
  
  names(cpue)
  names(catch)
  
  #--------------------------------------------------
  # option to exclude CPUE time series or catch year
  #--------------------------------------------------
  # NA
  
  
  #------------------------------------------------
  # mean and CV and sd for unfished biomass K (SB0)
  #------------------------------------------------
  mu.K = 200000; CV.K = 2; sd.K=sqrt(log(CV.K^2+1)) 
  K.pr = c(mu.K,sd.K)
  
  #-----------------------------------------------------------
  # mean and CV and sd for Initial depletion level P1= SB/SB0
  #-----------------------------------------------------------
  # To be translated into Beta prior as psi.pr
  mu.psi = 0.95; CV.psi = 0.05; sd.psi = sqrt(log(CV.psi^2+1)) # choose 0.99 and 0.001 for SB1/SB0 ~ 1
  
  #--------------------------------------------------------------
  # Determine estimation for catchability q and observation error 
  #--------------------------------------------------------------
  # Assign q to CPUE
  sets.q = 1:(ncol(cpue)-1) 
  
  
  # Series
  #sets.var = rep(1,ncol(cpue)-1)# estimate the same additional variance error
  sets.var = 1:(ncol(cpue)-1) # estimate individual additional variace
  
  # As option for data-weighing
  # minimum additional observation error for each variance set (optional choose 1 value for both)
  min.obsE = c(0.1) # Important if SE.I is not availble
  
  # Use SEs for abudance indices (TRUE/FALSE)
  SE.I = TRUE
  
  #><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>
  # Prior specification for Models 1-4, i.e. Schaefer, Fox
  #><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>
  
  #----------------------------------------------------
  # Determine r prior
  #----------------------------------------------------
  # The option are: 
  # a) Specifying a lognormal prior 
  # b) Specifying a resiliance category after Froese et al. (2016; CMSY)
  # Resilience: "Very low", "Low", "Medium", High" 
  
  #r.prior = "Low"
  r.prior = c(0.01,0.06) # as range with upper and lower bound of lnorm prior
  
  
  
  #><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>
  # Execute model and produce output
  #><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>><>
  
  # set TRUE if PUCL rules should be applied
  pucl = FALSE
  
  # Option to produce standard KOBE plot
  KOBE.plot = TRUE
  
  # Process Error
  #Estimate set sigma.proc == True
  # IF Fixed: typicallly 0.05-0.15 (see Ono et al. 2012)
  sigma.proc = TRUE
  # sigma.proc = 0.07 # Example for fixing the Process error
  
  # MCMC settings
  ni <- 50000 # Number of iterations
  nt <- 10 # Steps saved
  nb <- 10000 # Burn-in
  nc <- 2 # number of chains
  
  
  # Run model (BSPSPexe file must be in the same working directory)
  source(paste0(File,"/BSPSP_ICCATv3.r"))
  
  
  
  }# THE END
