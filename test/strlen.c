int strlen(char* p) {
	int l = 0;
	while (*(p++))
		++l;
	return l;
}