package shared_pkg;

    typedef enum {write_addr, write_data, read_addr, read_data}operation_t;
    typedef enum {IDLE, CHK_CMD, WRITE,  READ_ADD ,READ_DATA}state_t;

endpackage