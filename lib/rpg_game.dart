import 'dart:io';
import 'dart:math';

class Character {
  String name;
  int health;
  int attack;
  int defense;

  Character(this.name, this.health, this.attack, this.defense);

  void attackMonster(Monster monster) {
    int damage = attack;
    monster.health -= damage;
    print("$name이(가) ${monster.name}에게 $damage의 데미지를 입혔습니다.");

    if (monster.health <= 0) {
      print("${monster.name}을(를) 물리쳤습니다!");
    }
  }
}

class Monster {
  String name;
  int health;
  int attack;

  Monster(this.name, this.health, this.attack);

  void attackCharacter(Character character) {
    int damage = max(attack - character.defense, 0);
    character.health -= damage;
    print("$name이(가) ${character.name}에게 $damage의 데미지를 입혔습니다.");
  }
}

class Game {
  Character? player;
  List<Monster> monsters = [];
  int defeatedMonsters = 0;

  Game();

  void startGame() {
    print("게임을 시작합니다!\n");
    battle();
  }

  void battle() {
    if (player == null || monsters.isEmpty) {
      print("전투를 시작할 수 없습니다.");
      return;
    }

    Monster monster = getRandomMonster();
    print("새로운 몬스터가 나타났습니다!");
    print("${monster.name} - 체력: ${monster.health}, 공격력: ${monster.attack}");

    while (player!.health > 0 && monster.health > 0) {
      print("\n${player!.name}의 턴");
      print("행동을 선택하세요 (1: 공격, 2: 방어): ");
      String? input = stdin.readLineSync();

      if (input == "1") {
        player!.attackMonster(monster);
      } else if (input == "2") {
        print("${player!.name}이(가) 방어 태세를 취합니다.");
      } else {
        print("잘못된 입력입니다. 다시 입력하세요.");
        continue;
      }

      if (monster.health <= 0) {
        monsters.remove(monster);
        print("${monster.name}을(를) 물리쳤습니다!");

        if (monsters.isEmpty) {
          print("\n축하합니다! 모든 몬스터를 처치했습니다.");
          return;
        }

        print("다음 몬스터와 싸우시겠습니까? (y/n)");
        String? next = stdin.readLineSync();
        if (next?.toLowerCase() != "y") {
          print("게임을 종료합니다.");
          return;
        } else {
          monster = getRandomMonster();
          print("새로운 몬스터가 나타났습니다.");
          print("${monster.name} - 체력: ${monster.health}, 공격력: ${monster.attack}");
        }
      }

      print("${monster.name}의 턴");
      monster.attackCharacter(player!);

      if (player!.health <= 0) {
        print("${player!.name}이(가) 쓰러졌습니다. 게임 오버!");
      }
    }
  }

  Monster getRandomMonster() {
    return monsters[Random().nextInt(monsters.length)];
  }

  void loadCharacterStats() {
    try {
      final file = File('./characters.txt');
      final contents = file.readAsStringSync();
      final stats = contents.split(',');

      if (stats.length != 3) throw FormatException('데이터 형식이 잘못되었습니다.');

      int health = int.parse(stats[0]);
      int attack = int.parse(stats[1]);
      int defense = int.parse(stats[2]);

      print("\n캐릭터의 이름을 입력하세요:");
      String? name = stdin.readLineSync();
      if (name == null || name.isEmpty) {
        print("이름이 올바르지 않습니다. 기본 이름을 사용합니다.");
        name = "Player";
      }

      player = Character(name, health, attack, defense);
      print("\n캐릭터 생성 완료: ${player!.name} (체력: $health, 공격력: $attack, 방어력: $defense)\n");
    } catch (e) {
      print('캐릭터 데이터를 불러오는 데 실패했습니다: $e');
      exit(1);
    }
  }

  void loadMonsterStats() {
    try {
      final file = File('./monsters.txt');
      final lines = file.readAsLinesSync();

      for (var line in lines) {
        final stats = line.split(',');

        if (stats.length != 3) throw FormatException('데이터 형식이 잘못되었습니다.');

        String name = stats[0];
        int health = int.parse(stats[1]);
        int maxAttack = int.parse(stats[2]);
        int attack = Random().nextInt(maxAttack) + 1;

        monsters.add(Monster(name, health, attack));
      }

      print("몬스터 목록 불러오기 완료!");
      for (var monster in monsters) {
        print("${monster.name} (체력: ${monster.health}, 공격력: ${monster.attack})");
      }
    } catch (e) {
      print('몬스터 데이터를 불러오는 데 실패했습니다: $e');
      exit(1);
    }
  }
}

void main() {
  Game game = Game();
  game.loadCharacterStats();
  game.loadMonsterStats();
  game.startGame();
}
