import json
import os
f = open('city.list.json', 'r')
saveFileName = 'sorted_CN_city.txt'
dic = {}
for line in f:
	if '"CN"' in line:
		j = json.loads(line)
		key = j["name"]
		dic[key] = line

dict = sorted(dic.iteritems(), key=lambda d:d[0])

for fileName in os.listdir(os.getcwd()):
	if fileName == saveFileName:
		os.remove(fileName)
	
g = open(saveFileName, 'w')
for item in dict:
	g.write(item[1])
g.close()
f.close()

