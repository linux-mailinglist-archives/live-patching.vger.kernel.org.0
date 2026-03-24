Return-Path: <live-patching+bounces-2252-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ugi5OleLwmlvewQAu9opvQ
	(envelope-from <live-patching+bounces-2252-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 24 Mar 2026 14:02:15 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E7D8308D39
	for <lists+live-patching@lfdr.de>; Tue, 24 Mar 2026 14:02:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6E2D93050AB2
	for <lists+live-patching@lfdr.de>; Tue, 24 Mar 2026 12:53:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2690F39657C;
	Tue, 24 Mar 2026 12:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="LESe/nCj"
X-Original-To: live-patching@vger.kernel.org
Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DAF38B7B0
	for <live-patching@vger.kernel.org>; Tue, 24 Mar 2026 12:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774356800; cv=none; b=cAqH5PpW7s8xgjpL0syRBXVvzuKyuB5TyKBTleEa+fYcf7Ge5SbOd4m3lUgk7gcqAnFMU+JtQ4QklymeJKgR08gCEc42CiWwVLqgOZmIw/f6OQjmrq5522As3t4beetzj+iTrG4UBMXWfQ7RmB5WeJrCZWFNrh+Wd9lwlwxGnj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774356800; c=relaxed/simple;
	bh=czOsuqvFQqvM6JI9RdObWMtbvC9KS3m+61g9x9nKrZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aA9P49K65/DfNkTRobt6EpZUaFuUH9l06GUGw22/GaEsMTP5h3WDAVIKR020zt8ZGsIpk150RhGc3FxDwmrGGsi62hppaCorM7fo8LmuE05YzN0DftWobwSOzKFuehza0x72VdHr2enExQ25Ip6N4pNYPTTFEquezUNa6mnEFDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=LESe/nCj; arc=none smtp.client-ip=212.77.101.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Received: (wp-smtpd smtp.wp.pl 38048 invoked from network); 24 Mar 2026 13:53:05 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1774356785; bh=3I8BdEJ6fNQCElTQ50WkDj9eLS0W2x/JwM2lSBg4wFg=;
          h=From:To:Cc:Subject;
          b=LESe/nCjch/35QijCLpbvuDy/b+jpWkftSuhHZI/PMLG8528l80AwGDzUmerECn1U
           KTIIgMtyJ9l2+SDRN+9TkfaUjx9bmvJDyVfHcyrFnC28gXwe612NrnzoUYGtFw462n
           iDZaaOIl4xopbJZLYk4RUwEqrOeE+wcZyjym0ODoQv1V1ZuTvA7HkuMBWwayZZF/lv
           uOoBfC3K5n5uFXMHsjLaO3KQwstZnb/HrjJ7QRixvN+83LBHNoIgJc/BotI7JNpT2z
           RQ+Y6NU0bDaA8T5EJowXPnvEE2msTGb3lhHanAdNGNK/wdewaUXBDNPHI5wpjeH6q/
           JWRLjt8J6OlKA==
Received: from zbigniew33.net.autocom.pl (HELO localhost) (stf_xl@wp.pl@[77.236.6.42])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <petr.pavlu@suse.com>; 24 Mar 2026 13:53:05 +0100
Date: Tue, 24 Mar 2026 13:53:04 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Petr Pavlu <petr.pavlu@suse.com>
Cc: linux-modules@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>,
	Luis Chamberlain <mcgrof@kernel.org>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, live-patching@vger.kernel.org,
	Daniel Gomez <da.gomez@kernel.org>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Jordan Rome <linux@jordanrome.com>,
	Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCH] module/kallsyms: sort function symbols and use binary
 search
Message-ID: <20260324125304.GA15972@wp.pl>
References: <20260317110423.45481-1-stf_xl@wp.pl>
 <b6030f42-b4d2-4e52-acec-76e25c0f40db@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6030f42-b4d2-4e52-acec-76e25c0f40db@suse.com>
X-WP-MailID: 03314cd79dc357a376b4607d17023d82
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000001 [AcKt]                               
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[wp.pl,none];
	R_DKIM_ALLOW(-0.20)[wp.pl:s=20241105];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-2252-lists,live-patching=lfdr.de];
	FREEMAIL_FROM(0.00)[wp.pl];
	RCPT_COUNT_TWELVE(0.00)[13];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[stf_xl@wp.pl,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[wp.pl:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,nano:email,wp.pl:dkim,wp.pl:mid]
X-Rspamd-Queue-Id: 6E7D8308D39
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi,

On Mon, Mar 23, 2026 at 02:06:43PM +0100, Petr Pavlu wrote:
> On 3/17/26 12:04 PM, Stanislaw Gruszka wrote:
> > Module symbol lookup via find_kallsyms_symbol() performs a linear scan
> > over the entire symtab when resolving an address. The number of symbols
> > in module symtabs has grown over the years, largely due to additional
> > metadata in non-standard sections, making this lookup very slow.
> > 
> > Improve this by separating function symbols during module load, placing
> > them at the beginning of the symtab, sorting them by address, and using
> > binary search when resolving addresses in module text.
> 
> Doesn't considering only function symbols break the expected behavior
> with CONFIG_KALLSYMS_ALL=y. For instance, when using kdb, is it still
> able to see all symbols in a module? The module loader should be remain
> consistent with the main kallsyms code regarding which symbols can be
> looked up.

We already have a CONFIG_KALLSYMS_ALL=y inconsistency between kernel and 
module symbol lookup, independent of this patch. find_kallsyms_symbol()
restricts the search to MOD_TEXT (or MOD_INIT_TEXT) address ranges, so
it cannot resolve data or rodata symbols.

This appears to be acceptable in practice, most kallsyms_lookup() users are
interested in function symbols. Users relying on CONFIG_KALLSYMS_ALL=y
seems to use name-based lookups or iterate over the full symtab. Though kdb 
looks like the exception: it can resolve data symbols by address in the kernel,
but not in modules. But, I think, resolving symbols by name is more common for
kdb.

To make the behavior consistent, we could either: extend find_kallsyms_symbol()
to cover data/rodata symbols (for CONFIG_KALLSYSM_ALL), or restrict
kallsyms_lookup() to text symbols and introduce a separate API for data symbols
lookup for users that really need that. I think second option is better, as
some (maybe most) users are not interested in all symbols, even if
CONFIG_KALLSYSM_ALL is set.

However, either would require substantial rework and is outside the scope
of this patch.

Regards
Stanislaw

> > This also should improve times for linear symbol name lookups, as valid
> > function symbols are now located at the beginning of the symtab.
> > 
> > The cost of sorting is small relative to module load time. In repeated
> > module load tests [1], depending on .config options, this change
> > increases load time between 2% and 4%. With cold caches, the difference
> > is not measurable, as memory access latency dominates.
> > 
> > The sorting theoretically could be done in compile time, but much more
> > complicated as we would have to simulate kernel addresses resolution
> > for symbols, and then correct relocation entries. That would be risky
> > if get out of sync.
> > 
> > The improvement can be observed when listing ftrace filter functions:
> > 
> > root@nano:~# time cat /sys/kernel/tracing/available_filter_functions | wc -l
> > 74908
> > 
> > real	0m1.315s
> > user	0m0.000s
> > sys	0m1.312s
> > 
> > After:
> > 
> > root@nano:~# time cat /sys/kernel/tracing/available_filter_functions | wc -l
> > 74911
> > 
> > real	0m0.167s
> > user	0m0.004s
> > sys	0m0.175s
> > 
> > (there are three more symbols introduced by the patch)
> 
> This looks as a reasonable improvement.
> 
> > 
> > For livepatch modules, the symtab layout is preserved and the existing
> > linear search is used. For this case, it should be possible to keep
> > the original ELF symtab instead of copying it 1:1, but that is outside
> > the scope of this patch.
> 
> Livepatch modules are already handled specially by the kallsyms module
> code so excluding them from this optimization is probably ok.
> 
> However, it might be worth revisiting this exception. I believe that
> livepatch support requires the original symbol table for relocations to
> remain usable. It might make sense to investigate whether updating the
> relocation data with the adjusted symbol indexes would be sensible.
> 
> -- 
> Thanks,
> Petr

