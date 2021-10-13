# Firebase Realtime Database Chat

- Realtime Database
  - It uses `Firebase Realtime Database` for saving chat messages.
  - 채팅메시지는 realtime database 에 모두 저장하는 것이 좋다.
    괜히 채팅메시지를 백엔드(또는 RDBMS Database)에 저장하고, `Firebase Realtime Database` 를 realtime update 용으로만 사용하려 한다면 문제는 매우 복잡 해 질 수 있다.
    예를 들어, 채팅창이 여러개 동시에 열려 있는 경우, realtime update 가 발생하면 어느 메시지가 어느 챗 룸에 속하는진지 찾아야하는데 그러한 것 자체가 코드 복잡도가 높아지는 부담이 되며, 이 뿐만아니라 여러가지 문제가 발생 할 수 있다.
    - 다만, 원한다면, 기본적으로 모든 채팅 메시지는 `Firebase Realtime Database` 에 저장하되, callback 함수를 통해서 추가적으로 백엔드에 추가 할 수 있다. 그래서 채팅 메시지를 검색하게 할 수 있다.

- Chat logic agnostic
  - It provides chat functionality only. That means, chat users do not have to have Firebase auth account. Instead, the app must provide user ifnormation like user id, name, profile photo url.
    - In this way, this chat framework can be used by any existing apps.

- Chat UI agnostic
  - You can develop your own chat UI if you don't like the default one. Just copy the built-in UI and adjust them on your needs.


- 1:1 chat
  - Our original goal is to support one and one chat only. And offer our clients to use 3rd party chat app for multi user chats in one chat room.


- User can chat to himself
  - Like most of chat app, it allows to chat himself. When he has two phone, he can send message or photo from one device to another.



# Database Structure

- Chat message folder
  - `/chat/messages/[roomId]/[auto-generated-key]/{... properties ...}`



