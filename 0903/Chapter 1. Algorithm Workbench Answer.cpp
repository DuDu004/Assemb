#include <iostream>
#include <string>

//1
int toInt2(string s) {
	int num = 0;
	for (int i = 0; s[i] >= '0' && s[i] <= '1'; i++) {
		num = num * 2 + s[i] - '0';
	}
	return num;
}

//2
int toInt16(string s) {
	int num = 0;
	for (int i = 0; ; i++) {
		if (s[i] >= '0' && s[i] <= '9')
			num = num * 16 + s[i] - '0';
		else if (s[i] >= 'A' && s[i] <= 'F')
			num = num * 16 + (s[i] - 'A' + 10);
		else
			break;
	}
	return num;
}

//3
string intTostr(int n) {
	if (n == 0)
		return 0;

	string result = "";

	while (n > 0) {
		int remainder = n % 2;
		result = (char)('0' + remainder) + result;
		n = n / 2;
	}
	return result;
}

//4
string intTo16(int n) {
	if (n == 0)
		return "0";

	string result = "";

	while (n > 0) {
		int remainder = n % 16;
		char digit;

		if (remainder < 10) {
			digit = (char)('0' + remainder);
		}
		else {
			digit = (char)('A' + remainder - 10);
		}
		result = digit + result;
		n = n / 16;
	}
	return result;
}

//5
string strTostr(string a, string b, int Base) {
	int i = a.length() - 1;
	int j = b.length() - 1;
	int carry = 0;
	string result = "";

	while (i >= 0 || j >= 0 || carry != 0) {
		int x = 0;
		int y = 0;

		if (i >= 0) {
			x = a.charAt(i) - '0';
			i--;
		}
		if (j >= 0) {
			y = b.charAt(j) - '0';
			j--;
		}

		int sum = x + y + carry;
		int digit = sum % Base;
		carry = sum / Base;

		result = (char)('0' + digit) + result;
	}

	return result;
}

//6
int str16Toint(char c) {
	if (c >= '0' && c <= '9') {
		return c - '0';
	}
	if (c >= 'A' && c <= 'F') {
		return c - 'A' + 10;
	}
	return c - 'a' + 10;
}
char int16Tostr(int n) {
	if (n < 10) {
		return char('0' + n);
	}
	return char('A' + n - 10);
}
string add16(string a, string b) {
	int i = a.length() - 1;
	int j = b.length() - 1;
	int carry = 0;
	string result = "";

	while (i >= 0 || j >= 0 || carry > 0) {
		int x = 0;
		int y = 0;

		if (i >= 0) {
			x = str16Toint(a[i]);
			i--;
		}
		if (j >= 0) {
			y = str16Toint(b[j]);
			j--;
		}

		int sum = x + y + carry;
		int digit = sum % 16;
		carry = sum / 16;
		result = int16Tostr(digit) + result;
	}
	return result;
}

//7
string multiply16(char digit, string s) {
	int multi = str16Toint(digit);
	int carry = 0;
	string result = "";

	for (int i = s.length() - 1; i >= 0; i--) {
		int value = str16Toint(s[i]);
		int product = value * multi + carry;
		int digitResult = product % 16;
		carry = product / 16;

		result = int16Tostr(digitResult) + result;
	}

	while (carry > 0) {
		result = int16Tostr(carry % 16) + result;
		carry = carry / 16;
	}

	return result;
}

//9
string subtractBinary(string a, string b) {
	int i = a.length() - 1;
	int j = b.length() - 1;
	int borrow = 0;
	string result = "";

	while (i >= 0) {
		int x = a[i] - '0';
		int y = 0;

		if (j >= 0) {
			y = b[j] - '0';
			j--;
		}

		x = x - borrow;

		if (x < y) {
			x = x + 2;
			borrow = 1;
		}
		else {
			borrow = 0;
		}

		int digit = x - y;

		result = char('0' + digit) + result;

		i--;
	}

	return result;
}
