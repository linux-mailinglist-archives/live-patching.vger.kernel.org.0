Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADCD47D327
	for <lists+live-patching@lfdr.de>; Wed, 22 Dec 2021 14:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236710AbhLVNrY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Dec 2021 08:47:24 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:52806 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234159AbhLVNrY (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Dec 2021 08:47:24 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 345D81F388;
        Wed, 22 Dec 2021 13:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1640180843; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k57L7T1HFo6BPqAXN0sieUpWuA2JdRZZvO8uuOmZVkI=;
        b=hk9hNSehpgPjEhhYQ6InKoLbcyrWSZzt7roPYMtMEwUOowTwHpnc6/9+QF1/tzHJJmqGEI
        9ol92vjG4CAynslgyjK46zcFZK04ENjjGkfoHtJWVvGmfzl5R3Y94T6nMXv+KKzSF+MtWt
        ZzZ31s47Q8Qb15WacukQOS+A3lD8E5Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1640180843;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k57L7T1HFo6BPqAXN0sieUpWuA2JdRZZvO8uuOmZVkI=;
        b=TBrGVvf5jV+Mkf4gIOwJLU7GoPk1SN+OQSBw7mJNv8A+93AqucP/J2U8pc9XnZWNNh+XRn
        GtDG7c5CB+amK/CQ==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 9271FA3B89;
        Wed, 22 Dec 2021 13:47:22 +0000 (UTC)
Date:   Wed, 22 Dec 2021 14:47:22 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>
Subject: Re: [PATCH v2 01/13] livepatch: Fix build failure on 32 bits
 processors
In-Reply-To: <5288e11b018a762ea3351cc8fb2d4f15093a4457.1640017960.git.christophe.leroy@csgroup.eu>
Message-ID: <alpine.LSU.2.21.2112221447060.18494@pobox.suse.cz>
References: <cover.1640017960.git.christophe.leroy@csgroup.eu> <5288e11b018a762ea3351cc8fb2d4f15093a4457.1640017960.git.christophe.leroy@csgroup.eu>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 20 Dec 2021, Christophe Leroy wrote:

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
> Acked-by: Petr Mladek <pmladek@suse.com>

Acked-by: Miroslav Benes <mbenes@suse.cz>

M
