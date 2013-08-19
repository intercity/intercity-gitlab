Deploy GitLab using Capistrano
==============================

This project aims at providing a standard Capistrano configuration template to boostrap and configure GitLab on your own server.

## Prerequisites

The server is bootstrapped using [locomotive-chef-repo](https://github.com/firmhouse/locomotive-chef-repo) or [Intercity](http://intercityup.com).

Within the server configuration you added a `gitlab_production` application using a `deploy_user` called `git`.

## Getting started and configuration

First, modify your server URL where you would like to host GitLab in `config/deploy.rb.configure_this`. Replace `<server host>` with the hostname you want to install GitLab. We normally set up a `git.yourhost.com` subdomain for hosting GitLab.

Then, rename the `config/deploy.rb.configure_this` file to `config/deploy.rb`.

Configure both the `gitlab-shell.yml` and `gitlab.yml` files because they will be directly uploaded to the server as configuration files.

Now run

```
bundle install
```

to install the command line tools you need to run this project.

## Installing GitLab

First run

```
cap gitshell:install
```

which will install gitlab-shell on your server.

Run

```
cap gitlab:configure
```

which will upload the gitlab.yml configuration file and sets up GitLab's directories.

Now it's time to actually deploy the GitLab code and start it. All you have to do is run:

```
cap deploy:cold
```

This will take some time, since this will checkout the GitLab source code and compile the assets.