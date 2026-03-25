Return-Path: <live-patching+bounces-2256-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IIbBAUidw2l4sAQAu9opvQ
	(envelope-from <live-patching+bounces-2256-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 25 Mar 2026 09:31:04 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F7FD3216F0
	for <lists+live-patching@lfdr.de>; Wed, 25 Mar 2026 09:31:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0AD1E3063625
	for <lists+live-patching@lfdr.de>; Wed, 25 Mar 2026 08:27:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8BED396D32;
	Wed, 25 Mar 2026 08:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="YikIByFL"
X-Original-To: live-patching@vger.kernel.org
Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9172396D35
	for <live-patching@vger.kernel.org>; Wed, 25 Mar 2026 08:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774427223; cv=none; b=fMhWWKrLKL7YZ3sLN7Kf3aLyAul3asGy23ELNw60s0HUt6gjdb/SLbC+dtO6uMRVY6pFqDtnfpnErnHNKoaXeBPxI7l3bt8o4hct74V3aEPVWhF0f+1kbmY6nj2IIy/4e38AF06LsFOfcOpiYRATQtOT3ZVkO5LtOlEXBaJy8mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774427223; c=relaxed/simple;
	bh=gIUNhpBx+7oWQkB6WOG8yHO7M0ecgRUP2Cm3pdCBBT4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vAX7tbmrDT+3QqyoV5hC14ta7zj2zpW90+oNN32aIgfkdbbjzsWvHPgQuTQxP9ko8t/+Hgk6hhXCD51mImKATmHCfzQwb9zqANSvDxDTIn3FWCNeGJgOfMvP0MlnFpu8fMawy4bYudxPkdvBCPvYbOTdkqk/8q7U3JQb3/b1LhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=YikIByFL; arc=none smtp.client-ip=212.77.101.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Received: (wp-smtpd smtp.wp.pl 40096 invoked from network); 25 Mar 2026 09:26:49 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1774427209; bh=D38tD79X5kbhHnmc5UKWJdVgjAw8jN9cdQd6Fw+5ee8=;
          h=From:To:Cc:Subject;
          b=YikIByFLx5YfWiDmp/TOnJhDJOUceZQHqOY4yoDtJE1uEGj1jteT3CGZaC7qadF+E
           aVa0kZJgUR5BhvEZFZV65vuO2YOCHQuiErVw8dtLoOrN47wSdH2OvJ/MRW2e5LpiE9
           nUtcGbT9ME850SpP1PAVKT6mPfWD08yYvchnfiZeR7vv2wysXhmoWQ2qb+w5o0jSxo
           TinxuwijeKOcmtoSAjS8UUvuV5SMT8grf/+2n4CdiHL9fGV2TjIYiZ9cJsm4Onwnd2
           m/ijxD7ikbCJVznTEC7pZEpulre4MZCg0VvavuJTNm6TzCgM2x1Z42+vrd/1P/GV/u
           shJxFm6OFUllA==
Received: from zbigniew33.net.autocom.pl (HELO localhost) (stf_xl@wp.pl@[77.236.6.42])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <petr.pavlu@suse.com>; 25 Mar 2026 09:26:49 +0100
Date: Wed, 25 Mar 2026 09:26:48 +0100
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
Message-ID: <20260325082648.GA18968@wp.pl>
References: <20260317110423.45481-1-stf_xl@wp.pl>
 <b6030f42-b4d2-4e52-acec-76e25c0f40db@suse.com>
 <20260324125304.GA15972@wp.pl>
 <282574df-7689-4677-929b-b844e7201bd5@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <282574df-7689-4677-929b-b844e7201bd5@suse.com>
X-WP-MailID: 2acdd90e03552bdbe2169eb5f06892c4
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [kUNR]                               
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[wp.pl,none];
	R_DKIM_ALLOW(-0.20)[wp.pl:s=20241105];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-2256-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,wp.pl:dkim,wp.pl:mid]
X-Rspamd-Queue-Id: 0F7FD3216F0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Mar 24, 2026 at 05:00:19PM +0100, Petr Pavlu wrote:
> On 3/24/26 1:53 PM, Stanislaw Gruszka wrote:
> > Hi,
> > 
> > On Mon, Mar 23, 2026 at 02:06:43PM +0100, Petr Pavlu wrote:
> >> On 3/17/26 12:04 PM, Stanislaw Gruszka wrote:
> >>> Module symbol lookup via find_kallsyms_symbol() performs a linear scan
> >>> over the entire symtab when resolving an address. The number of symbols
> >>> in module symtabs has grown over the years, largely due to additional
> >>> metadata in non-standard sections, making this lookup very slow.
> >>>
> >>> Improve this by separating function symbols during module load, placing
> >>> them at the beginning of the symtab, sorting them by address, and using
> >>> binary search when resolving addresses in module text.
> >>
> >> Doesn't considering only function symbols break the expected behavior
> >> with CONFIG_KALLSYMS_ALL=y. For instance, when using kdb, is it still
> >> able to see all symbols in a module? The module loader should be remain
> >> consistent with the main kallsyms code regarding which symbols can be
> >> looked up.
> > 
> > We already have a CONFIG_KALLSYMS_ALL=y inconsistency between kernel and 
> > module symbol lookup, independent of this patch. find_kallsyms_symbol()
> > restricts the search to MOD_TEXT (or MOD_INIT_TEXT) address ranges, so
> > it cannot resolve data or rodata symbols.
> 
> My understanding is that find_kallsyms_symbol() can identify all symbols
> in a module by their addresses. However, the issue I see with
> MOD_TEXT/MOD_INIT_TEXT is that the function may incorrectly calculate
> the size of symbols that are not within these ranges, which is a bug
> that should be fixed.

You are right, I misinterpreted the code:

	if (within_module_init(addr, mod))
		mod_mem = &mod->mem[MOD_INIT_TEXT];
	else
		mod_mem = &mod->mem[MOD_TEXT];

	nextval = (unsigned long)mod_mem->base + mod_mem->size;

	bestval = kallsyms_symbol_value(&kallsyms->symtab[best]);

For best = 0, bestval is also 0 as it comes from the ELF null symbol.

> A test using kdb confirms that non-text symbols can be found by their
> addresses. The following shows the current behavior with 7.0-rc5 when
> printing a module parameter in mlx4_en:
> 
> [1]kdb> mds __param_arr_num_vfs
> 0xffffffffc1209f20 0000000100000003   ........
> 0xffffffffc1209f28 ffffffffc0fbf07c [mlx4_core]num_vfs_argc  
> 0xffffffffc1209f30 ffffffff8844bba0 param_ops_byte  
> 0xffffffffc1209f38 ffffffffc0fbf080 [mlx4_core]num_vfs  
> 0xffffffffc1209f40 000000785f69736d   msi_x...
> 0xffffffffc1209f48 656c5f6775626564   debug_le
> 0xffffffffc1209f50 00000000006c6576   vel.....
> 0xffffffffc1209f58 0000000000000000   ........
> 
> .. and the behavior with the proposed patch:
> 
> [1]kdb> mds __param_arr_num_vfs
> 0xffffffffc1077f20 0000000100000003   ........
> 0xffffffffc1077f28 ffffffffc104707c   |p......
> 0xffffffffc1077f30 ffffffffb4a4bba0 param_ops_byte  
> 0xffffffffc1077f38 ffffffffc1047080   .p......
> 0xffffffffc1077f40 000000785f69736d   msi_x...
> 0xffffffffc1077f48 656c5f6775626564   debug_le
> 0xffffffffc1077f50 00000000006c6576   vel.....
> 0xffffffffc1077f58 0000000000000000   ........

Thanks for testing and pointing this out. Patch indeed breaks
the CONFIG_KALLSYMS_ALL case. 

I think, possible fix would be to track the relevant sections in 
__layout_sections() and use defined symbols from those sections,
instead of just function symbols. 

Regards
Stanislaw

