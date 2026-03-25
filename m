Return-Path: <live-patching+bounces-2258-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KNAgI6Czw2lstgQAu9opvQ
	(envelope-from <live-patching+bounces-2258-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 25 Mar 2026 11:06:24 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 36756322A40
	for <lists+live-patching@lfdr.de>; Wed, 25 Mar 2026 11:06:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 90B8930115BD
	for <lists+live-patching@lfdr.de>; Wed, 25 Mar 2026 10:02:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C0F03A6B76;
	Wed, 25 Mar 2026 10:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="P9l3nviL"
X-Original-To: live-patching@vger.kernel.org
Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D02A38D6A4
	for <live-patching@vger.kernel.org>; Wed, 25 Mar 2026 10:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774432938; cv=none; b=HGRpl8WsIJXFfZSyiQGCsd9TB+ZdVFSN7joEvJospwpYbzH56H8tXCfXlQX7RbPeKXkKoYJlSb1+2igdv9GfwArBfxsOBNYP1KQsQqhYZKqEivHmGCJGvrFh9LLZCOE6lJ6Yegv/ICv33ktryO22lHyuiBFQyNDUvbKH0YrUHZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774432938; c=relaxed/simple;
	bh=BOHQdiU/gvG8mcDwZGxgkiG7C1zsf4yixpRiH2WNyPc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V58opRJ061FiqB9VDRxxdvg8W6J+8CBzyY5C7+2XPnQf0EBX5Zyij9YsY4VCKlCeNQPdEIvzSkxe+YGQvO0EeFesxeRcJb6oeqiHA7qIvTV+1ziYKjk2Gx+pgB0XLD4prUgU/frjX8Qo+3N5M9RNLjeMCOUfDV1ydb3KZFWuPR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=P9l3nviL; arc=none smtp.client-ip=212.77.101.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Received: (wp-smtpd smtp.wp.pl 45216 invoked from network); 25 Mar 2026 11:02:05 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1774432925; bh=WjvzYWzbjDqBs7Z1emu9dcy8LFxZG9M7Xjaah8E6lgg=;
          h=From:To:Cc:Subject;
          b=P9l3nviLmxoMmV1QNHAHt2ufbxAEyY0CuaiZoXFh4aud7k0AwYNFkmb3GK9b8qOBQ
           ajX63NC4WN5y5MjhwjyL+0VydkI/IfDTpebBofGWsijE8zyYMqotFo7VG2fVZ3U78v
           ul12DgoZ/6wae7DiCuRz1JXsZCr35nu/fYCT86l9apf0GRe+8cPXdMvLb1JwxAfcYB
           sNYwXd0Aj/+SQ6Gs03GDbMvSnSfjh69rP9qWuqx4uFhZbUgQ5QFaA4EXDypiHm5Ztr
           v7A7H2ggp4owWg2zIpZlDjhkBlwETtDe4CwzDo6sPw17pXpMJMpesN7jlzxdTBfkmP
           W2WR1FlMntI5w==
Received: from zbigniew33.net.autocom.pl (HELO localhost) (stf_xl@wp.pl@[77.236.6.42])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <petr.pavlu@suse.com>; 25 Mar 2026 11:02:05 +0100
Date: Wed, 25 Mar 2026 11:02:02 +0100
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
Message-ID: <20260325100202.GA22612@wp.pl>
References: <20260317110423.45481-1-stf_xl@wp.pl>
 <b6030f42-b4d2-4e52-acec-76e25c0f40db@suse.com>
 <20260324125304.GA15972@wp.pl>
 <282574df-7689-4677-929b-b844e7201bd5@suse.com>
 <20260325082648.GA18968@wp.pl>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325082648.GA18968@wp.pl>
X-WP-MailID: 5038ef7f550eeb2bd6590bf38a52a15d
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [UXMR]                               
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[wp.pl,none];
	R_DKIM_ALLOW(-0.20)[wp.pl:s=20241105];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-2258-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[wp.pl:dkim,wp.pl:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 36756322A40
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Mar 25, 2026 at 09:26:56AM +0100, Stanislaw Gruszka wrote:
> On Tue, Mar 24, 2026 at 05:00:19PM +0100, Petr Pavlu wrote:
> > On 3/24/26 1:53 PM, Stanislaw Gruszka wrote:
> > > Hi,
> > > 
> > > On Mon, Mar 23, 2026 at 02:06:43PM +0100, Petr Pavlu wrote:
> > >> On 3/17/26 12:04 PM, Stanislaw Gruszka wrote:
> > >>> Module symbol lookup via find_kallsyms_symbol() performs a linear scan
> > >>> over the entire symtab when resolving an address. The number of symbols
> > >>> in module symtabs has grown over the years, largely due to additional
> > >>> metadata in non-standard sections, making this lookup very slow.
> > >>>
> > >>> Improve this by separating function symbols during module load, placing
> > >>> them at the beginning of the symtab, sorting them by address, and using
> > >>> binary search when resolving addresses in module text.
> > >>
> > >> Doesn't considering only function symbols break the expected behavior
> > >> with CONFIG_KALLSYMS_ALL=y. For instance, when using kdb, is it still
> > >> able to see all symbols in a module? The module loader should be remain
> > >> consistent with the main kallsyms code regarding which symbols can be
> > >> looked up.
> > > 
> > > We already have a CONFIG_KALLSYMS_ALL=y inconsistency between kernel and 
> > > module symbol lookup, independent of this patch. find_kallsyms_symbol()
> > > restricts the search to MOD_TEXT (or MOD_INIT_TEXT) address ranges, so
> > > it cannot resolve data or rodata symbols.
> > 
> > My understanding is that find_kallsyms_symbol() can identify all symbols
> > in a module by their addresses. However, the issue I see with
> > MOD_TEXT/MOD_INIT_TEXT is that the function may incorrectly calculate
> > the size of symbols that are not within these ranges, which is a bug
> > that should be fixed.
> 
> You are right, I misinterpreted the code:
> 
> 	if (within_module_init(addr, mod))
> 		mod_mem = &mod->mem[MOD_INIT_TEXT];
> 	else
> 		mod_mem = &mod->mem[MOD_TEXT];
> 
> 	nextval = (unsigned long)mod_mem->base + mod_mem->size;
> 
> 	bestval = kallsyms_symbol_value(&kallsyms->symtab[best]);
> 
> For best = 0, bestval is also 0 as it comes from the ELF null symbol.
> 
> > A test using kdb confirms that non-text symbols can be found by their
> > addresses. The following shows the current behavior with 7.0-rc5 when
> > printing a module parameter in mlx4_en:
> > 
> > [1]kdb> mds __param_arr_num_vfs
> > 0xffffffffc1209f20 0000000100000003   ........
> > 0xffffffffc1209f28 ffffffffc0fbf07c [mlx4_core]num_vfs_argc  
> > 0xffffffffc1209f30 ffffffff8844bba0 param_ops_byte  
> > 0xffffffffc1209f38 ffffffffc0fbf080 [mlx4_core]num_vfs  
> > 0xffffffffc1209f40 000000785f69736d   msi_x...
> > 0xffffffffc1209f48 656c5f6775626564   debug_le
> > 0xffffffffc1209f50 00000000006c6576   vel.....
> > 0xffffffffc1209f58 0000000000000000   ........
> > 
> > .. and the behavior with the proposed patch:
> > 
> > [1]kdb> mds __param_arr_num_vfs
> > 0xffffffffc1077f20 0000000100000003   ........
> > 0xffffffffc1077f28 ffffffffc104707c   |p......
> > 0xffffffffc1077f30 ffffffffb4a4bba0 param_ops_byte  
> > 0xffffffffc1077f38 ffffffffc1047080   .p......
> > 0xffffffffc1077f40 000000785f69736d   msi_x...
> > 0xffffffffc1077f48 656c5f6775626564   debug_le
> > 0xffffffffc1077f50 00000000006c6576   vel.....
> > 0xffffffffc1077f58 0000000000000000   ........
> 
> Thanks for testing and pointing this out. Patch indeed breaks
> the CONFIG_KALLSYMS_ALL case. 
> 
> I think, possible fix would be to track the relevant sections in 
> __layout_sections() and use defined symbols from those sections,
> instead of just function symbols. 

I considered sorting data symbols as well, but this is nontrivial, 
it is difficult to reliably distinguish real data sections from metadata
sections containing symbols we do not want to include.

An alternative approach is to check the module memory type and fall back to
a linear search for ranges other than MOD_TEXT. This approach would also
fix the incorrect nextval/size problem.

Regards
Stanislaw

