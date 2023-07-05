# website

This project aims to make it easier to customize Pterodactyl.  
If you make changes to the panel and then update it, all your changes are gone.  
With this Project, you only need to set up everything once, and then you only need up update the panel (the panel folder).  
It could happen that an Update causes the setup to fail, but this won't happen with every update, and it's easy to fix because it will mostly likely be only a few instructions or even just one that is broken.  
**NOTE: I originally created this just for me, but I think this could be useful for some People.**

## Setup
1. Clone this Repository into a Private repository of you.  
2. Open the .github/workflows/workflow.yml and adjust the PATH if the panel isn't installed in `/var/www/pterodactyl`  
3. Add all Github secrets that are needed for the workflow to work properly.  
3.1 Add the SSH_IP secret that contains the Server IP where Pterodactyl is installed.  
3.2 Add the SSH_USER secret that contains the username for the SSH User. (Don't use root!)  
3.3 Add the SSH_PRIVATE_KEY or SSH_PASSWORD secret that contains the key or password for the SSH User. (I need to learn to use SSH Keys)  
4. Give the SSH User all sudo permissions needed. (`chown`, `rm`)  
5. Install all [Dependencies](https://pterodactyl.io/community/customization/panel.html#install-dependencies) and [Build](https://pterodactyl.io/community/customization/panel.html#build-panel-assets) the Panel once Yourself

Now test the workflow and see if it works properly.
If the workflow had no errors, open your Panel and see if the Server Router has now Icons.  
If it has, then everything works properly.  

## Usage

See the [Addons folder](https://github.com/RaphaelIT7/pterodactyl-addons/tree/main/addons) that contains a list of all functions.
