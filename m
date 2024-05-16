Return-Path: <live-patching+bounces-266-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EAF228C779D
	for <lists+live-patching@lfdr.de>; Thu, 16 May 2024 15:30:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A3E9BB20E8D
	for <lists+live-patching@lfdr.de>; Thu, 16 May 2024 13:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34B131474B4;
	Thu, 16 May 2024 13:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ekOk+g49";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="jKSPxtxQ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vj+lMX7G";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="trPUhBgs"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B34C1482E0;
	Thu, 16 May 2024 13:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715866226; cv=none; b=FNOmWxY5jkm2jJYOVw9+/0npISDzS+YQPpXZSFQnMxbO++AEXCfDRTRftN719CsU1gBDTpIFMR113lrMxCn4AAAoA9Uas477D7XjW7Lt/LngaRK+I5Ip9nqb+TFMB6yW/OVDlQLyAKXG8Hzea6UnBgc3p864vw+BpAyRg0df6Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715866226; c=relaxed/simple;
	bh=wEVpxd09aFmKjuI3dDVx5l3bQ3x5w1RA7fwb1G1AxV0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M9gaQpYYnXV2XNR/dbIPQaE/HaTxyDG8nhS0Bp/2ZRs3IvvJzvLQVvMRA79B3DKPP5TgBVq9DwQSHOVET4SJkaCfU5mfHGZdZ/NafoQe8f05Ppwyg+gAmBQxcaQUWBXUUco/KAw/vvB+KdxsnEBjqcVQ4lsI+tleRBW+85UbL/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ekOk+g49; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=jKSPxtxQ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vj+lMX7G; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=trPUhBgs; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EA572349E4;
	Thu, 16 May 2024 13:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1715866222; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=SD52y9nA0QzKEwzGE40KRitU2ogD463y5a2LcORhPUs=;
	b=ekOk+g49WJPFNTSCALqGDtxSk2CyQ4srVYffYDje8s4tKMxshQuX1UT6jvoaZHG/8udiHc
	yKyX/+vZwuFz40kDIiLe9SB8eeU7QeU8umI6lW6KS/QwY969kxE1HWc95beefrL//XNgGN
	rjF5ysHmzpEHfm2jkeX9t6YOM0DO8uM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1715866222;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=SD52y9nA0QzKEwzGE40KRitU2ogD463y5a2LcORhPUs=;
	b=jKSPxtxQVl5rsM+JXK26yFu9X1ENAnw3qe0GObgdE7fJ/R4djfoj02RDLlYlMRxZmnW7JO
	KS08BpHbcbV1pgDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1715866221; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=SD52y9nA0QzKEwzGE40KRitU2ogD463y5a2LcORhPUs=;
	b=vj+lMX7G64of6AI4QH8a+jQeamRmYP1JTG95rKmghac2JrXrVEtYKsL1/m8MB4ES67hoaY
	UFHjPB85Xwn27i+a6+M/ifu78V9qeyi1fNC6/YE4Ah9NTYc8UcgtjkOB0ihjILyeWESk6S
	htE4GiAATiVZIk6KjctuHph8gw4csGo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1715866221;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=SD52y9nA0QzKEwzGE40KRitU2ogD463y5a2LcORhPUs=;
	b=trPUhBgsPqp5oFDPiAtcM3WWtrjfFGfcGLPWh91mpIW2h/IePYZQPm6fQMPXdO7r7PO7/s
	wht8ePydcZMyeCCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D828313A69;
	Thu, 16 May 2024 13:30:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lyvDM20KRmY+BwAAD6G6ig
	(envelope-from <lhruska@suse.cz>); Thu, 16 May 2024 13:30:21 +0000
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
Subject: [PATCH v2 0/5] livepatch: klp-convert tool - Minimal version
Date: Thu, 16 May 2024 15:30:03 +0200
Message-ID: <20240516133009.20224-1-lhruska@suse.cz>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[9];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -2.80
X-Spam-Flag: NO

Summary
-------

This is a significantly simplified version of the original klp-convert tool.
The klp-convert code has never got a proper review and also clean ups
were not easy. The last version was v7, see
https://lore.kernel.org/r/20230306140824.3858543-1-joe.lawrence@redhat.com

The main change is that the tool does not longer search for the
symbols which would need the livepatch specific relocation entry.
Also klp.symbols file is not longer needed.

Instead, the needed information is appended to the symbol declaration
via a new macro KLP_RELOC_SYMBOL(). It creates symbol with all needed
metadata. For example:

  extern char *saved_command_line \
                 KLP_RELOC_SYMBOL(vmlinux, vmlinux, saved_command_line, 0);

would create symbol

$>readelf -r -W <compiled livepatch module>:
Relocation section '.rela.text' at offset 0x32e60 contains 10 entries:
    Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
[...]
0000000000000068  0000003c00000002 R_X86_64_PC32          0000000000000000 .klp.sym.rela.vmlinux.vmlinux.saved_command_line,0 - 4
[...]


The simplified klp-convert tool just transforms symbols
created by KLP_RELOC_SYMBOL() to object specific rela sections
and rela entries which would later be proceed when the livepatch
or the livepatched object is loaded.

For example, klp-convert would replace the above symbols with:

$> readelf -r -W <livepatch_module_proceed_by_klp_convert>
Relocation section '.klp.rela.vmlinux.text' at offset 0x5cb60 contains 1 entry:
    Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
0000000000000068  0000003c00000002 R_X86_64_PC32          0000000000000000 .klp.sym.vmlinux.saved_command_line,0 - 4


Note that similar macro was needed also in the original version
to handle more symbols of the same name (sympos).

Given the above, add klp-convert tool; integrate klp-convert tool into
kbuild; add data-structure and macros to enable users to annotate
livepatch source code; make modpost stage compatible with livepatches;
update livepatch-sample and update documentation.


Testing
-------

The patchset selftests build and execute on x86_64, s390x, and ppc64le
for both default config (with added livepatch dependencies) and a larger
SLE-15-ish config.


Summary of changes in this minimal version v2
------------------------

- rebase for v6.9
- cleaned-up SoB chains (suggested by pmladek)
- klp-convert: remove the symbol map auto-resolving solution
- klp-convert: add macro for flagging variables inside a LP src to be resolved by this tool
- klp-convert: code simplification
- selftests: add selftest livepatching function using an external symbol

Previous versions
-----------------

RFC:
  https://lore.kernel.org/r/cover.1477578530.git.jpoimboe@redhat.com/
v2:
  https://lore.kernel.org/r/f52d29f7-7d1b-ad3d-050b-a9fa8878faf2@redhat.com/
v3:
  https://lore.kernel.org/r/20190410155058.9437-1-joe.lawrence@redhat.com/
v4:
  https://lore.kernel.org/r/20190509143859.9050-1-joe.lawrence@redhat.com/
v5:
  (not posted)
  https://github.com/joe-lawrence/klp-convert-tree/tree/klp-convert-v5-devel
v6:
  https://lore.kernel.org/r/20220216163940.228309-1-joe.lawrence@redhat.com/
v7:
  https://lore.kernel.org/r/20230306140824.3858543-1-joe.lawrence@redhat.com/
v1 minimal:
  https://lore.kernel.org/r/20231106162513.17556-1-lhruska@suse.cz/

