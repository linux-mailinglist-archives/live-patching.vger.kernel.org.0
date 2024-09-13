Return-Path: <live-patching+bounces-656-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A57BC9782C5
	for <lists+live-patching@lfdr.de>; Fri, 13 Sep 2024 16:39:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1A046B255D5
	for <lists+live-patching@lfdr.de>; Fri, 13 Sep 2024 14:39:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5120910A0D;
	Fri, 13 Sep 2024 14:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ES3VaV3K"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FA95228
	for <live-patching@vger.kernel.org>; Fri, 13 Sep 2024 14:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726238371; cv=none; b=O5ol94FSnCVniUrPWBwqisR6SODPxhMW1Oq1tkZCxFPXLMBfEVnFcKh0CZiQW/3HZzw5HOV+oiRawlJJJ/hIl1C4+kP8JoDI+fXq+TvW3Un6H/woVOjAukJ9AiD1na4j4GFMVBfrg6C6dddbxNAWPGS+7IwdnUiAI8p64NLZyfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726238371; c=relaxed/simple;
	bh=iF+OwMVzAxNrDmu6houQARtAsobEPYNKJexijboTY5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zyws58PV01YlYauoOyqsZnm1PsSRRCnkj2A+hJ663YDu0jT8AMttEzf6/BPxKyEaTSJIHCTdoKlO5y2II6ezQVxfm9Zlsv/HfZBlnR+bDNvk9gtvFjXSXVBhDjzS88FSxbpLuNVKK5BjmhHXDQexdJ4Pz2HsEWcq9pi1366JptU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ES3VaV3K; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726238368;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iaQbIDBF55GqS7IkFMCgMsaRgkbnRg9eREgwNo66+n0=;
	b=ES3VaV3KdyF/Wt+AF/7mqjiSukMQw/Vi9WLgKMmNX5PlVdNWzf4GsI3KWQycUVbikTQPvb
	KXLWe3NnooZGB8BM9O7hsWHssKIjelZSkp2bKmgNDmhcuXl/atepzKrhM8cfR5i8zdmmz1
	FrHURoEw6YSXqXxISMflcLUQh5+AJns=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-166-e0HL4IeGPTe1OLhcK9g9YQ-1; Fri,
 13 Sep 2024 10:39:25 -0400
X-MC-Unique: e0HL4IeGPTe1OLhcK9g9YQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7117F1955BC1;
	Fri, 13 Sep 2024 14:39:23 +0000 (UTC)
Received: from redhat.com (unknown [10.22.8.105])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 380051956086;
	Fri, 13 Sep 2024 14:39:21 +0000 (UTC)
Date: Fri, 13 Sep 2024 10:39:18 -0400
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: Re: [RFC 00/31] objtool, livepatch: Livepatch module generation
Message-ID: <ZuROlpVFO3OE9o1r@redhat.com>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <20240911073942.fem2kekg3f23hzf2@treble>
 <ZuLwJIgt4nsQKvqZ@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZuLwJIgt4nsQKvqZ@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Thu, Sep 12, 2024 at 09:44:04AM -0400, Joe Lawrence wrote:
> On Wed, Sep 11, 2024 at 12:39:42AM -0700, Josh Poimboeuf wrote:
> > On Mon, Sep 02, 2024 at 08:59:43PM -0700, Josh Poimboeuf wrote:
> > > Hi,
> > > 
> > > Here's a new way to build livepatch modules called klp-build.
> > > 
> > > I started working on it when I realized that objtool already does 99% of
> > > the work needed for detecting function changes.
> > > 
> > > This is similar in concept to kpatch-build, but the implementation is
> > > much cleaner.
> > > 
> > > Personally I still have reservations about the "source-based" approach
> > > (klp-convert and friends), including the fragility and performance
> > > concerns of -flive-patching.  I would submit that klp-build might be
> > > considered the "official" way to make livepatch modules.
> > > 
> > > Please try it out and let me know what you think.  Based on v6.10.
> > > 
> > > Also avaiable at:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git klp-build-rfc
> > 
> > Here's an updated branch with a bunch of fixes.  It's still incompatible
> > with BTF at the moment, otherwise it should (hopefully) fix the rest of
> > the issues reported so far.
> > 
> > While the known bugs are fixed, I haven't finished processing all the
> > review comments yet.  Once that happens I'll post a proper v2.
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git klp-build-v1.5
> 
> Hi Josh,
> 
> I've had much better results with v1.5, thanks for collecting up those
> fixes in a branch.
>

Today's experiment used the centos-stream-10's kernel config with
CONFIG_MODULE_ALLOW_BTF_MISMATCH=y and cs-10's gcc (GCC) 14.2.1 20240801
(Red Hat 14.2.1-1).

First, more gcc nits (running top-level `make`):

  check.c: In function ‘decode_instructions’:
  check.c:410:54: error: ‘calloc’ sizes specified with ‘sizeof’ in the earlier argument and not in the later argument [-Werror=calloc-transposed-args]
    410 |                                 insns = calloc(sizeof(*insn), INSN_CHUNK_SIZE);
        |                                                      ^
  check.c:410:54: note: earlier argument should specify number of elements, later size of each element
  check.c: In function ‘init_pv_ops’:
  check.c:551:38: error: ‘calloc’ sizes specified with ‘sizeof’ in the earlier argument and not in the later argument [-Werror=calloc-transposed-args]
    551 |         file->pv_ops = calloc(sizeof(struct pv_state), nr);
        |                                      ^~~~~~
  check.c:551:38: note: earlier argument should specify number of elements, later size of each element

-->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8--

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 63c2d6c06..c6f192859 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -407,7 +407,7 @@ static void decode_instructions(struct objtool_file *file)
 
 		for (offset = 0; offset < sec_size(sec); offset += insn->len) {
 			if (!insns || idx == INSN_CHUNK_MAX) {
-				insns = calloc(sizeof(*insn), INSN_CHUNK_SIZE);
+				insns = calloc(INSN_CHUNK_SIZE, sizeof(*insn));
 				ERROR_ON(!insns, "calloc");
 
 				idx = 0;
@@ -548,7 +548,7 @@ static void init_pv_ops(struct objtool_file *file)
 		return;
 
 	nr = sym->len / sizeof(unsigned long);
-	file->pv_ops = calloc(sizeof(struct pv_state), nr);
+	file->pv_ops = calloc(nr, sizeof(struct pv_state));
 	ERROR_ON(!file->pv_ops, "calloc");
 
 	for (idx = 0; idx < nr; idx++)

-->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8--

and now a happy build of objtool.


The top-level `make` moves onto building all the kernel objects, but
then objtool vmlinux.o crashes:

  $ gdb --args ./tools/objtool/objtool --sym-checksum --hacks=jump_label --hacks=noinstr --hacks=skylake --ibt --orc --retpoline --rethunk --static-call --uaccess --prefix=16 --link vmlinux.o
  
  Program received signal SIGSEGV, Segmentation fault.
  ignore_unreachable_insn (file=0x435ea0 <file>, insn=0x1cd928c0) at check.c:3980
  3980            if (prev_insn->dead_end &&
  
  (gdb) bt
  #0  ignore_unreachable_insn (file=0x435ea0 <file>, insn=0x1cd928c0) at check.c:3980
  #1  validate_reachable_instructions (file=0x435ea0 <file>) at check.c:4452
  #2  check (file=file@entry=0x435ea0 <file>) at check.c:4610
  #3  0x0000000000412d4f in objtool_run (argc=<optimized out>, argc@entry=14, argv=argv@entry=0x7fffffffdd78) at builtin-check.c:206
  #4  0x0000000000417f9b in main (argc=14, argv=0x7fffffffdd78) at objtool.c:131
  
  (gdb) p prev_insn
  $1 = (struct instruction *) 0x0

which I worked around by copying a similar conditional check on
prev_insn after calling prev_insn_same_sec():

-->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8--

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 63c2d6c06..c6f192859 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3977,7 +3977,7 @@ static bool ignore_unreachable_insn(struct objtool_file *file, struct instructio
 	 * It may also insert a UD2 after calling a __noreturn function.
 	 */
 	prev_insn = prev_insn_same_sec(file, insn);
-	if (prev_insn->dead_end &&
+	if (prev_insn && prev_insn->dead_end &&
 	    (insn->type == INSN_BUG ||
 	     (insn->type == INSN_JUMP_UNCONDITIONAL &&
 	      insn->jump_dest && insn->jump_dest->type == INSN_BUG)))

-->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8--

and now a happy kernel build and boot.


A klp-build of the usual cmdline.patch succeeds, however it generates
some strange relocations:

  Relocation section '.rela.text' at offset 0x238 contains 6 entries:
      Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
  0000000000000016  0000004600000004 R_X86_64_PLT32         0000000000000000 __kmalloc_noprof - 4
  0000000000000035  0000004e00000004 R_X86_64_PLT32         0000000000000000 __fentry__ - 4
  000000000000003c  0000000000000000 R_X86_64_NONE                             -4
  
  Relocation section '.rela.klp.relocs' at offset 0x1168 contains 2 entries:
      Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
  0000000000000000  0000000700000001 R_X86_64_64            0000000000000000 .text + 3c
  0000000000000008  0000000000000001 R_X86_64_64                               -4
  
  Relocation section '.klp.rela.h..text' at offset 0x53f18 contains 1 entry: 
      Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
  000000000000003c  0000000000000002 R_X86_64_PC32                             -4

No bueno.  FWIW, Song's 0001-test-klp.patch does seem to build w/o odd
relocations and it loads fine.

--
Joe


