# this script scans the src directory for files with the .java extension and
# changes it to the .vala extension 

import os, sys, codecs

def listFiles (dir):
	for root, subFolders, files in os.walk(dir):
		for file in files:
			yield os.path.join(root,file)
	return

def main ():
	path = os.path.dirname(os.path.realpath(__file__))
	for f in listFiles (path):
		if (f.endswith ('java')) :
			newname = f.replace('.java', '.vala')
			output = os.rename(f, newname)
		elif (f.endswith ('vala')) :
			print f.replace(path + "/", '\t') + " \\"

		
if __name__ == "__main__":
	main()
