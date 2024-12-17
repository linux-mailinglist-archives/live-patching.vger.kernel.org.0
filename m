Return-Path: <live-patching+bounces-929-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 139129F5A29
	for <lists+live-patching@lfdr.de>; Wed, 18 Dec 2024 00:11:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A02D87A384C
	for <lists+live-patching@lfdr.de>; Tue, 17 Dec 2024 23:10:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E5E21F9F77;
	Tue, 17 Dec 2024 23:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Dl3xkQko"
X-Original-To: live-patching@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA6721D45FC;
	Tue, 17 Dec 2024 23:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734477005; cv=none; b=ZIIpXkFty7FxuGhHoENXmuz2/G3xRtnzSkrf/h9aSQOqVOLWNEqhw0XZeQVJOQS5WFOmuX9bS1KmSI+fGMcDPQaSVVeSs6BXwiiUaGU2xgdI9cdBwHK0eQ5Kz8jNRVxSRpPJq8QpSf1sJj6vKVYkWs9b06kzAe9wtWUDGp5fbfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734477005; c=relaxed/simple;
	bh=ao390XD76wzW3yvt0PKxjKOKWAWQlVD+QXi2uJgMCjM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VRAqQrlkw4sg+hgI8b1qAOla1owdrNfsTOgoVec51TVLp4Aze0U9vs3Xg3mOrhdbyN9MPyMFzLwiOGeCElf3fbrkNnb8CLoOAeYLsdmj9xoYn65QN4tgFnZbFn++aAwqZiSkvOFYuq6npBs+I66RYr/ln9KqYj+ByYCtWlNw3GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Dl3xkQko; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from eahariha-devbox.5bhznamrcrmeznzvghz2s0u2eh.xx.internal.cloudapp.net (unknown [40.91.112.99])
	by linux.microsoft.com (Postfix) with ESMTPSA id 42C2B2171F9D;
	Tue, 17 Dec 2024 15:10:03 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 42C2B2171F9D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1734477003;
	bh=3kWxC7n8ntl4vUFiPWiw1VP4WXU+6lJ19vBVQZNZeXM=;
	h=From:To:Cc:Subject:Date:From;
	b=Dl3xkQko0wHtWWmiqmGuhft4Q+Y3Yf2vMiq6XHx4nGI78q8eb8Zw5YRESaKjZkl5s
	 LWCIhIUlPuKvTtUY1tB3VmK5n0PoGq5kgKF+iEyR0yELdhHV9hfKNIAMyS+b1tJUaX
	 vE/TRn+NGo/NeJoAsafMvHHALKYNSJ18PfxTeXuA=
From: Easwar Hariharan <eahariha@linux.microsoft.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>
Cc: linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Easwar Hariharan <eahariha@linux.microsoft.com>
Subject: [PATCH v4 0/2] Converge on using secs_to_jiffies()
Date: Tue, 17 Dec 2024 23:09:57 +0000
Message-ID: <20241217231000.228677-1-eahariha@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixups for a couple of patches that received review after the series was
queued into mm.

Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
---
Changes in v4:
- Replace schedule_delayed_work() that had a 0 timeout with
  schedule_work() in livepatch (Christophe Leroy)
- Added requested hunk in s390 (Alexander Gordeev)
- Link to v3: https://lore.kernel.org/r/20241210-converge-secs-to-jiffies-v3-0-ddfefd7e9f2a@linux.microsoft.com
Changes in v3:
- Rebase on next-20241210
- Fix typo'ed timeout in net/netfilter/nf_conntrack_proto_sctp.c (Stephen Rothwell)
- Use Coccinelle operation modes for Coccinelle script (Markus Elfring)
- Remove redundant comments in arch/arm/mach-pxa/sharpsl_pm.c (Christophe Leroy)
- Remove excess line breaks (Heiko Carstens, Christophe Leroy)
- Add more detail into the commit messages throughout (Christophe Leroy)
- Pick up Reviewed-by Thomas Hellstrom for drm/xe
- Drop drm/etnaviv patch already queued into etnaviv/next
- Replace call to [m]secs_to_jiffies(0) with just 0 for livepatch (Dan Carpenter, Christophe Leroy)
- Split out nfp patch to send to net-next (Christophe Leroy)
- Pick up Acked-by from Jeff Johnson for ath11k
- Link to v2: https://lore.kernel.org/r/20241115-converge-secs-to-jiffies-v2-0-911fb7595e79@linux.microsoft.com
Changes in v2:
- Exclude already accepted patch adding secs_to_jiffies() https://git.kernel.org/tip/b35108a51cf7bab58d7eace1267d7965978bcdb8
- Link to v1: https://lore.kernel.org/r/20241115-converge-secs-to-jiffies-v1-0-19aadc34941b@linux.microsoft.com

Easwar Hariharan (2):
  s390: kernel: Convert timeouts to use secs_to_jiffies()
  livepatch: Convert timeouts to secs_to_jiffies()

 arch/s390/kernel/lgr.c                          |  2 +-
 arch/s390/kernel/time.c                         |  4 ++--
 arch/s390/kernel/topology.c                     |  2 +-
 arch/s390/mm/cmm.c                              |  2 +-
 samples/livepatch/livepatch-callbacks-busymod.c |  3 +--
 samples/livepatch/livepatch-shadow-fix1.c       |  3 +--
 samples/livepatch/livepatch-shadow-mod.c        | 15 +++++----------
 7 files changed, 12 insertions(+), 19 deletions(-)

-- 
2.43.0


