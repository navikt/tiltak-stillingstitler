# tiltak-stillingstitler
Tilbyr typeahead for tiltaksgjennomforing

## Kjøre lokalt

For å få en mest mulig prodlik opplevelse kan man bruke docker for å
bygge og kjøre appen:

```
docker build . --target=dev -t tiltak-stillingstitlerlokal
docker run -i --rm -p 4000:4000 tiltak-stillingstitlerlokal
```

```
curl localhost:4000?q=utvikler
```
