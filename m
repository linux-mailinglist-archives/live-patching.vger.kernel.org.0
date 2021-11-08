Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B532447D0B
	for <lists+live-patching@lfdr.de>; Mon,  8 Nov 2021 10:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236099AbhKHJtw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 8 Nov 2021 04:49:52 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:34590 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232818AbhKHJtw (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 8 Nov 2021 04:49:52 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 46FD91FD4B;
        Mon,  8 Nov 2021 09:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1636364827; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zigEgwMAEavRVLp+BJtAfXNpYofMF3JDQX/JpOBUL4w=;
        b=WLLKV/YRu4/8Yv2L2sy9mY69NGD5Xm49FdpVe16AL4LOEP8J4o2s/u8FBeNwgL5mH1i7bj
        taui7ghqRshCvhcpTfGwsygDhsx+MkX6w85OO7fMP9IdsakUPjweCptxJuxYYhrdt+fILV
        vRqLwTKcGR/Eywyn0otcoPztY1Iypsg=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id F254EA3B81;
        Mon,  8 Nov 2021 09:47:06 +0000 (UTC)
Date:   Mon, 8 Nov 2021 10:47:06 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v1 1/5] livepatch: Fix build failure on 32 bits processors
Message-ID: <YYjyGhhNbwtrx4p8@alley>
References: <cover.1635423081.git.christophe.leroy@csgroup.eu>
 <cefeeaf1447088db00c5a62e2ff03f7d15bb4c05.1635423081.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cefeeaf1447088db00c5a62e2ff03f7d15bb4c05.1635423081.git.christophe.leroy@csgroup.eu>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2021-10-28 14:24:01, Christophe Leroy wrote:
> Trying to build livepatch on powerpc/32 results in:
> 
> 	kernel/livepatch/core.c: In function 'klp_resolve_symbols':
> 	kernel/livepatch/core.c:221:23: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> 	  221 |                 sym = (Elf64_Sym *)sechdrs[symndx].sh_addr + ELF_R_SYM(relas[i].r_info);
> 	      |                       ^
> 	kernel/livepatch/core.c:221:21: error: assignment to 'Elf32_Sym *' {aka 'struct elf32_sym *'} from incompatible pointer type 'Elf64_Sym *' {aka 'struct elf64_sym *'} [-Werror=incompatible-pointer-types]
> 	  221 |                 sym = (Elf64_Sym *)sechdrs[symndx].sh_addr + ELF_R_SYM(relas[i].r_info);
> 	      |                     ^
> 	kernel/livepatch/core.c: In function 'klp_apply_section_relocs':
> 	kernel/livepatch/core.c:312:35: error: passing argument 1 of 'klp_resolve_symbols' from incompatible pointer type [-Werror=incompatible-pointer-types]
> 	  312 |         ret = klp_resolve_symbols(sechdrs, strtab, symndx, sec, sec_objname);
> 	      |                                   ^~~~~~~
> 	      |                                   |
> 	      |                                   Elf32_Shdr * {aka struct elf32_shdr *}
> 	kernel/livepatch/core.c:193:44: note: expected 'Elf64_Shdr *' {aka 'struct elf64_shdr *'} but argument is of type 'Elf32_Shdr *' {aka 'struct elf32_shdr *'}
> 	  193 | static int klp_resolve_symbols(Elf64_Shdr *sechdrs, const char *strtab,
> 	      |                                ~~~~~~~~~~~~^~~~~~~
> 
> Fix it by using the right types instead of forcing 64 bits types.
> 
> Fixes: 7c8e2bdd5f0d ("livepatch: Apply vmlinux-specific KLP relocations early")
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>

Makes sense. I haven't tested it but it looks correct ;-)

Acked-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
