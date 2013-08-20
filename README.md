Deploy GitLab using Capistrano
==============================

This project aims at providing a standard Capistrano configuration template to boostrap and configure GitLab on your own server (Ubuntu)

## Prerequisites

* The server is bootstrapped using [locomotive-chef-repo](https://github.com/firmhouse/locomotive-chef-repo) or [Intercity](http://intercityup.com).
* The server is configured to have a `gitlab_production` application using a `deploy_user` called `git`. This is what you configure in the chef recipes or your Intercity dashboard.
* You need to `apt-get install libicu-dev` on your server.

## Getting started and configuration

First, start by cloning this repo.

```
$ git clone git@github.com:intercity/intercity-gitlab.git
$ cd intercity-gitlab
```

Install the dependencies using bundler.

```
$ bundle install
```

Modify your server URL where you would like to host GitLab in `config/deploy.rb`. Replace `<server host>` with the hostname you want to install GitLab. We normally set up a `git.yourhost.com` subdomain for hosting GitLab.

Configure both the `gitlab-shell.yml` and `gitlab.yml` files because they will be directly uploaded to the server as configuration files using the `gitlab:configure` capistrano task.

Next up is preparing your server (this will install gitshell and upload the `gitlab.yml`)

```
$ bundle exec cap gitlab:prepare
```

Now it's time to actually deploy the GitLab code and start it. All you have to do is run (This will take some time, since this will checkout the GitLab source code and compile the assets):

```
$ bundle exec cap deploy:cold
```

Finally, run

```
$ bundle exec cap gitlab:setup
```

This will configure GitLab and create the administrator user for you. You will see the initial username and password for the administrator at the bottom of the command output:

```
** [out :: git.yourserver.com] Administrator account created:
** [out :: git.yourserver.com]
** [out :: git.yourserver.com] login.........admin@local.host
** [out :: git.yourserver.com] password......5iveL!fe
```

Happy gitlabbing! :)