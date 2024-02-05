# Artists-test
### Endpoints:
> All artists <br/>
GET `http://artists.test/api/artists` => all artists

> Artists filter by active/inactive <br/>
GET `http://artists.test/api/artists?filter[inactive]` => inactive
GET `http://artists.test/api/artists?filter[active]` => active

> Artists filter by email <br/>
GET `http://artists.test/api/artists?filter[email]=some_email` => email

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

If you want to add local domain to hosts file, you can run `make` command or add it manually:
- `sudo make add-host`
- Manually: add `127.0.0.1 artists.test` to `/etc/hosts` file.

### Files changed/added:
app/Http/Controllers/API/ArtistsController.php <br/>
app/Http/Resources/ArtistCollection.php

routes/api.php

tests/HTTP/artists.http <br/>
tests/HTTP/http-client.env.json
