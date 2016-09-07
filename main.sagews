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

#ENCRYPTION--------------------------------------------

#random size of random set S
Ssize=int(random()*(m+1))
print "The number of elements of random set S is: ",Ssize

#random rows of Public Key are entered in S.
S=matrix(Ssize,n+1)
counter=[0 for i in range(m)]
for i in range(Ssize):
	rand=int(random()*(m))
	counter[rand]+=1
	if counter[rand]<2:
		for l in range(n+1):
			S[i,l]=PK[rand,l]
print "Random Set is: ",S

Message=[0,1,1,0,1,0,1,1,0,0]
Messagelength=10
EncryptedMessage=matrix(Messagelength,2)
for i in range(Messagelength):
    for j in range(Ssize):
        for k in range(n):
            EncryptedMessage[i,0]+=S[j,k]
        if Message[i]==0:
            EncryptedMessage[i,1]+=S[j,n]
        else:
            EncryptedMessage[i,1]+=S[j,n]+floor(p/2)
print EncryptedMessage
