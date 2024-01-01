double abs(double a){return a>0?a:-a;}

class MyPoint{

  //qwerty[which board][vertical height of the board][horizontal width of the board][n/height of the stack]=double;
  //qwerty[x][y][z][n]=double;
  int x=0;
  int y=0;
  int z=0;

  MyPoint({int x=0,int y=0,int z=0}){
    this.x=x;
    this.y=y;
    this.z=z;
  }

  void zero(){
    this.x=0;
    this.y=0;
    this.z=0;
  }
  void nagOne(){
    this.x=-1;
    this.y=-1;
    this.z=-1;
  }

  void myPrint(){
    print('${this.x},     ${this.y},     ${this.z}');
  }

  double getLastNumber({required List<List<List<List<double>>>> arr}){return arr[x][y][z].last;}

  void popNumber({required List<List<List<List<double>>>> arr}){
    if(getLastNumber(arr: arr)==0){return;}
    arr[x][y][z].removeLast();
  }

  void insertNumber({required List<List<List<List<double>>>> arr,required double num}){
    arr[x][y][z].add(num);
  }
}
