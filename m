Return-Path: <live-patching+bounces-524-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BA7A7960A65
	for <lists+live-patching@lfdr.de>; Tue, 27 Aug 2024 14:32:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71D9F283B33
	for <lists+live-patching@lfdr.de>; Tue, 27 Aug 2024 12:32:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB24C1BBBCE;
	Tue, 27 Aug 2024 12:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kmCYMNlt";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="KVZFUZIW";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZEHygrym";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="3nCpdqd9"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473E11BC06D;
	Tue, 27 Aug 2024 12:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724761869; cv=none; b=ORP0Jrp0QLtLqgvDyuWh9OdVyqd5fvXQXu0ahvZs/2ODdtQskVNyoEBp06hpgpDCoRgG6eQTdIO5q2dfQijFpboVhFaBXFWm8xzZPZvlDSUo+w+JBAnrf0EBIPTdlbmPKg/CqrQQ7WRplspIVNv7u5CmOpfkwsJror2wb5AXY5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724761869; c=relaxed/simple;
	bh=ApneUWloadgZwddxuJJRwqII87YG/RGISlx1qPgh4ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBNuaqFA6KS+Vwkoao9Gb8ZWM/UZ73ms/y60pXjOVaCsAhjyMxfdKIpAPf4bnPuy+UK5CJUZ/gWe6+tlz/ZqXBGJsaupPL6ICmd6/1UjKMCwB6Yi7A2b1XuSPIb5mjdez4YWJB8wD7fegC9JBvBkWyf5ZVbKO+Uzp5GlL/+VLbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kmCYMNlt; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=KVZFUZIW; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZEHygrym; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=3nCpdqd9; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6B0281FB68;
	Tue, 27 Aug 2024 12:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1724761865; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V4oYFPo458Wmz+yfMGftePr620+V1zwV88B/zXGDnQ8=;
	b=kmCYMNltaQIswjRW+kCuurEO4CHnKwnOIJrYJLvx1+b84cUwFVSSG3jis0cInNQl4af8PI
	T9Jl0rSSVhVuQKQNWNuTp0X7jmSn0IYKQEQewLUSet0uk/VYChK5HYIPLihSeiZMFsSmZT
	wdZZp2jOk07PejUYz2GjjDJxtkPCdAU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1724761865;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V4oYFPo458Wmz+yfMGftePr620+V1zwV88B/zXGDnQ8=;
	b=KVZFUZIWvqo/kM9IqxvhhmHW4+2TxiIDgtuUr+TmZA80EyQslaH+8pA+2qaLi2aIt18m/6
	zEFVQtpNp7xNOxCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1724761864; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V4oYFPo458Wmz+yfMGftePr620+V1zwV88B/zXGDnQ8=;
	b=ZEHygrym+tzV87MRKPKiuwUaxwfk0xSegwhlXrpEDB2F5ZAM9FA+mUxseGIsXyjpRlPJkh
	ZZL6sHf0feoLI3c5TGdWUGaRVueKDhC/vgl6jRLM7dzOg1bBSOqp4kYnZHYUONiM9CBkAN
	0htAm1HkiwHlJh7nIW8vFB6v0eiYIK4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1724761864;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V4oYFPo458Wmz+yfMGftePr620+V1zwV88B/zXGDnQ8=;
	b=3nCpdqd9vGPTik9a6anq6VMVh+5PNQK0zAbVfafz6k0y8UKxoyuvpgw9EeLfPn9gT5Lucy
	0mizbipwhW2rQ7AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 648A413724;
	Tue, 27 Aug 2024 12:31:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IzCKGAjHzWbEYwAAD6G6ig
	(envelope-from <lhruska@suse.cz>); Tue, 27 Aug 2024 12:31:04 +0000
From: Lukas Hruska <lhruska@suse.cz>
To: pmladek@suse.com,
	mbenes@suse.cz,
	jpoimboe@kernel.org
Cc: joe.lawrence@redhat.com,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	mpdesouza@suse.com,
	lhruska@suse.cz
Subject: [PATCH v3 5/6] documentation: Update on livepatch elf format
Date: Tue, 27 Aug 2024 14:30:50 +0200
Message-ID: <20240827123052.9002-6-lhruska@suse.cz>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240827123052.9002-1-lhruska@suse.cz>
References: <20240827123052.9002-1-lhruska@suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,suse.cz:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -6.80
X-Spam-Flag: NO

Add a section to Documentation/livepatch/module-elf-format.rst
describing how klp-convert works for fixing relocations.

Signed-off-by: Lukas Hruska <lhruska@suse.cz>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 Documentation/livepatch/module-elf-format.rst | 67 +++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/Documentation/livepatch/module-elf-format.rst b/Documentation/livepatch/module-elf-format.rst
index a03ed02ec57e..2aa9b11cd806 100644
--- a/Documentation/livepatch/module-elf-format.rst
+++ b/Documentation/livepatch/module-elf-format.rst
@@ -300,3 +300,70 @@ symbol table, and relocation section indices, ELF information is preserved for
 livepatch modules and is made accessible by the module loader through
 module->klp_info, which is a :c:type:`klp_modinfo` struct. When a livepatch module
 loads, this struct is filled in by the module loader.
+
+6. klp-convert tool
+===================
+The livepatch relocation sections might be created using
+scripts/livepatch/klp-convert. It is called automatically during
+the build as part of a module post processing.
+
+The tool is not able to find the symbols and all the metadata
+automatically. Instead, all needed information must already be
+part of rela entry for the given symbol. Such a rela can
+be created easily by using KLP_RELOC_SYMBOL() macro after
+the symbol declaration.
+
+KLP_RELOC_SYMBOL causes that the relocation entries for
+the given symbol will be created in the following format::
+
+  .klp.sym.rela.lp_object.sym_object.sym_name,sympos
+  ^           ^ ^       ^ ^        ^ ^      ^   ^
+  |___________| |_______| |________| |______|   |
+       [A]         [B]        [C]       [D]    [E]
+
+[A]
+  The symbol name is prefixed with the string ".klp.sym.rela."
+
+[B]
+  The name of the object (i.e. "vmlinux" or name of module) which
+  is livepatched.
+
+[C]
+  The name of the object (i.e. "vmlinux" or name of module) to
+  which the symbol belongs follows immediately after the prefix.
+
+[D]
+  The actual name of the symbol.
+
+[E]
+  The position of the symbol in the object (as according to kallsyms)
+  This is used to differentiate duplicate symbols within the same
+  object. The symbol position is expressed numerically (0, 1, 2...).
+  The symbol position of a unique symbol is 0.
+
+Example:
+--------
+**Livepatch source code:**
+
+::
+
+  extern char *saved_command_line \
+                 KLP_RELOC_SYMBOL(vmlinux, vmlinux, saved_command_line, 0);
+
+**`readelf -r -W` output of compiled module:**
+
+::
+
+  Relocation section '.rela.text' at offset 0x32e60 contains 10 entries:
+      Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
+  ...
+  0000000000000068  0000003c00000002 R_X86_64_PC32          0000000000000000 .klp.sym.rela.vmlinux.vmlinux.saved_command_line,0 - 4
+  ...
+
+**`readelf -r -W` output of transformed module by klp-convert:**
+
+::
+
+  Relocation section '.klp.rela.vmlinux.text' at offset 0x5cb60 contains 1 entry:
+      Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
+      0000000000000068  0000003c00000002 R_X86_64_PC32          0000000000000000 .klp.sym.vmlinux.saved_command_line,0 - 4
-- 
2.46.0


