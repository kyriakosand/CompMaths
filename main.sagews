from sage.stats.distributions.discrete_gaussian_integer import DiscreteGaussianDistributionIntegerSampler
import numpy as np
import warnings
warnings.filterwarnings("ignore", category=DeprecationWarning)


#---------------------initialization------------------------------
n = 15
p = next_prime(n^2)
e_arbitrary = 5           #can be anything, it's arbitrary
m = floor(((1+e_arbitrary)*(n+1)*log(p)).n())
a_error = (1/(sqrt(n)*(log(n)^2))).n()

#-------------------private key construction-----------------------
s=vector(np.random.random_integers(0,p-1,n))

print "Private key is ",s

#--------------------public key contruction---------------------------------
a = matrix(m,n)
for i in range(m):
    a[i] = vector(np.random.random_integers(0,p-1,n)) #those are the public key vectors
sigma = a_error*p                                     #standard deviation  is a*q
D = DiscreteGaussianDistributionIntegerSampler(sigma=sigma) #the Ψa(n) distribution 
e = [Mod(D(),p) for _ in xrange(m)]     #error offsets
PK = matrix(m,n+1)                      #last column will be the b
for i in range(m):
    for j in range(n):
            PK[i,j] = a[i,j]
    PK[i,n] = Mod(Mod(a[i].inner_product(s),p)+e[i],p)
print "Public Key is: ",PK