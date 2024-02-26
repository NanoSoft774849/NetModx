#ifndef __defs__p4
#define __defs__p4

// table size for MODulations types 
#define MOD_TABLE_SIZE 32
// Number of bits per IQ symbol
#define IQ_BITS_PER_SYMBOL  16
//the number of bits in the b's in the net_mod_payload_hdr_t 
#define PAYLOAD_BITS_PER_B  16
// The number of IQs in the main header struct 
#define IQ_HDRS_COUNT  16
// the number of payloads in the main header struct
#define PAYLOAD_HDRS_COUNT  8
// the number of s_i in the net_mod_iq_hdr_t
#define IQ_HDR_S_COUNT 16
// the number of b_i in the net_mod_payload_hdr_t
#define PAYLOAD_HDR_B_COUNT 8

#define NET_MOD_RECIRCULATION_PORT 192

//#define hs_IQ_count (PAYLOAD_HDR_B_COUNT * PAYLOAD_BITS_PER_B * hdr.mod.mhl)
// define header types for each modulation fro the payload
#define PB_BPSK_BITS_PER_B 16
#define PB_QPSK_BITS_PER_B 16
#define PB_QAM16_BITS_PER_B 16
#define PB_QAM64_BITS_PER_B 6
#define PB_QAM256_BITS_PER_B 16

typedef bit<PB_BPSK_BITS_PER_B> bpsk_t;
typedef bit<PB_QPSK_BITS_PER_B> qpsk_t;
typedef bit<PB_QAM16_BITS_PER_B> qam16_t;
typedef bit<PB_QAM64_BITS_PER_B> qam64_t;
typedef bit<PB_QAM256_BITS_PER_B> qam256_t;
// for modulation compression (MC)
// please refer to ETSI TS 103 859 v7.0.2 ( 2022-09) sepcification (page 251)
#define MC_BPSK_BITS_PER_S 4
#define MC_QPSK_BITS_PER_S 2
#define MC_QAM16_BITS_PER_S 4
#define MC_QAM64_BITS_PER_S 6
#define MC_QAM256_BITS_PER_S 8

// for 128-bit payload header
#define IQ_STR_BPSK_IQ_COUNT 8
#define IQ_STR_QPSK_IQ_COUNT 4
#define IQ_STR_QAM16_IQ_COUNT 2
#define IQ_STR_QAM64_IQ_COUNT 2
#define IQ_STR_QAM256_IQ_COUNT 1


// MC data types for IQ symbols 

typedef bit<MC_BPSK_BITS_PER_S> mc_iq_bpsk_t;
typedef bit<MC_QPSK_BITS_PER_S> mc_iq_qpsk_t;
typedef bit<MC_QAM16_BITS_PER_S> mc_iq_qam16_t;
typedef bit<MC_QAM64_BITS_PER_S> mc_iq_qam64_t;
typedef bit<MC_QAM256_BITS_PER_S> mc_iq_qam256_t;


typedef bit<IQ_BITS_PER_SYMBOL> iq_t;
typedef bit<PAYLOAD_BITS_PER_B>   bs_t;
// ttc must be 8-bits otherwise an error occurs.
typedef bit<8> ttc_t;

const bit<32> BITS_PER_PAYLOAD_HDR = PAYLOAD_HDR_B_COUNT * PAYLOAD_BITS_PER_B;
//* hdr.mod.mhl
const  bit<32> hs_IQ_count = BITS_PER_PAYLOAD_HDR;

typedef bit<48> mac_addr_t;
//typedef bit<32> int32;
//typedef bit<32> key_t;
//typedef bit<32> var_t;
typedef bit<16> port_addr_t;
typedef bit<32> ipv4_addr_t;

typedef bit<32> index_t;
//typedef bit<32> counter_t;

//#define NEXTHOP_ID_WIDTH 14
//typedef bit<NEXTHOP_ID_WIDTH> nexthop_id_t;
//const int NEXTHOP_SIZE = 1 << NEXTHOP_ID_WIDTH;

/* Header Stuff */
enum bit<16> ether_type_t {
    TPID = 0x8100,
    IPV4 = 0x0800,
    ARP  = 0x0806,
    IPV6 = 0x86DD,
    MPLS = 0x8847
}

enum bit<8> ip_protocol_t {
    ICMP = 1,
    IGMP = 2,
    TCP  = 6,
    UDP  = 17
}

enum bit<16> arp_opcode_t {
    REQUEST = 1,
    REPLY   = 2
}


enum bit<8> icmp_type_t {
    ECHO_REPLY   = 0,
    ECHO_REQUEST = 8
}

#endif