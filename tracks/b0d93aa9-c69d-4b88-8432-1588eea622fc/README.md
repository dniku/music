# Avantasia — «Lost in Space»

На GitHub Pages публикуются PDF, MIDI и MP3 полной фортепианной аранжировки
[piano-roll.ly](piano-roll.ly), описанной ниже.

Прежний набросок начала соло сохранён в [score.ly](score.ly) как отдельный
черновик с пустыми тактами для продолжения работы. Ритм и синхронизация рук
ещё черновые; MIDI использует темп 122 BPM и тембр overdriven guitar.
Ключевые знаки — два диеза, как в начале piano roll. Команда
`nix run .#render-avantasia--lost-in-space` по-прежнему собирает этот черновик
в `build/avantasia--lost-in-space/score.{pdf,midi}`, не заменяя piano roll.

Основной идентификатор — MusicBrainz Recording
[b0d93aa9-c69d-4b88-8432-1588eea622fc](https://musicbrainz.org/recording/b0d93aa9-c69d-4b88-8432-1588eea622fc).
Это студийная запись без уточнения версии; radio edit, alternate, extended,
video и концертные записи имеют отдельные MBID.

Metadata выбора находятся в
[reference/recordings.json](reference/recordings.json), а воспроизводимая
локальная сборка описана в [dvc.yaml](dvc.yaml).

Отдельно в [piano-roll.ly](piano-roll.ly) записана полная фортепианная
аранжировка Alejandro Ríos, восстановленная из
[piano-roll видео](https://www.youtube.com/watch?v=_-DEer9afE0).
Она хранится отдельно от черновика: 107 тактов, 4/4, 120 BPM, две руки.
Временные метки над нотами относятся к видео; MIDI начинается сразу с музыки,
без его первых 5,70 секунды. Моменты нажатий сохранены, а длительности
упрощены до восьмых и триольных восьмых без технических микропауз;
настоящая шестнадцатая в такте 52 сохранена. Динамика, педаль и авторские
штрихи не восстановлены.
Метод, ограничения и команды — в [piano-roll/README.md](piano-roll/README.md).
