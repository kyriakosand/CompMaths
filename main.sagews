from sage.stats.distributions.discrete_gaussian_integer import DiscreteGaussianDistributionIntegerSampler
import numpy as np
import warnings
import random
warnings.filterwarnings("ignore", category=DeprecationWarning)


#---------------------initialization------------------------------
n = 50
primes=[]
for num in range(n^2,2*n^2):
    for i in range(2,num):
        if (num % i) == 0:
            break
        else:
            primes.append(num)
primesNonDuplicates = list(set(primes))
p = random.choice(primesNonDuplicates)
print "Modulo p is ",p
e_arbitrary = 5           #can be anything, it's arbitrary
m = floor(((1+e_arbitrary)*(n+1)*log(p)).n())
a_error = (1/(sqrt(n)*(log(n)^2))).n()

#-------------------private key construction-----------------------
s=vector(np.random.random_integers(0,p-1,n))

#print "Private key is ",s

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
#print "Public Key is: ",PK

#ENCRYPTION--------------------------------------------
Keyboard=[' ','!','"','#','$']
BinaryKeyboard=["00100000","00100001","00100010","00100011","00100100"]

test="!"
index=0
for i in range(len(test)):
    if(test[i]==Keyboard[i]):
        index=i
    test=Keyboard[index]
print test
    
#A message in binary
Message=[1,1,1,1,1,1,1,1,1,1]
Messagelength=10

#EncryptedMessage matrix initialization
EncryptedMessage=matrix(Messagelength,n+1)

#Encryption Proccess
for i in range(Messagelength):
    #Random size of random set S
    Ssize=int(random.random()*(m+1))

    #Random Set S initilization
    S=matrix(Ssize,n+1)

    #This list counts the times a random row of Public Key is chosen to be entered in S.
    counter=[0 for ci in range(m)]

    #Random rows of Public Key are entered in S.
    for ci in range(Ssize):
        rand=int(random.random()*(m))
        counter[rand]+=1
        #No duplicate rows
        if counter[rand]<2:
    	    for l in range(n+1):
    	        S[ci,l]=PK[rand,l]
    for k in range(n+1):
        for j in range(Ssize):
            #In each column of EncryptedMessage, the sum of A parameters of each of column of S is entered,except for the last one
                EncryptedMessage[i,k]+=Mod(S[j,k],p)
    if Message[i]==1:
        EncryptedMessage[i,n]=Mod(EncryptedMessage[i,n]+floor(p/2),p)
    
#DECRYPTION--------------------------------------------------------------------------------------------------------------------------------------------------
#(c1,c2) is the encrypted pair, c1 is a vector and c2 is a value

c1 = matrix(Messagelength,n)  #initialization as matrix because there are many pairs
for i in range(Messagelength): #initialization
    c1[i] = vector(np.random.random_integers(0,p-1,n))  #initialization

c2=vector(np.random.random_integers(0,p-1,Messagelength)) #initialization as vector because there are many pairs

for i in range(Messagelength):
    for j in range(n):
            c1[i,j] = EncryptedMessage[i,j]  #we choose a from EncryptedMessage[a,b]
for i in range(Messagelength):
    c2[i] = EncryptedMessage[i,n]     #we choose b from EncryptedMessage[a,b]
    

dm= vector(QQ,Messagelength) #decrypted message
for i in range(Messagelength):
    number = Mod(c2[i]-Mod(c1[i].inner_product(s),p),p)
    diffFromMiddle = number-floor(p/2)            #this returns the substraction modulo p!!!!e.g. for p=11 and number=2, 2-5=-3mod11=8, real distance=11-8=3
    if(number<p-number):                 
        if(number < p-diffFromMiddle):   #p-diffFromMiddle is to calculate the real distance from floor(p/2)
            dm[i] = 0
        else:
            dm[i] = 1
    elif (number>p-number):
        if(number<diffFromMiddle):
            dm[i]=0
        else:
            dm[i]=1
    elif (number == p-number):
        dm[i] = 0
print "Decrypted Message is: ",dm
print "Original Message is: ",Message