

#informatii despre un nod din arborele de parcurgere (nu din graful initial)
class NodParcurgere:
	def __init__(self, id, info, cost, parinte):
		self.id=id # este indicele din vectorul de noduri
		self.info=info
		self.parinte=parinte #parintele din arborele de parcurgere
		self.cost=cost

	def obtineDrum(self):
		l=[self.info];
		nod=self
		while nod.parinte is not None:
			l.insert(0, nod.parinte.info)
			nod=nod.parinte
		return l
		
	def afisDrum(self): #returneaza si lungimea drumului
		l=self.obtineDrum()
		print(("->").join(l))
		return len(l)


	def contineInDrum(self, infoNodNou):
		nodDrum=self
		while nodDrum is not None:
			if(infoNodNou==nodDrum.info):
				return True
			nodDrum=nodDrum.parinte
		
		return False
		
	def __repr__(self):
		sir=""		
		sir+=self.info+"("
		sir+="id = {}, ".format(self.id)
		sir+="drum="
		drum=self.obtineDrum()
		sir+=("->").join(drum)
		sir+=" cost:{})".format(self.cost)
		return(sir)
		

class Graph: #graful problemei
	def __init__(self, noduri, matriceAdiacenta, matricePonderi, start, scopuri):
		self.noduri=noduri
		self.matriceAdiacenta=matriceAdiacenta
		self.matricePonderi=matricePonderi
		self.nrNoduri=len(matriceAdiacenta)
		self.start=start
		self.scopuri=scopuri
	def indiceNod(self, n):
		return self.noduri.index(n)
		
	#va genera succesorii sub forma de noduri in arborele de parcurgere	
	def genereazaSuccesori(self, nodCurent):
		listaSuccesori=[]
		for i in range(self.nrNoduri):
			if self.matriceAdiacenta[nodCurent.id][i] == 1 and  not nodCurent.contineInDrum(self.noduri[i]):
				nodNou=NodParcurgere(i, self.noduri[i], nodCurent.cost+ self.matricePonderi[nodCurent.id][i], nodCurent)
				listaSuccesori.append(nodNou)
		return listaSuccesori
		
	def __repr__(self):
		sir=""
		for (k,v) in self.__dict__.items() :
			sir+="{} = {}\n".format(k,v)
		return(sir)
		
		

##############################################################################################	
#                                 Initializare problema                                      #
##############################################################################################		

#pozitia i din vectorul de noduri da si numarul liniei/coloanei corespunzatoare din matricea de adiacenta		
noduri=["a","b","c","d","e","f","g","h","i","j"]

m=[
	[0,1,0,1,1,0,0,0,0,0],
	[1,0,1,0,0,1,0,0,0,0],
	[0,1,0,0,0,1,0,1,0,0],
	[1,0,0,0,0,0,1,0,0,0],
	[1,0,0,0,0,0,0,1,0,0],
	[0,1,1,0,0,0,0,0,0,0],
	[0,0,0,1,0,0,0,0,0,0],
	[0,0,1,0,1,0,0,0,1,1],
	[0,0,0,0,0,0,0,1,0,0],
	[0,0,0,0,0,0,0,1,0,0]
]
mp=[
	[0,3,0,1,1,0,0,0,0,0],
	[3,0,1,0,0,10,0,0,0,0],
	[0,1,0,0,0,3,0,1,0,0],
	[1,0,0,0,0,0,1,0,0,0],
	[1,0,0,0,0,0,0,1,0,0],
	[0,10,3,0,0,0,0,0,0,0],
	[0,0,0,1,0,0,0,0,0,0],
	[0,0,1,0,1,0,0,0,1,1],
	[0,0,0,0,0,0,0,1,0,0],
	[0,0,0,0,0,0,0,1,0,0]
]
start="a"
scopuri=["f","j"]
gr=Graph(noduri, m, mp, start, scopuri)







#### algoritm Uniform Cost Search
#presupunem ca vrem mai multe solutii (un numar fix)
#daca vrem doar o solutie, renuntam la variabila nrSolutiiCautate
#si doar oprim algoritmul la afisarea primei solutii
nrSolutiiCautate=4

def uniform_cost(gr):
	global nrSolutiiCautate
	#in coada vom avea doar noduri de tip NodParcurgere (nodurile din arborele de parcurgere)
	c=[NodParcurgere(gr.noduri.index(start), start, 0, None)]
	continua=True #variabila pe care o setez la false cand consider ca s-au afisat suficiente solutii
	while(len(c)>0 and continua):
		print("Coada actuala: " + str(c))
		input()
		nodCurent=c.pop(0)
		
		if nodCurent.info in scopuri:
			nodCurent.afisDrum()
			nrSolutiiCautate-=1
			if nrSolutiiCautate==0:
				continua=False
		lSuccesori=gr.genereazaSuccesori(nodCurent)	
		for s in lSuccesori:
			i=0
			gasit_loc=False
			for i in range(len(c)):
				#diferenta e ca ordonez dupa f
				if c[i].cost>=s.cost :
					gasit_loc=True
					break;
			if gasit_loc:
				c.insert(i,s)
			else:
				c.append(s)					
				


uniform_cost(gr)