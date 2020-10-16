# Using PostgREST

## Connecting to local Postgresql Server
```
sudo docker run --rm -p 3000:3000 --net=host -e PGRST_DB_URI="postgres://postgres:password@127.0.0.1:5432/postgres"  -e PGRST_DB_ANON_ROLE="postgres"  postgrest/postgrest
```
