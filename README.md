# 레시피 관리 앱 (idg2recipes)

Flutter 기반 로컬 레시피 관리 애플리케이션입니다.

## 주요 기능

- ✅ 레시피 입력 및 저장 (이름, 재료, 조리법, 조리시간, 난이도, 인분)
- ✅ 레시피 조회 및 상세 보기
- ✅ 재료 기반 검색 - 보유한 재료로 만들 수 있는 레시피 찾기
- ✅ 재료 자동완성 및 직접 추가
- ✅ 완전 한글 지원

## 기술 스택

- **Flutter** - 크로스 플랫폼 UI 프레임워크
- **Riverpod** (riverpod_generator) - 상태 관리
- **Isar** - 고성능 로컬 데이터베이스
- **build_runner** - 코드 생성

## 시작하기

### 의존성 설치
```bash
flutter pub get
```

### 코드 생성
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 앱 실행
```bash
flutter run
```

### 개발 중 자동 코드 생성 (권장)
```bash
dart run build_runner watch --delete-conflicting-outputs
```

## 프로젝트 구조

```
lib/
├── main.dart                           # 앱 진입점
├── app.dart                            # MaterialApp 설정
├── core/
│   └── database/
│       └── isar_service.dart           # Isar DB 초기화
├── models/
│   ├── recipe.dart                     # Recipe 엔티티
│   └── ingredient.dart                 # Ingredient 엔티티
├── providers/
│   ├── database_provider.dart          # Isar 프로바이더
│   ├── recipe_provider.dart            # 레시피 프로바이더
│   └── ingredient_provider.dart        # 재료 프로바이더
├── repositories/
│   ├── recipe_repository.dart          # Recipe CRUD + 검색
│   └── ingredient_repository.dart      # Ingredient CRUD + 정규화
├── screens/
│   ├── home/
│   │   └── home_screen.dart            # 레시피 목록
│   ├── recipe_detail/
│   │   └── recipe_detail_screen.dart   # 레시피 상세
│   ├── recipe_form/
│   │   └── recipe_form_screen.dart     # 레시피 입력/수정
│   └── ingredient_search/
│       └── ingredient_search_screen.dart # 재료 검색
└── widgets/
    ├── recipe_card.dart                # 레시피 카드 위젯
    └── ingredient_chip.dart            # 재료 칩 위젯
```

## 주요 기능 설명

### 재료 기반 검색
보유한 재료를 선택하면:
1. 완전 일치 레시피 (모든 재료를 가지고 있음) 우선 표시
2. 부분 일치 레시피를 매칭률 순으로 정렬
3. 각 레시피의 매칭률 표시 (예: "✅ 만들 수 있어요!", "80% 일치")

### 재료 관리
- 재료명 자동 정규화 (공백 제거, 소문자 변환)로 중복 방지
- 검색 시 자동완성 지원
- 검색 결과가 없으면 새 재료 직접 추가 가능
- 사용 빈도 기반 정렬

## 향후 계획

- [ ] 레시피 이미지 업로드
- [ ] 카테고리/태그 분류
- [ ] 즐겨찾기 기능
- [ ] 레시피 공유 기능

## 라이선스

MIT License
