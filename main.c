#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>
#include "structs.h"
#include "functions.h"

#define MAX_SIZE 256

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
