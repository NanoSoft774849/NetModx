#ifndef __headers__p4

#define __headers__p4


#include"defs.p4"
#include"netModHeaders.p4"

header ethernet_h{
    mac_addr_t dst_addr;
    mac_addr_t src_addr;
    bit<16> ether_type;
}


header ipv4_h {
    bit<4>   version;
    bit<4>   ihl;
    bit<8>   diffserv;
    bit<16>  total_len;
    bit<16>  identification;
    bit<3>   flags;
    bit<13>  frag_offset;
    bit<8>   ttl;
    bit<8>   protocol;
    bit<16>  hdr_checksum;
    ipv4_addr_t  src_addr;
    ipv4_addr_t  dst_addr;
}
header udp_h 
{
    port_addr_t src_port;
    port_addr_t dest_port;
    bit<16> len;
    bit<16> checksum;
}

header icmp_h {
    icmp_type_t msg_type;
    bit<8>      msg_code;
    bit<16>     checksum;
}

header arp_h {
    bit<16>       hw_type;
    ether_type_t  proto_type;
    bit<8>        hw_addr_len;
    bit<8>        proto_addr_len;
    arp_opcode_t  opcode;
} 

header arp_ipv4_h {
    mac_addr_t   src_hw_addr;
    ipv4_addr_t  src_proto_addr;
    mac_addr_t   dst_hw_addr;
    ipv4_addr_t  dst_proto_addr;
}





header net_mod_hdr_t
{
    // for enable circulation
    bit<1> ec;
    // for parsing 
    //bit<1> bos;
    // net mod header len : number of net_mod_payload_hdrs in the packet..
    bit<7> mhl;
    // bits per Symbol ( 1, 2 , 4, 6, 8) for ( BPSK, QPSK, QAM16, ...)
    bit<8> bps;
    // Modulation Level 2**bps;
    bit<16> M;
    // payload sequence.
    bit<32> seq;
    bit<8> worker_id;
}
// Input payload header
// header net_mod_payload_hdr_t
// {
//     bs_t b0;
//     bs_t b1;
//     bs_t b2;
//     bs_t b3;
//     bs_t b4;
//     bs_t b5;
//     bs_t b6;
//     bs_t b7;
// }
// Output IQ symbols header..
// header net_mod_iq_hdr_t
// {
//     iq_t s0;
//     iq_t s1;
//     iq_t s2;
//     iq_t s3;
//     iq_t s4;
//     iq_t s5;
//     iq_t s6;
//     iq_t s7;
// }

// RECIRCULATION header
header net_mod_circ_hdr_t 
{
    // time to recirc
    ttc_t ttc;
    ttc_t bps;
    index_t index; // GP index
    bit<8> payload_hdr_index;
    bit<8> payload_b_index;
    bit<8> payload_b_shift_cntr;
    bit<8> payload_hdr_shift_cntr;
    // this will be incremented when we reach IQ_HDR_S_COUNT
    bit<8> iq_hdr_index;
    // this will be incrememted every circirulation iteration
    bit<8> iq_s_index;
    bs_t current_payload_b;
    bit<8> iq_hdr_end;
}
// hdr.circ_bpsk.iq_hdr_end, hdr.circ_bpsk.iq_hdr_index)
header net_mod_circ_hdr_bpsk_t 
{
    ttc_t ttc;
    ttc_t bps;
    index_t index; // GP index
    bit<8> payload_hdr_index;
    bit<8> payload_b_index;
    bit<8> payload_b_shift_cntr;
    bit<8> payload_hdr_shift_cntr;
    // this will be incremented when we reach IQ_HDR_S_COUNT
    bit<8> iq_hdr_index;
    // this will be incrememted every circirulation iteration
    bit<8> iq_s_index;
    bpsk_t current_payload_b;
    bit<8> iq_hdr_end;
    
}
header net_mod_circ_hdr_qpsk_t
{
   ttc_t ttc;
    ttc_t bps;
    index_t index; // GP index
    bit<8> payload_hdr_index;
    bit<8> payload_b_index;
    bit<8> payload_b_shift_cntr;
    bit<8> payload_hdr_shift_cntr;
    // this will be incremented when we reach IQ_HDR_S_COUNT
    bit<8> iq_hdr_index;
    // this will be incrememted every circirulation iteration
    bit<8> iq_s_index;
    qpsk_t current_payload_b;
    bit<8> iq_hdr_end;

}
header net_mod_circ_hdr_qam16_t
{
  
    ttc_t bps;
    index_t index; // GP index
    bit<8> payload_hdr_index;
    bit<8> payload_b_index;
    bit<8> payload_b_shift_cntr;
    bit<8> payload_hdr_shift_cntr;
    // this will be incremented when we reach IQ_HDR_S_COUNT
    bit<8> iq_hdr_index;
    // this will be incrememted every circirulation iteration
    bit<8> iq_s_index;
    qam16_t current_payload_b;
    bit<8> iq_hdr_end;

}
header net_mod_circ_hdr_qam64_t 
{
   ttc_t ttc;
    ttc_t bps;
    index_t index; // GP index
    bit<8> payload_hdr_index;
    bit<8> payload_b_index;
    bit<8> payload_b_shift_cntr;
    bit<8> payload_hdr_shift_cntr;
    // this will be incremented when we reach IQ_HDR_S_COUNT
    bit<8> iq_hdr_index;
    // this will be incrememted every circirulation iteration
    bit<8> iq_s_index;
    qam64_t current_payload_b;
    bit<8> iq_hdr_end;
    bit<2> pad;

}
header net_mod_circ_hdr_qam256_t
{
  
    ttc_t bps;
    index_t index; // GP index
    bit<8> payload_hdr_index;
    bit<8> payload_b_index;
    bit<8> payload_b_shift_cntr;
    bit<8> payload_hdr_shift_cntr;
    // this will be incremented when we reach IQ_HDR_S_COUNT
    bit<8> iq_hdr_index;
    // this will be incrememted every circirulation iteration
    bit<8> iq_s_index;
    qam256_t current_payload_b;
    bit<8> iq_hdr_end;
}
//net_mod_iq_hdr_
// 8 * 16 = 128 

struct net_mod_iq_str_bpsk_t 
{
    net_mod_iq_hdr_bpsk_t IQ0;
    net_mod_iq_hdr_bpsk_t IQ1;
    net_mod_iq_hdr_bpsk_t IQ2;
    net_mod_iq_hdr_bpsk_t IQ3;
    net_mod_iq_hdr_bpsk_t IQ4;
    net_mod_iq_hdr_bpsk_t IQ5;
    net_mod_iq_hdr_bpsk_t IQ6;
    net_mod_iq_hdr_bpsk_t IQ7;
}
// for QPSK = 128-bit /2 = 64/16 = 

struct net_mod_iq_str_qpsk_t 
{
    net_mod_iq_hdr_qpsk_t IQ0;
    net_mod_iq_hdr_qpsk_t IQ1;
    net_mod_iq_hdr_qpsk_t IQ2;
    net_mod_iq_hdr_qpsk_t IQ3;
}

// for QAM16 128-bit/4 = 32/16 = 2 IQ

struct net_mod_iq_str_qam16_t
{
    net_mod_iq_hdr_qam16_t IQ0;
    net_mod_iq_hdr_qam16_t IQ1;
}
// for QAM64 -> 6 * 8 *4 = 48*4 = 192/6 = 32 /16 = 2
struct net_mod_iq_str_qam64_t
{
    net_mod_iq_hdr_qam64_t IQ0;
    net_mod_iq_hdr_qam64_t IQ1;
}
// for QAM256 --> 128/8 = 16 then we only have one IQ
struct net_mod_iq_str_qam256_t
{
    net_mod_iq_hdr_qam256_t IQ0;
}

struct ns_headers 
{
    ethernet_h  ethernet;
    arp_h       arp;
    arp_ipv4_h  arp_ipv4;
    ipv4_h      ipv4;
    icmp_h      icmp;
    udp_h       udp;
    net_mod_hdr_t mod; // modulation header...
    net_mod_payload_hdr_bpsk_t payload_bpsk;
    net_mod_payload_hdr_qpsk_t payload_qpsk;
    net_mod_payload_hdr_qam16_t payload_qam16;
    // 48 -bit per header and four QAM64 headers equivalent to 192 bits --> 32 IQ symbols -> 24 bytes 
    net_mod_payload_hdr_qam64_t payload_qam640;
    net_mod_payload_hdr_qam64_t payload_qam641;
    net_mod_payload_hdr_qam64_t payload_qam642;
    net_mod_payload_hdr_qam64_t payload_qam643;
    net_mod_payload_hdr_qam256_t payload_qam256;
    
    net_mod_circ_hdr_t circ;
    // net_mod_circ_hdr_bpsk_t circ_bpsk;
    // net_mod_circ_hdr_qpsk_t circ_qpsk;
    // net_mod_circ_hdr_qam16_t circ_qam16;
    // net_mod_circ_hdr_qam64_t circ_qam64;
    // net_mod_circ_hdr_qam256_t circ_qam256;

    net_mod_iq_str_bpsk_t   iq_str_bpsk;
    net_mod_iq_str_qpsk_t   iq_str_qpsk;
    net_mod_iq_str_qam16_t  iq_str_qam16;
    net_mod_iq_str_qam64_t  iq_str_qam64;
    net_mod_iq_str_qam256_t iq_str_qam256;


    net_mod_iq_hdr_bpsk_t tmp_iq_bpsk;
    net_mod_iq_hdr_qpsk_t tmp_iq_qpsk;
    net_mod_iq_hdr_qam16_t tmp_iq_qam16;
    net_mod_iq_hdr_qam64_t tmp_iq_qam64;
    net_mod_iq_hdr_qam256_t tmp_iq_qam256;

}

// struct ns_headers 
// {
//     ethernet_h  ethernet;
//     arp_h       arp;
//     arp_ipv4_h  arp_ipv4;
//     ipv4_h      ipv4;
//     icmp_h      icmp;
//     udp_h       udp;
//     net_mod_hdr_t mod; // modulation header...
//     net_mod_payload_hdr_t payload0;
//     net_mod_payload_hdr_t payload1;
//     net_mod_payload_hdr_t payload2;
//     net_mod_payload_hdr_t payload3;
//     net_mod_payload_hdr_t payload4;
//     net_mod_payload_hdr_t payload5;
//     net_mod_payload_hdr_t payload6;
//     net_mod_payload_hdr_t payload7;
//     net_mod_circ_hdr_t circ;
//     net_mod_iq_hdr_t IQ0;
//     net_mod_iq_hdr_t IQ1;
//     net_mod_iq_hdr_t IQ2;
//     net_mod_iq_hdr_t IQ3;
//     net_mod_iq_hdr_t IQ4;
//     net_mod_iq_hdr_t IQ5;
//     net_mod_iq_hdr_t IQ6;
//     net_mod_iq_hdr_t IQ7;
//     net_mod_iq_hdr_t IQ8;
//     net_mod_iq_hdr_t IQ9;
//     net_mod_iq_hdr_t IQ10;
//     net_mod_iq_hdr_t IQ11;
//     net_mod_iq_hdr_t IQ12;
//     net_mod_iq_hdr_t IQ13;
//     net_mod_iq_hdr_t IQ14;
//     net_mod_iq_hdr_t IQ15;

//     net_mod_iq_hdr_t tmp_iq;
// }

struct meta_data 
{
    ipv4_addr_t   dst_ipv4;
    bit<1>        ipv4_csum_err;
    bit<8> rst;
    bit<32> index;
    qam64_t current_payload_b;
    //bit_slice_t bit_slice_value;
    //iq_t iq_value;
    //bool is_qam;
}

#endif