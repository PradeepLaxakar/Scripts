# Install azcopy

#(Downloads the zip setup file on our local machine )
wget https://aka.ms/downloadazcopy-v10-linux 

#(Extracts the file content from the archive file downloaded in step 1)
tar -xvf downloadazcopy-v10-linux 

#(To be executed if we had a previous version of Azcopy in our machine. This command removes #the bin file for the previous installation)
sudo rm /usr/bin/azcopy 

#(This command moves the azcopy files in the bin folder of the user)
sudo cp ./azcopy_linux_amd64_*/azcopy /usr/bin/ 
