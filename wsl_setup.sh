cd ~
mkdir -p ~/Downloads # make downloads directory, -p makes parents, but also allows existing directory to not cause error

cd ./Downloads # has to exist now

condaVersion="Anaconda3-2024.10-1-Linux-x86_64.sh" # ideally this would be dynamic, but this can just be updated to a newer version

condaHash=3ba0a298155c32fbfd80cbc238298560bf69a2df511783054adfc151b76d80d8

curl -O https://repo.anaconda.com/archive/$condaVersion 

shasum -a 256 ~/Downloads/$condaVersion

if ! echo "$condaHash $condaVersion" | sha256sum -c -; then
	echo "Checksum failed!" >&2
	exit 1
fi 

# see https://www.anaconda.com/docs/getting-started/anaconda/advanced-install/silent-mode#mac-os-linux
bash ~/Downloads/$condaVersion -b -p $HOME/anaconda3 -f 

# configure anaconda to autoactivate in supported shells
source ~/anaconda3/bin/activate
conda init --all
conda config --set auto_activate_base true


# get wakehealthrootca.pem

curl -O https://phswiki.phs.wakehealth.edu/media_assets/files/wakehealthrootca.pem

# set header in root ca
echo $'\nWake Health Root CA\n==================================' | cat - wakehealthrootca.pem > tmp.txt && mv tmp.txt wakehealthrootca.pem

# add cert to main anaconda bundle
cat $HOME/Downloads/wakehealthrootca.pem >> $HOME/anaconda3/ssl/cert.pem

# Set this bundle as conda default
conda config --set ssl_verify $HOME/anaconda3/ssl/cert.pem


echo "export REQUESTS_CA_BUNDLE=\"$HOME/anaconda3/ssl/cert.pem\"" >> $HOME/.bashrc


source $HOME/.bashrc




sudo apt-get update
sudo apt install gcc
sudo apt install g++


conda create -n TotalSeg python -y
conda activate TotalSeg
pip install TotalSegmentator 

totalseg_download_weights






