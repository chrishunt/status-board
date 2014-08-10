# Status Board

### Your very own status board API

For use with the [Panic Status Board](http://panic.com/statusboard)

![](screenshots/screenshot-placed.png)

## Getting started

Your status board is already setup! Pull it down, deploy it on Heroku, and take
a look.

```bash
$ git clone https://github.com/chrishunt/status-board.git
$ cd status-board
$ heroku create
$ git push heroku master
$ heroku open
```

## What APIs do I get?

I made these APIs to help me watch folks listen to [Healthy
Hacker](http://www.healthyhacker.com/), so right now, all you get is [Chartbeat
Analytics](https://chartbeat.com) and [Libsyn Podcast
Hosting](http://www.libsyn.com/).

Want more? Woo! Me too. [Add your
own](https://github.com/chrishunt/status-board#how-do-i-make-my-own) and send
me a PR.

### Chartbeat Analytics

```
GET /chartbeat/summary/:host
```

Table summary of current visitors for `:host`

```
GET /chartbeat/visitors/:host
```

Count of current visitors for `:host`

```
GET /chartbeat/historical/:host
```

Hourly graph of total/returning visitors for `:host`

### Libsyn Podcast Hosting

```
GET /libsyn/today
```

Count of total downloads for today

```
GET /libsyn/recent
```

Count of total downloads for latest episode

```
GET /libsyn/history
```

Graph of total daily downloads

```
GET /libsyn/totals
```

Graph of total downloads for each of the last 3 months

## Configuration

### Chartbeat Analytics

If you'd like to see Chartbeat Analytics, you'll need to add a Chartbeat API
key to your Heroku environment. You can generate one with the correct
permissions on the Chartbeat [API key manager](https://chartbeat.com/apikeys/).
Make sure you generate a key that works with all domains that you want to
monitor.

```bash
$ heroku config:set \
  CHARTBEAT_API_KEY="YOUR_CHARTBEAT_API_KEY"
```

### Libsyn Podcast Hosting

Libsyn doesn't actually have an API, but it *does* let you download many
different CSV summaries. We download these CSV summaries for you in the
background, parse them, and make them status board friendly.

You'll need to configure Heroku with your login email, password, and show ID.

```bash
$ heroku config:set \
  LIBSYN_EMAIL="YOUR_LIBSYN_EMAIL" \
  LIBSYN_PASSWORD="YOUR_LIBSYN_PASSWORD" \
  LIBSYN_SHOW_ID="YOUR_LIBSYN_SHOW_ID"
```

If you don't know your show ID, visit the [stats
page](http://four.libsyn.com/stats) and you'll see it in the URL:

```
http://four.libsyn.com/stats/general/target/show/id/:show_id
```

## How do I make my own?

Status board supports 3 types of custom panels:

  - [Graph](http://panic.com/statusboard/docs/graph_tutorial.pdf)
  - [Table](http://panic.com/statusboard/docs/table_tutorial.pdf)
  - [DIY](http://panic.com/statusboard/docs/diy_tutorial.pdf)

To create your own panel, wrap the API of your choice and output in one of the
three supported formats. For an example, see how we do it for
[Chartbeat](https://github.com/chrishunt/status-board/blob/master/lib/status_board/chartbeat.rb).

After you have the wrapper, add a route in
[`app.rb`](https://github.com/chrishunt/status-board/blob/master/app.rb)

## Contributing
Please see the [Contributing
Document](https://github.com/chrishunt/status-board/blob/master/CONTRIBUTING.md)

## License
Copyright (C) 2014 Chris Hunt, [MIT
License](https://github.com/chrishunt/status-board/blob/master/LICENSE.txt)
