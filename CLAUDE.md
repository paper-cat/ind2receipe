# CLAUDE.md
## Project Overview

Flutter 기반 레시피 기록 앱.
재료들로 검색 및 색인이 가능합니다.

## Always
- 한글로 대답
- 작업을 끝낸 뒤, 간결하게 설명.

## Tech Stack



## Commands



## Project Structure



## Code Style


## Before Coding

1. 기존 코드 패턴 먼저 확인
2. 관련 모델/프로바이더가 이미 있는지 검색
3. 복잡한 기능은 먼저 설계 논의
4. Riverpod/Isar 코드 변경 시 build_runner 실행 필요

## After Coding
1. 에러 수정
2. 타입 에러 수정
3. 화면에서 한국어 Text 깨지는 것 확인 (intl 초기화 필요)

## Don't
- Riverpod 프로바이더를 수동으로 작성하지 말 것 → riverpod_generator 사용
- Isar 엔티티 수정 후 build_runner 실행하지 않으면 컴파일 에러 발생
- 전역 변수 금지
- `*` import 금지 → 명시적 import
