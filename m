Return-Path: <live-patching+bounces-2015-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qA9PAyOSlGl3FgIAu9opvQ
	(envelope-from <live-patching+bounces-2015-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 17:06:59 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6995314DDD9
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 17:06:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3232730107C5
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 16:06:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DB772010EE;
	Tue, 17 Feb 2026 16:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FMUAueaE"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFAB18C2C
	for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 16:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771344415; cv=none; b=MTLDCDxZO98g8aEBew5+1z30k+o3eiW2LEclp4eQUrvnFleSEv4ikc02k7TEfiDjPBJv0nk6kK/Q/q5XANlZaBi9v78dOSWr0ir4nOoLD/N1T7Q7bdVnLnLRyPqGCIR1dfKg3GpGcSZ+JcI53r2ftjeIhXisEnD2X8B5mtD+Bl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771344415; c=relaxed/simple;
	bh=LpWb6+WIQq72UZybJ8E61xuiyN6i+Vc4MtHUki7mCMg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-type; b=f0yBldwrXUuwuKSQ1LAEK9CpNVpEBpfIEy8pvpq5w+o2V05XNvCUO4IEA/X0nNJhAP1eL2KhS/A70lXWytu04zH0etvRlFHXbUH7g8JnGk7uxPaxu5SSlje1tG5LaHDC87Mcb9s+hCZBEl62YJa6AB3l0d0MxjqErNrdE17dtIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FMUAueaE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771344413;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XWNzajvmDWQ7fHrkhyL1II/CK62vHPBKS57h2+1gwzI=;
	b=FMUAueaET4KCP8nC4OJsW7bsQHKQed4OSzcus09l5Mr/cWU9msTZbw7ytJBpbqZ8Am3PGE
	rxVkUsqBOn5IiJTHsX0YRJnW66A5e/XjChyOmOI5G+I0bGsl4mWuOOiQcrdwv425vf/u5W
	pL7aLkN6EcDptj9cUOjtBFqhOjyUPsw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-79-pVh3L50mNmu6k-lPdjmI7g-1; Tue,
 17 Feb 2026 11:06:51 -0500
X-MC-Unique: pVh3L50mNmu6k-lPdjmI7g-1
X-Mimecast-MFC-AGG-ID: pVh3L50mNmu6k-lPdjmI7g_1771344410
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 069631955F1F;
	Tue, 17 Feb 2026 16:06:50 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.80.197])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A252230001B9;
	Tue, 17 Feb 2026 16:06:48 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v3 00/13] livepatch-klp-build: small fixups and enhancements
Date: Tue, 17 Feb 2026 11:06:31 -0500
Message-ID: <20260217160645.3434685-1-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2015-lists,live-patching=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCVD_COUNT_FIVE(0.00)[6];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6995314DDD9
X-Rspamd-Action: no action

Here is v3, addressing review feedback from the v2 thread as well as
finding a few more things along the way.

I'll reply to specific patches with more details on new bugs/behavior.
I've ordered the patchset IMHO order of importance, fixing bugs then
moving on to enhancements.

v3:

- Added a patch to objtool ELF code to fix packed string section alignment
- Simplified the mkstemp() patch and surrounding code [Josh]
- Added patches to catch grep use, add Makefile shellcheck, and fix
  current shellcheck warnings [Josh]
- Simplified the short-circuit validation patch [Josh]
- Added a patch to fix short-circuit version mismatch
- Pretty-print output in color [Josh]
- Reduce 'patch' chatter to fuzz/offset warning during patch validation
- Prune tools/ from paths that find_objects() looks for changed objects

v2: https://lore.kernel.org/live-patching/20260204025140.2023382-1-joe.lawrence@redhat.com/

- Update patch subject prefixes accordingly [Josh]
- Added a small objtool/klp patch.  Test systems setup crazy long
  pathnames :D
- Removed patch ("limit parent .git directory search") as this version
  replaces the use of git apply --recount with patch and recountdiff.
  A side effect of this simplification was no longer needing this weird
  hack. [Josh]
- Updated the patch that handles input patches that add files to also
  support removing files, implement this by directly inspecting the
  .patch  +++ and --- header lines via two file lists [Josh]
- Implement two short-circuiting updates: validate patches for steps 1
  and 2, and allow the user to omit patches for steps 3 and 4.  This
  combines the original 'fail-fast' patch and some related notes on the
  v1 thread. [Josh]
- Since v2 replaces git apply with patch and recountdiff, there is no
  need for a -z/--fuzz argument, it comes with GNU patch for free.

v1: https://lore.kernel.org/live-patching/CAPhsuW5qrueccM123YbTo2ZvP-Rf+0UT-goG6c5A8gXw7BsF3w@mail.gmail.com/T/#t

Joe Lawrence (13):
  objtool/klp: honor SHF_MERGE entry alignment in elf_add_data()
  objtool/klp: fix mkstemp() failure with long paths
  livepatch/klp-build: support patches that add/remove files
  livepatch/klp-build: switch to GNU patch and recountdiff
  livepatch/klp-build: add grep-override function
  livepatch/klp-build: add Makefile with check target
  livepatch/klp-build: fix shellcheck complaints
  livepatch/klp-build: improve short-circuit validation
  livepatch/klp-build: fix version mismatch when short-circuiting
  livepatch/klp-build: provide friendlier error messages
  livepatch/klp-build: add terminal color output
  livepatch/klp-build: report patch validation drift
  livepatch/klp-build: don't look for changed objects in tools/

 scripts/livepatch/Makefile  |  20 +++++
 scripts/livepatch/klp-build | 142 ++++++++++++++++++++++--------------
 tools/objtool/elf.c         |  25 +------
 3 files changed, 110 insertions(+), 77 deletions(-)
 create mode 100644 scripts/livepatch/Makefile

-- Joe

-- 
2.53.0


