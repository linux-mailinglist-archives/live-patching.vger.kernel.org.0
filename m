Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A398A1B4D98
	for <lists+live-patching@lfdr.de>; Wed, 22 Apr 2020 21:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgDVTqS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Apr 2020 15:46:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46914 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725961AbgDVTqR (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Apr 2020 15:46:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587584775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bz3/wnwvPYrqLraYmQKr5kAw4lnPaAd0IDA6hfhqLJ8=;
        b=aXjjuFARD/g5on3pfn2E7ljzCKnYnlMGH90cvWtOVHXcZSxHNxkKwJ7UFQIC+rho5aVLuj
        Uv4UrSgg/2sEJbvpWx5305ECOLNr4nLQSHCJwwPRaEnggXRHhGzgXYm3U2utpviMJzgtd1
        87emjITMbhTJh3TJOOm8T2FO+Nb4v1A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-fAo_F7r5Oj6tBd3ZC9FM_A-1; Wed, 22 Apr 2020 15:46:13 -0400
X-MC-Unique: fAo_F7r5Oj6tBd3ZC9FM_A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 63BF7800685;
        Wed, 22 Apr 2020 19:46:11 +0000 (UTC)
Received: from treble (unknown [10.10.115.243])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 146175C1D4;
        Wed, 22 Apr 2020 19:46:06 +0000 (UTC)
Date:   Wed, 22 Apr 2020 14:46:05 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, Vasily Gorbik <gor@linux.ibm.com>,
        Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH v2 6/9] s390/module: Use s390_kernel_write() for late
 relocations
Message-ID: <20200422194605.n77t2wtx5fomxpyd@treble>
References: <cover.1587131959.git.jpoimboe@redhat.com>
 <18266eb2c2c9a2ce0033426837d89dcb363a85d3.1587131959.git.jpoimboe@redhat.com>
 <20200422164037.7edd21ea@thinkpad>
 <20200422172126.743908f5@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200422172126.743908f5@thinkpad>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Apr 22, 2020 at 05:21:26PM +0200, Gerald Schaefer wrote:
> > Sorry, just noticed this. Heiko will return next month, and I'm not
> > really familiar with s390 livepatching. Adding Vasily, he might
> > have some more insight.
> > 
> > So, I might be completely wrong here, but using s390_kernel_write()
> > for writing to anything other than 1:1 mapped kernel, should go
> > horribly wrong, as that runs w/o DAT. It would allow to bypass
> > DAT write protection, which I assume is why you want to use it,
> > but it should not work on module text section, as that would be
> > in vmalloc space and not 1:1 mapped kernel memory.
> > 
> > Not quite sure how to test / trigger this, did this really work for
> > you on s390?
> 
> OK, using s390_kernel_write() as default write function for module
> relocation seems to work fine for me, so apparently I am missing /
> mixing up something. Sorry for the noise, please ignore my concern.

Hi Gerald,

I think you were right.  Joe found the below panic with his klp-convert
tests.

Your test was probably the early module loading case (normal relocations
before write protection), rather than the late case.  Not sure why that
would work, but calling s390_kernel_write() late definitely seems to be
broken.

Is there some other way to write vmalloc'ed s390 text without using
module_disable_ro()?

[   50.294476] Unable to handle kernel pointer dereference in virtual kernel address space
[   50.294479] Failing address: 000003ff8015b000 TEID: 000003ff8015b407
[   50.294480] Fault in home space mode while using kernel ASCE.
[   50.294483] AS:000000006cef0007 R3:000000007e2c4007 S:0000000003ccb800 P:0000 00000257321d
[   50.294557] Oops: 0004 ilc:3 [#1] SMP
[   50.294561] Modules linked in: test_klp_convert1(K+) test_klp_convert_mod ghash_s390 prng xts aes_s390 des_s390 libdes sha512_s390 vmur zcrypt_cex4 ip_tables xfs libcrc32c dasd_fba_mod qeth_l2 dasd_eckd_mod dasd_mod qeth lcs ctcm qdio cc
wgroup fsm dm_mirror dm_region_hash dm_log dm_mod pkey zcrypt [last unloaded: test_klp_atomic_replace]
[   50.294576] CPU: 0 PID: 1743 Comm: modprobe Tainted: G              K   5.6.0 + #2
[   50.294579] Hardware name: IBM 2964 N96 400 (z/VM 6.4.0)
[   50.294583] Krnl PSW : 0704e00180000000 000000006bf6be0a (apply_rela+0x2ba/0x 4e0)
[   50.294589]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI: 0 EA:3
[   50.294684] Krnl GPRS: 000003ff80147010 000003e0001b9588 000003ff8015c168 000 003ff8015b19a
[   50.294686]            000003ff8015b07c 0d10e310100a0004 000003ff80147010 000 00000000000a0
[   50.294687]            000003ff8015e588 000003ff8015e5e8 000003ff8015d300 000 0003b00000014
[   50.294698]            000000007a663000 000000006c6bbb80 000003e0009a7918 000 003e0009a78b8
[   50.294707] Krnl Code: 000000006bf6bdf8: e350d0080004        lg      %r5,8(%r 13)
[   50.294707]            000000006bf6bdfe: e34010080008        ag      %r4,8(%r 1)
[   50.294707]           #000000006bf6be04: e340a2000008        ag      %r4,512( %r10)
[   50.294707]           >000000006bf6be0a: e35040000024        stg     %r5,0(%r 4)
[   50.294707]            000000006bf6be10: c050007c6136        larl    %r5,0000 00006cef807c
[   50.294707]            000000006bf6be16: e35050000012        lt      %r5,0(%r 5)
[   50.294707]            000000006bf6be1c: a78400a6            brc     8,000000 006bf6bf68
[   50.294707]            000000006bf6be20: a55e07f1            llilh   %r5,2033
01: HCPGSP2629I The virtual machine is placed in CP mode due to a SIGP stop from CPU 01.
01: HCPGSP2629I The virtual machine is placed in CP mode due to a SIGP stop from CPU 00.
[   50.295369] Call Trace:
[   50.295372]  [<000000006bf6be0a>] apply_rela+0x2ba/0x4e0
[   50.295376]  [<000000006bf6c5c8>] apply_relocate_add+0xe0/0x138
[   50.295378]  [<000000006c0229a0>] klp_apply_section_relocs+0xe8/0x128
[   50.295380]  [<000000006c022b4c>] klp_apply_object_relocs+0x9c/0xd0
[   50.295382]  [<000000006c022bb0>] klp_init_object_loaded+0x30/0x138
[   50.295384]  [<000000006c023052>] klp_enable_patch+0x39a/0x870
[   50.295387]  [<000003ff8015b0da>] test_klp_convert_init+0x22/0x50 [test_klp_convert1]
[   50.295389]  [<000000006bf54838>] do_one_initcall+0x40/0x1f0
[   50.295391]  [<000000006c04d610>] do_init_module+0x70/0x280
[   50.295392]  [<000000006c05002a>] load_module+0x1aba/0x1d10
[   50.295394]  [<000000006c0504c4>] __do_sys_finit_module+0xa4/0xe8
[   50.295416]  [<000000006c6b5742>] system_call+0x2aa/0x2c8
[   50.295416] Last Breaking-Event-Address:
[   50.295418]  [<000000006c6b6aa0>] __s390_indirect_jump_r4+0x0/0xc
[   50.295421] Kernel panic - not syncing: Fatal exception: panic_on_oops

-- 
Josh

