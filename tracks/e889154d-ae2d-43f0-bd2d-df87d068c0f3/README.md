# Мои Ракеты Вверх — «Blown Away»

Проект транскрипции записи с MusicBrainz Recording MBID
[`e889154d-ae2d-43f0-bd2d-df87d068c0f3`](https://musicbrainz.org/recording/e889154d-ae2d-43f0-bd2d-df87d068c0f3).

## Состояние

В [`score.ly`](score.ly) находится рабочая версия сольной партии. Последовательность
высот перенесена из пользовательского MusicXML, а длительности уточнены по
фонограмме в ритмическом кандидате № 2. Этот кандидат принят как основная
транскрипция; её рабочий темп — `♩ = 171`.

Аудиореференс с YouTube и точный диапазон оригинального соло `2:22.70–2:33.60`
описаны в [`reference/README.md`](reference/README.md). Готовый фрагмент для
прослушивания находится в
[`build/e889154d-ae2d-43f0-bd2d-df87d068c0f3/solos/original-02m22.70-02m33.60.mp3`](../../build/e889154d-ae2d-43f0-bd2d-df87d068c0f3/solos/original-02m22.70-02m33.60.mp3).

## Рендеринг

Воспроизвести партитуру, MP3-транскрипцию, оригинальный фрагмент и оба
стереосравнения:

```console
nix run .#dvc -- repro tracks/e889154d-ae2d-43f0-bd2d-df87d068c0f3/dvc.yaml
```

Только партитура:

```console
nix run .#dvc -- repro tracks/e889154d-ae2d-43f0-bd2d-df87d068c0f3/dvc.yaml:render-score
```

PDF и MIDI создаются в
`build/e889154d-ae2d-43f0-bd2d-df87d068c0f3/`, а отдельные аудиофайлы — в
его подкаталоге `solos/`.
