Return-Path: <live-patching+bounces-271-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A8888C77AC
	for <lists+live-patching@lfdr.de>; Thu, 16 May 2024 15:31:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D4961C225CD
	for <lists+live-patching@lfdr.de>; Thu, 16 May 2024 13:31:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61FD1147C77;
	Thu, 16 May 2024 13:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="JHhrBQLu";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UYyQGWGQ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="JHhrBQLu";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UYyQGWGQ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC1E14D446;
	Thu, 16 May 2024 13:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715866237; cv=none; b=mfmFT5sjKdpvjgj2Oa0YwHxReFeskHsFvIBDaIIhJGz62ZjUUF4Ih8WiFRXRxPYwfc1ZEuon+GZ2rNYZXJKNL/o6U3z0fFaxB0MLb7qWz9C6dTEY1bJgW4M4XKcom6zvqU0kOl+CKNlsBR40JJEiryxcznXZPYb2orThnMhzur8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715866237; c=relaxed/simple;
	bh=wyqwzplBP+XVgieQKpS9endqaVKStGMZs5g8jIJu0Wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMxMi/d9K2huj+mS4iT3gtsFxKoTQ9aRvxTtn8pgsbYL85eoFEWXDHWQ/zW3POZv41qwwT3+uT/CqAb+Yo3Vv0LeVSOLgL0j5LKMsSR+ZVPgv+xIKQ8+7of+BYm2hyscBdBAm5TD3a/sm736h4+6kAloJW98f1rvf7ggtBKSLdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=JHhrBQLu; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UYyQGWGQ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=JHhrBQLu; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UYyQGWGQ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 036DF5C445;
	Thu, 16 May 2024 13:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1715866234; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vXcaIUojiFzTn6/C8B2DBrSfDgG5AlW/ecRlVb4q+Eo=;
	b=JHhrBQLuSwXo1lWexQlFVf86XG7bIaPsH8UQ1UJIScgYcE5BxlLcZ194cltsq/q2SUoXVF
	qPti+nnUHrOocLupU6jF/EoVJB68wfeK8dTMLCOoYKyLQAfwaiuohQxKXX+vKD/1NVLEar
	Szsqz/bUG4o1EQI4cQrQ9xmJmWhJ2Tw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1715866234;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vXcaIUojiFzTn6/C8B2DBrSfDgG5AlW/ecRlVb4q+Eo=;
	b=UYyQGWGQojMU525jhS1gYJFAl7q8DA04Nj5VBDkLVKz3c+WeO8dpQT7hIzGKxy/XeXbHiU
	yoZpi9mpMU0YffCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1715866234; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vXcaIUojiFzTn6/C8B2DBrSfDgG5AlW/ecRlVb4q+Eo=;
	b=JHhrBQLuSwXo1lWexQlFVf86XG7bIaPsH8UQ1UJIScgYcE5BxlLcZ194cltsq/q2SUoXVF
	qPti+nnUHrOocLupU6jF/EoVJB68wfeK8dTMLCOoYKyLQAfwaiuohQxKXX+vKD/1NVLEar
	Szsqz/bUG4o1EQI4cQrQ9xmJmWhJ2Tw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1715866234;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vXcaIUojiFzTn6/C8B2DBrSfDgG5AlW/ecRlVb4q+Eo=;
	b=UYyQGWGQojMU525jhS1gYJFAl7q8DA04Nj5VBDkLVKz3c+WeO8dpQT7hIzGKxy/XeXbHiU
	yoZpi9mpMU0YffCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EBD6D13991;
	Thu, 16 May 2024 13:30:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Rx6yOHkKRmZJCwAAD6G6ig
	(envelope-from <lhruska@suse.cz>); Thu, 16 May 2024 13:30:33 +0000
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
Subject: [PATCH v2 5/6] documentation: Update on livepatch elf format
Date: Thu, 16 May 2024 15:30:08 +0200
Message-ID: <20240516133009.20224-6-lhruska@suse.cz>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240516133009.20224-1-lhruska@suse.cz>
References: <20240516133009.20224-1-lhruska@suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Spam-Level: 
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo,suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[]

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
2.45.0


