# TEST INSTALL SCRIPT FOR CASK
auth_gcloud_sdk () {
  GOOG_LOGIN="You'll now be asked to log in to Google, so Science Box can talk to GCP (gcloud SDK authentication)"
  echo $GOOG_LOGIN && echo && \
  read -n1 -r -p "Press space to continue..." key && \
  gcloud auth login && printf "\n\n"
}

auth_application_default_credentials () {
  GOOG_ADF_LOGIN="You'll now be asked to log in to Google AGAIN, so Science Box can talk to GCP a different way (application default credentials authentication)"
  echo $GOOG_ADF_LOGIN && echo && \
  read -n1 -r -p "Press space to continue..." key && \
  gcloud auth application-default login || echo "Google authentication failed! Please try again."
}

command -v docker >/dev/null 2>&1 && echo "Already installed" || (brew cask install docker && open /Applications/Docker.app/)
command -v gcloud >/dev/null 2>&1 && echo "Already installed" || brew cask install google-cloud-sdk

gcloud config configurations list | awk '{ print $1}' | grep default >/dev/null 2>&1 || gcloud config configurations create default 

# Only ask for gcloud sdk and application default credential auth if necessary.
gcloud config list | grep account >/dev/null 2>&1 && echo "Already authenticated with gcloud SDK" || auth_gcloud_sdk
ls ~/.config/gcloud/application_default_credentials.json >/dev/null 2>&1 && echo "Already authenticated with GCP application default credential" || auth_application_default_credentials


