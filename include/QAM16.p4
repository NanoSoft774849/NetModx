#ifndef __QAM16__P4
#define __QAM16__P4

#include"snaps.p4"


control QAM16Mapper(inout ns_headers hdr, inout meta_data meta)
{
    CreateRegisterMap(4)
#define GEN_ACTION(i)\
        action net##i(){\
        hdr.tmp_iq_qam16.s##i = (mc_iq_qam16_t) act4.execute((bit<32>)hdr.circ.current_payload_b[3:0]);\
        hdr.circ.current_payload_b =  hdr.circ.current_payload_b >> 1;}\
//
#define CREATE_ACTION_BANK()\
        GEN_ACTION(0)       \
        GEN_ACTION(1)       \
        GEN_ACTION(2)       \
        GEN_ACTION(3)       \
        GEN_ACTION(4)       \
        GEN_ACTION(5)       \
        GEN_ACTION(6)       \
        GEN_ACTION(7)       \
        GEN_ACTION(8)       \
        GEN_ACTION(9)       \
        GEN_ACTION(10)      \
        GEN_ACTION(11)      \
        GEN_ACTION(12)      \
        GEN_ACTION(13)      \
        GEN_ACTION(14)      \
        GEN_ACTION(15)      \
// //

#define ACTION_LIST_ITEM(i) net##i
#define ACTION_ENTRY_ITEM(i) (i):net##i
//
#define ACTION_LIST_BANK()\
        ACTION_LIST_ITEM(0);\
        ACTION_LIST_ITEM(1);\
        ACTION_LIST_ITEM(2);\
        ACTION_LIST_ITEM(3);\
        ACTION_LIST_ITEM(4);\
        ACTION_LIST_ITEM(5);\
        ACTION_LIST_ITEM(6);\
        ACTION_LIST_ITEM(7);\
        ACTION_LIST_ITEM(8);\
        ACTION_LIST_ITEM(9);\
        ACTION_LIST_ITEM(10);\
        ACTION_LIST_ITEM(11);\
        ACTION_LIST_ITEM(12);\
        ACTION_LIST_ITEM(13);\
        ACTION_LIST_ITEM(14);\
        ACTION_LIST_ITEM(15);\
//
#define ACTION_ENTRY_BANK()\
        ACTION_ENTRY_ITEM(0);\
        ACTION_ENTRY_ITEM(1);\
        ACTION_ENTRY_ITEM(2);\
        ACTION_ENTRY_ITEM(3);\
        ACTION_ENTRY_ITEM(4);\
        ACTION_ENTRY_ITEM(5);\
        ACTION_ENTRY_ITEM(6);\
        ACTION_ENTRY_ITEM(7);\
        ACTION_ENTRY_ITEM(8);\
        ACTION_ENTRY_ITEM(9);\
        ACTION_ENTRY_ITEM(10);\
        ACTION_ENTRY_ITEM(11);\
        ACTION_ENTRY_ITEM(12);\
        ACTION_ENTRY_ITEM(13);\
        ACTION_ENTRY_ITEM(14);\
        ACTION_ENTRY_ITEM(15);\
//

    CREATE_ACTION_BANK()
    
    NET_MOD_PAYLOAD_SELECTOR(qam16)



    table QAM16_table 
    {
        key = {
            hdr.circ.iq_s_index : exact;
        }
        actions = 
        {
            ACTION_LIST_BANK()
        }
        size = MOD_TABLE_SIZE;
        const entries = 
        {
            ACTION_ENTRY_BANK()
        }
    }

    apply{
        
        if( hdr.circ.payload_b_shift_cntr >= PB_QAM16_BITS_PER_B || hdr.circ.payload_b_shift_cntr == 0)
        {
           
           hdr.circ.payload_b_shift_cntr = 0;
           payload_selector_tbl_qam16.apply();
           hdr.circ.payload_b_index = hdr.circ.payload_b_index |+| 1;
        }
        // if (  hdr.circ.payload_b_index  == PAYLOAD_HDR_B_COUNT-1)
        // {
        //     hdr.circ.payload_hdr_index = hdr.circ.payload_hdr_index |+| 1;
        //     hdr.circ.payload_b_index = 0;
        // }
        QAM16_table.apply();
    }

}

#endif


