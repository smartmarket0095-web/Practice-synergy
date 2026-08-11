# Как загрузить проект в GitHub

1. Создайте новый репозиторий на GitHub, например `practice-project`.
2. Распакуйте этот архив.
3. Загрузите содержимое папки в репозиторий.
4. Нажмите **Commit changes**.

Если Git установлен на компьютере:

```bash
git init
git add .
git commit -m "Добавлен проект по учебной практике"
git branch -M main
git remote add origin https://github.com/ВАШ_ЛОГИН/practice-project.git
git push -u origin main
```

После загрузки ссылку вида

`https://github.com/ВАШ_ЛОГИН/practice-project`

можно указать в отчёте по практике.
