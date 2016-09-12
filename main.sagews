from sage.stats.distributions.discrete_gaussian_integer import DiscreteGaussianDistributionIntegerSampler
import numpy as np
import warnings
warnings.filterwarnings("ignore", category=DeprecationWarning)


#---------------------initialization------------------------------
n = 3
p = next_prime(n^2)
print "Modulo p is ",p
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
Message=[0,1,1,0,1,0,1,1,0,0]
Messagelength=10

#EncryptedMessage matrix initialization
EncryptedMessage=matrix(Messagelength,n+1)

#Encryption Proccess
for i in range(Messagelength):
    #Random size of random set S
    Ssize=int(random()*(m+1))
    print "The number of elements of random set S of %d bit is:"%i,Ssize

    #Random Set S initilization
    S=matrix(Ssize,n+1)

    #This list counts the times a random row of Public Key is chosen to be entered in S.
    counter=[0 for ci in range(m)]

    #Random rows of Public Key are entered in S.
    for ci in range(Ssize):
        rand=int(random()*(m))
        counter[rand]+=1
        #No duplicate rows
        if counter[rand]<2:
    	    for l in range(n+1):
    	        S[ci,l]=PK[rand,l]
    print "Random Set is: ",S
    print "----------------------"
    sumOfB=0    #this is the variable that will hold the sum of b,of last column
    for k in range(n+1):
        for j in range(Ssize):
            #In each column of EncryptedMessage, the sum of A parameters of each of column of S is entered,except for the last one
            if(k<n):
                EncryptedMessage[i,k]+=S[j,k]
            else:
                sumOfB +=S[j,k]
        #The sum is mod p
        EncryptedMessage[i,k]=Mod(EncryptedMessage[i,k],p)
    if Message[i]==0:
        #If the bit is 0, we enter in the second column of EncryptedMessage the sum of B of S.
        EncryptedMessage[i,n]=Mod(sumOfB,p)
    else:
        #If the bit is 1, we enter in the second column of EncryptedMessage the sum of the floor of p/2 plus Β of S.
        EncryptedMessage[i,n]=Mod(sumOfB+floor(p/2),p)
    print EncryptedMessage

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
#in modulo p if a value is closer to p than to p/2 then it is closer to 0 than p/2
#this means that if a value belongs between p/4 and 3p/4 then it is closer to p/2 than 0
#  0____p/4____p/2____3p/4____p
for i in range(Messagelength):
    #print floor(p/4),Mod(c2[i]-c1[i].inner_product(s),p), floor(3*p/4)        #this line prints p/4, value, 3p/4. If the value belongs in between then it is converted to 1        
    if Mod(c2[i]-c1[i].inner_product(s),p)<floor(p/4):                 #determine if value is closer to zero
        dm[i]= 0 
    elif Mod(c2[i]-c1[i].inner_product(s),p)>floor(3*p/4):             #determine if value is closer to p, thus to 0
        dm[i]=0
    elif Mod(c2[i]-c1[i].inner_product(s),p)==floor(3*p/4):            # if it is equal to 3p/4 we convert it to 0
        dm[i]=0
    elif Mod(c2[i]-c1[i].inner_product(s),p)==floor(p/4):              # if it is equal to p/4 we convert it to 1
        dm[i]= 1
    else:                                                              # value belongs in between p/4 and 3p/4
        dm[i]= 1
print "Decrypted Message is: ",dm
