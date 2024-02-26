

#ifndef __parser__p4

#define __parser__p4

#include"headers.p4"
//  NAMES 
#define NET_MOD_PARSER_STATE_NAME(t) parse_payload_##t
#define NET_MOD_PARSER_CIRC_STATE_NAME(t) parse_circ_##t
// i is the index and t is the modulation type.
#define NET_MOD_IQ_PARSER_STATE_NAME(t, i) parse_IQ_##i##t
#define NET_MOD_PARSE_TMP_IQ_STATE_NAME(t) parse_tmp_iq_##t
// t is the moduation type,  c current state , n for next state.
#define PARSE_IQ_STR(t, c, n)\
state NET_MOD_IQ_PARSER_STATE_NAME(t,c)\
    {\
        pkt.extract(hdr.iq_str_##t.IQ##c);\
        transition select( hdr.circ.iq_hdr_index, hdr.circ.iq_hdr_end)\
        {\
            (n, 0): NET_MOD_PARSE_TMP_IQ_STATE_NAME(t);\
            (n, 1): accept;\
            (_, _): NET_MOD_IQ_PARSER_STATE_NAME(t,n);\
        }\
    }\
//
#define PARSE_IQ_STR_LAST(t, n)\
state NET_MOD_IQ_PARSER_STATE_NAME(t,n)\
{\
 pkt.extract(hdr.iq_str_##t.IQ##n);\
 transition select(hdr.circ.iq_hdr_index, hdr.circ.iq_hdr_end)\
 {\
    (n, 0):NET_MOD_PARSE_TMP_IQ_STATE_NAME(t);\
    (n, 1): accept;\
    default:accept;\
 }\
 }\
//

#define PARSE_TMP_IQ(t)\
state parse_tmp_iq_##t\
    {\
        pkt.extract(hdr.tmp_iq_##t);\
        transition accept;\
    }\
//



#define NET_MOD_PARSER(t)\
state parse_payload_##t\
{\
    pkt.extract(hdr.payload_##t);\
    transition accept;\
}\
//

#define NET_MOD_QAM64_PARSER(c, n)\
state NET_MOD_PARSER_STATE_NAME(qam64##c)\
{\
    pkt.extract(hdr.payload_qam64##c);\
    transition NET_MOD_PARSER_STATE_NAME(qam64##n);\
}\
//
#define NET_MOD_CIRC_QAM64_LAST_PARSER(t)\
state parse_circ_##t\
{\
    pkt.extract(hdr.circ);\
    transition select( hdr.circ.iq_hdr_end, hdr.circ.iq_hdr_index)\
    {\
        (0, 0) :  NET_MOD_PARSE_TMP_IQ_STATE_NAME(t);\
        (1, _):   NET_MOD_IQ_PARSER_STATE_NAME(t,0);\
        default : NET_MOD_IQ_PARSER_STATE_NAME(t,0);\
    }\
}\
//

#define NET_MOD_CIRC_PARSER(t)\
state parse_circ_##t\
{\
    pkt.extract(hdr.payload_##t);\
    pkt.extract(hdr.circ);\
    transition select( hdr.circ.iq_hdr_end, hdr.circ.iq_hdr_index)\
    {\
        (0, 0) : NET_MOD_PARSE_TMP_IQ_STATE_NAME(t);\
        (1, _): NET_MOD_IQ_PARSER_STATE_NAME(t,0);\
        default : NET_MOD_IQ_PARSER_STATE_NAME(t,0);\
    }\
}\
//
#define PARSE_IQ_FOR_BPSK_STATES()\
        PARSE_IQ_STR(bpsk, 0, 1)\
        PARSE_IQ_STR(bpsk, 1, 2)\
        PARSE_IQ_STR(bpsk, 2, 3)\
        PARSE_IQ_STR(bpsk, 3, 4)\
        PARSE_IQ_STR(bpsk, 4, 5)\
        PARSE_IQ_STR(bpsk, 5, 6)\
        PARSE_IQ_STR(bpsk, 6, 7)\
        PARSE_IQ_STR_LAST(bpsk, 7)\
        PARSE_TMP_IQ(bpsk)\
//

#define PARSE_IQ_FOR_QPSK_STATES()\
        PARSE_IQ_STR(qpsk, 0, 1)\
        PARSE_IQ_STR(qpsk, 1, 2)\
        PARSE_IQ_STR(qpsk, 2, 3)\
        PARSE_IQ_STR_LAST(qpsk, 3)\
        PARSE_TMP_IQ(qpsk)\
//
#define PARSE_IQ_FOR_QAM16_STATES()\
        PARSE_IQ_STR(qam16, 0, 1)\
        PARSE_IQ_STR_LAST(qam16, 1)\
        PARSE_TMP_IQ(qam16)\
//
#define PARSE_IQ_FOR_QAM64_STATES()\
        PARSE_IQ_STR(qam64, 0, 1)\
        PARSE_IQ_STR_LAST(qam64, 1)\
        PARSE_TMP_IQ(qam64)\
//

#define PARSE_IQ_FOR_QAM256_STATES()\
        PARSE_IQ_STR_LAST(qam256, 0)\
        PARSE_TMP_IQ(qam256)\
//

//#define NET_MOD_PARSER_STATE_NAME(t) parse_payload_##t
//#define NET_MOD_PARSER_CIRC_STATE_NAME(t) parse_circ_##t
//

parser IngressParser (
    packet_in pkt, 
    out ns_headers hdr,
    out meta_data meta, 
    out ingress_intrinsic_metadata_t ig_md

)
{
    Checksum() ipv4_checksum;

    state start 
    {
        pkt.extract(ig_md);
        pkt.advance(PORT_METADATA_SIZE);
        transition meta_init;
    }
    state meta_init {
        meta.ipv4_csum_err = 0;
        meta.dst_ipv4      = 0;
        meta.index = 0;
        transition parse_ethernet;
    }
    
    state parse_ethernet {
        pkt.extract(hdr.ethernet);
        transition select(hdr.ethernet.ether_type) {
            ether_type_t.IPV4 :  parse_ipv4;
            ether_type_t.ARP  :  parse_arp;
            default:  accept;
        }
    }
    
    state parse_arp {
        pkt.extract(hdr.arp);
        transition select(hdr.arp.hw_type, hdr.arp.proto_type) {
            (0x0001, ether_type_t.IPV4) : parse_arp_ipv4;
            default: reject; // Currently the same as accept
        }
    }

    state parse_arp_ipv4 {
        pkt.extract(hdr.arp_ipv4);
        meta.dst_ipv4 = hdr.arp_ipv4.dst_proto_addr;
        transition accept;
    }  
    state parse_ipv4 {
        pkt.extract(hdr.ipv4);
        meta.dst_ipv4 = hdr.ipv4.dst_addr;
        
        ipv4_checksum.add(hdr.ipv4);
        meta.ipv4_csum_err = (bit<1>)ipv4_checksum.verify();
        
        transition select(
            hdr.ipv4.ihl,
            hdr.ipv4.frag_offset,
            hdr.ipv4.protocol)
        {
            (5, 0, ip_protocol_t.ICMP) : parse_icmp;
            (_, _, ip_protocol_t.UDP)  : parse_udp;
            default: accept;
        }
    }
    state parse_icmp {
        pkt.extract(hdr.icmp);
        transition accept;
    }
    state parse_udp
    {
        pkt.extract(hdr.udp);
        transition parse_mod;
    }
    state parse_mod{
        pkt.extract(hdr.mod);
        transition select(hdr.mod.ec , hdr.mod.bps)
        {
            (1w0, 1): NET_MOD_PARSER_STATE_NAME(bpsk);
            (1w1, 1): NET_MOD_PARSER_CIRC_STATE_NAME(bpsk);
            (1w0, 2): NET_MOD_PARSER_STATE_NAME(qpsk);
            (1w1, 2): NET_MOD_PARSER_CIRC_STATE_NAME(qpsk);
            (1w0, 4): NET_MOD_PARSER_STATE_NAME(qam16);
            (1w1, 4): NET_MOD_PARSER_CIRC_STATE_NAME(qam16);
            (_, 6):   NET_MOD_PARSER_STATE_NAME(qam640);
            (1w0, 8): NET_MOD_PARSER_STATE_NAME(qam256);
            (1w1, 8): NET_MOD_PARSER_CIRC_STATE_NAME(qam256);
            default : reject;
        }
       
    }
    
    NET_MOD_PARSER(bpsk)
    NET_MOD_PARSER(qpsk)
    NET_MOD_PARSER(qam16)
    NET_MOD_PARSER(qam256)
    NET_MOD_QAM64_PARSER(0,1)
    NET_MOD_QAM64_PARSER(1,2)
    NET_MOD_QAM64_PARSER(2,3)

    state NET_MOD_PARSER_STATE_NAME(qam643)
    {
        pkt.extract(hdr.payload_qam643);
        transition select(hdr.mod.ec)
        {
            (1w0): accept;
            (1w1): parse_circ_qam64;
        }
    }

   
   // with circ
   NET_MOD_CIRC_PARSER(bpsk)
   NET_MOD_CIRC_PARSER(qpsk)
   NET_MOD_CIRC_PARSER(qam16)
   NET_MOD_CIRC_PARSER(qam256)
   NET_MOD_CIRC_QAM64_LAST_PARSER(qam64)
   
   
   PARSE_IQ_FOR_BPSK_STATES()
   PARSE_IQ_FOR_QPSK_STATES()
   PARSE_IQ_FOR_QAM16_STATES()
   PARSE_IQ_FOR_QAM64_STATES()
   PARSE_IQ_FOR_QAM256_STATES()


    // state parse_circ_payload0
    // {
    //     pkt.extract(hdr.payload_bpsk);
    //     pkt.extract(hdr.circ_bpsk);
    //     // depends on the value of hdr.circ.iq_s_index, hdr.iq_hdr_index 
    //     // when hdr.circ.iq_s_index = 7 then you should put temp into 
    //     // each time we circulate the packet the hdr.circ.iq_s_index is incremented and a value is passed to hdr.tmp_iq.s##k 
    //     // but this is not valid in fact , when the value of iq_s_index == 7 then you shoudl pass the value of hdr.tmp_iq to the 
    //     // hdr.IQ hdr with the value of iq_hdr_index 
    //     // transition select( hdr.circ.iq_s_index, hdr.iq_hdr_index)
    //     // {
    //     //     (7, 0): 
    //     // }
    //     // let the parser do the job, but how 
    //     // if hdr.circ.iq_hdr_end == 1 then parse hdr
    //      transition select( hdr.circ_bpsk.iq_hdr_end, hdr.circ_bpsk.iq_hdr_index)
    //     {
    //         (0, 0) : parse_tmp_iq_bpsk;
    //         (1, _): parse_bpsk_IQ0;
    //         default : parse_bpsk_IQ0;
    //     }
    // }
    // state parse_tmp_iq_bpsk
    // {
    //     pkt.extract(hdr.tmp_iq_bpsk);
    //     transition accept;
    // }
    // state parse_bpsk_IQ0
    // {
    //     pkt.extract(hdr.iq_str_bpsk.IQ0);
    //     transition accept;
    // }
    // state parse_iq0 
    // {
    //     transition select( hdr.circ.iq_hdr_end, hdr.circ.iq_hdr_index)
    //     {
    //         (0, c) : parse_tmp_iq;
    //         (1): parse_IQ0;
    //     }
    // }

    // PARSE_IQ(0, 1)
    // PARSE_IQ(1, 2)
    // PARSE_IQ(2, 3)
    // PARSE_IQ(3, 4)
    // PARSE_IQ(4, 5)
    // PARSE_IQ(5, 6)
    // PARSE_IQ(6, 7)
    // PARSE_IQ(7, 8)
    // PARSE_IQ(8, 9)
    // PARSE_IQ(9,  10)
    // PARSE_IQ(10, 11)
    // PARSE_IQ(11, 12)
    // PARSE_IQ(12, 13)
    // PARSE_IQ(13, 14)
    // PARSE_IQ(14, 15)
    //PARSE_IQ(14, 7)
    

//     state parse_IQ0
//     {
//         pkt.extract(hdr.IQ15);
//         transition select(hdr.circ.iq_hdr_index, hdr.circ.iq_hdr_end)
//         {
//             (15, 0):parse_tmp_iq;
//             (15, 1): accept;
//             default:accept;
//         }
//     }
//  state parse_tmp_iq
//     {
//         pkt.extract(hdr.tmp_iq);
//         transition accept;
//     }

}

#endif
