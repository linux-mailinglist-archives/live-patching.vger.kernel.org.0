Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E39001B51A3
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2020 03:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgDWBKO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Apr 2020 21:10:14 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56764 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726324AbgDWBKO (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Apr 2020 21:10:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587604213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gpmF7iLJaKAhFgik0YYBKvZq2mUVWcZ8e1b5KXEpW50=;
        b=HWA7Ll+0R36CpD1eZFaQ2d664zSSp4Bn49d35k19Dr/O+k6C2tuFGJ26MZm+mVeZzTroDe
        dVOvw7/ts55E+wD2eaDGo0OoGxGp9zS6PhwfmKHMh9R+HacN9ACGa8K7u6+HJ1iLxrqoGo
        7pLKzrxwoFwtO452eD/mC7abDKVPBv8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-B2P9V75uPF6XHblE7rVSvA-1; Wed, 22 Apr 2020 21:10:09 -0400
X-MC-Unique: B2P9V75uPF6XHblE7rVSvA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5DB4F1005510;
        Thu, 23 Apr 2020 01:10:08 +0000 (UTC)
Received: from redhat.com (ovpn-112-171.phx2.redhat.com [10.3.112.171])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CFA465D9E2;
        Thu, 23 Apr 2020 01:10:05 +0000 (UTC)
Date:   Wed, 22 Apr 2020 21:10:03 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH v2 2/9] livepatch: Apply vmlinux-specific KLP relocations
 early
Message-ID: <20200423011003.GA20432@redhat.com>
References: <cover.1587131959.git.jpoimboe@redhat.com>
 <83eb0be61671eab05e2d7bcd0aa848f6e20087b0.1587131959.git.jpoimboe@redhat.com>
 <20200420175751.GA13807@redhat.com>
 <20200420182516.6awwwbvoen62gwbr@treble>
 <20200420190141.GB13807@redhat.com>
 <20200420191117.wrjauayeutkpvkwd@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420191117.wrjauayeutkpvkwd@treble>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Apr 20, 2020 at 02:11:17PM -0500, Josh Poimboeuf wrote:
> On Mon, Apr 20, 2020 at 03:01:41PM -0400, Joe Lawrence wrote:
> > > > ... apply_relocations() is also iterating over the section headers (the
> > > > diff context doesn't show it here, but i is an incrementing index over
> > > > sechdrs[]).
> > > > 
> > > > So if there is more than one KLP relocation section, we'll process them
> > > > multiple times.  At least the x86 relocation code will detect this and
> > > > fail the module load with an invalid relocation (existing value not
> > > > zero).
> > > 
> > > Ah, yes, good catch!
> > > 
> > 
> > The same test case passed with a small modification to push the foreach
> > KLP section part to a kernel/livepatch/core.c local function and
> > exposing the klp_resolve_symbols() + apply_relocate_add() for a given
> > section to kernel/module.c.  Something like following...
> 
> I came up with something very similar, though I named them
> klp_apply_object_relocs() and klp_apply_section_relocs() and changed the
> argument order a bit (module first).  Since it sounds like you have a
> test, could you try this one?
> 
> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> index 533359e48c39..fb1a3de39726 100644
> --- a/include/linux/livepatch.h
> +++ b/include/linux/livepatch.h
> 
> [ ... snip ... ]
> 
> @@ -245,10 +245,10 @@ static inline void klp_update_patch_state(struct task_struct *task) {}
>  static inline void klp_copy_process(struct task_struct *child) {}
>  
>  static inline
> -int klp_write_relocations(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
> -			  const char *shstrtab, const char *strtab,
> -			  unsigned int symindex, struct module *pmod,
> -			  const char *objname)
> +int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
> +			     const char *shstrtab, const char *strtab,
> +			     unsigned int symindex, unsigned int secindex,
> +			     const char *objname);
                                                ^^
Whoops, stray semicolon in !CONFIG_LIVEPATCH case.  I found it by
botching my cross-compiling .config, but the build-bot might find it
when you push your branch.

>  {
>  	return 0;
>  }

-- Joe

