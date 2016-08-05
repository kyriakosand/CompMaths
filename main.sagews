︠9a74985a-48b3-4ae2-9006-325d53b095c7s︠
from sage.crypto.lwe import Regev
import numpy as np
lwe =Regev(n=4,m=5)
L = [lwe() for _ in range(m)]
s=vector(np.random.random_integers(0,17,4))

s #idiotiko kleidi

#q=17
#n=4
#m=5
#a=1.3794007834502475
︡da308eae-23e9-43f3-bff1-747e4100c2b0︡{"stdout":"(1, 6, 9, 10)\n"}︡{"done":true}︡









