Return-Path: <live-patching+bounces-964-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A728A06FAA
	for <lists+live-patching@lfdr.de>; Thu,  9 Jan 2025 09:06:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9BAF67A0F57
	for <lists+live-patching@lfdr.de>; Thu,  9 Jan 2025 08:06:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A8FD214811;
	Thu,  9 Jan 2025 08:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DfBLx4Nv"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC9C21481B
	for <live-patching@vger.kernel.org>; Thu,  9 Jan 2025 08:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736409968; cv=none; b=GxFOjifunkfqbAa2XccIy43st5EXBtrrg8inRL6FX4nNE/8s0Yq3Xndua2MQj0NULEHMFIQ5Hiy/itqJvdoQ3rXvndpebdFfQINmqnUHDNeQRnJ7kFt4Tc8kDl4+iNt6H+NKwGhwRJzwegY/UgPuWvVPwwMujWyPvKmRqvt46/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736409968; c=relaxed/simple;
	bh=KFUB25o9UQQJzS0Rib0+4wnoYyXJfqfqKywL0fnhTBY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZL1f6UsQh//MxOa+QjebwXlmXyHehINF9bFfRc0y2jN0JZ4MKb+cEfNbcJlr0LrO0uHg0TjrqBByy7xHaUCDPVepKRnjZIvI9mtrdm9Vh3CzFRe+DflIO0PL6QEBoFg0WTwb1Inlm8v0U2mLYMTngKrdXyZLq0ngoR9v1OQHd/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DfBLx4Nv; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-38a8b17d7a7so296643f8f.2
        for <live-patching@vger.kernel.org>; Thu, 09 Jan 2025 00:06:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736409963; x=1737014763; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9ITqsiinxyZSSgCuY2qBILl0Bh+ReB71Q93l6wv0brE=;
        b=DfBLx4NvXltpRH0jfAk8czOt7rHKMqlX7koR5SLwfD4X+6pwKFmV3ZoP7OE/fDJz4K
         MrldMyzhlOCiMYhkgpzD7z6vw1yFlSKQTgoSQpeokQl2m76yWglQWcgH08/3NI4SpskM
         eL0RdghK48k6x/xo/8hY2PUiU1qja18+STZ3Xm75pWOImfRvJj0e2aOWrq/EJ/uixjNR
         IPqmpljPmn1wbOje80HXhx3DkYbiRUZo/oBPWJSOynn9StTVU9TdpxY2uLMbe4qK+lyi
         +291+7E09NCiEevijGKqoaOpBp8xBS24H13j9aT745W7NInTlXkLL1C6xxbiUca0C1pN
         CRlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736409963; x=1737014763;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ITqsiinxyZSSgCuY2qBILl0Bh+ReB71Q93l6wv0brE=;
        b=Ra/sq4+ZQPD9Z9U8Ywk+o+SFAai7i2lbpe6QiMF3irIxT22HGkz2TwFV/sKe4vl1C/
         TLmofG97VXRCvXd0OgERy6VVcXXld53qb80plsHvDP01tjGNPjfRPA8+ypM1eBqtrFcw
         uetpsz3+2KYCKeRIHaUBxBoF4VEgOxPhloU2J2vuaOmwIof1uzUSrr3LPRtO6IXQsRx+
         Jxnx0TjrTYrmZypiixCB8s99HnrhpOtUqsZ02lAfS7Fz8cU6I09R3EP7AGzlvGDqgq54
         AAveTj730FJuFXkE+6nC9zzRN07/VaKrt/PYH1jnk96Qihh2EBpmLP5Z+1sbOSVmLabg
         5uqw==
X-Forwarded-Encrypted: i=1; AJvYcCWlHEynHUa9bnsv1P5qV5Pq1IymkOYmeL311ZyQAdU4Lji+kuTzJ5gQ6BT8cEcp63vtwf/+nUNoMRhKA0fM@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5RI+i4GI3R9QRD7dhvGQqHLwjXSty3oROJAXiGaGafx4Noqup
	FBt84Pjqi0BU8Zm+0orSMvNZoJo2ZM60s7M8Y+lRUrSeZlprOBOqHlxbbxoIyR8=
X-Gm-Gg: ASbGncsVmgP6McF0EgmcS3rDdsylniC0FuXr5di/3UIgloSV26SDjJv3GcfCvEyOGL4
	/V09eBG7W5sc/uVjuRvEqT7zq1adK2Y7sEe7HVy2/ncyOhPRh6ejw8VaRUgPY+Z8ryJzQHdgR91
	DIPeOxAaxHl7qYBI6RwcHeWlEBlB/u0xRO/hphQSp/NBVQPpheHGbXuOr2zEbZ83G1Ip+SG90pE
	bWYnaZeUfxsN3BGCVbmRhYVxML4EpLVWK7RhdmhUAjhgLSCe+4/RQQLuA==
X-Google-Smtp-Source: AGHT+IGIKmYup4HfNyvVOdshyFsmquudgwv4hp4j0NV3FCOB24xiS/Vj/WSSzxsQI5fRwQg1rXrPAw==
X-Received: by 2002:adf:c08d:0:b0:38a:87cc:fb2c with SMTP id ffacd0b85a97d-38a87ccfc17mr3141056f8f.18.1736409963511;
        Thu, 09 Jan 2025 00:06:03 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e4b7f79sm1074729f8f.69.2025.01.09.00.06.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2025 00:06:03 -0800 (PST)
Date: Thu, 9 Jan 2025 09:06:00 +0100
From: Petr Mladek <pmladek@suse.com>
To: Petr Pavlu <petr.pavlu@suse.com>
Cc: rppt@kernel.org, akpm@linux-foundation.org, mmaslanka@google.com,
	mcgrof@kernel.org, regressions@lists.linux.dev,
	linux-modules@vger.kernel.org, linux-mm@kvack.org,
	live-patching@vger.kernel.org, joe.lawrence@redhat.com,
	jpoimboe@kernel.org
Subject: Re: [PATCH] module: Fix writing of livepatch relocations in ROX text
Message-ID: <Z3-DaPKN7hrQl7Lz@pathway.suse.cz>
References: <0530eee7-f329-4786-bea3-c9c66d5f0bed@suse.com>
 <20250107153507.14733-1-petr.pavlu@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250107153507.14733-1-petr.pavlu@suse.com>

On Tue 2025-01-07 16:34:57, Petr Pavlu wrote:
> A livepatch module can contain a special relocation section
> .klp.rela.<objname>.<secname> to apply its relocations at the appropriate
> time and to additionally access local and unexported symbols. When
> <objname> points to another module, such relocations are processed
> separately from the regular module relocation process. For instance, only
> when the target <objname> actually becomes loaded.
> 
> With CONFIG_STRICT_MODULE_RWX, when the livepatch core decides to apply
> these relocations, their processing results in the following bug:
> 
> [   25.827238] BUG: unable to handle page fault for address: 00000000000012ba
> [   25.827819] #PF: supervisor read access in kernel mode
> [   25.828153] #PF: error_code(0x0000) - not-present page
> [   25.828588] PGD 0 P4D 0
> [   25.829063] Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
> [   25.829742] CPU: 2 UID: 0 PID: 452 Comm: insmod Tainted: G O  K    6.13.0-rc4-00078-g059dd502b263 #7820
> [   25.830417] Tainted: [O]=OOT_MODULE, [K]=LIVEPATCH
> [   25.830768] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-20220807_005459-localhost 04/01/2014
> [   25.831651] RIP: 0010:memcmp+0x24/0x60
> [   25.832190] Code: [...]
> [   25.833378] RSP: 0018:ffffa40b403a3ae8 EFLAGS: 00000246
> [   25.833637] RAX: 0000000000000000 RBX: ffff93bc81d8e700 RCX: ffffffffc0202000
> [   25.834072] RDX: 0000000000000000 RSI: 0000000000000004 RDI: 00000000000012ba
> [   25.834548] RBP: ffffa40b403a3b68 R08: ffffa40b403a3b30 R09: 0000004a00000002
> [   25.835088] R10: ffffffffffffd222 R11: f000000000000000 R12: 0000000000000000
> [   25.835666] R13: ffffffffc02032ba R14: ffffffffc007d1e0 R15: 0000000000000004
> [   25.836139] FS:  00007fecef8c3080(0000) GS:ffff93bc8f900000(0000) knlGS:0000000000000000
> [   25.836519] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   25.836977] CR2: 00000000000012ba CR3: 0000000002f24000 CR4: 00000000000006f0
> [   25.837442] Call Trace:
> [   25.838297]  <TASK>
> [   25.841083]  __write_relocate_add.constprop.0+0xc7/0x2b0
> [   25.841701]  apply_relocate_add+0x75/0xa0
> [   25.841973]  klp_write_section_relocs+0x10e/0x140
> [   25.842304]  klp_write_object_relocs+0x70/0xa0
> [   25.842682]  klp_init_object_loaded+0x21/0xf0
> [   25.842972]  klp_enable_patch+0x43d/0x900
> [   25.843572]  do_one_initcall+0x4c/0x220
> [   25.844186]  do_init_module+0x6a/0x260
> [   25.844423]  init_module_from_file+0x9c/0xe0
> [   25.844702]  idempotent_init_module+0x172/0x270
> [   25.845008]  __x64_sys_finit_module+0x69/0xc0
> [   25.845253]  do_syscall_64+0x9e/0x1a0
> [   25.845498]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> [   25.846056] RIP: 0033:0x7fecef9eb25d
> [   25.846444] Code: [...]
> [   25.847563] RSP: 002b:00007ffd0c5d6de8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
> [   25.848082] RAX: ffffffffffffffda RBX: 000055b03f05e470 RCX: 00007fecef9eb25d
> [   25.848456] RDX: 0000000000000000 RSI: 000055b001e74e52 RDI: 0000000000000003
> [   25.848969] RBP: 00007ffd0c5d6ea0 R08: 0000000000000040 R09: 0000000000004100
> [   25.849411] R10: 00007fecefac7b20 R11: 0000000000000246 R12: 000055b001e74e52
> [   25.849905] R13: 0000000000000000 R14: 000055b03f05e440 R15: 0000000000000000
> [   25.850336]  </TASK>
> [   25.850553] Modules linked in: deku(OK+) uinput
> [   25.851408] CR2: 00000000000012ba
> [   25.852085] ---[ end trace 0000000000000000 ]---
> 
> The problem is that the .klp.rela.<objname>.<secname> relocations are
> processed after the module was already formed and mod->rw_copy was reset.
> However, the code in __write_relocate_add() calls module_writable_address()
> which translates the target address 'loc' still to
> 'loc + (mem->rw_copy - mem->base)', with mem->rw_copy now being 0.
> 
> Fix the problem by returning directly 'loc' in module_writable_address()
> when the module is already formed. Function __write_relocate_add() knows to
> use text_poke() in such a case.
> 
> Fixes: 0c133b1e78cd ("module: prepare to handle ROX allocations for text")
> Reported-by: Marek Maslanka <mmaslanka@google.com>
> Closes: https://lore.kernel.org/linux-modules/CAGcaFA2hdThQV6mjD_1_U+GNHThv84+MQvMWLgEuX+LVbAyDxg@mail.gmail.com/
> Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>

The fix makes sense. I could confirm that it fixes the problem
and the livepatch relocations works again.

I have tested it on x86_64 with current Linus' origin/master
and the selftest from the patchset adding klp-convert tool, see
https://lore.kernel.org/r/20240827123052.9002-7-lhruska@suse.cz

Reviewed-by: Petr Mladek <pmladek@suse.com>
Tested-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr

