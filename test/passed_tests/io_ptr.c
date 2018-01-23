#define IO_UNIT_SR (char*)(0xFAF10004)

int ui_state() {
    return *IO_UNIT_SR & 0x01;
}