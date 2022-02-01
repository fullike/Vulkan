import os
import subprocess

dir_path = os.path.dirname(os.path.realpath(__file__))
dir_path = dir_path.replace('\\', '/')
for root, dirs, files in os.walk(dir_path):
    for file in files:
        if file.endswith(".png"):
            input_file = os.path.join(root, file)
            output_file = input_file.replace("png", "ktx")
            res = subprocess.call("%s %s %s" % ('"C:/Program Files/KTX-Software/bin/toktx.exe"', output_file, input_file), shell=True)
