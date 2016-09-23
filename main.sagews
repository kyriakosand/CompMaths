from sage.stats.distributions.discrete_gaussian_integer import DiscreteGaussianDistributionIntegerSampler
import numpy as np
import warnings
import random
warnings.filterwarnings("ignore", category=DeprecationWarning)
sage_server.MAX_STDOUT_SIZE=50000

#---------------------initialization------------------------------
n = 130
primes=[]
for num in range(n^2,2*n^2):
    d=0
    for i in range(2,num):
        if (num % i) == 0:
            d=d+1
    if d==0:
        primes.append(num)
p = random.choice(primes)
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
#Message to binary
Amessage="A"
Message=' '.join(format(ord(x), 'b') for x in Amessage)

Messagelength=len(Message)

#EncryptedMessage matrix initialization
EncryptedMessage=matrix(Messagelength,n+1)

#Encryption Proccess
for i in range(Messagelength):
    #Random size of random set S
    Ssize= int(random.uniform(1,m+1))

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
c2 = []

for i in range(Messagelength):
    for j in range(n):
            c1[i,j] = EncryptedMessage[i,j]  #we choose a from EncryptedMessage[a,b]
    c2.append(EncryptedMessage[i,n])     #we choose b from EncryptedMessage[a,b]
    

dm= vector(QQ,Messagelength) #decrypted message
#in modulo p if a value is closer to p than to p/2 then it is closer to 0 than p/2
#this means that if a value belongs between p/4 and 3p/4 then it is closer to p/2 than 0
#  0____p/4____p/2____3p/4____p
for i in range(Messagelength):
    print floor(p/4),Mod(c2[i]-c1[i].inner_product(s),p), floor(3*p/4)        #this line prints p/4, value, 3p/4. If the value belongs in between then it is converted to 1        
    if Mod(c2[i]-Mod(c1[i].inner_product(s),p),p)<floor(p/4):                 #determine if value is closer to zero
        dm[i]= 0 
    elif Mod(c2[i]-Mod(c1[i].inner_product(s),p),p)>floor(3*p/4):             #determine if value is closer to p, thus to 0
        dm[i]=0
    elif Mod(c2[i]-Mod(c1[i].inner_product(s),p),p)>floor(p/4):
        if Mod(c2[i]-Mod(c1[i].inner_product(s),p),p)<floor(3*p/4):
            dm[i]=1
    elif Mod(c2[i]-Mod(c1[i].inner_product(s),p),p)<floor(3*p/4):
        if Mod(c2[i]-Mod(c1[i].inner_product(s),p),p)>floor(p/4):
            dm[i]=1
    elif Mod(c2[i]-Mod(c1[i].inner_product(s),p),p)==floor(3*p/4):
        dm[i]=1
    elif Mod(c2[i]-Mod(c1[i].inner_product(s),p),p)==floor(p/4):
        dm[i]=1
print "Decrypted Message is: ",dm
print "Original Message is: ",Message
