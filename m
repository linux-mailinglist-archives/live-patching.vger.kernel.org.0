Return-Path: <live-patching+bounces-930-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ED2449F5A35
	for <lists+live-patching@lfdr.de>; Wed, 18 Dec 2024 00:13:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 69A1C172772
	for <lists+live-patching@lfdr.de>; Tue, 17 Dec 2024 23:10:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 554541FA14B;
	Tue, 17 Dec 2024 23:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Jvcd6cZK"
X-Original-To: live-patching@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA6CF1E3DF7;
	Tue, 17 Dec 2024 23:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734477005; cv=none; b=lma6ZnqUPzEpsTOYx28q/BhwEm6zfppMGjB3oDF5OSeJ4A306dMjCVqxCHfJZGyjxS1Y1W0/b8JpFNK11/ELmzVhHOK/d3yBldCRYw7tLUUy1AJpNBZs586cerKlb5MuggL+zad2kPBDycGBvl7krqN33yJzv8rznrrbi6QryZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734477005; c=relaxed/simple;
	bh=Ikti6q6wkhSIMWijXaBshzCvoZ4qQAs2T1Y2rFyC1DU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nr9+5t38BAeLUfNu5QAFeAAfiX08kTH4fxb3p5mKeizt+nFvG3rc7ovTAd1621vziRJ7REJh6a0yI3FEh8BQO5uYTp6Au7iuRlYRXGY1sjFVtLVBRnCLSzSerpwc9wyzAT+lGQdBZIDRRXFMep+57Vv8ehFc/iZ5QzsYl5lvYhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Jvcd6cZK; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from eahariha-devbox.5bhznamrcrmeznzvghz2s0u2eh.xx.internal.cloudapp.net (unknown [40.91.112.99])
	by linux.microsoft.com (Postfix) with ESMTPSA id 61B6123718AC;
	Tue, 17 Dec 2024 15:10:03 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 61B6123718AC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1734477003;
	bh=gxgh/V6SqlPJRY/u4Yw6PpJQ/NxNqx8Lk7oQJkApKsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jvcd6cZK3BfVGmdocD9lczUpUcLEPzr4X5nC3KtBx20nfJCcY+U9L7julY9xCwZam
	 r4Aes5nhWDq5Nzug66gQjboQah1+r35R2LZYnNJi89EcmrF0SU5u/MsOU3JJu/WPrN
	 7mTUH7PxbMjxbgpR5jF+KdAXgQbTD9w5Iaq/+16g=
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
Subject: [PATCH v4 1/2] s390: kernel: Convert timeouts to use secs_to_jiffies()
Date: Tue, 17 Dec 2024 23:09:58 +0000
Message-ID: <20241217231000.228677-2-eahariha@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241217231000.228677-1-eahariha@linux.microsoft.com>
References: <20241217231000.228677-1-eahariha@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit b35108a51cf7 ("jiffies: Define secs_to_jiffies()") introduced
secs_to_jiffies(). As the values here are a multiple of 1000, use
secs_to_jiffies() instead of msecs_to_jiffies to avoid the multiplication.

This is converted using scripts/coccinelle/misc/secs_to_jiffies.cocci with
the following Coccinelle rules:

@@ constant C; @@

- msecs_to_jiffies(C * 1000)
+ secs_to_jiffies(C)

@@ constant C; @@

- msecs_to_jiffies(C * MSEC_PER_SEC)
+ secs_to_jiffies(C)

While here, manually convert the one other remaining instance as
requested.

Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
---
 arch/s390/kernel/lgr.c      | 2 +-
 arch/s390/kernel/time.c     | 4 ++--
 arch/s390/kernel/topology.c | 2 +-
 arch/s390/mm/cmm.c          | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kernel/lgr.c b/arch/s390/kernel/lgr.c
index 6652e54cf3db..6d1ffca5f798 100644
--- a/arch/s390/kernel/lgr.c
+++ b/arch/s390/kernel/lgr.c
@@ -166,7 +166,7 @@ static struct timer_list lgr_timer;
  */
 static void lgr_timer_set(void)
 {
-	mod_timer(&lgr_timer, jiffies + msecs_to_jiffies(LGR_TIMER_INTERVAL_SECS * MSEC_PER_SEC));
+	mod_timer(&lgr_timer, jiffies + secs_to_jiffies(LGR_TIMER_INTERVAL_SECS));
 }
 
 /*
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index 34a65c141ea0..e9f47c3a6197 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -662,12 +662,12 @@ static void stp_check_leap(void)
 		if (ret < 0)
 			pr_err("failed to set leap second flags\n");
 		/* arm Timer to clear leap second flags */
-		mod_timer(&stp_timer, jiffies + msecs_to_jiffies(14400 * MSEC_PER_SEC));
+		mod_timer(&stp_timer, jiffies + secs_to_jiffies(14400));
 	} else {
 		/* The day the leap second is scheduled for hasn't been reached. Retry
 		 * in one hour.
 		 */
-		mod_timer(&stp_timer, jiffies + msecs_to_jiffies(3600 * MSEC_PER_SEC));
+		mod_timer(&stp_timer, jiffies + secs_to_jiffies(3600));
 	}
 }
 
diff --git a/arch/s390/kernel/topology.c b/arch/s390/kernel/topology.c
index 4f9c301a705b..0fd56a1cadbd 100644
--- a/arch/s390/kernel/topology.c
+++ b/arch/s390/kernel/topology.c
@@ -371,7 +371,7 @@ static void set_topology_timer(void)
 	if (atomic_add_unless(&topology_poll, -1, 0))
 		mod_timer(&topology_timer, jiffies + msecs_to_jiffies(100));
 	else
-		mod_timer(&topology_timer, jiffies + msecs_to_jiffies(60 * MSEC_PER_SEC));
+		mod_timer(&topology_timer, jiffies + secs_to_jiffies(60));
 }
 
 void topology_expect_change(void)
diff --git a/arch/s390/mm/cmm.c b/arch/s390/mm/cmm.c
index d01724a715d0..7bf0f691827b 100644
--- a/arch/s390/mm/cmm.c
+++ b/arch/s390/mm/cmm.c
@@ -204,7 +204,7 @@ static void cmm_set_timer(void)
 			del_timer(&cmm_timer);
 		return;
 	}
-	mod_timer(&cmm_timer, jiffies + msecs_to_jiffies(cmm_timeout_seconds * MSEC_PER_SEC));
+	mod_timer(&cmm_timer, jiffies + secs_to_jiffies(cmm_timeout_seconds));
 }
 
 static void cmm_timer_fn(struct timer_list *unused)
-- 
2.43.0


