# Firestore CRUD Example

## 프로젝트 소개 👨‍💻
이 프로젝트는 Flutter 애플리케이션에서 Firebase Firestore를 사용하여 CRUD(생성, 읽기, 업데이트, 삭제) 작업을 수행하는 간단한 예제. 사용자는 이름과 나이를 입력하고, 이 정보를 Firebase Firestore에 저장할 수 있으며, 저장된 데이터를 실시간으로 스트리밍하여 표시하고, 업데이트 및 삭제할 수 있음. Firebase와 Firestore에 대한 Crud 예제.

## 주요 기능 ✨
사용자 생성: 이름과 나이를 입력하여 새로운 사용자 데이터를 Firestore에 저장.
사용자 목록 읽기: Firestore에 저장된 사용자 데이터를 실시간으로 읽어 화면에 표시.
사용자 업데이트: 사용자 정보를 수정할 수 있으며, 이 정보는 Firestore에 실시간으로 반영.
사용자 삭제: Firestore에서 사용자를 삭제할 수 있음.

## 주요 파일 구조 🗂️
main.dart: 애플리케이션의 진입점이며, Firebase 초기화 및 Firestore CRUD 작업을 위한 메인 로직이 포함.
Firestore에 연결하여 사용자 데이터를 관리하고, StreamBuilder를 통해 실시간으로 사용자 목록을 표시.

## 사용된 패키지 📦
firebase_core: Firebase 초기화를 위한 패키지.
cloud_firestore: Firebase Firestore와의 통합을 위한 패키지로, Firestore CRUD 작업을 수행할 수 있음.
