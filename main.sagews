from sage.crypto.lwe import Regev
import numpy as np
n = 4
m = 5
q = 17
a = 1.3794007834502475
lwe =Regev(n=n,m=m)
L = [lwe() for _ in range(m)]
s=vector(np.random.random_integers(0,q-1,n))

s #idiotiko kleidi

#q=17
#n=4
#m=5
#a=1.3794007834502475









