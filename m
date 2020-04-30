Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2423F1BFE83
	for <lists+live-patching@lfdr.de>; Thu, 30 Apr 2020 16:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbgD3Oib (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 30 Apr 2020 10:38:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58366 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727899AbgD3Oib (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 30 Apr 2020 10:38:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588257509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ByKU/UvmG+5uVD3nwPmlWIqbXZ/e5s+ex3rfVMZS44E=;
        b=TRnJUs8SRQxiNh7uZxh1UQ6QweqFyU94WmLpEfsULP/zetXOaa5Uryi3WnjFozKe4KY7Qc
        roZm7fYNwK5ns8/k7TDBkZIzFAeah8H/z4zdLwZRxWPutna+mOtV1DGPqnEhYvE3i+vx2T
        jz++vyuqgim3UqGo/EtoYMl/ra5Z5Bk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-aCIDm1xEOq-BFhOT_wXtLA-1; Thu, 30 Apr 2020 10:38:25 -0400
X-MC-Unique: aCIDm1xEOq-BFhOT_wXtLA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37A9D1009613;
        Thu, 30 Apr 2020 14:38:24 +0000 (UTC)
Received: from redhat.com (ovpn-112-171.phx2.redhat.com [10.3.112.171])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 03BCD610AF;
        Thu, 30 Apr 2020 14:38:22 +0000 (UTC)
Date:   Thu, 30 Apr 2020 10:38:21 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Miroslav Benes <mbenes@suse.cz>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH v2 6/9] s390/module: Use s390_kernel_write() for late
 relocations
Message-ID: <20200430143821.GA10092@redhat.com>
References: <cover.1587131959.git.jpoimboe@redhat.com>
 <18266eb2c2c9a2ce0033426837d89dcb363a85d3.1587131959.git.jpoimboe@redhat.com>
 <20200422164037.7edd21ea@thinkpad>
 <20200422172126.743908f5@thinkpad>
 <20200422194605.n77t2wtx5fomxpyd@treble>
 <20200423141834.234ed0bc@thinkpad>
 <alpine.LSU.2.21.2004231513250.6520@pobox.suse.cz>
 <20200423141228.sjvnxwdqlzoyqdwg@treble>
 <20200423181030.b5mircvgc7zmqacr@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423181030.b5mircvgc7zmqacr@treble>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Apr 23, 2020 at 01:10:30PM -0500, Josh Poimboeuf wrote:
> On Thu, Apr 23, 2020 at 09:12:28AM -0500, Josh Poimboeuf wrote:
> > > > this is strange. While I would have expected an exception similar to
> > > > this, it really should have happened on the "sturg" instruction which
> > > > does the DAT-off store in s390_kernel_write(), and certainly not with
> > > > an ID of 0004 (protection). However, in your case, it happens on a
> > > > normal store instruction, with 0004 indicating a protection exception.
> > > > 
> > > > This is more like what I would expect e.g. in the case where you do
> > > > _not_ use the s390_kernel_write() function for RO module text patching,
> > > > but rather normal memory access. So I am pretty sure that this is not
> > > > related to the s390_kernel_write(), but some other issue, maybe some
> > > > place left where you still use normal memory access?
> > > 
> > > The call trace above also suggests that it is not a late relocation, no? 
> > > The path is from KLP module init function through klp_enable_patch. It should 
> > > mean that the to-be-patched object is loaded (it must be a module thanks 
> > > to a check klp_init_object_loaded(), vmlinux relocations were processed 
> > > earlier in apply_relocations()).
> > > 
> > > However, the KLP module state here must be COMING, so s390_kernel_write() 
> > > should be used. What are we missing?
> > 
> > I'm also scratching my head.  It _should_ be using s390_kernel_write()
> > based on the module state, but I don't see that on the stack trace.
> > 
> > This trace (and Gerald's comment) seem to imply it's using
> > __builtin_memcpy(), which might expected for UNFORMED state.
> > 
> > Weird...
> 
> Mystery solved:
> 
>   $ CROSS_COMPILE=s390x-linux-gnu- scripts/faddr2line vmlinux apply_rela+0x16a/0x520
>   apply_rela+0x16a/0x520:
>   apply_rela at arch/s390/kernel/module.c:336
> 
> which corresponds to the following code in apply_rela():
> 
> 
> 	case R_390_PLTOFF64:	/* 16 bit offset from GOT to PLT. */
> 		if (info->plt_initialized == 0) {
> 			unsigned int *ip;
> 			ip = me->core_layout.base + me->arch.plt_offset +
> 				info->plt_offset;
> 			ip[0] = 0x0d10e310;	/* basr 1,0  */
> 			ip[1] = 0x100a0004;	/* lg	1,10(1) */
> 
> 
> Notice how it's writing directly to text... oops.
> 

This is more of note for the future, but when/if we add livepatch
support on arm64 we'll need to make the very same adjustment there as
well.  See the following pattern:

arch/arm64/kernel/module.c:

  reloc_insn_movw()
  reloc_insn_imm()
  reloc_insn_adrp()

    *place = cpu_to_le32(insn);

maybe something like aarch64_insn_patch_text_nosync() could be used
there, I dunno. (It looks like ftrace and jump_labels are using that
interface.)

This is outside the scope of the patchset, but I thought I'd mention it
as I was curious to see how other arches were currently handling their
relocation updates.

-- Joe

