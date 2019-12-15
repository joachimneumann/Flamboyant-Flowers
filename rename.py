#!/usr/bin/env python

import os
import subprocess

picturePath = os.path.join(os.getcwd(), 'pictures2')
print picturePath
counter = 1
for filename in os.listdir(picturePath):
    name1 = "\""+os.path.join(picturePath, filename)+"\""
    name2 = "\""+os.path.join(picturePath, str(counter)+".jpg")+"\""
    name3 = "\""+os.path.join(picturePath, str(counter)+".compressed.jpg")+"\""
    command = "mv "+name1+" "+name2
    subprocess.call(command, shell=True)
    #    print command
    command = "convert -strip -interlace Plane -gaussian-blur 0.05 -quality 85% "+name2+" " +name3
    subprocess.call(command, shell=True)
    #    print command
    counter += 1
