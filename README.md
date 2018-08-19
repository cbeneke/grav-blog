# grav-blog
Docker image for grav used as blog

# Usage
This image is meant to be run behind an SSL capable proxy, as it does not care
about transport layer security. You must provide configs for grav in the
`/app/user/config` folder. See the examples folder for a minimal setup.

I recommend the clena-blog theme for the best compability.  It is intended to be
synced via git-sync. Manually you can install it with gpm:

```
# Workdir /app
bin/gpm install clean-blog
```

The gitsync must be triggered on docker start, e.g. by:

```
# Workdir /app
su nginx -s /bin/sh -c 'bin/plugin git-sync sync'
```
