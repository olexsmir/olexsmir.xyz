---
title = FreshRSS on fly
date = 2025-11-10
slug = freshfly
---
# The problem.
I'm broke, and I like using FreshRSS.

# The solution.
We'll be using [fly.io](https://fly.io)
they have a generous [free allowance](https://fly.io/docs/about/pricing).

## Setting up 
First, you have to [sign up for fly account](https://fly.io/app/sign-up).
[Get their cli](https://fly.io/docs/flyctl/install), and login with `flyctl auth login`. 

## Deploying FreshRSS
Create a directory where you'll store the `fly.toml` file, `cd` into this directory, we'll do our magic.

Now, we need to create an app on fly.io, using the following command:
```bash
flyctl app create --save
```

After this, you'll get an auto-generated `fly.toml` file.
<br>
Modify it to look like this (**don't change the app name**):

```toml
app = 'your-app-name' # TODO: update me
primary_region = 'fra'
kill_signal = 'SIGINT'

[build]
# Please check what the latest version is at: https://github.com/FreshRSS/FreshRSS
# and set it here
image = 'docker.io/freshrss/freshrss:1.27.1'

[env]
CRON_MIN = '*/20' # update feeds every 20 minutes

# you don't want your account and feeds to be deleted after a restart
[[mounts]]
source = 'freshrss_data'
destination = '/var/www/FreshRSS/data'

# you probably want this app to be accessible
[[services]]
protocol = 'tcp'
internal_port = 80
processes = ['app']

[[services.ports]]
port = 80
handlers = ['http']
force_https = true

[[services.ports]]
port = 443
handlers = ['tls', 'http']

[[vm]]
size = 'shared-cpu-1x'
```

Deploy to fly.io by running:
```bash
flyctl launch
```

Now open [your-app-name.fly.dev](https://your-app-name.fly.dev)
in your browser, and follow the setup wizard.
Chose **sqlite** as your database, it will be automatically stored in `/var/www/FreshRSS/data`.

## Setting up custom domain (optional)
```bash
fly certs create rss.your-domain.com
```

The output of this command will guide you through the records you need to add to your domain.
