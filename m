Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 792DCE6F79
	for <lists+live-patching@lfdr.de>; Mon, 28 Oct 2019 11:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731512AbfJ1KHu (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 28 Oct 2019 06:07:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57008 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730905AbfJ1KHu (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 28 Oct 2019 06:07:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=h2Q4yMabWumXaZW53yYMs/vUzD0t62txBeu69uMhfXs=; b=KdOrf3hpp77uq0JTZQt6zyPlH
        XzejktAexd5FqlOvsyVuhOIZLVZYCCpD+rrX/G2HzAGICCFlGupJiJe2LJkzaJoopYPoXLi3tB08G
        Ls7JjRtUd4tASjW2E04Et3J1uEuWLgiyGRlYNV0qST6JZnMjtowztrV37P73yT0RAgVhucM3Edkj7
        EQqVHKS7GhMVYk8tpVjJMYMJME/KK22DVdlK6hMvizKkAWsXZ75mT3G1ud3zBFNyQN24CjCXHvR+f
        dLKCpkJAgbJKs0zRidkly+UiydCgHXt1JlOgTgtV5Nf++7RimZiCV8gBcSW9dI6M9GO2pJOUheIas
        RWfyYVPtQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iP1vo-0004CG-GA; Mon, 28 Oct 2019 10:07:24 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 83EEC30025A;
        Mon, 28 Oct 2019 11:06:21 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9D5C1201E3430; Mon, 28 Oct 2019 11:07:21 +0100 (CET)
Date:   Mon, 28 Oct 2019 11:07:21 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Petr Mladek <pmladek@suse.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, jeyu@kernel.org,
        live-patching@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v4 15/16] module: Move where we mark modules RO,X
Message-ID: <20191028100721.GK4131@hirez.programming.kicks-ass.net>
References: <20191018074634.801435443@infradead.org>
 <20191021135312.jbbxsuipxldocdjk@treble>
 <20191021141402.GI1817@hirez.programming.kicks-ass.net>
 <20191023114835.GT1817@hirez.programming.kicks-ass.net>
 <20191023170025.f34g3vxaqr4f5gqh@treble>
 <20191024131634.GC4131@hirez.programming.kicks-ass.net>
 <20191025064456.6jjrngm4m3mspaxw@pathway.suse.cz>
 <20191025084300.GG4131@hirez.programming.kicks-ass.net>
 <20191025100612.GB5671@hirez.programming.kicks-ass.net>
 <20191026011741.xywerjv62vdmz6sp@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191026011741.xywerjv62vdmz6sp@treble>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Oct 25, 2019 at 08:17:41PM -0500, Josh Poimboeuf wrote:

> + *    The following restrictions apply to module-specific relocation sections:
> + *
> + *    a) References to vmlinux symbols are not allowed.  Otherwise there might
> + *       be module init ordering issues, and crashes might occur in some of the
> + *       other kernel patching components like paravirt patching or jump
> + *       labels.  All references to vmlinux symbols should use either normal
> + *       relas (for exported symbols) or vmlinux-specific klp relas (for
> + *       unexported symbols).  This restriction is enforced in
> + *       klp_resolve_symbols().

Right.

> + *    b) Relocations to special sections like __jump_table and .altinstructions
> + *       aren't allowed.  In other words, there should never be a
> + *       .klp.rela.{module}.__jump_table section.  This will definitely cause
> + *       initialization ordering issues, as such special sections are processed
> + *       during the loading of the klp module itself, *not* the to-be-patched
> + *       module.  This means that e.g., it's not currently possible to patch a
> + *       module function which uses a static key jump label, if you want to
> + *       have the replacement function also use the same static key.  In this
> + *       case, a non-static interface like static_key_enabled() can be used in
> + *       the new function instead.

Idem for .static_call_sites I suppose..

Is there any enforcement on this? I'm thinking it should be possible to
detect the presence of these sections and yell a bit.

OTOH, it should be possible to actually handle this, but let's do that
later.

> + *       On the other hand, a .klp.rela.vmlinux.__jump_table section is fine,
> + *       as it can be resolved early enough during the load of the klp module,
> + *       as described above.
> + */

> diff --git a/kernel/module.c b/kernel/module.c
> index fe5bd382759c..ff4347385f05 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2327,11 +2327,9 @@ static int apply_relocations(struct module *mod, const struct load_info *info)
>  		if (!(info->sechdrs[infosec].sh_flags & SHF_ALLOC))
>  			continue;
>  
> -		/* Livepatch relocation sections are applied by livepatch */
>  		if (info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH)
> -			continue;
> -
> -		if (info->sechdrs[i].sh_type == SHT_REL)
> +			err = klp_write_relocations(mod, NULL);
> +		else if (info->sechdrs[i].sh_type == SHT_REL)
>  			err = apply_relocate(info->sechdrs, info->strtab,
>  					     info->index.sym, i, mod);
>  		else if (info->sechdrs[i].sh_type == SHT_RELA)

Like here, we can yell and error if .klp.rela.{mod}.__jump_table
sections are encountered.


Other than that, this should work I suppose.
