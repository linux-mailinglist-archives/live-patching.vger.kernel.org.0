Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F34B6BF153
	for <lists+live-patching@lfdr.de>; Fri, 17 Mar 2023 20:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjCQTBL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Mar 2023 15:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbjCQTBG (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Mar 2023 15:01:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA4D196AD;
        Fri, 17 Mar 2023 12:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9l1jlBa2TW433jl7IJq8lUkTy9f/IvnEj0Y2pjJtp2w=; b=aOJ5OxoAmKYzoZThHS05n6pJI2
        zjx5Y3zFzl17uudPa9G+NIXQDbjn6epkPMDvI3TW1mybTKg03+PBrTVAeaOKgHenSld8K+TdDFzWZ
        iXGOJnM4UYh4aPpKvlAyovuyC4xbGtgbYzEaAoRSG0WPDpPVzk0Q6ZcIwKwi2n19PEBkDQfUegka3
        XwWroYsFKlYRBhrLz0AKhsJdvfAI06tN872iG5cvwqyUjfwlbpTJAAP8167dvU+2A+GwmehQ/UGGb
        l49xInMLWzmpjfBi1T+cZi5WWD86jGhqBvdFFFX0Gzfl/GlWrcgm8HCApU4Dk60JwTs7OU/Is7cxP
        BgRnrR5Q==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pdFJg-0036Xe-0y;
        Fri, 17 Mar 2023 19:00:40 +0000
Date:   Fri, 17 Mar 2023 12:00:40 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Cc:     Petr Mladek <pmladek@suse.com>, Song Liu <song@kernel.org>,
        patches@lists.linux.dev, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: mod->klp set on copy ok ?
Message-ID: <ZBS42Lid+CX0h0fk@bombadil.infradead.org>
References: <CAB=NE6Vo4AXVrn1GPEoZWVF3NkXRoPwWOuUEJqJ35S9VMGTM2Q@mail.gmail.com>
 <ZA8NBuXbVP+PRPp0@alley>
 <ZBOPP4YWWhJRk2yn@bombadil.infradead.org>
 <20230317161639.3de7yeek6ia4y7ul@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317161639.3de7yeek6ia4y7ul@treble>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

+ linux-kbuild

On Fri, Mar 17, 2023 at 09:16:39AM -0700, Josh Poimboeuf wrote:
> On Thu, Mar 16, 2023 at 02:50:55PM -0700, Luis Chamberlain wrote:
> > The comment for "Update sh_addr to point to copy in image." seems pretty
> > misleading to me, what we are doing there is actually ensuring that we update
> > the copy's ELF section address to point to our newly allocated memory.
> > Do folks agree?
> > 
> > And how about the size on the memcpy()? That's a shd->sh_size. No matter
> > how much I increase my struct module in include/linux/module.h I see
> > thes same sh_size. Do folks see same?
> > 
> > nm --print-size --size-sort fs/xfs/xfs.ko | grep __this_module
> > 0000000000000000 0000000000000500 D __this_module
> > 
> > This is what is supposed to make the final part of layout_and_allocate() work:
> > 
> > 	mod = (void *)info->sechdrs[info->index.mod].sh_addr;
> > 
> > This works off of the copy of the module. Let's recall that
> > setup_load_info() sets the copy mod to:
> > 
> > 	info->mod = (void *)info->hdr + info->sechdrs[info->index.mod].sh_offset;
> > 
> > The memcpy() in move_module() is what *should* be copying over the entire
> > mod stuff properly over, that includes the mod->klp for live patching
> > but also any new data we muck with in-kernel as the new mod->mem stuff
> > in layout_sections(). In short, anything in struct module should be
> > shoved into an ELF section. But I'm not quite sure this is all right.
> 
> I dug into that code years ago, and the above sounds right.
> 
> The .ko file has a .gnu.linkonce.this_module section whose data is just
> the original "struct module __this_module" which is created by the
> module build (from foo.mod.c).
> 
> At the beginning of the finit_module() syscall, the .ko file's ELF
> sections get copied (and optionally decompressed) into kernel memory.
> Then 'mod' just points to the copied __this_module struct.
> 
> Then mod->klp (and possibly mod->taint) get set.
> 
> Then in layout_and_allocate(), that 'mod' gets memcpy'd into the second
> (and final) in-kernel copy of 'struct module':
> 
>  		if (shdr->sh_type != SHT_NOBITS)
>  			memcpy(dest, (void *)shdr->sh_addr, shdr->sh_size);
>  		/* Update sh_addr to point to copy in image. */
>  		shdr->sh_addr = (unsigned long)dest;
> 
> I suspect you don't see the size changing when you add to 'struct
> module' because it's ____cacheline_aligned.
> 
> It's all rather obtuse, but working as designed as far as I can tell.

Ah, well it is beyond a ____cacheline_aligned issue! It would seem our build
system does not incur a full re-build of $foo.mod.c if the size of struct module
changes. Doing a full rebuild does get the right drift size change in
struct module:

nm --print-size --radix=dec --size-sort fs/xfs/xfs.ko | grep __this_module
0000000000000000 0000000000001280 D __this_module

I validated that sizeof(struct module) does match 1280. And so, to remove all
these cob webs for good, and to extend our ELF validity checker, what about
the following patch (boot tested):

From cdd78ff0cb6d521930305026089a72776a982845 Mon Sep 17 00:00:00 2001
From: Luis Chamberlain <mcgrof@kernel.org>
Date: Fri, 17 Mar 2023 11:41:02 -0700
Subject: [PATCH] module: add sanity check for ELF module section

The ELF ".gnu.linkonce.this_module" section is special, it is what we
use to construct the struct module __this_module, which THIS_MODULE
points to. When userspace loads a module we always deal first with a
copy of the userspace buffer, and twiddle with the userspace copy's
version of the struct module. Eventually we allocate memory to do a
memcpy() of that struct module, under the assumption that the module
size is right. But we have no validity checks against the size or
the requirements for the section.

Add some validity checks for the special module section early and while
at it, cache the module section index early, so we don't have to do that
later.

While at it, just move over the assigment of the info->mod to make the
code clearer. The validity checker also adds an explicit size check to
ensure the module section size matches the kernel's run time size for
sizeof(struct module). This should prevent sloppy loads of modules
which are built today *without* actually increasing the size of
the struct module. A developer today can for example expand the size
of struct module, rebuild a directoroy 'make fs/xfs/' for example and
then try to insmode the driver there. That module would in effect have
an incorrect size. This new size check would put a stop gap against such
mistakes.

This also makes the entire goal of ".gnu.linkonce.this_module" pretty
clear. Before this patch verification of the goal / intent required some
Indian Jones whips, torches and cleaning up big old spider webs.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 kernel/module/main.c | 60 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 51 insertions(+), 9 deletions(-)

diff --git a/kernel/module/main.c b/kernel/module/main.c
index 57cc10a20b45..d1aee35ab928 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -1656,6 +1656,7 @@ static int elf_validity_check(struct load_info *info)
 	unsigned int i;
 	Elf_Shdr *shdr, *strhdr;
 	int err;
+	unsigned int num_mod_secs = 0, mod_idx;
 
 	if (info->len < sizeof(*(info->hdr))) {
 		pr_err("Invalid ELF header len %lu\n", info->len);
@@ -1767,6 +1768,11 @@ static int elf_validity_check(struct load_info *info)
 					i, shdr->sh_type);
 				return err;
 			}
+			if (strcmp(info->secstrings + shdr->sh_name,
+				   ".gnu.linkonce.this_module") == 0) {
+				num_mod_secs++;
+				mod_idx = i;
+			}
 
 			if (shdr->sh_flags & SHF_ALLOC) {
 				if (shdr->sh_name >= strhdr->sh_size) {
@@ -1779,6 +1785,51 @@ static int elf_validity_check(struct load_info *info)
 		}
 	}
 
+	/* The ".gnu.linkonce.this_module" ELF section is special. It is
+	 * what modpost uses to refer to __this_module and let's use rely
+	 * on THIS_MODULE to point to &__this_module properly. The kernel's
+	 * modpost declares it on each modules's *.mod.c file. If the struct
+	 * module of the kernel changes a full kernel rebuild is required.
+	 *
+	 * We have a few expectaions for this special section, the following
+	 * code validates all this for us:
+	 *
+	 *   o Only one section must exist
+	 *   o We expect the kernel to always have to allocate it: SHF_ALLOC
+	 *   o The section size must match the kernel's run time's struct module
+	 *     size
+	 */
+	if (num_mod_secs != 1) {
+		pr_err("Only one .gnu.linkonce.this_module section must exist.\n");
+		goto no_exec;
+	}
+
+	shdr = &info->sechdrs[mod_idx];
+
+	/*
+	 * This is already implied on the switch above, however let's be
+	 * pedantic about it.
+	 */
+	if (shdr->sh_type == SHT_NOBITS) {
+		pr_err(".gnu.linkonce.this_module section must have a size set\n");
+		goto no_exec;
+	}
+
+	if (!(shdr->sh_flags & SHF_ALLOC)) {
+		pr_err(".gnu.linkonce.this_module must occupy memory during process execution\n");
+		goto no_exec;
+	}
+
+	if (shdr->sh_size != sizeof(struct module)) {
+		pr_err(".gnu.linkonce.this_module section size must match the kernel's built struct module size at run time\n");
+		goto no_exec;
+	}
+
+	info->index.mod = mod_idx;
+
+	/* This is temporary: point mod into copy of data. */
+	info->mod = (void *)info->hdr + shdr->sh_offset;
+
 	return 0;
 
 no_exec:
@@ -1925,15 +1976,6 @@ static int setup_load_info(struct load_info *info, int flags)
 		return -ENOEXEC;
 	}
 
-	info->index.mod = find_sec(info, ".gnu.linkonce.this_module");
-	if (!info->index.mod) {
-		pr_warn("%s: No module found in object\n",
-			info->name ?: "(missing .modinfo section or name field)");
-		return -ENOEXEC;
-	}
-	/* This is temporary: point mod into copy of data. */
-	info->mod = (void *)info->hdr + info->sechdrs[info->index.mod].sh_offset;
-
 	/*
 	 * If we didn't load the .modinfo 'name' field earlier, fall back to
 	 * on-disk struct mod 'name' field.
-- 
2.39.2

