#include<iostream>
#include<stdio.h>
#include <stdlib.h>
#include <bits/stdc++.h>
#include<vector>
using namespace std;

int main(){
uint32_t code[17] = { 
0x00a00a13,
0xfff00a93,
0x00000513,
0x0000a103,
0x0280a183,
0x40310233,
0x00022b33,
0x000b1c63,
0x015a0a33,
0x00450533,
0x00408093,
0x000a0a63,
0xfc0a1ee3,
0x40218233,
0x00022b33,
0xfe0b02e3,
0x00100f93

};
    for (int i = 16 ; i>= 0 ; i--){
         cout<< hex <<setfill('0')<<setw(8)<<code[i];
    }

    return 0;
}