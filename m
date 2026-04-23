Return-Path: <live-patching+bounces-2499-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iAWPLkxy6mkRzgIAu9opvQ
	(envelope-from <live-patching+bounces-2499-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 21:26:04 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 71646456C91
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 21:26:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2B134307C220
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 19:23:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D670838F929;
	Thu, 23 Apr 2026 19:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g6wfx4SO"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32FC2D8399;
	Thu, 23 Apr 2026 19:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776972215; cv=none; b=T4xUXzvTwy0QtCKsUiSACj900pVlzBovC7bs8yn6HsrcE2Of1VP1Li8JaSO3sjHULPyF3vXj9tpOwHR+oel5yWSpgfhVw3FJD7FxCnO8LMB2HZRFi7j6BEtr6ghWJMc9N8LTWZ7z6uuhZ1TyWc0bBymbBFYprdY7gA9KR4jAocM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776972215; c=relaxed/simple;
	bh=vZtCIukY8TtS5P+gs21qM8glzTRDUAdUqW8Sy3bhAEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ell+wyht0yEy+WPkKUvT1+mUwQOAqk8Z1M9nabSe0dhaqEWPimMGzirXZAB318oWABVONGiAgizY2ewxKOAIHlTDAtCFxPwH00WDtS1hkyXNdzXwMHmI489CXm2daucj+BmYh1D2k1qIr7UJ8hWe46V7vFLSZ04JQUP5Pxg5RzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g6wfx4SO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859D5C2BCAF;
	Thu, 23 Apr 2026 19:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776972215;
	bh=vZtCIukY8TtS5P+gs21qM8glzTRDUAdUqW8Sy3bhAEw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g6wfx4SOhXV5YmgjyioZ2WBQbW1UnVCK6aTGKPhIWIpAkyPOK5krxSrOKLtRsZJcv
	 SvoRkpvUKiY8rjOeVKBTSTUWMv2Of/yMgG0/FSRTgFjgqC4OXfAQtyhTZw4DL0jEfY
	 bVjyEebnoreRmMyRoGp462NWgrbsGwS+WR+R2GsdF0+duabzMdtbh70ZH1tCl6RmFM
	 LfUbaM4Moba8742JVt0iwtad3tzoNBmEC+uIAGmLXaaJuh193FNT4SnPv3aZHuMEUR
	 UIwXX4zh4dVuFEfMqhO3XpWw/mMjFkE5qK5EyhvVP0PYSN6a/Zw88oZPcB1M8E2aFX
	 F5z9UOMrCbwLA==
Date: Thu, 23 Apr 2026 12:23:32 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Joe Lawrence <joe.lawrence@redhat.com>, 
	Song Liu <song@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 32/48] objtool: Add is_cold_func() helper
Message-ID: <kbvnzbwbw2m46yd6usmo54gon45cfwkrkowgipybjj77fvwsup@zcyioxgyejd2>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <8eea11ea7d0efc5fcd2e57a10c4285fe998f0cec.1776916871.git.jpoimboe@kernel.org>
 <20260423083849.GV3126523@noisy.programming.kicks-ass.net>
 <qp7srvaafzmgsh334jeidseax2zgvt2j65iugsru5co3wrm6ka@opizry3c2m6d>
 <20260423151405.GF1064669@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260423151405.GF1064669@noisy.programming.kicks-ass.net>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2499-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 71646456C91
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Apr 23, 2026 at 05:14:05PM +0200, Peter Zijlstra wrote:
> On Thu, Apr 23, 2026 at 08:12:07AM -0700, Josh Poimboeuf wrote:
> > On Thu, Apr 23, 2026 at 10:38:49AM +0200, Peter Zijlstra wrote:
> > > On Wed, Apr 22, 2026 at 09:04:00PM -0700, Josh Poimboeuf wrote:
> > > 
> > > > diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
> > > > index 00c2389f345f..8a6e1338af97 100644
> > > > --- a/tools/objtool/elf.c
> > > > +++ b/tools/objtool/elf.c
> > > > @@ -586,8 +586,11 @@ static int elf_add_symbol(struct elf *elf, struct symbol *sym)
> > > >  	if (strstarts(sym->name, ".klp.sym"))
> > > >  		sym->klp = 1;
> > > >  
> > > > +	sym->pfunc = sym->cfunc = sym;
> > > > +
> > > >  	if (!sym->klp && !is_sec_sym(sym) && strstr(sym->name, ".cold")) {
> > > > -		sym->cold = 1;
> > > > +		/* Tell read_symbols() this is a cold subfunction */
> > > > +		sym->pfunc = NULL;
> > > >  
> > > >  		/*
> > > >  		 * Clang doesn't mark cold subfunctions as STT_FUNC, which
> > > > @@ -596,8 +599,6 @@ static int elf_add_symbol(struct elf *elf, struct symbol *sym)
> > > >  		sym->type = STT_FUNC;
> > > >  	}
> > > >  
> > > > -	sym->pfunc = sym->cfunc = sym;
> > > > -
> > > >  	return 0;
> > > >  }
> > > 
> > > So now the cold subfunction has a NULL parent-function and a
> > > child-function that points to the parent?
> > > 
> > > I'm confused.
> > 
> > It's a bit clunky.  As the comment implies, 'sym->pfunc = NULL' is a
> > signal to it caller read_symbols() that this is a .cold function.  Then,
> > after all the symbols have been added, read_symbols() goes and finds the
> > parent.
> > 
> > I think I did it this way because klp-diff.c calls elf_add_symbol() (via
> > elf_create_symbol()) and later needs to call is_cold_func() on it.  In
> > that case, even though the parent isn't set, it still works because
> > is_cold_func() returns true for sym->pfunc != sym;
> 
> I'm thinking this needs more comments if it stays like this. Is most
> confusing.

So we can just keep the 'cold' bit and keep the confusingness at its
current level :-)

From: Josh Poimboeuf <jpoimboe@kernel.org>
Subject: [PATCH] objtool: Add is_cold_func() helper

Add an is_cold_func() helper.  No functional changes intended.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c               | 6 +++---
 tools/objtool/include/objtool/elf.h | 5 +++++
 tools/objtool/klp-diff.c            | 3 ++-
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 4c18d6e7f6c3..4ed27c53c718 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2614,7 +2614,7 @@ static void mark_holes(struct objtool_file *file)
 		if (insn->jump_dest) {
 			struct symbol *dest_func = insn_func(insn->jump_dest);
 
-			if (dest_func && dest_func->cold)
+			if (dest_func && is_cold_func(dest_func))
 				dest_func->ignore = true;
 		}
 	}
@@ -4426,8 +4426,8 @@ static int create_prefix_symbol(struct objtool_file *file, struct symbol *func)
 	char name[SYM_NAME_LEN];
 	struct cfi_state *cfi;
 
-	if (!is_func_sym(func) || is_prefix_func(func) ||
-	    func->cold || func->static_call_tramp)
+	if (!is_func_sym(func) || is_prefix_func(func) || is_cold_func(func) ||
+	    func->static_call_tramp)
 		return 0;
 
 	if ((strlen(func->name) + sizeof("__pfx_") > SYM_NAME_LEN)) {
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 3abe4cbc584c..ad0cc57a9d5f 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -289,6 +289,11 @@ static inline bool is_prefix_func(struct symbol *sym)
 	return sym->prefix;
 }
 
+static inline bool is_cold_func(struct symbol *sym)
+{
+	return sym->cold;
+}
+
 static inline bool is_reloc_sec(struct section *sec)
 {
 	return sec->sh.sh_type == SHT_RELA || sec->sh.sh_type == SHT_REL;
diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 1951a8b2df44..266f0d2ba4fe 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -1718,7 +1718,8 @@ static int create_klp_sections(struct elfs *e)
 		unsigned long sympos;
 		void *func_data;
 
-		if (!is_func_sym(sym) || sym->cold || !sym->clone || !sym->clone->changed)
+		if (!is_func_sym(sym) || is_cold_func(sym) ||
+		    !sym->clone || !sym->clone->changed)
 			continue;
 
 		/* allocate klp_func_ext */
-- 
2.53.0


