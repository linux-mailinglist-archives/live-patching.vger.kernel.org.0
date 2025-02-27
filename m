Return-Path: <live-patching+bounces-1241-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F3CCA48286
	for <lists+live-patching@lfdr.de>; Thu, 27 Feb 2025 16:10:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 292141676AD
	for <lists+live-patching@lfdr.de>; Thu, 27 Feb 2025 15:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB48525F967;
	Thu, 27 Feb 2025 15:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="fQcHyLnM";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="DxhGKqdK"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C01269CE8
	for <live-patching@vger.kernel.org>; Thu, 27 Feb 2025 15:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740668615; cv=none; b=HaYpOTrVxirTDyBNdEzZ+Bn+yhn7Ft2WWYAVflFCe8dx5YOgOC5OpJ6GFsTJ1+qxFhawvNMTqAPXjQDq+HsMvUyj8j8ab/F4fhK99Mooq6h0juIA3bsoQdevQbxZwsH9dyT6jbLwxlX/zTMhuiIIvd65OuWeoFu6WK022V3suo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740668615; c=relaxed/simple;
	bh=1FMpYSSNrm5jFXSaO7kwUtTWhd7AhGZ1E1RuRjpIB5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FQbY+6jHTcXxKl75coRlOsJLep8nvGUEljvPsJkcbXhXFKxbgpPyr7QkIoLTSYaWmYZZg/UAO6KWssS08PlB2WgZ8wa3XuQV3dCAy5Pc3ok60l0WroAIPSabYK0My75ZzlgLrJY1gONkpdcnJGKm7jYieVGn0aNpEYgeKhaCcTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=fQcHyLnM; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=DxhGKqdK; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DF46A1F457;
	Thu, 27 Feb 2025 15:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1740668612; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ZgFUlmr6WcP558S1jjl25yNZ/UxRgb8t4jQCSQY55N8=;
	b=fQcHyLnMj97VC2bhtz5W1GXdRl18vm5PEvAm2CqE61R5ia7w2Bj7TUkxtmMeIsejY2UX9L
	OtRICJ8jeO+frGA004UH7ms0V5o3Wfh3lqzFOuoUkFlCZQvUK9Wvr0OZKZq7qT80p3vaMr
	lAU95L3AdqD3s26EbsfIha7T08iI2JQ=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=DxhGKqdK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1740668611; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ZgFUlmr6WcP558S1jjl25yNZ/UxRgb8t4jQCSQY55N8=;
	b=DxhGKqdKwxTIqFQatcVqgpPEsImckyG7W7LlInKdXhyhoD32n+yGHoh4oE401kLDFDyvaJ
	um3DSA8aTEhD1WvyAi/LCS4JsFTEOM17F6UTXknzRcVoIuknqnoHWfhb7BuKKxkXoXJv46
	9YeN9nMUvE1gIGalqJ3dwbYJf5Oa1wc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 97BDF13888;
	Thu, 27 Feb 2025 15:03:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1MGPI8N+wGfiAgAAD6G6ig
	(envelope-from <vincenzo.mezzela@suse.com>); Thu, 27 Feb 2025 15:03:31 +0000
From: Vincenzo MEZZELA <vincenzo.mezzela@suse.com>
To: live-patching@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	corbet@lwn.net,
	Vincenzo MEZZELA <vincenzo.mezzela@suse.com>
Subject: [PATCH] docs: livepatch: move text out of code block
Date: Thu, 27 Feb 2025 16:03:28 +0100
Message-ID: <20250227150328.124438-1-vincenzo.mezzela@suse.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DF46A1F457
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:mid,suse.com:email];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

Part of the documentation text is included in the readelf output code
block. Hence, split the code block and move the affected text outside.

Signed-off-by: Vincenzo MEZZELA <vincenzo.mezzela@suse.com>
---
 Documentation/livepatch/module-elf-format.rst | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/Documentation/livepatch/module-elf-format.rst b/Documentation/livepatch/module-elf-format.rst
index a03ed02ec57e..eadcff224335 100644
--- a/Documentation/livepatch/module-elf-format.rst
+++ b/Documentation/livepatch/module-elf-format.rst
@@ -217,16 +217,23 @@ livepatch relocation section refer to their respective symbols with their symbol
 indices, and the original symbol indices (and thus the symtab ordering) must be
 preserved in order for apply_relocate_add() to find the right symbol.
 
-For example, take this particular rela from a livepatch module:::
+For example, take this particular rela from a livepatch module:
+
+::
 
   Relocation section '.klp.rela.btrfs.text.btrfs_feature_attr_show' at offset 0x2ba0 contains 4 entries:
       Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
   000000000000001f  0000005e00000002 R_X86_64_PC32          0000000000000000 .klp.sym.vmlinux.printk,0 - 4
 
-  This rela refers to the symbol '.klp.sym.vmlinux.printk,0', and the symbol index is encoded
-  in 'Info'. Here its symbol index is 0x5e, which is 94 in decimal, which refers to the
-  symbol index 94.
-  And in this patch module's corresponding symbol table, symbol index 94 refers to that very symbol:
+This rela refers to the symbol '.klp.sym.vmlinux.printk,0', and the symbol
+index is encoded in 'Info'. Here its symbol index is 0x5e, which is 94 in
+decimal, which refers to the symbol index 94.
+
+And in this patch module's corresponding symbol table, symbol index 94 refers
+to that very symbol:
+
+::
+
   [ snip ]
   94: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT OS [0xff20] .klp.sym.vmlinux.printk,0
   [ snip ]
-- 
2.48.1


