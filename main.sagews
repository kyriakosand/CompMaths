from sage.crypto.lwe import Regev
import numpy as np
lwe =Regev(n=4,m=5)
L = [lwe() for _ in range(m)]
s=vector(np.random.random_integers(0,16,4))

s #idiotiko kleidi

#q=17
#n=4
#m=5
#a=1.3794007834502475









