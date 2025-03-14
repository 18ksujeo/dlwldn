class Product {
String name;
int price;

Product(this.name, this.price);
}

class ShoppingMall {
List<Product> products;
int totalPrice = 0;

ShoppingMall(this.products);

void showProducts() {
for (Product item in products){
  print("${item.name}/${item.price}원");
}
} 

List<Product> cart = [];

void addToCart(String name, int quantity){
for (Product item in products){
  if (item.name == name){
    if (quantity <= 0){
      print("0개보다 많은 개수의 상품만 담을 수 있어요!");
      return;
    }

    cart.add(item);

    print("장바구니에 상품이 담겼어요!");
    return;
  }
}
}
}

void main() {
List<Product> items = [
  Product("셔츠", 45000),
  Product("원피스", 30000),
  Product("반팔티", 35000),
  Product("반바지", 30000),
  Product("양말", 5000)
];

ShoppingMall mall = ShoppingMall(items);
print("상품 목록이 쇼핑몰이 추가되었습니다.");

mall.showProducts();
}

/*
1->판매하는 상품 목록을 출력
2->상품 이름과 개수를 입력받아 장바구니에 추가
3->장바구니 총 가격을 출력
4->프로그램 종료
다른 입력->"잘못된 입력입니다."
*/