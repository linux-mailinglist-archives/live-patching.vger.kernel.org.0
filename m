Return-Path: <live-patching+bounces-2168-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OFoBMC2BsGmwjwIAu9opvQ
	(envelope-from <live-patching+bounces-2168-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 21:38:05 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A31C257EE6
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 21:38:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 113E730A24F2
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 20:38:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6190D36896E;
	Tue, 10 Mar 2026 20:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fizxchsH"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A27368953
	for <live-patching@vger.kernel.org>; Tue, 10 Mar 2026 20:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773175082; cv=none; b=h82cjnvADXVI/OEoodYwixbFqpYHwgleBZKvlUcdERFGRW7NbeUA2KaJDao7c0OOZiwO5aOE++cHIXSqd5JIMI1zASO877xVsxtR8MwC08jJhVBEH11lTFp/k62YKH5/Q0QeFk4GVRqqChgqiC+GLFdvrqC/IdTUROYPZTyd0EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773175082; c=relaxed/simple;
	bh=xV6ZKAzWaCSDnzgTVwgqb1ffT463Al2RDb6SPaS4jAU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-type; b=oNfj/ymyFfx0wVRu7sXEeeGRHTfSZsTFpN1X4bUGKjNIgp8eykUCgBCpkX5WL9/w7U4WHKwssxKgmcJVce5BT9z/8HdEYVagOOFaE07SI6zJ1POGYODEpfJ/CxX1y79tM0N1QrVxJHuOtkMQt1egXsS2jUrMAZCr7+e6JzB3L1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fizxchsH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773175079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ywjf0DPglU3jokPImtKRlBZUhu3DhfVa0Yx0sBdmbN0=;
	b=fizxchsHAKSbjtVU4b+DCYMEuWLfVWHoFsNYQVrqp70qMXyOxUTI9x+vlHxCwEZLkgniMT
	8Ay220RYB3UGU5+muIr0l1DG/jmBTmZmf3Mphq6ZI0OVuL/bd6MCrO+6e3DqDN344RtU6n
	jBBpCwEBurpa/QMOjkfPs/BxQTVLvmI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-372-DriuSFouOkGPMyuOzmPv1w-1; Tue,
 10 Mar 2026 16:37:56 -0400
X-MC-Unique: DriuSFouOkGPMyuOzmPv1w-1
X-Mimecast-MFC-AGG-ID: DriuSFouOkGPMyuOzmPv1w_1773175075
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6A3F21800561;
	Tue, 10 Mar 2026 20:37:55 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.80.5])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id ED14419560A6;
	Tue, 10 Mar 2026 20:37:53 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v4 00/12] livepatch-klp-build: small fixups and enhancements
Date: Tue, 10 Mar 2026 16:37:39 -0400
Message-ID: <20260310203751.1479229-1-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Queue-Id: 3A31C257EE6
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
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2168-lists,live-patching=lfdr.de];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

v4:

- Rebased on 9a73f085dc91 (tip/objtool/urgent)
- Dropped elf_add_data() fix, added __clone_symbol() align fix [Josh]
- Adopted Josh's kernel version fix [Josh]
- Updated friendly msg, "foo.patch: unsupported patch to bar.c" [Josh]
- s/warn:/warning:/, trap_err -> die, and commit msg clarification on
  colorization commit [Josh]
- Use "fuzz" instead of "drift", adjust output ordering, and send patch
  cmd errors to stderr [Josh]
- Dropped ("livepatch/klp-build: don't look for changed objects in
  tools/") for now
- Added Song's Acks [Song]

v3: https://lore.kernel.org/live-patching/20260217160645.3434685-1-joe.lawrence@redhat.com/T/#t

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

Joe Lawrence (11):
  objtool/klp: fix data alignment in __clone_symbol()
  objtool/klp: fix mkstemp() failure with long paths
  livepatch/klp-build: support patches that add/remove files
  livepatch/klp-build: switch to GNU patch and recountdiff
  livepatch/klp-build: add grep-override function
  livepatch/klp-build: add Makefile with check target
  livepatch/klp-build: fix shellcheck complaints
  livepatch/klp-build: improve short-circuit validation
  livepatch/klp-build: provide friendlier error messages
  livepatch/klp-build: add terminal color output
  livepatch/klp-build: report patch validation fuzz

Josh Poimboeuf (1):
  livepatch/klp-build: Fix inconsistent kernel version

 scripts/livepatch/Makefile  |  20 ++++++
 scripts/livepatch/klp-build | 140 ++++++++++++++++++++----------------
 tools/objtool/elf.c         |  23 +-----
 tools/objtool/klp-diff.c    |   3 +-
 4 files changed, 105 insertions(+), 81 deletions(-)
 create mode 100644 scripts/livepatch/Makefile

-- 
2.53.0


