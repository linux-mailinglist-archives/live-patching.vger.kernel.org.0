Return-Path: <live-patching+bounces-2587-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KJP9LUrl8GmiawEAu9opvQ
	(envelope-from <live-patching+bounces-2587-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 18:50:18 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E9D648953F
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 18:50:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2973230E7AF5
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 16:25:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A38C6330678;
	Tue, 28 Apr 2026 16:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q19dBzic"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802C532F764;
	Tue, 28 Apr 2026 16:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777393393; cv=none; b=og2sjYocW/LEyjrrhRm59ReVGDJt/OLy2qvQU5XPxkLXiL9/QEi0Sv88ctiph9Jd5fgodLLC0Yp7czd6AT4lZfNRg8GsxzaDOqsM78QayPTwABHHUgyXyYwg0GOGeq9/nyNymKr/vgowhIAl95cn/sRCJ817VlIrUP0psbggzDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777393393; c=relaxed/simple;
	bh=OWg7jB/yOMJyYiVxNbrPf7CA7RoUno4HadcAKPo+7VA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iSiW/XeTx/zbILAtOlF2xENKDgsNLpjk7B62boRPb7c3vSCIvRnsVtdQR1AWPrl2Yq4KzpE1At4g3ooMUr8Q3Py0pJ2TB2fuc690wr4SKDF8Z6xOcIC2f2/GnRosUIeI7xQx0vP3ZZMNw8GPzJX796aYEQQcgZszU+XgYUFLl1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q19dBzic; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D824C2BCAF;
	Tue, 28 Apr 2026 16:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777393393;
	bh=OWg7jB/yOMJyYiVxNbrPf7CA7RoUno4HadcAKPo+7VA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q19dBzicwQRCe7ZOTtwfzMXzyMQg5x6lv53yr2J0fO7cAFOmImK2fnPfiZBh6jMJz
	 7yo7xZcH+IlbH3cwhpiOv4dKedyyNQFcWQjVnP5+qHSLsqrAHBy8SuPyFSp+e3C8ts
	 ohhgw9cZEMIRKVo6w5uEdPETjOJW0sAy4E+C/vsXyiyM6PndzYD8Cv/XE38CbsFEq5
	 5bbeU+4i11XDm+F2z6LGiyUnCmmEFpFUwZjl8ESN+zNbUKbA6UcRY4/ek5zW9vBk3Q
	 aA8KaO6rxV4OgRo5GoXp65phOWzR4ZaBz+H4CbPgn+8KUVZ6gIVXT7Lmketdn3DGmp
	 rBlJ6R6veFLdg==
Date: Tue, 28 Apr 2026 09:23:10 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 41/48] objtool/klp: Rewrite symbol correlation algorithm
Message-ID: <abm7sbrlshe23ccholc5q67idnvuackxfy34thnpvyeiglafwe@cdtxtdi3zenv>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <284944d45120ff69959c4d9cde90db13e493d223.1776916871.git.jpoimboe@kernel.org>
 <CAPhsuW4zF9P1mpZ88P5k=TgbHSCQfrdqFok9YiANHo5CLttZNQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW4zF9P1mpZ88P5k=TgbHSCQfrdqFok9YiANHo5CLttZNQ@mail.gmail.com>
X-Rspamd-Queue-Id: 4E9D648953F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2587-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
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

On Fri, Apr 24, 2026 at 05:53:47PM -0700, Song Liu wrote:
> On Wed, Apr 22, 2026 at 9:04 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> >
> > Rewrite the symbol correlation code, using a tiered list of
> > deterministic strategies in a loop.  For duplicately named symbols, each
> > tier applies a filter with the goal of finding a 1:1 deterministic
> > correlation between the original and patched version of the symbol.
> >
> > Overall this works much better than the existing algorithm, particularly
> > with LTO kernels.
> 
> I found it is hard to follow all the matching algorithms here. Could you
> please add some examples for each case: different levels in find_twin(),
> match in find_twin_suffixed(), and match in find_twin_positional()?

Ack.

> Also a few nitpicks below.
> 
> > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > ---
> [...]
> > +static struct symbol *find_twin(struct elfs *e, struct symbol *sym1)
> > +{
> > +       struct symbol *name_last = NULL, *scope_last = NULL,
> > +                     *file_last = NULL, *csum_last = NULL;
> > +       unsigned int name_orig = 0, name_patched = 0;
> > +       unsigned int scope_orig = 0, scope_patched = 0;
> > +       unsigned int file_orig = 0, file_patched = 0;
> > +       unsigned int csum_orig = 0, csum_patched = 0;
> > +       struct symbol *sym2, *match = NULL;
> > +
> > +       /* Count orig candidates */
> > +       for_each_sym_by_demangled_name(e->orig, sym1->demangled_name, sym2) {
> > +               if (sym2->twin || sym1->type != sym2->type || dont_correlate(sym2) ||
> > +                   (!maybe_same_file(sym1, sym2)))
> >                         continue;
> >
> > -               count++;
> > -               result = sym2;
> > +               /* Level 1: name match (widest filter)  */
> > +               name_orig++;
> > +
> > +               /* Level 2: scope (scope changes allowed) */
> > +               if (is_tu_local_sym(sym1) != is_tu_local_sym(sym2))
> 
> is_tu_local_sym(sym1) is called many times, shall we add a variable
> for it?

Unless it's actually a performance issue I'd prefer not to add yet
another bit to struct symbol.

> 
> > +                       continue;
> > +               scope_orig++;
> > +
> > +               /* Level 3: file (scope changes disallowed) */
> > +               if (!same_file(sym1, sym2))
> > +                       continue;
> > +               file_orig++;
> > +
> > +               /* Level 4: checksum (unchanged symbols) */
> > +               if (sym1->len != sym2->len || !sym1->csum.checksum ||
> > +                   sym1->csum.checksum != sym2->csum.checksum)
> > +                       continue;
> > +               csum_orig++;
> >         }
> >
> > -       if (count > 1) {
> > -               ERROR("Multiple (%d) correlation candidates for %s", count, sym->name);
> > -               return -1;
> > +       /* Count patched candidates */
> > +       for_each_sym_by_demangled_name(e->patched, sym1->demangled_name, sym2) {
> > +               if (sym2->twin || sym1->type != sym2->type || dont_correlate(sym2))
> > +                       continue;
> > +
> > +               /* Level 1 */
> > +               if (!maybe_same_file(sym1, sym2))
> > +                       continue;
> 
> This for_each_sym_by_demangled_name() has two "if () continue" while the
> first one has one. Maybe keep them the same (just for symmetry)?

Oops, asymmetry not intended there, thanks.

-- 
Josh

