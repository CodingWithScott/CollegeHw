// Byte-to-Binary converter
// http://stackoverflow.com/questions/111928/is-there-a-printf-converter-to-print-in-binary-format

#define BYTETOBINARYPATTERN "%d%d%d%d%d%d%d%d"
#define BYTETOBINARY(byte)  \
  (byte & 0x80 ? 1 : 0), \
  (byte & 0x40 ? 1 : 0), \
  (byte & 0x20 ? 1 : 0), \
  (byte & 0x10 ? 1 : 0), \
  (byte & 0x08 ? 1 : 0), \
  (byte & 0x04 ? 1 : 0), \
  (byte & 0x02 ? 1 : 0), \
  (byte & 0x01 ? 1 : 0) 

// usage:

  printf ("Leading text "BYTETOBINARYPATTERN, BYTETOBINARY(byte));

// For multi-byte types:

printf("M: "BYTETOBINARYPATTERN" "BYTETOBINARYPATTERN"\n",
  BYTETOBINARY(M>>8), BYTETOBINARY(M));
