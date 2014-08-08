# Status Board

### Your very own status board API

Create your own API to use with [Panic Status
Board](http://panic.com/statusboard).

## Deploy to Heroku

```bash
$ git clone https://github.com/chrishunt/status-board.git
$ cd status-board
$ heroku create

$ heroku config:set \
  CHARTBEAT_API_KEY="YOUR_CHARTBEAT_API_KEY" \
  CHARTBEAT_DOMAIN="YOUR_CHARTBEAT_DOMAIN" \
  LIBSYN_EMAIL="YOUR_LIBSYN_EMAIL" \
  LIBSYN_PASSWORD="YOUR_LIBSYN_PASSWORD" \
  LIBSYN_SHOW_ID="YOUR_LIBSYN_SHOW_ID"

$ git push heroku master
$ heroku open
```

## What do I get?

### `GET /chartbeat/summary`
Returns an HTML table summary of all current visitors.

### `GET /chartbeat/visitors`
Returns a JSON graph (count) of all current visitors.

### `GET /chartbeat/historical`
Returns a JSON hourly graph history of total and returning visitors.

### `GET /libsyn/recent`
Returns a JSON graph (count) of total downloads for latest episode.

### `GET /libsyn/totals`
Returns a JSON graph count of total downloads for the last 3 months.

### `GET /libsyn/history`
Returns a JSON graph of total daily downloads.

### `GET /libsyn/today`
Returns a JSON graph (count) of total downloads for today.

## Contributing
Please see the [Contributing
Document](https://github.com/chrishunt/status-board/blob/master/CONTRIBUTING.md)

## License
Copyright (C) 2014 Chris Hunt, [MIT
License](https://github.com/chrishunt/status-board/blob/master/LICENSE.txt)
