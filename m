Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB1978745D
	for <lists+live-patching@lfdr.de>; Thu, 24 Aug 2023 17:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239972AbjHXPgT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 24 Aug 2023 11:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242310AbjHXPf6 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 24 Aug 2023 11:35:58 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7CBAE19BC;
        Thu, 24 Aug 2023 08:35:50 -0700 (PDT)
Received: from pwmachine.localnet (85-170-34-233.rev.numericable.fr [85.170.34.233])
        by linux.microsoft.com (Postfix) with ESMTPSA id 296892127C83;
        Thu, 24 Aug 2023 08:35:45 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 296892127C83
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1692891349;
        bh=veZ4otjMsEXZqoEJa8bHqVYHXotA6b8p7C1j99JS7vc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ENFFJdKFC9f58Hk1kFSjGDJaPxhJglV2wmhEYjtlCHTwOQq1udYP82FhG0nkdWRsm
         aB+mj7Cb3nM9KYJIGM/Ffy77Hj63yPNoZcPTaJNyNxyFc6ZkHabiSoQYdrRwqY7Cax
         QPmrVi1VPEGdcE72zhhX99Pjt63jvmfl+L4c5zTo=
From:   Francis Laniel <flaniel@linux.microsoft.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Alexander Lobakin <aleksander.lobakin@intel.com>,
        Nick Alcock <nick.alcock@oracle.com>,
        Alessandro Carminati <alessandro.carminati@gmail.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Viktor Malik <vmalik@redhat.com>,
        Kris Van Hees <kris.van.hees@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>, eugene.loh@oracle.com,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        live-patching@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scripts/link-vmlinux.sh: Add alias to duplicate symbols for kallsyms
Date:   Thu, 24 Aug 2023 17:35:43 +0200
Message-ID: <1862253.tdWV9SEqCh@pwmachine>
In-Reply-To: <CAPp5cGRBW6WDm9ku3nsr0x=rhEOGAUx==BctCo+DJ+498Tz2Sw@mail.gmail.com>
References: <20230718125523.2fc05491@gandalf.local.home> <20230721092127.1931028-1-alessandro.carminati@gmail.com> <CAPp5cGRBW6WDm9ku3nsr0x=rhEOGAUx==BctCo+DJ+498Tz2Sw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi.

Le vendredi 21 juillet 2023, 14:40:54 CEST Alessandro Carminati a =C3=A9cri=
t :
> Hello,
>=20
> I apologize for being noisy today.
>=20
> In an effort to be collaborative, I would like to share my thoughts on wh=
y I
> see duplicate symbols in fs/binfmt_elf.c.
>=20
> Il giorno ven 21 lug 2023 alle ore 11:22 Alessandro Carminati
>=20
> <alessandro.carminati@gmail.com> ha scritto:
> > Hello Steven, Alexander, and Nick,
> >=20
> > Since now I realize that a lot of people are working on my very same
> > argument, I'm writing you this mail just with the intent of not leaving
> > my statements floating in the air, and help the cause by sharing my
> > experience, as little it is, to solve this problem.
> >=20
> > The addr2line strategy, I tried to implement, allows me to achieve the
> > level of accuracy that Luis mentioned in his comment about live-patching
> > suggestions. The addr2line-based approach is feasible, however, to make
> > this approach operable, I had to ensure that vmlinux contains the
> > necessary debug information.
> > Let me clarify.
> > During the kernel build, I do need the vmlinux to contain debug
> > information. The approach I pursued parses the nm output and, when it
> > detects a duplicate symbol, it needs to query vmlinux using addr2line to
> > resolve the address where the symbol is reported to be.
> > The whole process takes place during the building phase.
> > I've completed the work to integrate the new alias within the compilati=
on
> > phase, and I wanted to share with you how it looks now.
> >=20
> > ```
> > ~ # uname -a
> > Linux (none) 6.4.0 #1 SMP PREEMPT Thu Jul 20 10:05:36 UTC 2023 aarch64
> > GNU/Linux ~ # cat /proc/kallsyms | grep gic_mask_irq
> > ffffacf2eb64dae4 t gic_mask_irq
> > ffffacf2eb64dae4 t gic_mask_irq@_drivers_irqchip_irq-gic_c_167
> > ffffacf2eb650960 t gic_mask_irq
> > ffffacf2eb650960 t gic_mask_irq@_drivers_irqchip_irq-gic-v3_c_404
> > ~ #
> > ```
> >=20
> > Despite this appearing to have a sufficient level of accuracy, when I
> > tested it, I realized something I really did not expect. Multiple
> > instances of the same function exist, and when I say "same function," I
> > don't just mean the name, but also the function's body. I apologize for
> > stating something that may sound obvious to you, but I found this really
> > unexpected.
> >=20
> > ```
> > ~ # uname -a
> > Linux (none) 6.4.0 #1 SMP PREEMPT Thu Jul 20 10:05:36 UTC 2023 aarch64
> > GNU/Linux ~ # cat /proc/kallsyms | grep -E " [ttT] " | cut -d" "
> > -f3|sort| uniq -d| grep @_
> > BIT_initDStream@_lib_zstd_common_bitstream_h_259
> > __dev_hold@_include_linux_netdevice_h_4059
> > __dev_put@_include_linux_netdevice_h_4048
> > __flush_tlb_range@_arch_arm64_include_asm_tlbflush_h_291
> > __flush_tlb_range_constprop_0@_arch_arm64_include_asm_tlbflush_h_291
> > __kern_my_cpu_offset@_arch_arm64_include_asm_percpu_h_40
> > __kvm_nvhe_$x@_arch_arm64_kvm_hyp_include_nvhe_memory_h_22
> > __kvm_nvhe___kvm_skip_instr@_arch_arm64_kvm_hyp_include_hyp_adjust_pc_h=
_34
> > __kvm_nvhe_hyp_page_count@_arch_arm64_kvm_hyp_include_nvhe_memory_h_47
> > __kvm_nvhe_hyp_phys_to_virt@_arch_arm64_kvm_hyp_include_nvhe_memory_h_22
> > __kvm_nvhe_hyp_virt_to_phys@_arch_arm64_kvm_hyp_include_nvhe_memory_h_27
> > __kvm_skip_instr@_arch_arm64_kvm_hyp_include_hyp_adjust_pc_h_34
> > __nodes_weight_constprop_0@_include_linux_nodemask_h_239
> > __pi_$x@_scripts_dtc_libfdt_libfdt_h_145
> > __pi_fdt32_ld@_scripts_dtc_libfdt_libfdt_h_145
> > __preempt_count_dec_and_test@_arch_arm64_include_asm_current_h_19
> > acpi_dev_filter_resource_type_cb@_include_linux_acpi_h_520
> > add_quirk@_drivers_mmc_core_card_h_158
> > bpf_enable_instrumentation@_include_linux_bpf_h_1937
> > btf_id_cmp_func@_include_linux_btf_h_469
> > copy_from_sockptr_offset_constprop_0@_include_linux_sockptr_h_44
> > cpucap_multi_entry_cap_matches@_arch_arm64_include_asm_cpufeature_h_395
> > cpufreq_register_em_with_opp@_include_linux_cpufreq_h_1228
> > cpumask_weight@_include_linux_cpumask_h_691
> > cpumask_weight_constprop_0@_include_linux_cpumask_h_690
> > css_put@_include_linux_cgroup_refcnt_h_77
> > dma_cookie_status@_drivers_dma_dmaengine_h_74
> > dst_discard@_include_net_dst_h_392
> > dst_output@_include_net_dst_h_457
> > elf_core_dump@_fs_binfmt_elf_c_2027
> > fixup_use_fwh_lock@_drivers_mtd_chips_fwh_lock_h_102
> > flush_tlb_mm@_arch_arm64_include_asm_tlbflush_h_250
> > fwh_lock_varsize@_drivers_mtd_chips_fwh_lock_h_81
> > fwh_unlock_varsize@_drivers_mtd_chips_fwh_lock_h_92
> > fwh_xxlock_oneblock@_drivers_mtd_chips_fwh_lock_h_31
> > get_net_ns@_include_net_net_namespace_h_231
> > inline_map_read_isra_0@_include_linux_mtd_map_h_393
> > inline_map_write_part_0@_include_linux_mtd_map_h_426
> > io_run_task_work@_io_uring_io_uring_h_282
> > ipv6_portaddr_hash_isra_0@_include_net_ipv6_h_732
> > irq_find_host@_include_linux_irqdomain_h_322
> > jhash@_include_linux_jhash_h_76
> > jhash_constprop_0@_include_linux_jhash_h_76
> > ktime_get_boottime@_include_linux_timekeeping_h_94
> > ktime_get_real@_include_linux_timekeeping_h_78
> > load_elf_binary@_fs_binfmt_elf_c_824
> > load_elf_phdrs@_fs_binfmt_elf_c_468
> > may_use_simd@_arch_arm64_include_asm_alternative-macros_h_232
> > netif_tx_disable@_include_linux_netdevice_h_4486
> > of_parse_phandle@_include_linux_of_h_946
> > of_parse_phandle_constprop_0@_include_linux_of_h_943
> > padzero@_fs_binfmt_elf_c_142
> > percpu_down_read_constprop_0@_include_linux_percpu-rwsem_h_47
> > percpu_ref_get_many@_include_linux_percpu-refcount_h_199
> > percpu_ref_get_many_constprop_0@_include_linux_percpu-refcount_h_198
> > percpu_ref_put_many_constprop_0@_include_linux_percpu-refcount_h_326
> > percpu_up_read@_include_linux_percpu-rwsem_h_98
> > percpu_up_read_constprop_0@_include_linux_percpu-rwsem_h_97
> > pinconf_generic_dt_node_to_map_all@_include_linux_pinctrl_pinconf-gener=
ic_
> > h_223
> > pinconf_generic_dt_node_to_map_group@_include_linux_pinctrl_pinconf-gen=
er
> > ic_h_207
> > pinconf_generic_dt_node_to_map_pin@_include_linux_pinctrl_pinconf-gener=
ic
> > _h_215
> > platform_device_register_resndata_constprop_0@_include_linux_platform_d=
ev
> > ice_h_125
> > ptrauth_keys_install_user@_arch_arm64_include_asm_alternative-macros_h_=
23
> > 2 readl@_arch_arm64_include_asm_io_h_75
> > reqsk_put@_include_net_request_sock_h_133
> > rht_key_get_hash_constprop_0_isra_0@_include_linux_rhashtable_h_133
> > rht_key_get_hash_isra_0@_include_linux_rhashtable_h_125
> > role_show@_include_linux_device_h_763
> > sdhci_and_cqhci_reset@_drivers_mmc_host_sdhci-cqhci_h_16
> > set_active_memcg_part_0@_include_linux_sched_mm_h_410
> > set_brk@_fs_binfmt_elf_c_114
> > set_is_seen@_arch_arm64_include_asm_current_h_19
> > set_lookup@_arch_arm64_include_asm_current_h_19
> > sha1_base_init@_include_crypto_sha1_base_h_22
> > sha224_base_init@_include_crypto_sha256_base_h_23
> > sha256_base_init@_include_crypto_sha256_base_h_31
> > spi_sync_transfer_constprop_0@_include_linux_spi_spi_h_1339
> > spi_write@_include_linux_spi_spi_h_1363
> > tlb_flush@_arch_arm64_include_asm_tlb_h_54
> > trace_xhci_dbg_quirks@_drivers_usb_host_xhci-trace_h_48
> > udp_lib_close@_include_net_udp_h_197
> > udp_lib_hash@_include_net_udp_h_189
> > virtio_net_hdr_to_skb_constprop_0@_include_linux_virtio_net_h_48
> > writenote@_fs_binfmt_elf_c_1479
> > zero_user_segments@_include_linux_highmem_h_271
> > zero_user_segments_constprop_0@_include_linux_highmem_h_268
> > ```
> >=20
> > The previous evidence demonstrates that adding a tag with a file and li=
ne
> > number does not make a symbol unique.
> >=20
> > Here, I inspect the function body to verify if the functions are indeed
> > the same.
> >=20
> > ```
> > Welcome to Buildroot
> > buildroot login: root
> > ~ # cat /proc/kallsyms | grep set_brk
> > ffffa8a9d1cf1d2c t set_brk
> > ffffa8a9d1cf1d2c t set_brk@_fs_binfmt_elf_c_114
> > ffffa8a9d1cf4454 t set_brk
> > ffffa8a9d1cf4454 t set_brk@_fs_binfmt_elf_c_114
> > ~ # QEMU: Terminated
> > $ cat System.map | grep set_brk
> > ffff8000082f1d2c t set_brk
> > ffff8000082f4454 t set_brk
> > ~ $ r2 vmlinux
> > Warning: run r2 with -e bin.cache=3Dtrue to fix relocations in disassem=
bly
> >=20
> >  -- Reduce the delta where flag resolving by address is used with
> >  cfg.delta
> >=20
> > [0xffff800008000000]> s 0xffff8000082f1d2c
> > [0xffff8000082f1d2c]> aa
> > [x] Analyze all flags starting with sym. and entry0 (aa)
> > [x] Analyze all functions arguments/locals
> > [0xffff8000082f1d2c]> pdf
> >=20
> >             ; CALL XREFS from sym.load_elf_binary @ 0xffff8000082f352c(=
x),
> >             0xffff8000082f38d4(x), 0xffff8000082f3a68(x)>=20
> > =E2=94=8C 112: sym.set_brk (int64_t arg1, int64_t arg2, int64_t arg3);
> > =E2=94=82           ; arg int64_t arg1 @ x0
> > =E2=94=82           ; arg int64_t arg2 @ x1
> > =E2=94=82           ; arg int64_t arg3 @ x2
> > =E2=94=82           ; var int64_t var_10h @ sp+0x10
> > =E2=94=82           0xffff8000082f1d2c      3f2303d5       paciasp     =
        ;
> > binfmt_elf.c:114 =E2=94=82           0xffff8000082f1d30      fd7bbea9  =
     stp
> > x29, x30, [sp, -0x20]! =E2=94=82           0xffff8000082f1d34      00fc=
3f91     =20
> > add x0, x0, 0xfff   ; binfmt_elf.c:115 ; arg1 =E2=94=82         =20
> > 0xffff8000082f1d38      fd030091       mov x29, sp         ;
> > binfmt_elf.c:114 =E2=94=82           0xffff8000082f1d3c      21fc3f91  =
     add
> > x1, x1, 0xfff   ; binfmt_elf.c:116 ; arg2 =E2=94=82           0xffff800=
0082f1d40=20
> >     00cc7492       and x0, x0, 0xfffffffffffff000 ; binfmt_elf.c:114 ;
> > arg1 =E2=94=82           0xffff8000082f1d44      f30b00f9       str x19=
, [sp,
> > 0x10] ; binfmt_elf.c:116 =E2=94=82           0xffff8000082f1d48      33=
cc7492   =20
> >   and x19, x1, 0xfffffffffffff000 ; arg2 =E2=94=82           0xffff8000=
082f1d4c =20
> >    1f0013eb       cmp x0, x19         ; binfmt_elf.c:117 ; arg1 =E2=94=
=82     =20
> > =E2=94=8C=E2=94=80< 0xffff8000082f1d50      63010054       b.lo 0xffff8=
000082f1d7c =E2=94=82    =20
> > =E2=94=8C=E2=94=80=E2=94=80> 0xffff8000082f1d54      014138d5       mrs=
 x1, sp_el0      ;
> > binfmt_elf.c:128 =E2=94=82      =E2=95=8E=E2=94=82   0xffff8000082f1d58=
      22fc41f9       ldr
> > x2, [x1, 0x3f8] ; current.h:21 ; 0xd9 ; 217 =E2=94=82      =E2=95=8E=E2=
=94=82 =20
> > 0xffff8000082f1d5c      00008052       mov w0, 0           ;
> > binfmt_elf.c:129 =E2=94=82      =E2=95=8E=E2=94=82   0xffff8000082f1d60=
      539400f9       str
> > x19, [x2, 0x128] ; binfmt_elf.c:128 =E2=94=82      =E2=95=8E=E2=94=82  =
 0xffff8000082f1d64    =20
> > 21fc41f9       ldr x1, [x1, 0x3f8] ; current.h:17 ; 0xd9 ; 217 =E2=94=
=82      =E2=95=8E=E2=94=82=20
> >  0xffff8000082f1d68      339000f9       str x19, [x1, 0x120] ;
> > binfmt_elf.c:128 =E2=94=82      =E2=95=8E=E2=94=82   0xffff8000082f1d6c=
      f30b40f9       ldr
> > x19, [var_10h]  ; binfmt_elf.c:129 ; 5 =E2=94=82      =E2=95=8E=E2=94=
=82   0xffff8000082f1d70   =20
> >  fd7bc2a8       ldp x29, x30, [sp], 0x20 =E2=94=82      =E2=95=8E=E2=94=
=82   0xffff8000082f1d74 =20
> >    bf2303d5       autiasp
> > =E2=94=82      =E2=95=8E=E2=94=82   0xffff8000082f1d78      c0035fd6   =
    ret
> > =E2=94=82      =E2=95=8E=E2=94=94=E2=94=80> 0xffff8000082f1d7c      420=
07e92       and x2, x2, 4       ;
> > binfmt_elf.c:123 ; arg3 =E2=94=82      =E2=95=8E    0xffff8000082f1d80 =
     610200cb    =20
> >  sub x1, x19, x0     ; arg1 =E2=94=82      =E2=95=8E    0xffff8000082f1=
d84      cae3fc97=20
> >      bl sym.vm_brk_flags =E2=94=82      =E2=94=94=E2=94=80=E2=94=80< 0x=
ffff8000082f1d88      60feff34   =20
> >   cbz w0, 0xffff8000082f1d54 ; binfmt_elf.c:125 =E2=94=82         =20
> > 0xffff8000082f1d8c      f30b40f9       ldr x19, [var_10h]  ;
> > binfmt_elf.c:130 ; 5 =E2=94=82           0xffff8000082f1d90      fd7bc2=
a8     =20
> > ldp x29, x30, [sp], 0x20 =E2=94=82           0xffff8000082f1d94      bf=
2303d5   =20
> >   autiasp
> > =E2=94=94           0xffff8000082f1d98      c0035fd6       ret
> > [0xffff8000082f1d2c]> s  0xffff8000082f4454
> > [0xffff8000082f4454]> pdf
> >=20
> >             ; CALL XREFS from sym.load_elf_binary_1 @
> >             0xffff8000082f5cc0(x), 0xffff8000082f5e5c(x),
> >             0xffff8000082f6648(x)>=20
> > =E2=94=8C 112: sym.set_brk_1 (int64_t arg1, int64_t arg2, int64_t arg3);
> > =E2=94=82           ; arg int64_t arg1 @ x0
> > =E2=94=82           ; arg int64_t arg2 @ x1
> > =E2=94=82           ; arg int64_t arg3 @ x2
> > =E2=94=82           ; var int64_t var_10h @ sp+0x10
> > =E2=94=82           0xffff8000082f4454      3f2303d5       paciasp     =
        ;
> > binfmt_elf.c:114 =E2=94=82           0xffff8000082f4458      fd7bbea9  =
     stp
> > x29, x30, [sp, -0x20]! =E2=94=82           0xffff8000082f445c      00fc=
3f91     =20
> > add x0, x0, 0xfff   ; binfmt_elf.c:115 ; arg1 =E2=94=82         =20
> > 0xffff8000082f4460      fd030091       mov x29, sp         ;
> > binfmt_elf.c:114 =E2=94=82           0xffff8000082f4464      21fc3f91  =
     add
> > x1, x1, 0xfff   ; binfmt_elf.c:116 ; arg2 =E2=94=82           0xffff800=
0082f4468=20
> >     00cc7492       and x0, x0, 0xfffffffffffff000 ; binfmt_elf.c:114 ;
> > arg1 =E2=94=82           0xffff8000082f446c      f30b00f9       str x19=
, [sp,
> > 0x10] ; binfmt_elf.c:116 =E2=94=82           0xffff8000082f4470      33=
cc7492   =20
> >   and x19, x1, 0xfffffffffffff000 ; arg2 =E2=94=82           0xffff8000=
082f4474 =20
> >    1f0013eb       cmp x0, x19         ; binfmt_elf.c:117 ; arg1 =E2=94=
=82     =20
> > =E2=94=8C=E2=94=80< 0xffff8000082f4478      63010054       b.lo 0xffff8=
000082f44a4 =E2=94=82    =20
> > =E2=94=8C=E2=94=80=E2=94=80> 0xffff8000082f447c      014138d5       mrs=
 x1, sp_el0      ;
> > binfmt_elf.c:128 =E2=94=82      =E2=95=8E=E2=94=82   0xffff8000082f4480=
      22fc41f9       ldr
> > x2, [x1, 0x3f8] ; current.h:21 ; 0xd9 ; 217 =E2=94=82      =E2=95=8E=E2=
=94=82 =20
> > 0xffff8000082f4484      00008052       mov w0, 0           ;
> > binfmt_elf.c:129 =E2=94=82      =E2=95=8E=E2=94=82   0xffff8000082f4488=
      539400f9       str
> > x19, [x2, 0x128] ; binfmt_elf.c:128 =E2=94=82      =E2=95=8E=E2=94=82  =
 0xffff8000082f448c    =20
> > 21fc41f9       ldr x1, [x1, 0x3f8] ; current.h:17 ; 0xd9 ; 217 =E2=94=
=82      =E2=95=8E=E2=94=82=20
> >  0xffff8000082f4490      339000f9       str x19, [x1, 0x120] ;
> > binfmt_elf.c:128 =E2=94=82      =E2=95=8E=E2=94=82   0xffff8000082f4494=
      f30b40f9       ldr
> > x19, [var_10h]  ; binfmt_elf.c:129 ; 5 =E2=94=82      =E2=95=8E=E2=94=
=82   0xffff8000082f4498   =20
> >  fd7bc2a8       ldp x29, x30, [sp], 0x20 =E2=94=82      =E2=95=8E=E2=94=
=82   0xffff8000082f449c =20
> >    bf2303d5       autiasp
> > =E2=94=82      =E2=95=8E=E2=94=82   0xffff8000082f44a0      c0035fd6   =
    ret
> > =E2=94=82      =E2=95=8E=E2=94=94=E2=94=80> 0xffff8000082f44a4      420=
07e92       and x2, x2, 4       ;
> > binfmt_elf.c:123 ; arg3 =E2=94=82      =E2=95=8E    0xffff8000082f44a8 =
     610200cb    =20
> >  sub x1, x19, x0     ; arg1 =E2=94=82      =E2=95=8E    0xffff8000082f4=
4ac      00dafc97=20
> >      bl sym.vm_brk_flags =E2=94=82      =E2=94=94=E2=94=80=E2=94=80< 0x=
ffff8000082f44b0      60feff34   =20
> >   cbz w0, 0xffff8000082f447c ; binfmt_elf.c:125 =E2=94=82         =20
> > 0xffff8000082f44b4      f30b40f9       ldr x19, [var_10h]  ;
> > binfmt_elf.c:130 ; 5 =E2=94=82           0xffff8000082f44b8      fd7bc2=
a8     =20
> > ldp x29, x30, [sp], 0x20 =E2=94=82           0xffff8000082f44bc      bf=
2303d5   =20
> >   autiasp
> > =E2=94=94           0xffff8000082f44c0      c0035fd6       ret
> > [0xffff8000082f4454]>
> > ```
> >=20
> > While I can speculate on a reasonable explanation for why I see symbols
> > coming from header files being duplicated =E2=80=93 when a header file =
is
> > included in a C file and it produces a function that the compiler does
> > not want to inline, it is replicated every time the file is included =
=E2=80=93 I
> > have no convincing explanation as to why the fs/binfmt.c functions exist
> > in more than one instance.
> >=20
> > ```
> > elf_core_dump@_fs_binfmt_elf_c_2027
> > load_elf_binary@_fs_binfmt_elf_c_824
> > load_elf_phdrs@_fs_binfmt_elf_c_468
> > padzero@_fs_binfmt_elf_c_142
> > set_brk@_fs_binfmt_elf_c_114
> > writenote@_fs_binfmt_elf_c_1479
> > ```
>=20
> After examining the contents of built-in.a, I have come up with a new
> interpretation of what I am observing.
> According to built-in.a, System.map, and vmlinux there are two symbols na=
med
> set_brk.
>=20
> ```
> ~ $ cat System.map | grep set_brk
> ffff8000082f1d2c t set_brk
> ffff8000082f4454 t set_brk
> ~ $
> ~ $ nm -n vmlinux | grep set_brk
> ffff8000082f1d2c t set_brk
> ffff8000082f4454 t set_brk
> ~ $
> ~ $ nm -n built-in.a| grep set_brk
> 00000000000000d4 t set_brk
> 00000000000000d4 t set_brk
> ~ $
> ~ $ nm -n built-in.a | grep set_brk -B100| egrep "set_brk|\.o:$"
> fs/binfmt_elf.o:
> 00000000000000d4 t set_brk
> fs/compat_binfmt_elf.o:
> 00000000000000d4 t set_brk
> ```
>=20
> These two symbols come from fs/binfmt_elf.o and fs/compat_binfmt_elf.o, a=
nd
> they are just two symbols that happen to share the same name, as is common
> in the kernel.
>=20
> at the same time, addr2line reports symbols to be generated from the same
> file.
>=20
> ```
> ~ $ llvm-addr2line-14 -fe vmlinux ffff8000082f1d2c ffff8000082f4454
> set_brk
> /home/alessandro/src/lka64/linux-6.4/fs/binfmt_elf.c:114
> set_brk
> /home/alessandro/src/lka64/linux-6.4/fs/binfmt_elf.c:114
> ~ $
> ~ $ addr2line -fe vmlinux ffff8000082f1d2c ffff8000082f4454
> set_brk
> /home/alessandro/src/lka64/linux-6.4/fs/binfmt_elf.c:114
> set_brk
> /home/alessandro/src/lka64/linux-6.4/fs/binfmt_elf.c:114
> ```
> looking at the source code:
> https://elixir.bootlin.com/linux/v6.4/source/fs/compat_binfmt_elf.c#L144
> the cause of this behavior, which is unexpected but correct.

Thank you for the investigation, this an interesting reading!

> The rationale is that using source file + line number iproduces better
> kallsyms table, but it is still do not produce unique names.

When I first read your cover letter, I also thought it would be cool to hav=
e=20
the filename rather than a serial ID.
So, your latest modification is really good as it goes into this direction.
Regarding having non unique names, I am not sure if this is a problem.
In my case, which is using kprobe to attach BPF code to trace some events,=
=20
your contribution would make me on the way to know which address I should u=
se=20
because I could choose regarding the filename.

I am curious about a potential v3 of this patch!

> BR
> Alessandro
>=20
> > As a final note, please understand that my patch was not intended to
> > undermine anyone's work. I simply encountered a problem that I wanted to
> > help solve. Attached to this message is my code, in case anyone wants to
> > replicate it. I would appreciate being kept in the loop, as I genuinely
> > want to assist in fixing this problem.
> >=20
> > BR
> > Alessandro
> > ---
> >=20
> >  init/Kconfig                        |  36 ++++
> >  scripts/Makefile                    |   4 +
> >  scripts/kas_alias/Makefile          |   4 +
> >  scripts/kas_alias/a2l.c             | 268 ++++++++++++++++++++++++++++
> >  scripts/kas_alias/a2l.h             |  32 ++++
> >  scripts/kas_alias/duplicates_list.c |  70 ++++++++
> >  scripts/kas_alias/duplicates_list.h |  15 ++
> >  scripts/kas_alias/item_list.c       | 230 ++++++++++++++++++++++++
> >  scripts/kas_alias/item_list.h       |  26 +++
> >  scripts/kas_alias/kas_alias.c       | 217 ++++++++++++++++++++++
> >  scripts/link-vmlinux.sh             |  11 +-
> >  11 files changed, 910 insertions(+), 3 deletions(-)
> >  create mode 100644 scripts/kas_alias/Makefile
> >  create mode 100644 scripts/kas_alias/a2l.c
> >  create mode 100644 scripts/kas_alias/a2l.h
> >  create mode 100644 scripts/kas_alias/duplicates_list.c
> >  create mode 100644 scripts/kas_alias/duplicates_list.h
> >  create mode 100644 scripts/kas_alias/item_list.c
> >  create mode 100644 scripts/kas_alias/item_list.h
> >  create mode 100644 scripts/kas_alias/kas_alias.c
> >=20
> > diff --git a/init/Kconfig b/init/Kconfig
> > index f7f65af4ee12..bc69fcd9cbc8 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -1737,6 +1737,42 @@ config KALLSYMS_BASE_RELATIVE
> >=20
> >           time constants, and no relocation pass is required at runtime=
 to
> >           fix
> >           up the entries based on the runtime load address of the kerne=
l.
> >=20
> > +config KALLSYMS_ALIAS
> > +       bool "Produces alias for duplicated symbols" if EXPERT
> > +       depends on KALLSYMS && (DEBUG_INFO_DWARF4 || DEBUG_INFO_DWARF5)
> > +       help
> > +         It is not uncommon for drivers or modules related to similar
> > +         peripherals to have symbols with the exact same name.
> > +         While this is not a problem for the kernel's binary itself, it
> > +         becomes an issue when attempting to trace or probe specific
> > +         functions using infrastructure like ftrace or kprobe.
> > +
> > +         This option addresses this challenge by extending the symbol
> > names +         with unique suffixes during the kernel build process.
> > +         The newly created aliases for these duplicated symbols are
> > unique
> > +         names that can be fed to the ftrace sysfs interface. By doing
> > so, it +         enables previously unreachable symbols to be probed.
> > +
> > +config CONFIG_KALLSYMS_ALIAS_DATA
> > +       bool "Produces alias also for data"
> > +       depends on KALLSYMS_ALIAS
> > +       help
> > +         Sometimes it can be useful to refer to data. In live patch
> > scenarios, +         you may find yourself needing to use symbols that
> > are shared with +         other functions. Since symbols face the same
> > issue as functions, this +         option allows you to create aliases
> > for data as well.
> > +
> > +config CONFIG_KALLSYMS_ALIAS_DATA_ALL
> > +       bool "Removes all filter when producing data alias"
> > +       depends on CONFIG_KALLSYMS_ALIAS_DATA
> > +       help
> > +         When selecting data aliases, not all symbols are included in =
the
> > set +         This is because many symbols are unlikely to be used. If
> > you choose +         to have an alias for all data symbols, be aware th=
at
> > it will +         significantly increase the size.
> > +
> > +         If unsure, say N.
> > +
> >=20
> >  # end of the "standard kernel features (expert users)" menu
> > =20
> >  # syscall, maps, verifier
> >=20
> > diff --git a/scripts/Makefile b/scripts/Makefile
> > index 32b6ba722728..65fafe17cfe5 100644
> > --- a/scripts/Makefile
> > +++ b/scripts/Makefile
> > @@ -49,3 +49,7 @@ subdir-$(CONFIG_SECURITY_SELINUX) +=3D selinux
> >=20
> >  # Let clean descend into subdirs
> >  subdir-        +=3D basic dtc gdb kconfig mod
> >=20
> > +
> > +# KALLSyms alias
> > +subdir-$(CONFIG_KALLSYMS_ALIAS) +=3D kas_alias
> > +
> > diff --git a/scripts/kas_alias/Makefile b/scripts/kas_alias/Makefile
> > new file mode 100644
> > index 000000000000..e1fde69232b4
> > --- /dev/null
> > +++ b/scripts/kas_alias/Makefile
> > @@ -0,0 +1,4 @@
> > +# SPDX-License-Identifier: GPL-2.0
> > +hostprogs-always-$(CONFIG_KALLSYMS_ALIAS)    +=3D kas_alias
> > +
> > +kas_alias-objs        :=3D duplicates_list.o item_list.o kas_alias.o a=
2l.o
> > diff --git a/scripts/kas_alias/a2l.c b/scripts/kas_alias/a2l.c
> > new file mode 100644
> > index 000000000000..a9692ac30180
> > --- /dev/null
> > +++ b/scripts/kas_alias/a2l.c
> > @@ -0,0 +1,268 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <string.h>
> > +#include <unistd.h>
> > +#include <sys/types.h>
> > +#include <sys/wait.h>
> > +#include <string.h>
> > +#include <stdint.h>
> > +#include <stdbool.h>
> > +
> > +#include "a2l.h"
> > +
> > +int addr2line_pid =3D -1;
> > +int a2l_in[2];
> > +int a2l_out[2];
> > +char line[MAX_BUF];
> > +char vmlinux_path[MAX_BUF];
> > +char addr2line_cmd[MAX_CMD_LEN];
> > +FILE *a2l_stdin, *a2l_stdout;
> > +
> > +static char *normalize_path(const char *input_path, char *output_path)
> > +{
> > +       char *prev_token =3D NULL;
> > +       char *delimiter =3D "/";
> > +       char inbuf[MAX_BUF];
> > +       char *token;
> > +       char *pos;
> > +
> > +       memset(inbuf, 0, MAX_BUF);
> > +       *output_path =3D '\0';
> > +       strncpy(inbuf, input_path, MAX_BUF);
> > +       if (!input_path || !output_path || strlen(input_path) =3D=3D 0)
> > +               return NULL;
> > +
> > +       token =3D strtok(inbuf, delimiter);
> > +       while (token) {
> > +               if (strcmp(token, "..") =3D=3D 0 && prev_token) {
> > +                       pos =3D strrchr(output_path, '/');
> > +                       if (pos)
> > +                               *pos =3D '\0';
> > +
> > +               } else if (strcmp(token, ".") !=3D 0) {
> > +                       strcat(output_path, "/");
> > +                       strcat(output_path, token);
> > +               }
> > +
> > +               prev_token =3D token;
> > +               token =3D strtok(NULL, delimiter);
> > +       }
> > +
> > +       return output_path;
> > +}
> > +
> > +static void path_of(const char *full_path, char *path)
> > +{
> > +       const char *last_slash =3D strrchr(full_path, '/');
> > +       size_t path_length;
> > +       char cwd[MAX_BUF];
> > +
> > +       if (!last_slash) {
> > +               if (getcwd(cwd, sizeof(cwd)))
> > +                       strcpy(path, cwd);
> > +               else
> > +                       strcpy(path, ".");
> > +       } else {
> > +               path_length =3D last_slash - full_path;
> > +               strncpy(path, full_path, path_length);
> > +               path[path_length] =3D '\0';
> > +       }
> > +}
> > +
> > +static bool file_exists(const char *file_path)
> > +{
> > +       FILE *file;
> > +
> > +       file =3D fopen(file_path, "r");
> > +       if (file) {
> > +               fclose(file);
> > +               return true;
> > +       }
> > +       return false;
> > +}
> > +
> > +int addr2line_init(const char *cmd, const char *vmlinux)
> > +{
> > +       if ((!file_exists(cmd)) || (!file_exists(vmlinux))) {
> > +               printf("file not found\n");
> > +               return 0;
> > +               }
> > +
> > +       path_of(vmlinux, vmlinux_path);
> > +       if (pipe(a2l_in) =3D=3D -1) {
> > +               printf("Failed to create pipe\n");
> > +               return 0;
> > +       }
> > +
> > +       if (pipe(a2l_out) =3D=3D -1) {
> > +               printf("Failed to create pipe\n");
> > +               return 0;
> > +       }
> > +
> > +       addr2line_pid =3D fork();
> > +       if (addr2line_pid =3D=3D -1) {
> > +               printf("Failed to fork process\n");
> > +               close(a2l_in[P_READ]);
> > +               close(a2l_in[P_WRITE]);
> > +               close(a2l_out[P_READ]);
> > +               close(a2l_out[P_WRITE]);
> > +               return 0;
> > +       }
> > +
> > +       if (addr2line_pid =3D=3D 0) {
> > +               dup2(a2l_in[P_READ], 0);
> > +               dup2(a2l_out[P_WRITE], 1);
> > +               close(a2l_in[P_WRITE]);
> > +               close(a2l_out[P_READ]);
> > +
> > +               execlp(cmd, cmd, ADDR2LINE_ARGS, vmlinux, NULL);
> > +
> > +               printf("Failed to execute addr2line command\n");
> > +               exit(1);
> > +       } else {
> > +               close(a2l_in[P_READ]);
> > +               close(a2l_out[P_WRITE]);
> > +       }
> > +
> > +       a2l_stdin =3D fdopen(a2l_in[P_WRITE], "w");
> > +       if (!a2l_stdin) {
> > +               printf("Failed to open pipe a2l_in\n");
> > +               return 0;
> > +       }
> > +
> > +       a2l_stdout =3D fdopen(a2l_out[P_READ], "r");
> > +       if (!a2l_stdout) {
> > +               printf("Failed to open pipe a2l_out\n");
> > +               fclose(a2l_stdin);
> > +               return 0;
> > +       }
> > +
> > +       return 1;
> > +}
> > +
> > +const char *remove_subdir(const char *home, const char *f_path)
> > +{
> > +       int i =3D 0;
> > +
> > +       while (*(home + i) =3D=3D *(f_path + i))
> > +               i++;
> > +
> > +       return (strlen(home) !=3D i) ? NULL : f_path + i;
> > +}
> > +
> > +char *addr2line_get_lines(uint64_t address)
> > +{
> > +       char buf[MAX_BUF];
> > +
> > +       fprintf(a2l_stdin, "%08lx\n", address);
> > +       fflush(a2l_stdin);
> > +
> > +       if (!fgets(line, sizeof(line), a2l_stdout)) {
> > +               printf("Failed to read lines from addr2line\n");
> > +               return NULL;
> > +       }
> > +
> > +       if (!fgets(line, sizeof(line), a2l_stdout)) {
> > +               printf("Failed to read lines from addr2line\n");
> > +               return NULL;
> > +       }
> > +
> > +       line[strcspn(line, "\n")] =3D '\0';
> > +       strncpy(buf, line, MAX_BUF);
> > +       return normalize_path(buf, line);
> > +}
> > +
> > +int addr2line_cleanup(void)
> > +{
> > +       int status;
> > +
> > +       if (addr2line_pid !=3D -1) {
> > +               kill(addr2line_pid, SIGKILL);
> > +               waitpid(addr2line_pid, &status, 0);
> > +               fclose(a2l_stdin);
> > +               fclose(a2l_stdout);
> > +               addr2line_pid =3D -1;
> > +       }
> > +
> > +       return 1;
> > +}
> > +
> > +static char *find_executable(const char *command)
> > +{
> > +       char *path_env =3D getenv("PATH");
> > +       char *executable_path;
> > +       char *path_copy;
> > +       char *path;
> > +       int n;
> > +
> > +       if (!path_env)
> > +               return NULL;
> > +
> > +       path_copy =3D strdup(path_env);
> > +       if (!path_copy)
> > +               return NULL;
> > +
> > +       path =3D strtok(path_copy, ":");
> > +       while (path) {
> > +               n =3D snprintf(0, 0, "%s/%s", path, command);
> > +               executable_path =3D (char *)malloc(n + 1);
> > +               snprintf(executable_path, n + 1, "%s/%s", path, command=
);
> > +               if (access(executable_path, X_OK) =3D=3D 0) {
> > +                       free(path_copy);
> > +                       return executable_path;
> > +               }
> > +
> > +       path =3D strtok(NULL, ":");
> > +       free(executable_path);
> > +       executable_path =3D NULL;
> > +       }
> > +
> > +       free(path_copy);
> > +       if (executable_path)
> > +               free(executable_path);
> > +       return NULL;
> > +}
> > +
> > +const char *get_addr2line(int mode)
> > +{
> > +       char *buf =3D "";
> > +
> > +       switch (mode) {
> > +       case A2L_CROSS:
> > +               buf =3D getenv("CROSS_COMPILE");
> > +               memcpy(addr2line_cmd, buf, strlen(buf));
> > +       case A2L_DEFAULT:
> > +               memcpy(addr2line_cmd + strlen(buf), ADDR2LINE,
> > strlen(ADDR2LINE)); +               buf =3D find_executable(addr2line_c=
md);
> > +               if (buf) {
> > +                       memcpy(addr2line_cmd, buf, strlen(buf));
> > +                       free(buf);
> > +               }
> > +               return addr2line_cmd;
> > +       case A2L_LLVM:
> > +       default:
> > +               return NULL;
> > +       }
> > +}
> > +
> > +char *get_vmlinux(char *input)
> > +{
> > +       const char *match_string1 =3D ".syms";
> > +       const char *match_string2 =3D ".tmp_vmlinux.kallsyms";
> > +       char *result =3D NULL;
> > +       char *match_pos;
> > +
> > +       match_pos =3D strstr(input, match_string1);
> > +       if (!match_pos)
> > +               return NULL;
> > +
> > +       match_pos =3D strstr(input, match_string2);
> > +       if (!match_pos)
> > +               return NULL;
> > +
> > +       result =3D strdup(input);
> > +       match_pos =3D strstr(result, match_string1);
> > +       *match_pos =3D '\0';
> > +       return result;
> > +}
> > diff --git a/scripts/kas_alias/a2l.h b/scripts/kas_alias/a2l.h
> > new file mode 100644
> > index 000000000000..ca6419229dde
> > --- /dev/null
> > +++ b/scripts/kas_alias/a2l.h
> > @@ -0,0 +1,32 @@
> > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> > +#ifndef A2L_H
> > +#define A2L_H
> > +#include <stdint.h>
> > +
> > +#define ADDR2LINE "addr2line"
> > +#define ADDR2LINE_ARGS "-fe"
> > +//#define VMLINUX "vmlinux"
> > +#define MAX_BUF 4096
> > +#define MAX_CMD_LEN 256
> > +#define P_READ 0
> > +#define P_WRITE 1
> > +#define A2L_DEFAULT 1
> > +#define A2L_CROSS 2
> > +#define A2L_LLVM 3
> > +#define A2L_MAKE_VALUE 2
> > +
> > +extern int addr2line_pid;
> > +extern int a2l_in[2];
> > +extern int a2l_out[2];
> > +extern char line[MAX_BUF];
> > +extern char vmlinux_path[MAX_BUF];
> > +extern char addr2line_cmd[MAX_CMD_LEN];
> > +
> > +int addr2line_init(const char *cmd, const char *vmlinux);
> > +char *addr2line_get_lines(uint64_t address);
> > +int addr2line_cleanup(void);
> > +const char *remove_subdir(const char *home, const char *f_path);
> > +const char *get_addr2line(int mode);
> > +char *get_vmlinux(char *input);
> > +
> > +#endif
> > diff --git a/scripts/kas_alias/duplicates_list.c
> > b/scripts/kas_alias/duplicates_list.c new file mode 100644
> > index 000000000000..e7a3d2917937
> > --- /dev/null
> > +++ b/scripts/kas_alias/duplicates_list.c
> > @@ -0,0 +1,70 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +#include <stdint.h>
> > +#include <stdio.h>
> > +#include <string.h>
> > +#include <stdlib.h>
> > +#include <stdbool.h>
> > +
> > +#include "item_list.h"
> > +#include "duplicates_list.h"
> > +
> > +struct duplicate_item *find_duplicates(struct item *list)
> > +{
> > +       struct duplicate_item *current_duplicate =3D NULL;
> > +       struct duplicate_item *duplicates =3D NULL;
> > +       struct duplicate_item *new_duplicate;
> > +       struct item *current_item =3D list;
> > +       bool prev_was_duplicate =3D false;
> > +       struct item *prev_item =3D NULL;
> > +
> > +       while (current_item) {
> > +               if ((prev_item && (strcmp(current_item->symb_name,
> > prev_item->symb_name) =3D=3D 0)) || +                   prev_was_duplic=
ate) {
> > +                       if (!duplicates) {
> > +                               duplicates =3D malloc(sizeof(struct
> > duplicate_item)); +                               if (!duplicates)
> > +                                       return NULL;
> > +
> > +                               duplicates->original_item =3D prev_item;
> > +                               duplicates->next =3D NULL;
> > +                               current_duplicate =3D duplicates;
> > +                       } else {
> > +                               new_duplicate =3D malloc(sizeof(struct
> > duplicate_item)); +                               if (!new_duplicate) {
> > +                                       free_duplicates(&duplicates);
> > +                                       return NULL;
> > +                               }
> > +
> > +                               new_duplicate->original_item =3D prev_i=
tem;
> > +                               new_duplicate->next =3D NULL;
> > +                               current_duplicate->next =3D new_duplica=
te;
> > +                               current_duplicate =3D new_duplicate;
> > +
> > +                               if ((strcmp(current_item->symb_name,
> > prev_item->symb_name) !=3D 0) && +                                 =20
> > (prev_was_duplicate))
> > +                                       prev_was_duplicate =3D false;
> > +                               else
> > +                                       prev_was_duplicate =3D true;
> > +                       }
> > +               }
> > +
> > +               prev_item =3D current_item;
> > +               current_item =3D current_item->next;
> > +       }
> > +
> > +       return duplicates;
> > +}
> > +
> > +void free_duplicates(struct duplicate_item **duplicates)
> > +{
> > +       struct duplicate_item *duplicates_iterator =3D *duplicates;
> > +       struct duplicate_item *app;
> > +
> > +       while (duplicates_iterator) {
> > +               app =3D duplicates_iterator;
> > +               duplicates_iterator =3D duplicates_iterator->next;
> > +               free(app);
> > +       }
> > +
> > +       *duplicates =3D NULL;
> > +}
> > diff --git a/scripts/kas_alias/duplicates_list.h
> > b/scripts/kas_alias/duplicates_list.h new file mode 100644
> > index 000000000000..76aa73e584bc
> > --- /dev/null
> > +++ b/scripts/kas_alias/duplicates_list.h
> > @@ -0,0 +1,15 @@
> > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> > +#ifndef DUPLICATES_LIST_H
> > +#define DUPLICATES_LIST_H
> > +
> > +#include "item_list.h"
> > +
> > +struct duplicate_item {
> > +       struct item *original_item;
> > +       struct duplicate_item *next;
> > +};
> > +
> > +struct duplicate_item *find_duplicates(struct item *list);
> > +void free_duplicates(struct duplicate_item **duplicates);
> > +
> > +#endif
> > diff --git a/scripts/kas_alias/item_list.c b/scripts/kas_alias/item_lis=
t.c
> > new file mode 100644
> > index 000000000000..48f2e525592a
> > --- /dev/null
> > +++ b/scripts/kas_alias/item_list.c
> > @@ -0,0 +1,230 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <stdint.h>
> > +#include <string.h>
> > +#include <stdbool.h>
> > +#include <assert.h>
> > +#include "item_list.h"
> > +
> > +#define CHECK_ORDER_BY_ADDRESS(sort_by, current, temp, op) \
> > +       ((sort_by) =3D=3D BY_ADDRESS && (current)->addr op (temp)->addr)
> > +#define CHECK_ORDER_BY_NAME(sort_by, current, temp, op) \
> > +       ((sort_by) =3D=3D BY_NAME && strcmp((current)->symb_name,
> > (temp)->symb_name) op 0) +
> > +struct item *list_index[96] =3D {0};
> > +
> > +void build_index(struct item *list)
> > +{
> > +       char current_first_letter =3D ' ';
> > +       struct item *current =3D list;
> > +
> > +       while (current) {
> > +               if (current->symb_name[0] !=3D current_first_letter) {
> > +                       current_first_letter =3D current->symb_name[0];
> > +                       list_index[current_first_letter - 32] =3D curre=
nt;
> > +               }
> > +               current =3D current->next;
> > +       }
> > +}
> > +
> > +struct item *add_item(struct item **list, const char *name, char stype,
> > uint64_t addr) +{
> > +       struct item *new_item;
> > +       struct item *current;
> > +
> > +       new_item =3D malloc(sizeof(struct item));
> > +       if (!new_item)
> > +               return NULL;
> > +
> > +       strncpy(new_item->symb_name, name, MAX_NAME_SIZE);
> > +       new_item->symb_name[MAX_NAME_SIZE - 1] =3D '\0';
> > +       new_item->addr =3D addr;
> > +       new_item->stype =3D stype;
> > +       new_item->next =3D NULL;
> > +
> > +       if (!(*list)) {
> > +               *list =3D new_item;
> > +       } else {
> > +               current =3D *list;
> > +               while (current->next)
> > +                       current =3D current->next;
> > +
> > +               current->next =3D new_item;
> > +       }
> > +       return new_item;
> > +}
> > +
> > +void sort_list(struct item **list, int sort_by)
> > +{
> > +       struct item *current =3D *list;
> > +       struct item *sorted =3D NULL;
> > +       struct item *next_item;
> > +       struct item *temp;
> > +
> > +       if (!(*list) || !((*list)->next))
> > +               return;
> > +
> > +       while (current) {
> > +               next_item =3D current->next;
> > +               if (!sorted ||
> > +                   (CHECK_ORDER_BY_ADDRESS(sort_by, current, sorted, <)
> > ||
> > +                   CHECK_ORDER_BY_NAME(sort_by, current, sorted, >=3D)=
)) {
> > +                       current->next =3D sorted;
> > +                       sorted =3D current;
> > +               } else {
> > +                       temp =3D sorted;
> > +                       while (temp->next &&
> > +                              (CHECK_ORDER_BY_ADDRESS(sort_by, current,
> > temp->next, >=3D) || +                            =20
> > CHECK_ORDER_BY_NAME(sort_by, current, temp->next, >=3D))) +            =
   =20
> >               temp =3D temp->next;
> > +
> > +                       current->next =3D temp->next;
> > +                       temp->next =3D current;
> > +               }
> > +               current =3D next_item;
> > +       }
> > +
> > +       *list =3D sorted;
> > +}
> > +
> > +struct item *merge(struct item *left, struct item *right, int sort_by)
> > +{
> > +       struct item *current =3D NULL;
> > +       struct item *result =3D NULL;
> > +
> > +       if (!left)
> > +               return right;
> > +       if (!right)
> > +               return left;
> > +
> > +       if (sort_by =3D=3D BY_NAME) {
> > +               if (strcmp(left->symb_name, right->symb_name) <=3D 0) {
> > +                       result =3D left;
> > +                       left =3D left->next;
> > +               } else {
> > +                       result =3D right;
> > +                       right =3D right->next;
> > +               }
> > +       } else {
> > +               if (sort_by =3D=3D BY_ADDRESS) {
> > +                       if (left->addr <=3D right->addr) {
> > +                               result =3D left;
> > +                               left =3D left->next;
> > +                       } else {
> > +                               result =3D right;
> > +                               right =3D right->next;
> > +                       }
> > +               }
> > +       }
> > +
> > +       current =3D result;
> > +
> > +       while (left && right) {
> > +               if (sort_by =3D=3D BY_NAME) {
> > +                       if (strcmp(left->symb_name, right->symb_name) <=
=3D
> > 0) { +                               current->next =3D left;
> > +                               left =3D left->next;
> > +                       } else {
> > +                               current->next =3D right;
> > +                               right =3D right->next;
> > +                       }
> > +               } else {
> > +                       if (sort_by =3D=3D BY_ADDRESS) {
> > +                               if (left->addr <=3D right->addr) {
> > +                                       current->next =3D left;
> > +                                       left =3D left->next;
> > +                               } else {
> > +                                       current->next =3D right;
> > +                                       right =3D right->next;
> > +                               }
> > +                       }
> > +               }
> > +
> > +               current =3D current->next;
> > +       }
> > +
> > +       if (left) {
> > +               current->next =3D left;
> > +       } else {
> > +               if (right)
> > +                       current->next =3D right;
> > +       }
> > +
> > +       return result;
> > +}
> > +
> > +struct item *merge_sort(struct item *head, int sort_by)
> > +{
> > +       struct item *right;
> > +       struct item *slow;
> > +       struct item *fast;
> > +       struct item *left;
> > +
> > +       if (!head || !head->next)
> > +               return head;
> > +
> > +       slow =3D head;
> > +       fast =3D head->next;
> > +
> > +       while (fast && fast->next) {
> > +               slow =3D slow->next;
> > +               fast =3D fast->next->next;
> > +       }
> > +
> > +       left =3D head;
> > +       right =3D slow->next;
> > +       slow->next =3D NULL;
> > +
> > +       left =3D merge_sort(left, sort_by);
> > +       right =3D merge_sort(right, sort_by);
> > +
> > +       return merge(left, right, sort_by);
> > +}
> > +
> > +void sort_list_m(struct item **head, int sort_by)
> > +{
> > +       if (!(*head) || !((*head)->next))
> > +               return;
> > +
> > +       *head =3D merge_sort(*head, sort_by);
> > +}
> > +
> > +int insert_after(struct item *list, const uint64_t search_addr,
> > +                const char *name, uint64_t addr, char stype)
> > +{
> > +       struct item *new_item;
> > +       struct item *current;
> > +       int ret =3D 0;
> > +
> > +       current =3D (list_index[name[0] - 32]) ? list_index[name[0] - 3=
2] :
> > list; +       while (current) {
> > +               if (current->addr =3D=3D search_addr) {
> > +                       new_item =3D malloc(sizeof(struct item));
> > +                       if (!new_item)
> > +                               return ret;
> > +                       strncpy(new_item->symb_name, name, MAX_NAME_SIZ=
E);
> > +                       new_item->symb_name[MAX_NAME_SIZE - 1] =3D '\0';
> > +                       new_item->addr =3D addr;
> > +                       new_item->stype =3D stype;
> > +                       new_item->next =3D current->next;
> > +                       current->next =3D new_item;
> > +                       ret =3D 1;
> > +                       break;
> > +               }
> > +               current =3D current->next;
> > +       }
> > +       return ret;
> > +}
> > +
> > +void free_items(struct item **head)
> > +{
> > +       struct item *app, *item_iterator =3D *head;
> > +
> > +       while (item_iterator) {
> > +               app =3D item_iterator;
> > +               item_iterator =3D item_iterator->next;
> > +               free(app);
> > +       }
> > +       *head =3D NULL;
> > +}
> > diff --git a/scripts/kas_alias/item_list.h b/scripts/kas_alias/item_lis=
t.h
> > new file mode 100644
> > index 000000000000..b4891cb088ee
> > --- /dev/null
> > +++ b/scripts/kas_alias/item_list.h
> > @@ -0,0 +1,26 @@
> > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> > +#ifndef ITEM_LIST_H
> > +#define ITEM_LIST_H
> > +#include <stdint.h>
> > +
> > +#define MAX_NAME_SIZE 256
> > +#define BY_ADDRESS 1
> > +#define BY_NAME 2
> > +
> > +struct item {
> > +       char            symb_name[MAX_NAME_SIZE];
> > +       uint64_t        addr;
> > +       char            stype;
> > +       struct item     *next;
> > +};
> > +
> > +void build_index(struct item *list);
> > +struct item *add_item(struct item **list, const char *name, char stype,
> > uint64_t addr); +void sort_list(struct item **list, int sort_by);
> > +struct item *merge(struct item *left, struct item *right, int sort_by);
> > +struct item *merge_sort(struct item *head, int sort_by);
> > +void sort_list_m(struct item **head, int sort_by);
> > +int insert_after(struct item *list, const uint64_t search_addr,
> > +                const char *name, uint64_t addr, char stype);
> > +void free_items(struct item **head);
> > +#endif
> > diff --git a/scripts/kas_alias/kas_alias.c b/scripts/kas_alias/kas_alia=
s.c
> > new file mode 100644
> > index 000000000000..532aeb39f851
> > --- /dev/null
> > +++ b/scripts/kas_alias/kas_alias.c
> > @@ -0,0 +1,217 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <stdint.h>
> > +#include <unistd.h>
> > +#include <string.h>
> > +#include <stdbool.h>
> > +#include <stdarg.h>
> > +#include <regex.h>
> > +
> > +#include "item_list.h"
> > +#include "duplicates_list.h"
> > +#include "a2l.h"
> > +
> > +#define SYMB_IS_TEXT(s) ((((s)->stype) =3D=3D 't') ||  (((s)->stype) =
=3D=3D 'T'))
> > +#define SYMB_IS_DATA(s) ((((s)->stype) =3D=3D 'b') ||  (((s)->stype) =
=3D=3D 'B')
> > || \ +                        (((s)->stype) =3D=3D 'd') ||  (((s)->styp=
e) =3D=3D
> > 'D') || \ +                        (((s)->stype) =3D=3D 'r') ||=20
> > (((s)->stype) =3D=3D 'R')) +#ifdef CONFIG_KALLSYMS_ALIAS_DATA
> > +#define SYMB_NEEDS_ALIAS(s) (SYMB_IS_TEXT(s) || SYMB_IS_DATA(s))
> > +#else
> > +#define SYMB_NEEDS_ALIAS(s) SYMB_IS_TEXT(s)
> > +#endif
> > +#define FNOMATCH 0
> > +#define FMATCH 1
> > +#define EREGEX 2
> > +
> > +const char *ignore_regex[] =3D {
> > +       "^__cfi_.*$",                           // __cfi_ preamble
> > +#ifndef CONFIG_KALLSYMS_ALIAS_DATA_ALL
> > +       "^_*TRACE_SYSTEM.*$",
> > +       "^__already_done\\.[0-9]+$",            // Call a function once
> > data +       "^___tp_str\\.[0-9]+$",
> > +       "^___done\\.[0-9]+$",
> > +       "^__print_once\\.[0-9]+$",
> > +       "^_rs\\.[0-9]+$",
> > +       "^__compound_literal\\.[0-9]+$",
> > +       "^___once_key\\.[0-9]+$",
> > +       "^__func__\\.[0-9]+$",
> > +       "^__msg\\.[0-9]+$",
> > +       "^CSWTCH\\.[0-9]+$",
> > +       "^__flags\\.[0-9]+$",
> > +       "^__wkey.*$",
> > +       "^__mkey.*$",
> > +       "^__key.*$",
> > +#endif
> > +       "^__pfx_.*$"                            // NOP-padding
> > +};
> > +
> > +int suffix_serial;
> > +
> > +static inline void verbose_msg(bool verbose, const char *fmt, ...)
> > +{
> > +       va_list args;
> > +
> > +       va_start(args, fmt);
> > +       if (verbose)
> > +               printf(fmt, args);
> > +
> > +       va_end(args);
> > +}
> > +
> > +static void create_suffix(const char *name, char *output_suffix)
> > +{
> > +       sprintf(output_suffix, "%s__alias__%d", name, suffix_serial++);
> > +}
> > +
> > +static void create_file_suffix(const char *name, uint64_t address, char
> > *output_suffix, char *cwd) +{
> > +       const char *f_path;
> > +       char *buf;
> > +       int i =3D 0;
> > +
> > +       buf =3D addr2line_get_lines(address);
> > +       f_path =3D remove_subdir(cwd, buf);
> > +       if (f_path) {
> > +               sprintf(output_suffix, "%s@%s", name, f_path);
> > +               while (*(output_suffix + i) !=3D '\0') {
> > +                       switch (*(output_suffix + i)) {
> > +                       case '/':
> > +                       case ':':
> > +                       case '.':
> > +                               *(output_suffix + i) =3D '_';
> > +                               break;
> > +                       default:
> > +                       }
> > +               i++;
> > +               }
> > +       } else {
> > +               create_suffix(name, output_suffix);
> > +       }
> > +}
> > +
> > +static int filter_symbols(char *symbol, const char **ignore_list, int
> > regex_no) +{
> > +       regex_t regex;
> > +       int res, i;
> > +
> > +       for (i =3D 0; i < regex_no; i++) {
> > +               res =3D regcomp(&regex, ignore_list[i], REG_EXTENDED);
> > +               if (res)
> > +                       return -EREGEX;
> > +
> > +               res =3D regexec(&regex, symbol, 0, NULL, 0);
> > +               regfree(&regex);
> > +               switch (res) {
> > +               case 0:
> > +                       return FMATCH;
> > +               case REG_NOMATCH:
> > +                       break;
> > +               default:
> > +                       return -EREGEX;
> > +               }
> > +       }
> > +
> > +       return FNOMATCH;
> > +}
> > +
> > +int main(int argc, char *argv[])
> > +{
> > +       char t, sym_name[MAX_NAME_SIZE], new_name[MAX_NAME_SIZE + 15];
> > +       struct duplicate_item  *duplicate_iterator;
> > +       struct duplicate_item *duplicate;
> > +       struct item *head =3D {NULL};
> > +       bool need_2_process =3D true;
> > +       struct item *last =3D {NULL};
> > +       struct item  *current;
> > +       int verbose_mode =3D 0;
> > +       uint64_t address;
> > +       FILE *fp;
> > +       int res;
> > +
> > +       if (argc < 2 || argc > 3) {
> > +               printf("Usage: %s <nmfile> [-verbose]\n", argv[0]);
> > +               return 1;
> > +       }
> > +
> > +       if (argc =3D=3D 3 && strcmp(argv[2], "-verbose") =3D=3D 0)
> > +               verbose_mode =3D 1;
> > +
> > +       verbose_msg(verbose_mode, "Scanning nm data(%s)\n", argv[1]);
> > +
> > +       fp =3D fopen(argv[1], "r");
> > +       if (!fp) {
> > +               printf("Can't open input file.\n");
> > +               return 1;
> > +       }
> > +
> > +       if (!addr2line_init(get_addr2line(A2L_DEFAULT),
> > get_vmlinux(argv[1]))) +               return 1;
> > +
> > +       while (fscanf(fp, "%lx %c %99s\n", &address, &t, sym_name) =3D=
=3D 3) {
> > +               if (strstr(sym_name, "@_")) {
> > +                       if (verbose_mode && need_2_process)
> > +                               printf("Already processed\n");
> > +                       need_2_process =3D false;
> > +                       }
> > +               last =3D add_item(&last, sym_name, t, address);
> > +               if (!last) {
> > +                       printf("Error in allocate memory\n");
> > +                       free_items(&head);
> > +                       return 1;
> > +               }
> > +
> > +               if (!head)
> > +                       head =3D last;
> > +       }
> > +
> > +       fclose(fp);
> > +
> > +       if (need_2_process) {
> > +               verbose_msg(verbose_mode, "Sorting nm data\n");
> > +               sort_list_m(&head, BY_NAME);
> > +               verbose_msg(verbose_mode, "Scanning nm data for
> > duplicates\n"); +               duplicate =3D find_duplicates(head);
> > +               if (!duplicate) {
> > +                       printf("Error in duplicates list\n");
> > +                       return 1;
> > +               }
> > +
> > +               verbose_msg(verbose_mode, "Applying suffixes\n");
> > +               build_index(head);
> > +               duplicate_iterator =3D duplicate;
> > +               while (duplicate_iterator) {
> > +                       res =3D
> > filter_symbols(duplicate_iterator->original_item->symb_name, +         =
 =20
> >                                 ignore_regex, sizeof(ignore_regex) / + =
 =20
> >                                         sizeof(ignore_regex[0])); +    =
 =20
> >                 if (res !=3D FMATCH &&
> > +                         =20
> > SYMB_NEEDS_ALIAS(duplicate_iterator->original_item)) { +               =
 =20
> >              if (res < 0)
> > +                                       return 1;
> > +
> > +                             =20
> > create_file_suffix(duplicate_iterator->original_item->symb_name, +     =
 =20
> >                                         =20
> > duplicate_iterator->original_item->addr, +                             =
 =20
> >                   new_name, vmlinux_path); +                           =
 =20
> >  if (!insert_after(head, duplicate_iterator->original_item->addr, +    =
 =20
> >                                           new_name,
> > duplicate_iterator->original_item->addr, +                             =
 =20
> >                  duplicate_iterator->original_item->stype)) +          =
 =20
> >                           return 1;
> > +                       }
> > +
> > +                       duplicate_iterator =3D duplicate_iterator->next;
> > +               }
> > +
> > +               sort_list_m(&head, BY_ADDRESS);
> > +       }
> > +       current =3D head;
> > +       while (current) {
> > +               printf("%08lx %c %s\n", current->addr, current->stype,
> > current->symb_name); +               current =3D current->next;
> > +       }
> > +
> > +       free_items(&head);
> > +       free_duplicates(&duplicate);
> > +       addr2line_cleanup();
> > +       return 0;
> > +}
> > diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> > index a432b171be82..cacf60b597ce 100755
> > --- a/scripts/link-vmlinux.sh
> > +++ b/scripts/link-vmlinux.sh
> > @@ -89,8 +89,9 @@ vmlinux_link()
> >=20
> >         ldflags=3D"${ldflags} ${wl}--script=3D${objtree}/${KBUILD_LDS}"
> >=20
> > -       # The kallsyms linking does not need debug symbols included.
> > -       if [ "$output" !=3D "${output#.tmp_vmlinux.kallsyms}" ] ; then
> > +       # The kallsyms linking does not need debug symbols included,
> > unless the KALLSYMS_ALIAS. +       if [ ! is_enabled
> > CONFIG_KALLSYMS_ALIAS ] && \
> > +           [ "$output" !=3D "${output#.tmp_vmlinux.kallsyms}" ] ; then
> >=20
> >                 ldflags=3D"${ldflags} ${wl}--strip-debug"
> >        =20
> >         fi
> >=20
> > @@ -161,7 +162,11 @@ kallsyms()
> >=20
> >         fi
> >        =20
> >         info KSYMS ${2}
> >=20
> > -       scripts/kallsyms ${kallsymopt} ${1} > ${2}
> > +       if is_enabled CONFIG_KALLSYMS_ALIAS; then
> > +               ALIAS=3D".alias"
> > +               scripts/kas_alias/kas_alias ${1} >${1}${ALIAS}
> > +               fi
> > +       scripts/kallsyms ${kallsymopt} ${1}${ALIAS} > ${2}
> >=20
> >  }
> > =20
> >  # Perform one step in kallsyms generation, including temporary linking=
 of
> >=20
> > --
> > 2.34.1

Best regards.


