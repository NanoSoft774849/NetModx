#ifndef __Initializer__p4
#define __Initializer__p4

#define INIT(q , ttc , pb)\
action init##q()\
        {\
            hdr.circ_##q.setValid();\
            hdr.circ_##q.ttc = ttc;\
            hdr.circ_##q.index = 0;\
            hdr.circ_##q.iq_s_index = 0;\
            hdr.circ_##q.iq_hdr_index = 0;\
            hdr.circ_##q.payload_hdr_index = 0;\
            hdr.circ_##q.payload_b_index = 0;\
            hdr.circ_##q.payload_b_shift_cntr = 0;\
            hdr.circ_##q.bps = (ttc_t) hdr.mod.bps;\
            hdr.circ_##q.current_payload_b = hdr.##pb;\
            hdr.mod.ec = 1w1;\
            recirculate();\
        }\
//

control initializer(inout ns_headers hdr, inout meta_data meta)
{
    action recirculate()
        {
            //port = {1: 452, 2: 324, 3: 448, 4: 196, 5: 192, 6: 64, 7: 68}
            hdr.mod.ec = 1w1;
            ig_tm_md.ucast_egress_port = NET_MOD_RECIRCULATION_PORT;
            ig_tm_md.bypass_egress = 1w1;
            ig_dprsr_md.drop_ctl[0:0] = 0;
        }

    init(bpsk, 128, payload_bpsk.b0)
    init(qpsk, 128, payload_qpsk.b0)
    init(qam16, 128, payload_qam16.b0)
    init(qam64, 192, payload_qam640.b0)
    init(qam256, 128, payload_qam256.b0)

    action reset_enable_circ()
    {
        hdr.mod.ec = 1w0;
    }
    action disable_circ()
    {
        hdr.circ.setInvalid();
        hdr.mod.ec = 1w0;
    }

    table init_tbl 
        {
            key = { hdr.circ_bpsk.isValid(): exact;
                    hdr.circ_qpsk.isValid(): exact;
                    hdr.circ_qam16.isValid(): exact;
                    hdr.circ_qam64.isValid(): exact;
                    hdr.circ_qam256.isValid(): exact;
                    hdr.mod.ec : exact;
            }
            actions= 
            {
                initialize;
                recirculate;
                disable_circ;
                reset_enable_circ;
            }
            size = 4;
            const entries = {
                // (true, 1w1): recirculate();
                // (true, 1w0): disable_circ();
                // (false, 1w1): reset_enable_circ();
                // (false, 1w0): initialize();
            }
        }

    apply{
        init_tbl.apply();
    }
}

#endif