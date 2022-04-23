#ifndef FUNCTIONS_H_
#define FUNCTIONS_H_

int add_last(void **arr, int *len, data_structure *data);

int add_at(void **arr, int *len, data_structure *data, int index);

void find(void *data_block, int len, int index);

int delete_at(void **arr, int *len, int index);

int pack_data(data_structure *data_s);

#endif  // FUNCTIONS_H_
