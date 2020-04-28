Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39C41BC5FD
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2020 19:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbgD1RDX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 28 Apr 2020 13:03:23 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:39028 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726406AbgD1RDW (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 28 Apr 2020 13:03:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588093400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zcoS40fbpIucEVEOA18HqlGMwt7Vf5w2w5C7357mLPs=;
        b=FtAXSZMdsy0+8qWKKothD8tLz8RCrMTPPfroPihP3S+3Xf0LkERa+hlfUjzRMqJVN6JEMq
        qRwJPWFXYm0OOp+pu3Y9wHLL+9ao7pLCxPSNFH+ORehrTQvaPHg52gQyUhWKaYB1XTsndW
        D/Q85s1FoKUpFsRr5Psoi4098Hq33JE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-Nec0OIyTPYeJqz0YXu2cSw-1; Tue, 28 Apr 2020 13:03:16 -0400
X-MC-Unique: Nec0OIyTPYeJqz0YXu2cSw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5CFB5835B41;
        Tue, 28 Apr 2020 17:03:15 +0000 (UTC)
Received: from treble (ovpn-112-209.rdu2.redhat.com [10.10.112.209])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A2ACE19C58;
        Tue, 28 Apr 2020 17:03:11 +0000 (UTC)
Date:   Tue, 28 Apr 2020 12:03:09 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Jessica Yu <jeyu@kernel.org>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH v3 09/10] module: Remove module_disable_ro()
Message-ID: <20200428170309.xrsmqdwj5qu2q6t6@treble>
References: <cover.1587812518.git.jpoimboe@redhat.com>
 <33089a8ffb2e724cecfa51d72887ae9bf70354f9.1587812518.git.jpoimboe@redhat.com>
 <20200428162505.GA12860@linux-8ccs.fritz.box>
 <20200428163602.77t6s2qeh4xeacdq@treble>
 <20200428164155.GB12860@linux-8ccs.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200428164155.GB12860@linux-8ccs.fritz.box>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Apr 28, 2020 at 06:41:55PM +0200, Jessica Yu wrote:
> +++ Josh Poimboeuf [28/04/20 11:36 -0500]:
> > On Tue, Apr 28, 2020 at 06:25:05PM +0200, Jessica Yu wrote:
> > > +++ Josh Poimboeuf [25/04/20 06:07 -0500]:
> > > > module_disable_ro() has no more users.  Remove it.
> > > >
> > > > Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > > > Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > > 
> > > Hm, I guess this means we can also remove the module_enable_ro() stubs
> > > in module.h and make it a static function again (like the other
> > > module_enable_* functions) as there are no more outside users. I have to
> > > remind myself after this patchset is merged :-)
> > 
> > Ah, true.  I'm respinning the patch set anyway, I can just add this as a
> > another patch.
> 
> That would be great. Thanks!

Sneak preview:

From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH] module: Make module_enable_ro() static again

Now that module_enable_ro() has no more external users, make it static
again.

Suggested-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 include/linux/module.h | 6 ------
 kernel/module.c        | 4 ++--
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index e4ef7b36feda..2c2e988bcf10 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -858,12 +858,6 @@ extern int module_sysfs_initialized;
 
 #define __MODULE_STRING(x) __stringify(x)
 
-#ifdef CONFIG_STRICT_MODULE_RWX
-extern void module_enable_ro(const struct module *mod, bool after_init);
-#else
-static inline void module_enable_ro(const struct module *mod, bool after_init) { }
-#endif
-
 #ifdef CONFIG_GENERIC_BUG
 void module_bug_finalize(const Elf_Ehdr *, const Elf_Shdr *,
 			 struct module *);
diff --git a/kernel/module.c b/kernel/module.c
index f0e414a01d91..6d8aab60943e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2016,7 +2016,7 @@ static void frob_writable_data(const struct module_layout *layout,
 		   (layout->size - layout->ro_after_init_size) >> PAGE_SHIFT);
 }
 
-void module_enable_ro(const struct module *mod, bool after_init)
+static void module_enable_ro(const struct module *mod, bool after_init)
 {
 	if (!rodata_enabled)
 		return;
@@ -2057,7 +2057,7 @@ static int module_enforce_rwx_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
 }
 
 #else /* !CONFIG_STRICT_MODULE_RWX */
-/* module_{enable,disable}_ro() stubs are in module.h */
+void module_enable_ro(const struct module *mod, bool after_init) {}
 static void module_enable_nx(const struct module *mod) { }
 static int module_enforce_rwx_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
 				       char *secstrings, struct module *mod)
-- 
2.21.1

