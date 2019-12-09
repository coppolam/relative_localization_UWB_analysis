# Bash script to download and unpack the data needed to reproduce the results.
# Allows some time to get a response from the request since the file is pretty big. It may take a few minutes!
#
# You can also do this manually, if you want.
# 1. Go to https://surfdrive.surf.nl/files/index.php/s/0k9vwKe8DZnWsdp
# 2. Click on download and download the zip file (it's almost 15GB!)
# 3. Unpack the file and rename the main folder to data_paper

wget  https://surfdrive.surf.nl/files/index.php/s/0k9vwKe8DZnWsdp/download

unzip download

mv AURO_UWB_relative_localization_data/ data
