Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECE61BCB5E
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2020 20:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729756AbgD1S4q (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 28 Apr 2020 14:56:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729313AbgD1S4p (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 28 Apr 2020 14:56:45 -0400
Received: from linux-8ccs.fritz.box (p3EE2CE96.dip0.t-ipconnect.de [62.226.206.150])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41F4D206D6;
        Tue, 28 Apr 2020 18:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588100204;
        bh=0305n2qo1oQ3Gv0+MWmU1c/cqoXpogKBnneHyGLLyPY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XmppFroab/0dGguUy2yW9Hk84ASbMa+V+IWa0oxQVj1XJ+FCM+G/02uRkxpmN6onG
         tw9qS4NAgnOx12Svzdl+qDCGlez8Hdx2N4Vn0ipalARdUiPlzSHswOrdmhg+seLH0p
         rdVL0Rv1DP1YQePgYr/IuLr+Y2KCuihM3UhbdGFQ=
Date:   Tue, 28 Apr 2020 20:56:40 +0200
From:   Jessica Yu <jeyu@kernel.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH v3 09/10] module: Remove module_disable_ro()
Message-ID: <20200428185639.GC12860@linux-8ccs.fritz.box>
References: <cover.1587812518.git.jpoimboe@redhat.com>
 <33089a8ffb2e724cecfa51d72887ae9bf70354f9.1587812518.git.jpoimboe@redhat.com>
 <20200428162505.GA12860@linux-8ccs.fritz.box>
 <20200428163602.77t6s2qeh4xeacdq@treble>
 <20200428164155.GB12860@linux-8ccs.fritz.box>
 <20200428170309.xrsmqdwj5qu2q6t6@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200428170309.xrsmqdwj5qu2q6t6@treble>
X-OS:   Linux linux-8ccs 4.12.14-lp150.12.61-default x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

+++ Josh Poimboeuf [28/04/20 12:03 -0500]:
>On Tue, Apr 28, 2020 at 06:41:55PM +0200, Jessica Yu wrote:
>> +++ Josh Poimboeuf [28/04/20 11:36 -0500]:
>> > On Tue, Apr 28, 2020 at 06:25:05PM +0200, Jessica Yu wrote:
>> > > +++ Josh Poimboeuf [25/04/20 06:07 -0500]:
>> > > > module_disable_ro() has no more users.  Remove it.
>> > > >
>> > > > Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
>> > > > Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>> > >
>> > > Hm, I guess this means we can also remove the module_enable_ro() stubs
>> > > in module.h and make it a static function again (like the other
>> > > module_enable_* functions) as there are no more outside users. I have to
>> > > remind myself after this patchset is merged :-)
>> >
>> > Ah, true.  I'm respinning the patch set anyway, I can just add this as a
>> > another patch.
>>
>> That would be great. Thanks!
>
>Sneak preview:
>
>From: Josh Poimboeuf <jpoimboe@redhat.com>
>Subject: [PATCH] module: Make module_enable_ro() static again
>
>Now that module_enable_ro() has no more external users, make it static
>again.
>
>Suggested-by: Jessica Yu <jeyu@kernel.org>
>Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
>---
> include/linux/module.h | 6 ------
> kernel/module.c        | 4 ++--
> 2 files changed, 2 insertions(+), 8 deletions(-)
>
>diff --git a/include/linux/module.h b/include/linux/module.h
>index e4ef7b36feda..2c2e988bcf10 100644
>--- a/include/linux/module.h
>+++ b/include/linux/module.h
>@@ -858,12 +858,6 @@ extern int module_sysfs_initialized;
>
> #define __MODULE_STRING(x) __stringify(x)
>
>-#ifdef CONFIG_STRICT_MODULE_RWX
>-extern void module_enable_ro(const struct module *mod, bool after_init);
>-#else
>-static inline void module_enable_ro(const struct module *mod, bool after_init) { }
>-#endif
>-
> #ifdef CONFIG_GENERIC_BUG
> void module_bug_finalize(const Elf_Ehdr *, const Elf_Shdr *,
> 			 struct module *);
>diff --git a/kernel/module.c b/kernel/module.c
>index f0e414a01d91..6d8aab60943e 100644
>--- a/kernel/module.c
>+++ b/kernel/module.c
>@@ -2016,7 +2016,7 @@ static void frob_writable_data(const struct module_layout *layout,
> 		   (layout->size - layout->ro_after_init_size) >> PAGE_SHIFT);
> }
>
>-void module_enable_ro(const struct module *mod, bool after_init)
>+static void module_enable_ro(const struct module *mod, bool after_init)
> {
> 	if (!rodata_enabled)
> 		return;
>@@ -2057,7 +2057,7 @@ static int module_enforce_rwx_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
> }
>
> #else /* !CONFIG_STRICT_MODULE_RWX */
>-/* module_{enable,disable}_ro() stubs are in module.h */
>+void module_enable_ro(const struct module *mod, bool after_init) {}

Missing static here, but otherwise looks good. Thanks!

> static void module_enable_nx(const struct module *mod) { }
> static int module_enforce_rwx_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
> 				       char *secstrings, struct module *mod)
>-- 
>2.21.1
>
