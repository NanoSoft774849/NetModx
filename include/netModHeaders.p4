#ifndef __netModHeaders__p4
#define __netModHeaders__p4

#include"defs.p4"
// just use bit<32> 
#define NET_MOD_DEFINE_PAYLOAD_HDR(t)\
header net_mod_payload_hdr_##t\
{\
    ##t b0;\
    ##t b1;\
    ##t b2;\
    ##t b3;\
    ##t b4;\
    ##t b5;\
    ##t b6;\
    ##t b7;\
}\
//
NET_MOD_DEFINE_PAYLOAD_HDR(bpsk_t)
NET_MOD_DEFINE_PAYLOAD_HDR(qpsk_t)
NET_MOD_DEFINE_PAYLOAD_HDR(qam16_t)
NET_MOD_DEFINE_PAYLOAD_HDR(qam64_t)
NET_MOD_DEFINE_PAYLOAD_HDR(qam256_t)
//
#define NET_MOD_DEFINE_IQ_HDR(t)\
header net_mod_iq_hdr_##t\
{\
    mc_iq_##t s0;\
    mc_iq_##t s1;\
    mc_iq_##t s2;\
    mc_iq_##t s3;\
    mc_iq_##t s4;\
    mc_iq_##t s5;\
    mc_iq_##t s6;\
    mc_iq_##t s7;\
    mc_iq_##t s8;\
    mc_iq_##t s9;\
    mc_iq_##t s10;\
    mc_iq_##t s11;\
    mc_iq_##t s12;\
    mc_iq_##t s13;\
    mc_iq_##t s14;\
    mc_iq_##t s15;\
}\
//
NET_MOD_DEFINE_IQ_HDR(bpsk_t)
NET_MOD_DEFINE_IQ_HDR(qpsk_t)
NET_MOD_DEFINE_IQ_HDR(qam16_t)
NET_MOD_DEFINE_IQ_HDR(qam64_t)
NET_MOD_DEFINE_IQ_HDR(qam256_t)
//

#endif