Return-Path: <live-patching+bounces-519-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CB4F960A53
	for <lists+live-patching@lfdr.de>; Tue, 27 Aug 2024 14:31:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05A9D28399B
	for <lists+live-patching@lfdr.de>; Tue, 27 Aug 2024 12:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E707B1BA865;
	Tue, 27 Aug 2024 12:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="IUbRiB2R";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="V1J/ng/u";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="IUbRiB2R";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="V1J/ng/u"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40E31B8E8D;
	Tue, 27 Aug 2024 12:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724761857; cv=none; b=pdpNF7spsUuL1PwNphuB/0elcwSjZkjhKbR8Bg6vAaKM5N37xtSwOc6Wddj8fjpYfvkNzJemMU//R7S8VjyfMHc5CBrUxzonAisUJDhdhuEm9zsW4WcZS5/ZdUXzpRF29Hz2m0m7ej5OSDHsWy8qNw8jPFRRmheOVASjDYOx6H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724761857; c=relaxed/simple;
	bh=f78axjmUclun1wfP7kwMZNcG2d9SoMClxopFFWHREJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Sz+FdTWTKYNc2DsYMxAJTizxh+IToLsKgHU1Ad26h7vr3piyLRz9iy8V95D0v4cqf2xL99yciWsikXLDg3NOFLQ6v/jnocBJYzvpXeMenfJ768er36OsDzocgBYviNW31bFfRd2QInC12jtccNXPBUcmM97wi36yEfBlu+BJ70o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=IUbRiB2R; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=V1J/ng/u; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=IUbRiB2R; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=V1J/ng/u; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CD37421B13;
	Tue, 27 Aug 2024 12:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1724761853; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=7xeRe7MAoinPXOehDj1oDor3joTDsLsD5OEV3LKTtL4=;
	b=IUbRiB2R60ah/B9UNr9nTUvkDQ/MlMufXyZaCKowZgzJ9MBLfDbJHxhHNeppzOeHXqDSoI
	BuEVSP2h3P/WhzggxO0MCN/rw+RAMCsheNaiWP/CuFx0AbuiS07wQdzqaigb292YsSznDT
	D7E0EG5fJnlQfXXhkFJuxchmD82xSZ4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1724761853;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=7xeRe7MAoinPXOehDj1oDor3joTDsLsD5OEV3LKTtL4=;
	b=V1J/ng/uHiY+L9OJlOAHtbTCJy4Q4vcv47NUJA4Ax4dXuXz+HmEMg4ZapBpQVPbNzZFKIV
	IVFkGpDBAAUUbzBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1724761853; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=7xeRe7MAoinPXOehDj1oDor3joTDsLsD5OEV3LKTtL4=;
	b=IUbRiB2R60ah/B9UNr9nTUvkDQ/MlMufXyZaCKowZgzJ9MBLfDbJHxhHNeppzOeHXqDSoI
	BuEVSP2h3P/WhzggxO0MCN/rw+RAMCsheNaiWP/CuFx0AbuiS07wQdzqaigb292YsSznDT
	D7E0EG5fJnlQfXXhkFJuxchmD82xSZ4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1724761853;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=7xeRe7MAoinPXOehDj1oDor3joTDsLsD5OEV3LKTtL4=;
	b=V1J/ng/uHiY+L9OJlOAHtbTCJy4Q4vcv47NUJA4Ax4dXuXz+HmEMg4ZapBpQVPbNzZFKIV
	IVFkGpDBAAUUbzBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C556F13724;
	Tue, 27 Aug 2024 12:30:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id blURMP3GzWauYwAAD6G6ig
	(envelope-from <lhruska@suse.cz>); Tue, 27 Aug 2024 12:30:53 +0000
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
Subject: [PATCH v3 0/6] livepatch: klp-convert tool - Minimal version
Date: Tue, 27 Aug 2024 14:30:45 +0200
Message-ID: <20240827123052.9002-1-lhruska@suse.cz>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[9];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Level: 

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


Summary of changes in this minimal version v3
------------------------

- klp-convert: symbol format changes (suggested by jlawrence)
- samples: fixed name of added sample in Makefile (suggested by pmladek)
- selftests: added ibt test case as an example (DON'T MERGE)
- fixed all suggested small changes in v2

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
v2 minimal:
  https://lore.kernel.org/r/20240516133009.20224-1-lhruska@suse.cz/

