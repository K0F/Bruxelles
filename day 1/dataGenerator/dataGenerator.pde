

int myLenght = 400; 

String ab[];
ab = new String[myLenght];

for (int i =0 ; i < ab.length ;i ++) {
  ab[i] = ""+noise(i/30.0)*400;
}

saveStrings("data.txt", ab);


