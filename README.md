# Музыкальные транскрипции

Репозиторий для работы над нотными сетками, текстами и отдельными партиями
нескольких музыкальных треков. Каждый трек изолирован в собственном каталоге,
а общие команды сборки находятся в корне.

## Треки

| Основной ID | Алиас | Трек | Партитура |
| --- | --- | --- | --- |
| [MusicBrainz Recording `7402…5533`](https://musicbrainz.org/recording/7402bbda-e0cf-4960-9b85-d8f6f4f85533) | `atom-76--volki-okeana` | Атом-76 — «Волки Океана» | [`score.ly`](tracks/7402bbda-e0cf-4960-9b85-d8f6f4f85533/score.ly) |
| [MusicBrainz Recording `e889…c0f3`](https://musicbrainz.org/recording/e889154d-ae2d-43f0-bd2d-df87d068c0f3) | `moi-rakety-vverh--blown-away` | Мои Ракеты Вверх — «Blown Away» | [`score.ly`](tracks/e889154d-ae2d-43f0-bd2d-df87d068c0f3/score.ly) |

Каталог трека называется по его MusicBrainz Recording MBID. Он однозначно
идентифицирует конкретную запись, к которой относятся таймкоды, аранжировка и
соло. Удобный человекочитаемый алиас хранится рядом с каноническим ID в
корневом [`aliases.json`](aliases.json). Work MBID хранится в metadata трека и
может быть заполнен, если для абстрактной композиции появится отдельная сущность
MusicBrainz.

## Структура

```text
aliases.json                       # удобные имена → Recording MBID
tracks/
  <musicbrainz-recording-mbid>/
    README.md
    score.ly
    sources/
      lyrics-with-bar-marks.txt
    reference/
      README.md
      recordings.json
      audio/                 # локально, вне Git
build/
  <musicbrainz-recording-mbid>/ # локальные PDF, MIDI и прослушивания
```

`flake.nix` автоматически обнаруживает непосредственные подкаталоги `tracks/`,
проверяет совпадение имени каталога с Recording MBID в metadata и создаёт
команды как по ID, так и по алиасу из `aliases.json`. Для нового трека
достаточно создать каталог с `score.ly` и `reference/recordings.json`, а затем
при желании добавить алиас. Новый каталог нужно добавить в индекс Git перед
запуском flake-команд, поскольку Nix не включает полностью неотслеживаемые пути
в flake source.

## Сборка

Собрать все треки в локальный `build/`:

```console
nix run .#render
```

Собрать только «Волков Океана»:

```console
nix run .#render-atom-76--volki-okeana
```

Та же команда по основному ID:

```console
nix run .#render-7402bbda-e0cf-4960-9b85-d8f6f4f85533
```

Дополнительные параметры передаются LilyPond. Например, диагностические PNG
для всех партитур создаются так:

```console
nix run .#render -- --png -dresolution=144
```

Проверить все обнаруженные партитуры и metadata в изолированной Nix-сборке:

```console
nix flake check
```

`nix build` собирает общий каталог результатов. Отдельный трек доступен и как
`nix build .#7402bbda-e0cf-4960-9b85-d8f6f4f85533`, и по удобному алиасу
`nix build .#atom-76--volki-okeana`.
