Return-Path: <live-patching+bounces-294-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 220028D38AA
	for <lists+live-patching@lfdr.de>; Wed, 29 May 2024 16:06:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 459CC1C2204D
	for <lists+live-patching@lfdr.de>; Wed, 29 May 2024 14:06:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CF7C2032B;
	Wed, 29 May 2024 14:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nVsGN4H5";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nVsGN4H5"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8C21F5F6;
	Wed, 29 May 2024 14:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716991544; cv=none; b=s9R0k7CwJAP4XBnFGD3hZkaVD1/hOTMJ3ifz9GRmwufJfNLL6Vhg6VBKYD91qI5ZOq6lgRkIi4lu+7BgIOQFc9xhnijNSewm4TBnhyZ0ZznGr6uB4H7pEivl+IfdTxpr7E+PLpnBm9u5f3ePju9OA4E58qy0Tniu4n16SpvEp2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716991544; c=relaxed/simple;
	bh=44DuED9EFhJ0GFgSWxyzBEOtcMqHHs3WgFTDn4hoJ6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BO7DnLmqw69DBnGgzTGzacpMVacXfcQ27/EDjLc88b4Evnsw7wHqJ1noXa2rAVC1v7u71ZzAKReMuVYNPx3wrh01qFXkJ9BeuCqwBbijeQ7cTUzVJjdvaeKgP0oo+lpd9AdN9rrUI4+MEeafPpkUloF4Zc1ygQUwDzs+VdAdctE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nVsGN4H5; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nVsGN4H5; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7B608336AF;
	Wed, 29 May 2024 14:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1716991540; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S7+lTfIl4GO+Abh7YhdGsCv7gLWnQXpzMH8I4JBF3MI=;
	b=nVsGN4H5ifPGKbfG0TTRltiQ3UENeJocDNI/xhYt33Uu8/PJKORDtd83+Mf8aYNLt5Ofgv
	9gU0ijoLi2bReJfhmQNb7FPdW2sbikbss8DJ/kVYPuukFUlAtTDtwBGhdzpNLAwsHCDDqi
	N8P+JGhW3ePbzRpwd7LvmPBZNAr21xc=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1716991540; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S7+lTfIl4GO+Abh7YhdGsCv7gLWnQXpzMH8I4JBF3MI=;
	b=nVsGN4H5ifPGKbfG0TTRltiQ3UENeJocDNI/xhYt33Uu8/PJKORDtd83+Mf8aYNLt5Ofgv
	9gU0ijoLi2bReJfhmQNb7FPdW2sbikbss8DJ/kVYPuukFUlAtTDtwBGhdzpNLAwsHCDDqi
	N8P+JGhW3ePbzRpwd7LvmPBZNAr21xc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 161041372E;
	Wed, 29 May 2024 14:05:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CtCHNTM2V2aRWAAAD6G6ig
	(envelope-from <mpdesouza@suse.com>); Wed, 29 May 2024 14:05:39 +0000
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Lukas Hruska <lhruska@suse.cz>
Cc: mpdesouza@suse.com,
	pmladek@suse.com,
	mbenes@suse.cz,
	jpoimboe@kernel.org,
	joe.lawrence@redhat.com,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v2 0/5] livepatch: klp-convert tool - Minimal version
Date: Wed, 29 May 2024 11:05:27 -0300
Message-ID: <20240529140536.18137-1-mpdesouza@suse.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240516133009.20224-1-lhruska@suse.cz>
References: 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_ALL(0.00)[]

From: mpdesouza@suse.com

On Thu, 16 May 2024 15:30:03 +0200 Lukas Hruska <lhruska@suse.cz> wrote:

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
> Summary of changes in this minimal version v2
> ------------------------
> 
> - rebase for v6.9
> - cleaned-up SoB chains (suggested by pmladek)
> - klp-convert: remove the symbol map auto-resolving solution
> - klp-convert: add macro for flagging variables inside a LP src to be resolved by this tool
> - klp-convert: code simplification
> - selftests: add selftest livepatching function using an external symbol

Thanks for sending this new version Lukas! It currently fails to apply on
current Linux master, but the conflict is very simple to address (attached
patch).

Joe, Josh, other people, can you also take a look in the patchset? It would be
good we can move this forward.

Thanks,
  Marcos

commit 1a1cf8b0967c26857b17e8ceb02f6a1bd854667d
Author: Marcos Paulo de Souza <mpdesouza@suse.com>
Date:   Wed May 29 10:18:38 2024 -0300

    Solve merge problem
    
    Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>

diff --git a/Makefile b/Makefile
index f975b6396328..579dfb46e691 100644
--- a/Makefile
+++ b/Makefile
@@ -1491,7 +1491,7 @@ endif # CONFIG_MODULES
 # Directories & files removed with 'make clean'
 CLEAN_FILES += vmlinux.symvers modules-only.symvers \
 	       modules.builtin modules.builtin.modinfo modules.nsdeps \
-	       compile_commands.json rust/test \
+	       compile_commands.json .thinlto-cache rust/test \
 	       rust-project.json .vmlinux.objs .vmlinux.export.c
 
 # Directories & files removed with 'make mrproper'

> 
> Previous versions
> -----------------
> 
> RFC:
>   https://lore.kernel.org/r/cover.1477578530.git.jpoimboe@redhat.com/
> v2:
>   https://lore.kernel.org/r/f52d29f7-7d1b-ad3d-050b-a9fa8878faf2@redhat.com/
> v3:
>   https://lore.kernel.org/r/20190410155058.9437-1-joe.lawrence@redhat.com/
> v4:
>   https://lore.kernel.org/r/20190509143859.9050-1-joe.lawrence@redhat.com/
> v5:
>   (not posted)
>   https://github.com/joe-lawrence/klp-convert-tree/tree/klp-convert-v5-devel
> v6:
>   https://lore.kernel.org/r/20220216163940.228309-1-joe.lawrence@redhat.com/
> v7:
>   https://lore.kernel.org/r/20230306140824.3858543-1-joe.lawrence@redhat.com/
> v1 minimal:
>   https://lore.kernel.org/r/20231106162513.17556-1-lhruska@suse.cz/

