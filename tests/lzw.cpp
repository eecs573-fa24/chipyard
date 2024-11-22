#include <bits/stdc++.h> 
#include "rocc.h"
using namespace std;

/*
    Lookup              - Decryption
    Lookup and Write       
    Write
    Reset
*/

static inline uint64_t CAM_lookup(char* input, int lenInput)
{
	// ROCC_INSTRUCTION_SS(0, data, idx, 0);
}

static inline uint64_t CAM_lookup_and_write(char* input, int lenInput)
{
	// unsigned long value;
	// ROCC_INSTRUCTION_DSS(0, value, 0, idx, 1);
	// return value;
}

static inline void CAM_write(int input, uint64_t value)
{
	// asm volatile ("fence");
	// ROCC_INSTRUCTION_SS(0, (uintptr_t) ptr, idx, 2);
}

static inline int CAM_reset()
{
	// ROCC_INSTRUCTION_SS(0, addend, idx, 3);
}






vector<int> encoding(string s1) 
{ 
    CAM_reset();
    cout << "Encoding\n"; 
    // unordered_map<string, int> table; 
    // for (int i = 0; i <= 255; i++) { 
    //     string ch = ""; 
    //     ch += char(i); 
    //     table[ch] = i; 
    // } 
  
    string p = "", c = ""; 
    p += s1[0]; 
    int code = 256; 
    vector<int> output_code;

    int output;

    cout << "String\tOutput_Code\tAddition\n"; 
    for (int i = 0; i < s1.length(); i++) { 
        if (i != s1.length() - 1) 
            c += s1[i + 1];
        // if (table.find(p + c) != table.end()) { 
        output = CAM_lookup_and_write(p+c);
        if (output != code) {
            p = p + c; 
        } 
        else {
            output = CAM_lookup(p);
            // cout << p << "\t" << table[p] << "\t\t" 
            //      << p + c << "\t" << code << endl;

            cout << p << "\t" << output << "\t\t" 
                 << p + c << "\t" << code << endl;  
            // output_code.push_back(table[p]);
            output_code.push_back(output); 
            // table[p + c] = code; 
            code++; 
            p = c; 
        } 
        c = ""; 
    } 
    // cout << p << "\t" << table[p] << endl; 
    cout << p << "\t" << output << endl; 
    output_code.push_back(output); 
    return output_code; 
} 
  



void decoding(vector<int> op) 
{ 
    CAM_reset();
    cout << "\nDecoding\n"; 
    // unordered_map<int, string> table; 
    // for (int i = 0; i <= 255; i++) { 
    //     string ch = ""; 
    //     ch += char(i); 
    //     table[i] = ch; 
    // } 

    int old = op[0];
    int n; 
    // string s = table[old]; 
    string s = CAM_lookup(old);
    string c = ""; 
    c += s[0]; 
    cout << s; 
    int count = 256;

    int output;
    for (int i = 0; i < op.size() - 1; i++) { 
        n = op[i + 1]; 
        output = CAM_lookup(n);
        // 
        // if (table.find(n) == table.end()) { 
        if (output == 4096) {
            // s = table[old];
            s = CAM_lookup(old); 
            s = s + c; 
        } 
        else { 
            // s = table[n]; 
            s = output;
        } 
        cout << s; 
        c = ""; 
        c += s[0]; 
        // table[count] = table[old] + c;
        CAM_write(count, CAM_lookup(old)+c);
        count++; 
        old = n; 
    } 
} 
int main() 
{ 
    // TODO: Set a size limit for lzw encoded/decoded strings?

    string s = "WYS*WYGWYS*WYSWYSG"; 
    vector<int> output_code = encoding(s); 
    cout << "Output Codes are: "; 
    for (int i = 0; i < output_code.size(); i++) { 
        cout << output_code[i] << " "; 
    } 
    cout << endl; 
    decoding(output_code); 
} 