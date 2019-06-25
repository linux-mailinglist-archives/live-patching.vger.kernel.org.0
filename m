Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55C235578D
	for <lists+live-patching@lfdr.de>; Tue, 25 Jun 2019 21:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728658AbfFYTIl (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 25 Jun 2019 15:08:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58468 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727684AbfFYTIk (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 25 Jun 2019 15:08:40 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 35F8930C1AFD;
        Tue, 25 Jun 2019 19:08:40 +0000 (UTC)
Received: from redhat.com (dhcp-17-153.bos.redhat.com [10.18.17.153])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A36E60BE5;
        Tue, 25 Jun 2019 19:08:38 +0000 (UTC)
Date:   Tue, 25 Jun 2019 15:08:36 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Petr Mladek <pmladek@suse.com>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v4 00/10] klp-convert livepatch build tooling
Message-ID: <20190625190836.GL20356@redhat.com>
References: <20190509143859.9050-1-joe.lawrence@redhat.com>
 <alpine.LSU.2.21.1906131451560.22698@pobox.suse.cz>
 <b1a627a4-3702-9689-6c03-0c2123c06a2d@redhat.com>
 <c9021573-11c6-b576-0aa6-97754c98a06e@redhat.com>
 <20190614083435.uq3mk6mprbatysol@pathway.suse.cz>
 <alpine.LSU.2.21.1906251324450.12085@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.1906251324450.12085@pobox.suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Tue, 25 Jun 2019 19:08:40 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Jun 25, 2019 at 01:36:37PM +0200, Miroslav Benes wrote:
>
> [ ... snip ... ]
>
> If I revert commit d59cadc0a8f8 ("[squash] klp-convert: make
> convert_rela() list-safe") (from Joe's expanded github tree), the problem
> disappears.
>
> I haven't spotted any problem in the code and I cannot explain a
> dependency on GCC version. Any ideas?
>

I can confirm that test_klp_convert1.ko crashes with RHEL-7 and its
older gcc.  I added some debugging printf's to klp-convert and see:

  % ./scripts/livepatch/klp-convert \
          ./Symbols.list \
          lib/livepatch/test_klp_convert1.klp.o \
          lib/livepatch/test_klp_convert1.ko | \
          grep saved_command_line

  convert_rela: oldsec: .rela.text rela @ 0x1279670 rela->sym @ 0x12791f0 (.klp.sym.vmlinux.saved_command_line,0) offset: 0x3
  convert_rela: oldsec: .rela.text rela @ 0x1279cd0 rela->sym @ 0x12791f0 (.klp.sym.vmlinux.saved_command_line,0) offset: 0x9a
  move_rela: rela @ 0x1279670 rela->sym @ 0x12791f0 (.klp.sym.vmlinux.saved_command_line,0) offset: 0x3
  main: skipping rela @ 0x1279cd0 rela->sym @ 0x12791f0 (.klp.sym.vmlinux.saved_command_line,0) (!must_convert)

I think the problem is:

- Relas at different offsets, but for the same symbol may share symbol
  storage.  Note the same rela->sym value above.

- Before d59cadc0a8f8 ("[squash] klp-convert: make convert_rela()
  list-safe"), convert_rela() iterated through the entire section's
  relas, moving any of the same name.  This was determined not to be
  list safe when moving consecutive relas in the linked list.

- After d59cadc0a8f8 ("[squash] klp-convert: make convert_rela()
  list-safe"), convert_rela() still iterates through the section relas,
  but only updates r1->sym->klp_rela_sec instead of moving them.
  move_rela() was added to be called by the for-each-rela loop in
  main().

  - Bug 1: klp_rela_sec probably belongs in struct rela and not struct
    symbol

  - Bug 2: the main loop skips over second, third, etc. matching relas
    anyway as the shared symbol name will have already been converted

The following fix might not be elegant, but I can't think of a clever
way to handle the original issue d59cadc0a8f8 ("[squash] klp-convert:
make convert_rela() list-safe") as well as these resulting regressions.
So I broke out the moving of relas to a seperate loop.  That is probably
worth a comment and at the same time we might be able to drop some of
these other "safe" loop traversals for ordinary list_for_each_entry.

-- Joe

-->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8--

diff --git a/scripts/livepatch/elf.h b/scripts/livepatch/elf.h
index 7551409..57a8242 100644
--- a/scripts/livepatch/elf.h
+++ b/scripts/livepatch/elf.h
@@ -33,7 +33,6 @@ struct symbol {
 	struct list_head list;
 	GElf_Sym sym;
 	struct section *sec;
-	struct section *klp_rela_sec;
 	char *name;
 	unsigned int idx;
 	unsigned char bind, type;
@@ -45,6 +44,7 @@ struct rela {
 	struct list_head list;
 	GElf_Rela rela;
 	struct symbol *sym;
+	struct section *klp_rela_sec;
 	unsigned int type;
 	unsigned long offset;
 	int addend;
diff --git a/scripts/livepatch/klp-convert.c b/scripts/livepatch/klp-convert.c
index b5873ab..50d6471 100644
--- a/scripts/livepatch/klp-convert.c
+++ b/scripts/livepatch/klp-convert.c
@@ -525,7 +525,7 @@ static bool convert_rela(struct section *oldsec, struct rela *r,
 
 	list_for_each_entry_safe(r1, r2, &oldsec->relas, list) {
 		if (r1->sym->name == r->sym->name) {
-			r1->sym->klp_rela_sec = sec;
+			r1->klp_rela_sec = sec;
 		}
 	}
 	return true;
@@ -535,7 +535,7 @@ static void move_rela(struct rela *r)
 {
 	/* Move the converted rela to klp rela section */
 	list_del(&r->list);
-	list_add(&r->list, &r->sym->klp_rela_sec->relas);
+	list_add(&r->list, &r->klp_rela_sec->relas);
 }
 
 /* Checks if given symbol name matches a symbol in exp_symbols */
@@ -687,8 +687,11 @@ int main(int argc, const char **argv)
 					return -1;
 				}
 			}
+		}
 
-			move_rela(rela);
+		list_for_each_entry_safe(rela, tmprela, &sec->relas, list) {
+			if (is_converted(rela->sym->name))
+				move_rela(rela);
 		}
 	}
 
