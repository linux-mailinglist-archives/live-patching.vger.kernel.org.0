Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5244BE2FA
	for <lists+live-patching@lfdr.de>; Mon, 21 Feb 2022 18:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351452AbiBUJtX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 21 Feb 2022 04:49:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352911AbiBUJsB (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 21 Feb 2022 04:48:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8F94823BFA
        for <live-patching@vger.kernel.org>; Mon, 21 Feb 2022 01:21:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645435276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GumUOC/tpD4HU1sIpPheYV1+0ORIMlK0adifuiQaD2s=;
        b=E+MdTCx+dS7M7G6qyH+NczW2cPeNwD8rj5F0XFqtxjq9xERNerEP2cQckc+IVw/NXcB2dZ
        o8lPaxYeWdNTuo3JwcE4IXWfcUYVAd6lOiN9MmPOYMxB1dQzmOjYYXgwNUGMVbqKHTr2Oy
        vcYsUl5O4vVrnB+jlIzl6P6V73f9Xr8=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131-T2eGSZWPMaW561lVexZWiw-1; Mon, 21 Feb 2022 04:21:15 -0500
X-MC-Unique: T2eGSZWPMaW561lVexZWiw-1
Received: by mail-lj1-f197.google.com with SMTP id n9-20020a2e82c9000000b002435af2e8b9so3748278ljh.20
        for <live-patching@vger.kernel.org>; Mon, 21 Feb 2022 01:21:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GumUOC/tpD4HU1sIpPheYV1+0ORIMlK0adifuiQaD2s=;
        b=DW7bT7TWUJzUFC6CxxwYvhEuAAtSdSbJkkfftxrEwdzlDgtNxGh0jDr73C7BefJdHO
         I0/5q6oum6eeiBt3+DmN4M2lKCB7HSgRhPkVM+Q2Fr8F++nG+GhgNkRr3+FfvkEpE17p
         1KtvdqUpI+lp5uQN0arS85+gUSdqyM2DT6dYKxaQSHbgj6ZoK3KyIb9v0Cfssc49N5bu
         BlAs+82zUbRS9Ar1PPxWmbQb9lEuh54+Jc0DhLfKH0AfzAQjyej/20M8TGqsqKDnQOdL
         lft4tQyt5GMjSB9c1MkfGbq6Uas47xsaOAnvaCvcQWj7wO0njfrFJa96IDdygmK/bseU
         sDhg==
X-Gm-Message-State: AOAM530geTRXvGG9B06X+kKSFQnJLRO4g/LXldZKOAmvsx5qZok4V4vJ
        6oCkISg8aKVwvx6GlV1ZXsLep9hjPBsmYE5NNIRiivpuMN9ikahw4uXXuU+4LZ6vG7pChZaJ4y2
        xLeilGgCkkGDqIILBr6xpl43R7cU/5Dyxx6Cw3ua6
X-Received: by 2002:a05:651c:386:b0:244:e2ab:87f9 with SMTP id e6-20020a05651c038600b00244e2ab87f9mr13464556ljp.201.1645435272754;
        Mon, 21 Feb 2022 01:21:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwvHaDSK1yq/EJhp1HN5IPx788Jxxn4WG+3hHVeYtWFW+WKzEDLmnp+QQW9Oi3deV9rKkZ3Si1vrNu1O+WNJLA=
X-Received: by 2002:a05:651c:386:b0:244:e2ab:87f9 with SMTP id
 e6-20020a05651c038600b00244e2ab87f9mr13464535ljp.201.1645435272173; Mon, 21
 Feb 2022 01:21:12 -0800 (PST)
MIME-Version: 1.0
References: <20220218212511.887059-1-atomlin@redhat.com> <20220218212511.887059-10-atomlin@redhat.com>
 <98cff67e-d2ca-705b-7c83-bd3f41df98d9@csgroup.eu>
In-Reply-To: <98cff67e-d2ca-705b-7c83-bd3f41df98d9@csgroup.eu>
From:   Aaron Tomlin <atomlin@redhat.com>
Date:   Mon, 21 Feb 2022 09:21:00 +0000
Message-ID: <CANfR36gBNC0ZPJPAn2H04cOC+ztQdeBC19LzaF5hU2fhHqrr9A@mail.gmail.com>
Subject: Re: [PATCH v6 09/13] module: Move kallsyms support into a separate file
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "mcgrof@kernel.org" <mcgrof@kernel.org>,
        "cl@linux.com" <cl@linux.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "atomlin@atomlin.com" <atomlin@atomlin.com>,
        "ghalat@redhat.com" <ghalat@redhat.com>,
        "allen.lkml@gmail.com" <allen.lkml@gmail.com>,
        "joe@perches.com" <joe@perches.com>,
        "msuchanek@suse.de" <msuchanek@suse.de>,
        "oleksandr@natalenko.name" <oleksandr@natalenko.name>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon 2022-02-21 08:15 +0000, Christophe Leroy wrote:
> [   36.421711] BUG: Unable to handle kernel data access on write at
> 0xbe79bb40
> [   36.428435] Faulting instruction address: 0xc008b74c
> [   36.433342] Oops: Kernel access of bad area, sig: 11 [#1]
> [   36.438672] BE PAGE_SIZE=16K PREEMPT CMPC885
> [   36.442947] SAF3000 DIE NOTIFICATION
> [   36.446421] Modules linked in:
> [   36.449436] CPU: 0 PID: 374 Comm: insmod Not tainted
> 5.17.0-rc4-s3k-dev-02274-g7d4ec8831803 #1016
> [   36.458211] NIP:  c008b74c LR: c00897ac CTR: c001145c
> [   36.463200] REGS: caf8bcf0 TRAP: 0300   Not tainted
> (5.17.0-rc4-s3k-dev-02274-g7d4ec8831803)
> [   36.471633] MSR:  00009032 <EE,ME,IR,DR,RI>  CR: 24002842  XER: 00000000
> [   36.478261] DAR: be79bb40 DSISR: c2000000
> [   36.478261] GPR00: c00899a0 caf8bdb0 c230a980 be74c000 caf8beb8
> 00000008 00000000 c035629c
> [   36.478261] GPR08: be75c000 caf9c9fc be79bb40 00000004 24002842
> 100d166a 00000290 00000000
> [   36.478261] GPR16: c0747320 caf9c9fc c11ff918 caf9b2a7 be75c290
> 00000550 00000022 c0747210
> [   36.478261] GPR24: c11ff8e8 be74c000 c11ff8fc 100b8820 00000000
> 00000000 be74c000 caf8beb8
> [   36.516729] NIP [c008b74c] add_kallsyms+0x48/0x30c
> [   36.521465] LR [c00897ac] load_module+0x16f8/0x2504
> [   36.526286] Call Trace:
> [   36.528693] [caf8bdb0] [00000208] 0x208 (unreliable)
> [   36.533598] [caf8bde0] [c00899a0] load_module+0x18ec/0x2504
> [   36.539107] [caf8beb0] [c008a7a8] sys_finit_module+0xb4/0xf8
> [   36.544700] [caf8bf30] [c00120a4] ret_from_syscall+0x0/0x28
> [   36.550209] --- interrupt: c00 at 0xfd5e7c0
> [   36.554339] NIP:  0fd5e7c0 LR: 100144e8 CTR: 10013238
> [   36.559331] REGS: caf8bf40 TRAP: 0c00   Not tainted
> (5.17.0-rc4-s3k-dev-02274-g7d4ec8831803)
> [   36.567763] MSR:  0000d032 <EE,PR,ME,IR,DR,RI>  CR: 24002222  XER:
> 00000000
> [   36.574735]
> [   36.574735] GPR00: 00000161 7fc5a130 7792f4e0 00000003 100b8820
> 00000000 0fd4ded4 0000d032
> [   36.574735] GPR08: 00000000 10013238 00000000 00000002 142d2297
> 100d166a 100a0920 00000000
> [   36.574735] GPR16: 100cac0c 100b0000 1013c3cc 1013d685 100d0000
> 100d0000 00000000 100a0900
> [   36.574735] GPR24: ffffffa2 ffffffff 1013c3a4 00000003 1013c3cc
> 100b8820 1013c3f0 1013c3cc
> [   36.610535] NIP [0fd5e7c0] 0xfd5e7c0
> [   36.614065] LR [100144e8] 0x100144e8
> [   36.617593] --- interrupt: c00
> [   36.620609] Instruction dump:
> [   36.623534] 7c7e1b78 81040038 8124003c 81430100 55082036 7d0a4214
> 1d490028 81240010
> [   36.631365] 9103015c 7d295214 8109000c 8143015c <910a0000> 81290014
> 8143015c 5529e13e
> [   36.639376] ---[ end trace 0000000000000000 ]---

Hi Christophe,

Unfortunately, I do not have the debuginfo data. Albeit, based on the stack
trace, I suspect this was the result of the dereference attempt (below) due
to the invalid pointer stored in mod->kallsyms i.e. mod->kallsyms = (struct
mod_kallsyms __rcu *)mod->init_layout.base + info->mod_kallsyms_init_off:

  177             /* The following is safe since this pointer cannot change */
  178             rcu_dereference_sched(mod->kallsyms)->symtab = (void
*)symsec->sh_addr;

Kind regards,

-- 
Aaron Tomlin

