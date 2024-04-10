Return-Path: <live-patching+bounces-225-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 336AD89FBA3
	for <lists+live-patching@lfdr.de>; Wed, 10 Apr 2024 17:32:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 570751C2323F
	for <lists+live-patching@lfdr.de>; Wed, 10 Apr 2024 15:32:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8847516EBE4;
	Wed, 10 Apr 2024 15:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="srz27ijB";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="srz27ijB"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F92516E871;
	Wed, 10 Apr 2024 15:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712763149; cv=none; b=fs+D1gBvHpqSXlrLgGYyC4iijrxBqzvl3/n0xo8aLMsNIMKLTb2X1YBQYWTcRTzndlsq2GO9w3PrjTfGBNX6EdXFNqgzmhbnz/6FiZC8p1hp5PUTtusUhGsNrxd0oNo2wf3LtLKiM5+QZ55gdfLgJGPjhUUIWKy+I3PrijPHN4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712763149; c=relaxed/simple;
	bh=B0nAhchM37YZ2xM/SSFrLXk96D+WGDIbRzquDnO1f2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EfUOpnqRhK4hd8GZIM7E/jESsqSHQfS6GoaGPMpKJsOMu/ZPZObsgCtmOUoryH+hle91CAeAYl8R+chl6KkiW3ZKSkis+3tCTYqwcaMFsY6pvB7FwAxgZpY5zkxCqjkmMJP1APUO/CoGGb1eHYtdrgWtPOcE3eJ1dFnAMBP+4SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=srz27ijB; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=srz27ijB; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1FCB85D062;
	Wed, 10 Apr 2024 15:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1712763145; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1OPC8ZgLiEqBr/w4gD9mybwHjbz8PCFyyQkn0bnLdg0=;
	b=srz27ijBb1CaOxMILf0y0BODVBSj6vzbTDLHNv20pFvSo/lwXczWQnkgRDUo7H8Oe3MNuB
	FNy1t8gf21EM3mV/x+hIv3spGsySh56XqbcCboC0KFCRuJJ6/KfReGp9j531CoQu9s25rw
	hxpbvUnOLXADLFMETxPHeHt76gPjgp4=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=srz27ijB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1712763145; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1OPC8ZgLiEqBr/w4gD9mybwHjbz8PCFyyQkn0bnLdg0=;
	b=srz27ijBb1CaOxMILf0y0BODVBSj6vzbTDLHNv20pFvSo/lwXczWQnkgRDUo7H8Oe3MNuB
	FNy1t8gf21EM3mV/x+hIv3spGsySh56XqbcCboC0KFCRuJJ6/KfReGp9j531CoQu9s25rw
	hxpbvUnOLXADLFMETxPHeHt76gPjgp4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3C4A413691;
	Wed, 10 Apr 2024 15:32:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id l2WqNQexFmZTNAAAD6G6ig
	(envelope-from <mpdesouza@suse.com>); Wed, 10 Apr 2024 15:32:23 +0000
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Lukas Hruska <lhruska@suse.cz>
Cc: Petr Mladek <pmladek@suse.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: Re: [PATCH v1 0/5] livepatch: klp-convert tool - Minimal version
Date: Wed, 10 Apr 2024 12:32:18 -0300
Message-ID: <20240410153220.15927-1-mpdesouza@suse.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20231106162513.17556-1-lhruska@suse.cz>
References: 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: *****
X-Spamd-Result: default: False [5.39 / 50.00];
	BAYES_SPAM(5.10)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	BAD_REP_POLICIES(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim,suse.cz:email];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[9];
	R_DKIM_ALLOW(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Score: 5.39
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 1FCB85D062
X-Spamd-Bar: +++++

On Mon,  6 Nov 2023 17:25:08 +0100 Lukas Hruska <lhruska@suse.cz> wrote:

> Summary
> -------
> 
> This is a significantly simplified version of the original klp-convert tool.
> The klp-convert code has never got a proper review and also clean ups 
> were not easy. The last version was v7, see 
> https://lore.kernel.org/r/20230306140824.3858543-1-joe.lawrence@redhat.com
> 
> The main change is that the tool does not longer search for the 
> symbols which would need the livepatch specific relocation entry.
> Also klp.symbols file is not longer needed.
> 
> Instead, the needed information is appended to the symbol declaration
> via a new macro KLP_RELOC_SYMBOL(). It creates symbol with all needed
> metadata. For example:
> 
>   extern char *saved_command_line \
>                  KLP_RELOC_SYMBOL(vmlinux, vmlinux, saved_command_line, 0); 
> 
> would create symbol
> 
> $>readelf -r -W <compiled livepatch module>:
> Relocation section '.rela.text' at offset 0x32e60 contains 10 entries:
>     Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
> [...]
> 0000000000000068  0000003c00000002 R_X86_64_PC32          0000000000000000 .klp.sym.rela.vmlinux.vmlinux.saved_command_line,0 - 4 
> [...]
> 
> 
> The simplified klp-convert tool just transforms symbols
> created by KLP_RELOC_SYMBOL() to object specific rela sections
> and rela entries which would later be proceed when the livepatch
> or the livepatched object is loaded.
> 
> For example, klp-convert would replace the above symbols with:
> 
> $> readelf -r -W <livepatch_module_proceed_by_klp_convert>
> Relocation section '.klp.rela.vmlinux.text' at offset 0x5cb60 contains 1 entry:
>     Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
> 0000000000000068  0000003c00000002 R_X86_64_PC32          0000000000000000 .klp.sym.vmlinux.saved_command_line,0 - 4 
> 
> 
> Note that similar macro was needed also in the original version
> to handle more symbols of the same name (sympos).
> 
> Given the above, add klp-convert tool; integrate klp-convert tool into
> kbuild; add data-structure and macros to enable users to annotate
> livepatch source code; make modpost stage compatible with livepatches;
> update livepatch-sample and update documentation.
> 
> 
> Testing
> -------
> 
> The patchset selftests build and execute on x86_64, s390x, and ppc64le
> for both default config (with added livepatch dependencies) and a larger
> SLE-15-ish config.
> 
> 
> Summary of changes in this minimal version
> ------------------------
> 
> - rebase for v6.5
> - cleaned-up SoB chains (suggested by pmladek)
> - klp-convert: remove the symbol map auto-resolving solution
> - klp-convert: add macro for flagging variables inside a LP src to be resolved by this tool
> - klp-convert: code simplification

Do we have anything that blocks klp-convert-mini to be merged, or something that
needs to be fixed?

Thanks,
  Marcos

> 
> Previous versions
> -----------------
> 
> RFC:
>   https://lore.kernel.org/lkml/cover.1477578530.git.jpoimboe@redhat.com/
> v2:
>   https://lore.kernel.org/lkml/f52d29f7-7d1b-ad3d-050b-a9fa8878faf2@redhat.com/
> v3:
>   https://lore.kernel.org/lkml/20190410155058.9437-1-joe.lawrence@redhat.com/
> v4:
>   https://lore.kernel.org/lkml/20190509143859.9050-1-joe.lawrence@redhat.com/
> v5:
>   (not posted)
>   https://github.com/joe-lawrence/klp-convert-tree/tree/klp-convert-v5-devel
> v6:
>   https://lore.kernel.org/live-patching/20220216163940.228309-1-joe.lawrence@redhat.com/
> v7:
>   https://lore.kernel.org/all/20230306140824.3858543-1-joe.lawrence@redhat.com/

