# grav-blog
Docker image for grav used as blog

# Disclaimer
This image is meant to be run behind an SSL capable proxy, as it does not (yet)
cares about transport layer security. You must make sure to mount and/or backup
the `/app/user/config` folder to make the config persistent.
