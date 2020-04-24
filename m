Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692CA1B6B67
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2020 04:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbgDXCfb (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 23 Apr 2020 22:35:31 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33337 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725922AbgDXCfa (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 23 Apr 2020 22:35:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587695729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YdcM+ZQkGIyYZX9cs2t00SumwFxHS5seBH1Rxvj+KGo=;
        b=MdUQcv+EuDKe2OvLnBGNbS8AmBIiyuha0RvFFFuwAaC9muJ1PSnz6pPc+1QxITuc0Ijno5
        /xImr3Ismh5xX+iR7kMt51ijB+4iQ8HAvXl3WHOW5MSLi0S3Uscws7WbA3fs1EVsoDI+Ms
        ZhPC+FYY4kVJH8limzASSLsJYA5k4lk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-mCIMKCH5OJGKVhiUrMVnCQ-1; Thu, 23 Apr 2020 22:35:26 -0400
X-MC-Unique: mCIMKCH5OJGKVhiUrMVnCQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 63695835B40;
        Fri, 24 Apr 2020 02:35:24 +0000 (UTC)
Received: from redhat.com (ovpn-112-171.phx2.redhat.com [10.3.112.171])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 31497600E8;
        Fri, 24 Apr 2020 02:35:23 +0000 (UTC)
Date:   Thu, 23 Apr 2020 22:35:21 -0400
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
Message-ID: <20200424023521.GA22117@redhat.com>
References: <cover.1587131959.git.jpoimboe@redhat.com>
 <18266eb2c2c9a2ce0033426837d89dcb363a85d3.1587131959.git.jpoimboe@redhat.com>
 <20200422164037.7edd21ea@thinkpad>
 <20200422172126.743908f5@thinkpad>
 <20200422194605.n77t2wtx5fomxpyd@treble>
 <20200423141834.234ed0bc@thinkpad>
 <alpine.LSU.2.21.2004231513250.6520@pobox.suse.cz>
 <20200423141228.sjvnxwdqlzoyqdwg@treble>
 <20200423181030.b5mircvgc7zmqacr@treble>
 <20200423232657.7minzcsysnhp474w@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423232657.7minzcsysnhp474w@treble>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Apr 23, 2020 at 06:26:57PM -0500, Josh Poimboeuf wrote:
> On Thu, Apr 23, 2020 at 01:10:30PM -0500, Josh Poimboeuf wrote:
> > Mystery solved:
> > 
> >   $ CROSS_COMPILE=s390x-linux-gnu- scripts/faddr2line vmlinux apply_rela+0x16a/0x520
> >   apply_rela+0x16a/0x520:
> >   apply_rela at arch/s390/kernel/module.c:336
> > 
> > which corresponds to the following code in apply_rela():
> > 
> > 
> > 	case R_390_PLTOFF64:	/* 16 bit offset from GOT to PLT. */
> > 		if (info->plt_initialized == 0) {
> > 			unsigned int *ip;
> > 			ip = me->core_layout.base + me->arch.plt_offset +
> > 				info->plt_offset;
> > 			ip[0] = 0x0d10e310;	/* basr 1,0  */
> > 			ip[1] = 0x100a0004;	/* lg	1,10(1) */
> > 
> > 
> > Notice how it's writing directly to text... oops.
> 
> Here's a fix, using write() for the PLT and the GOT.
> 
> diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
> index 2798329ebb74..fe446f42818f 100644
> --- a/arch/s390/kernel/module.c
> +++ b/arch/s390/kernel/module.c
> @@ -297,7 +297,7 @@ static int apply_rela(Elf_Rela *rela, Elf_Addr base, Elf_Sym *symtab,
>  
>  			gotent = me->core_layout.base + me->arch.got_offset +
>  				info->got_offset;
> -			*gotent = val;
> +			write(gotent, &val, sizeof(*gotent));
>  			info->got_initialized = 1;
>  		}
>  		val = info->got_offset + rela->r_addend;
> @@ -330,25 +330,29 @@ static int apply_rela(Elf_Rela *rela, Elf_Addr base, Elf_Sym *symtab,
>  	case R_390_PLTOFF32:	/* 32 bit offset from GOT to PLT. */
>  	case R_390_PLTOFF64:	/* 16 bit offset from GOT to PLT. */
>  		if (info->plt_initialized == 0) {
> -			unsigned int *ip;
> +			unsigned int *ip, insn[5];
> +
>  			ip = me->core_layout.base + me->arch.plt_offset +
>  				info->plt_offset;

Would it be too paranoid to declare:

  			const unsigned int *ip = me->core_layout.base + 
						 me->arch.plt_offset +
  						 info->plt_offset;

That would trip an assignment to read-only error if someone were tempted
to write directly through the pointer in the future.  Ditto for Elf_Addr
*gotent pointer in the R_390_GOTPLTENT case.

-- Joe

