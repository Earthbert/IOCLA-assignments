#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>
#include "structs.h"

#define MAX_SIZE 256

#define DEBUG

int add_last(void **arr, int *len, data_structure *data)
{
	char *last_p = *arr;  // will point to the end of the arr
	for (int i = 0; i < *len; i++) {
		head *curr = (head *)last_p;
		last_p = last_p + sizeof(head) + curr->len;
	}

	u_int64_t arr_size = (u_int64_t)last_p - (u_int64_t)*arr;
	char *tmp = realloc(*arr, arr_size + sizeof(head) + data->header->len);
	if (tmp == NULL) {
		fprintf(stderr, "Realloc error in add_last");
		return 0;
	}

	memcpy(tmp + arr_size, data->header, sizeof(head));
	memcpy(tmp + arr_size + sizeof(head), data->data, data->header->len);

	*arr = (void *)tmp;
	*len = *len + 1;
	return 1;
}

int add_at(void **arr, int *len, data_structure *data, int index)
{
	if (index < 0 || index > *len)
		return 0;

	if (index == *len) {
		add_last(arr, len, data);
		return 1;
	}

	char *last_p = *arr;  // will point to the end of the arr
	char *add_p;  // will point to the data from index

	for (int i = 0; i < *len; i++) {
		if (i == index)
			add_p = last_p;
		head *curr = (head *)last_p;
		last_p = last_p + sizeof(head) + curr->len;
	}

	// total nr of bytes of arr
	u_int64_t arr_size = (u_int64_t)last_p - (u_int64_t)*arr;

	char *tmp = malloc(arr_size + sizeof(head) + data->header->len);
	if (tmp == NULL) {
		fprintf(stderr, "Realloc error in add_at");
		return 0;
	}

	uint64_t copy_size = (uint64_t)add_p - (uint64_t)*arr;

	memcpy(tmp, *arr, copy_size);
	memcpy(tmp + copy_size, data->header, sizeof(head));
	memcpy(tmp + copy_size + sizeof(head), data->data, data->header->len);
	memcpy(tmp + copy_size + sizeof(head) + data->header->len, add_p, arr_size - copy_size);

	free(*arr);
	*arr = (void *)tmp;
	*len = *len + 1;
	return 1;
}

void print_data(void *data, u_char type) {
	printf("Tipul %d\n", type);
	if (type == 1) {
		char *name1 = data;
		char *bac1 = data + strlen(name1) + 1;
		char *bac2 = bac1 + sizeof(int8_t);
		char *name2 = bac2 + sizeof(int8_t);
		printf("%s pentru %s\n", name1, name2);
		printf("%hhd\n%hhd\n", *(int8_t *)bac1, *(int8_t *)bac2);
	}
	if (type == 2) {
		char *name1 = data;
		char *bac1 = data + strlen(name1) + 1;
		char *bac2 = bac1 + sizeof(int16_t);
		char *name2 = bac2 + sizeof(int32_t);
		printf("%s pentru %s\n", name1, name2);
		printf("%hd\n%d\n", *(int16_t *)bac1, *(int32_t *)bac2);
	}
	if (type == 3) {
		char *name1 = data;
		char *bac1 = data + strlen(name1) + 1;
		char *bac2 = bac1 + sizeof(int32_t);
		char *name2 = bac2 + sizeof(int32_t);
		printf("%s pentru %s\n", name1, name2);
		printf("%d\n%d\n", *(int32_t *)bac1, *(int32_t *)bac2);
	}
}

void find(void *data_block, int len, int index) 
{
	if (index < 0 || len <= 0)
		return;
	if (index >= len)
		index = len - 1;

	char *print_p = data_block;
	for (int i = 0; i < index; i++) {
		head *curr = (head *)print_p;
		print_p = print_p + sizeof(head) + curr->len;
	}

	head *data_s = (head *)print_p;
	print_data(print_p + sizeof(head), data_s->type);
}

int delete_at(void **arr, int *len, int index)
{
	if (index < 0)
		return 0;
	if (index >= *len)
		index = *len - 1;

	char *last_p;
	char *del_p;
	for (int i = 0; i < *len; i++) {
		if (i == index)
			del_p = last_p;
		head *curr = (head *)last_p;
		last_p = last_p + sizeof(head) + curr->len;
	}

	u_int64_t arr_size = (uint64_t)last_p - (uint64_t)*arr;
	head *del_s = (head *)del_p;
	u_int64_t del_size = sizeof(head) + del_s->len;
	u_int64_t remain_size = arr_size - ((uint64_t)del_p -(uint64_t)*arr);

	char *buffer = calloc(1, remain_size);
	if (buffer == NULL) {
		fprintf(stderr, "Calloc error in delete_at");
		return 0;
	}
	memcpy(buffer, del_p + del_size, remain_size);

	char *tmp = realloc(*arr, arr_size - del_size);
	if (buffer == NULL) {
		fprintf(stderr, "Realloc error in delete_at");
		return 0;
	}
	memcpy(buffer, tmp + (last_p - del_p), remain_size);

	*arr = tmp;
	*len = *len - 1;
	return 1;
}

int pack_data(data_structure *data_s) {
	u_char type;
	scanf("%hhd", &type);
	data_s->header->type = type;

	char *data = malloc(MAX_SIZE);
	if (data == NULL)
		return 0;

	int contor = 0;
	scanf("%s", data);
	data[strlen(data)] = '\0';
	contor = contor + strlen(data) + 1;

	if (type == 1) {
		scanf("%hhd", (int8_t *)(data + contor));
		contor = contor + sizeof(int8_t);
		scanf("%hhd", (int8_t *)(data + contor));
		contor = contor + sizeof(int8_t);
	}
	if (type == 2) {
		scanf("%hd", (int16_t *)(data + contor));
		contor = contor + sizeof(int16_t);
		scanf("%d", (int32_t *)(data + contor));
		contor = contor + sizeof(int32_t);
	}
	if (type == 3) {
		scanf("%d", (int32_t *)(data + contor));
		printf("Bac1 : %d\n", *(int32_t *)(data + contor));
		contor = contor + sizeof(int32_t);
		scanf("%d", (int32_t *)(data + contor));
		printf("Bac2 : %d\n", *(int32_t *)(data + contor));
		contor = contor + sizeof(int32_t);
	}
	
	scanf("%s", data + contor);
	contor = contor + strlen(data + contor) + 1;
	data[contor] = '\0';

	data_s->header->len = contor;
	data_s->data = data;
	return 1;
}

int main() {
	// the vector of bytes u have to work with
	// good luck :)
	void *arr = NULL;
	int len = 0;
	char *command = calloc(MAX_SIZE, sizeof(char));

	// will be used at input
	data_structure *data_s = calloc(1, sizeof(data_structure));
	data_s->header = calloc(1, sizeof(head));

	while (1) {
		scanf("%s", command);
		if (!strcmp(command, "insert")) {
			pack_data(data_s);
			add_last(&arr, &len, data_s);
			free(data_s->data);
		}
		if (!strcmp(command, "insert_at")) {
			int index;
			scanf("%d", &index);
			pack_data(data_s);
			add_at(&arr, &len, data_s, index);
			free(data_s->data);
		}
		if (!strcmp(command, "delete_at")) {
			int index;
			scanf("%d", &index);
			delete_at(&arr, &len, index);
		}
		if (!strcmp(command, "find")) {
			int index;
			scanf("%d", &index);
			find(arr, len, index);
		}
		if (!strcmp(command, "print")) {
			for (int i = 0; i < len; i++) {
				find(arr, len, i);
			}
		}
		if (!strcmp(command, "exit")) {
			break;
		}
	}

	if (arr)
		free(arr);
	free(command);
	free(data_s->header);
	free(data_s);
	return 0;
}
