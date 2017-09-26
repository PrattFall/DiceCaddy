# Telegram DiceCaddyBot Server

A Telegram bot for creating and rolling custom dice.

Mainly just to play around with a slightly larger OCaml codebase using server and database libraries as well as the Telegram Bot API.

This code is still in the development phase and currently will not return data to Telegram. Hopefully soon!

## Dependencies

- OPAM v1.2
- OCaml v4.0.5
- A Postgresql database

## To Build

```
make deps
make
```

## To Run

Rename the config.json.default file to config.json and fill it out for your database and API key beforehand.

```
./_build/default/src/Main.exe
```
