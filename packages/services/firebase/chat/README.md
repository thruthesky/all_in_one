# Firebase Firestore Chat

- Chat logic agnostic
  - It provides chat functionality only. That means, chat users do not have to have Firebase auth account. Instead, the app must provide user ifnormation like user id, name, profile photo url.
    - In this way, this chat framework can be used by any existing apps.

- Chat UI agnostic
  - You can develop your own chat UI if you don't like the default one. Just copy the built-in UI and adjust them on your needs.


- 1:1 chat
  - Our original goal is to support one and one chat only. And offer our clients to use 3rd party chat app for multi user chats in one chat room.


- User can chat to himself
  - Like most of chat app, it allows to chat himself. When he has two phone, he can send message or photo from one device to another.



# Firestore Database Structure & Chat room id and Firebase UID


- 1:1 채팅이기 때문에, 메시지를 하나의 공간에 저장한다.
- 메시지 저장 공간은 `/chat/messages/[room-id]` 이다.
- `room-id` 는 `[firebaseUid]__[firebaseUid]` 로 구성되며, 두 유저의 Firebase UID 를 알파벳 순서로 정렬해서 정한다.
  즉, 사용자 A 와 B 가 있는 경우, A 의 UID 가 알파벳순으로 뒤에 있다면, room-id 는 `B__A` 가 된다.
  이로 인해서, room-id 를 몰라도, 두 사용자의 Firebase UID 만 아는 경우, room-id 를 만들 수 있다.


- 방삭제
  - 방을 삭제하는 기능은 따로 없다.
  - 다만, 방 목록에서 삭제를 하면, `/chat/rooms/[my-uid]/[other-uid]` 만 삭제된다.
    - 즉, 데이터는 그대로 남아 있다. 이것이 필요한 이유는 나의 방 목록에서, 너무 많은 사용자가 있고 또, 별로 필요 없는 사용자가 있는 경우, 그 사용자만 안보이게 하는 것이다.
      - 만약, 다시 그 사용자와 채팅을 하게 되면, 다시 그 사용자가 방목록에 나타나며, 채팅 메시지도 이전의 것이 그대로 남아 있어, 이전 메시지를 다 볼 수 있다.





## Modeling

- `/chat/messages` 에 저장되는 문서와 `/chat/rooms` 에 저장도는 문서의 포멧이 매우 흡사하다. 그래서 `ChatDataModel` 로 통합해서 사용한다.