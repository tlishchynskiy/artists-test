# Artists-test
### Endpoints:
> All artists <br/>
GET `http://artists.test/api/artists` => all artists

> Artists filter by active/inactive <br/>
GET `http://artists.test/api/artists?filter[inactive]` => inactive <br/>
GET `http://artists.test/api/artists?filter[active]` => active

> Artists filter by email <br/>
GET `http://artists.test/api/artists?filter[email]=some_email` => email

> Error wrapped by Laravel's collection <br/>
GET `http://artists.test/api/artists?filter[ohmyerror]` => error response with 400 HTTP code
I didn't add any custom wrapper as Laravel has built-in if we use Collections.

** You can replace `artists.test` with `localhost` if you host on 80 port. If port is different from 80, use `localhost:<port>`.

All endpoints are paginated and wrapped as a Laravel collection, so the frontend part should use it without any issues.

If you use JetBrains production, such as PHPStorm, you can just right into `./tests/HTTP/artists.http` file to run HTTP requests right from the IDE (don't forget to select the dev environment located in `./tests/HTTP/http-client.env.json`).

### Rollup local build:
Clone this repository:
```bash
git clone https://github.com/tlishchynskiy/artists-test
cd artists-test
```

And follow the instructions below:

If you have `make` and `docker`/`podman`-compose installed:
** For immutable linux distros with pre-installed OCI containers, install podman-compose using rpm-ostree or similar.
```bash
make rollup
```
** Please don't forget about privileged ports and rootless setup, so it may throw an error if you are trying to build rootless compose without any configuration on your end.

** If `make rollup` **failed on database migration** (db container is not booted at that moment), then type these commands manually:
```bash
make migrate
make seed
```

And you are good to do ;)

> To enter the PHP container, run `make php`, then you are able to run compose/npm commands.

Otherwise, here are steps to rollup your local without make or docker/podman-compose
1. `cp .env.example .env`
2. `composer install`
3. `php artisan key:generate`
4. `npm install && npm run dev` (optional)
5. Add database credentials to `.env` file
6. `php artisan migrate`
7. `php artisan db:seed`
8. `php artisan serve`

If you want to add local domain to hosts file, you can run `make` command or add it manually:
- `sudo make add-host`
- Manually: add `127.0.0.1 artists.test` to `/etc/hosts` file.

### Files changed/added:
app/Http/Controllers/API/ArtistsController.php <br/>
app/Http/Resources/ArtistCollection.php

routes/api.php

tests/HTTP/artists.http <br/>
tests/HTTP/http-client.env.json
