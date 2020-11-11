import 'dart:io';

void main(List<String> arguments) {
  Solo('name');
}

class Solo {
  // String name = 'danane';

  factory Solo(String nam) {
    if (nam == 'name') {
      return Solo._name();
    }
  }

  Solo._name() {  
    String name = 'Abdjalil';
    print(name);
  }
}
