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
#random size of random set S
Ssize=int(random()*(m+1))
print "The number of elements of random set S is: ",Ssize

#1st element is entered in S without similarity check.The following elements are being checked if they already exist in S.
sim=0
S=matrix(Ssize,n+1)
for i in range(Ssize):
	for l in range(n+1):
		if i==0
			j=int(random()*(m+1))
			S[i,l]=PK[j,l]
		else
			j=int(random()*(m+1))
			#similarity check
			for k range(i):
				if PK[j,l]==S[k,l]
					sim=1
			if sim==0
				S[i,l]=PK[j,l]
		sim=0


print "Random Set is: ",S

EncryptedMessage=matrix(Ssize,2)
for i in range(Nn):
	if Message(i)==0
		for j in range(Ssize):
			for k in range(2):
				if k==0
					EncryptedMessage[j,k]=
