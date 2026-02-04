Return-Path: <live-patching+bounces-1977-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WCmQNEq0gmnwYgMAu9opvQ
	(envelope-from <live-patching+bounces-1977-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 04 Feb 2026 03:51:54 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EC37E0FE4
	for <lists+live-patching@lfdr.de>; Wed, 04 Feb 2026 03:51:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B6A5C300B457
	for <lists+live-patching@lfdr.de>; Wed,  4 Feb 2026 02:51:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81FDA237A4F;
	Wed,  4 Feb 2026 02:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BBznyzjB"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267C17082D
	for <live-patching@vger.kernel.org>; Wed,  4 Feb 2026 02:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770173510; cv=none; b=W/XP8Ek/YmiHeTA6WIyePkH2TYTmD6Gd1dE7ughaSCS0S9av4CvPxGa7hgccOBAGZRwehUKcoSqPvFv/3iwNqLvsKO96OZCxvowsw0ndjIXR/n0984fgh3m/QWzktqm8Dhp0dOdGinHltKTnRGRGVj2pnBqyzWyuyn7pCDqxF5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770173510; c=relaxed/simple;
	bh=Ga0Q+bOgEeD4IlE0HBq8Bt55RYFbrR0cBlFUhtHPnmM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-type; b=n6TM6zYPtcY608V3ASNGiLJgZzrVcTOA73oTF5muApfN6bDXm2g4NmUKZNmRKsskm4d9nUwAz6/9pwce20ls91jrXXhN6SerkHAs2/LmWh/OFc9GTkMR/ZaqqhxlwlLw8nYDtgcVBAktPCtN5iS+ohGXgyZUnVOqh7SFtwolWwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BBznyzjB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770173508;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=A0QBcoyiu2wYglTGwkDImA30JCJQGRIlWrmwZeuhYNY=;
	b=BBznyzjBgajh4nal/oHlyOxpC7oxc/G5LscIz8D8pfrFeTsGlDWXz9nFkIWxKcrIXuIWQV
	mtutPZarEdHBh53aYMh5cdIkwsGKhBXuuojzoZo7GCAIhlGqZi0zoN+bCUW8qU9Qe1jIRY
	zX37c82tuEaXgqpXISzObKsWttmdTDs=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-618-8aE-ANbPMeukxBuICwOVVg-1; Tue,
 03 Feb 2026 21:51:46 -0500
X-MC-Unique: 8aE-ANbPMeukxBuICwOVVg-1
X-Mimecast-MFC-AGG-ID: 8aE-ANbPMeukxBuICwOVVg_1770173505
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9083D1800447;
	Wed,  4 Feb 2026 02:51:45 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.80.42])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 08CF7180094B;
	Wed,  4 Feb 2026 02:51:43 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 0/5] livepatch-klp-build: small fixups and enhancements 
Date: Tue,  3 Feb 2026 21:51:35 -0500
Message-ID: <20260204025140.2023382-1-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	SUBJECT_ENDS_SPACES(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-1977-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0EC37E0FE4
X-Rspamd-Action: no action

Here is v2, a quick iteration on v1 posted lasted week.  I expect some
comments on verbosity and some code stylings, so fully expect to roll at
least another version.

See also some per-patch inline diffstat area commentary.

v2:

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

Joe Lawrence (5):
  objtool/klp: Fix mkstemp() failure with long paths
  livepatch/klp-build: handle patches that add/remove files
  livepatch/klp-build: switch to GNU patch and recountdiff
  livepatch/klp-build: minor short-circuiting tweaks
  livepatch/klp-build: provide friendlier error messages

 scripts/livepatch/klp-build | 92 ++++++++++++++++++++-----------------
 tools/objtool/elf.c         | 10 +++-
 2 files changed, 58 insertions(+), 44 deletions(-)

-- 
2.52.0


