# miniReddit

miniReddit - это приложение для просмотра постов с [Reddit](https://www.reddit.com).

![Imgur](https://i.imgur.com/2rUplMw.png)

## Запуск

**miniReddit** может загружать посты в режиме инкогнито, для авторизации можно использовать свой личный аккаунт или воспользовать этим:
- Login: **miniredditaccount**
- Psssword: **fLyr&63fhFHf**

Для работы **miniReddit** требуется `CLIENT_ID`, который находится в конфигурацонном файле - [/Configuration/Config.xcconfig](https://github.com/alexandersimbirtsev/miniReddit/blob/main/miniReddit/Configuration/Config.xcconfig).

Если он не работает, его можно получить самостоятельно [по инструкции](https://github.com/reddit-archive/reddit/wiki/OAuth2) или написать мне на почту alexandersimbirtcev@gmail.com.

## Сервисы Reddit

Для загрузки постов используется - [Reddit API](https://www.reddit.com/dev/api).

Авторизация происходит по протоколу OAuth2 - [Reddit OAuth2](https://github.com/reddit-archive/reddit/wiki/OAuth2).

## Приложение

В приложении не используются сторонние библиотеки.

Приложение адаптировано для работы в вертикальной и горизонтальной ориентации.

iOS Deployment Target - **iOS 13**.

### Описание

#### Архитектура

Архитектура приложения в **miniReddit** строится на координаторах, фабриках, роутере и модулях.

Каждый модуль включает в себя **View**, **ViewController**, **Model** и **Provider**.

Внутри модуля все части общаются друг с другом через протоколы.

**Provider**(это viewModel/presenter/interactor и т.д.) - предоставляет данные и сервисы для работы модуля.

[Общие сервисы](https://github.com/alexandersimbirtsev/miniReddit/tree/main/miniReddit/Services) закрыты протоколами и с использованием адаптеров они инжектятся в модули.

#### Работа приложения

Работа **miniReddit** начинается со сборки и старта координатора в [/Application/Lifecycle/SceneDelegate.swift](https://github.com/alexandersimbirtsev/miniReddit/blob/main/miniReddit/Application/Lifecycle/SceneDelegate.swift).

В приложении 2 модуля [Posts](https://github.com/alexandersimbirtsev/miniReddit/tree/main/miniReddit/Modules/Posts) и [Account](https://github.com/alexandersimbirtsev/miniReddit/tree/main/miniReddit/Modules/Account), каждый собирается с использованием своей фабрики [Posts factory](https://github.com/alexandersimbirtsev/miniReddit/blob/main/miniReddit/Modules/Posts/PostsModule.swift) и [Account factory](https://github.com/alexandersimbirtsev/miniReddit/blob/main/miniReddit/Modules/Account/AccountModule.swift).

Есть 2 состояния: **режим инкогнито** и **авторизован**.

В режиме **авторизован**, при выполнении запросов к **Reddit API**, используется `accessToken`, если его действие истекло, то будет вызван запрос на обновление токена с `refreshToken`, после чего основной запрос будет выполнен с новым `accessToken` - [Реализация с fallback](https://github.com/alexandersimbirtsev/miniReddit/blob/main/miniReddit/Services/Network/Abstractions/NetworkDataLoaderWithUnauthorizedFallback.swift) через [unauthorizedFallback](https://github.com/alexandersimbirtsev/miniReddit/blob/main/miniReddit/Services/Network/Protocols/URLSessionRequestDataLoader.swift).

Хранилищем для токенов выступает [Keychain](https://github.com/alexandersimbirtsev/miniReddit/blob/main/miniReddit/Services/SecureStorage/KeychainSecureStorage.swift).

Загрузка изображений постов в таблице выполняется с помощью *Operation* и *OperationQueue* с последующим кешированием. [Реализация](https://github.com/alexandersimbirtsev/miniReddit/blob/main/miniReddit/Services/Concurrent%20loader/ConcurrentDataLoader.swift).

Для удобства авторизации по OAuth2 используется *ASWebAuthenticationSession*. [Реализация](https://github.com/alexandersimbirtsev/miniReddit/blob/main/miniReddit/Services/AuthenticationCallbackRetriever.swift).
