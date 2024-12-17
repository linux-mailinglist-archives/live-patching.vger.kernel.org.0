Return-Path: <live-patching+bounces-931-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F16A9F5A37
	for <lists+live-patching@lfdr.de>; Wed, 18 Dec 2024 00:13:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9EDAA1727B8
	for <lists+live-patching@lfdr.de>; Tue, 17 Dec 2024 23:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 752941FA179;
	Tue, 17 Dec 2024 23:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="iwdwlmJW"
X-Original-To: live-patching@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E03E01EBA07;
	Tue, 17 Dec 2024 23:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734477005; cv=none; b=sVpjeOBbOerZEzrufDmzbb2QKfYf988Zy6HqDSiOKU8POA72muKu+JucxYLFh6uOx+s8d5xfJk65OFGIDZ/jIc6YRKr4GfdrbMr+KaWGFMonzyMPj/kzvzDBAHrZcWc0f6F12DVNRoWSzHkvKEatDr+yoJqAvzWG7tuTHsT9slo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734477005; c=relaxed/simple;
	bh=ZA5Vo3QaMUoEv0CB2a2TWNZh5CmOBLwYO51ucHEYKsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFDLZuK+RU6N18btabn9kcoH+saHvpqiEVu77A5feqibcvXGSrPuU7SpX/1hvfOhYerdMCX+ZqD8xHiOgTRHg80J9/IJmq1DL2zTMHJj26KETY52Z6S06l7sBbjZR79Yub72Km7PWEfLOxkLgGUuabV8m0wTQ7u7mZZAod6aFO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=iwdwlmJW; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from eahariha-devbox.5bhznamrcrmeznzvghz2s0u2eh.xx.internal.cloudapp.net (unknown [40.91.112.99])
	by linux.microsoft.com (Postfix) with ESMTPSA id 7D995238AF4D;
	Tue, 17 Dec 2024 15:10:03 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7D995238AF4D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1734477003;
	bh=WocG0qxvmHcCOlpFOfTVCHfuoVdDuRdRUMu/Tae06EM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iwdwlmJW9qmIm61ZFLg+K9NF/W/Mf3IGZ6u1kM2LvNovgglyn7uykJyWC/0cHnKMH
	 xOrih05Dx8L3HtDpwfM4vZgdNtAl3SgdVOv38G2x7Isnx+P2YgIE4vMKZn1M06l9qn
	 +o/yu0kCeChISYvXyWEyyLC8bkIpZLAUQnQRVGYg=
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
Subject: [PATCH v4 2/2] livepatch: Convert timeouts to secs_to_jiffies()
Date: Tue, 17 Dec 2024 23:09:59 +0000
Message-ID: <20241217231000.228677-3-eahariha@linux.microsoft.com>
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
secs_to_jiffies(). As the value here is a multiple of 1000, use
secs_to_jiffies() instead of msecs_to_jiffies to avoid the multiplication.

This is converted using scripts/coccinelle/misc/secs_to_jiffies.cocci with
the following Coccinelle rules:

@@ constant C; @@

- msecs_to_jiffies(C * 1000)
+ secs_to_jiffies(C)

@@ constant C; @@

- msecs_to_jiffies(C * MSEC_PER_SEC)
+ secs_to_jiffies(C)

While here, replace the schedule_delayed_work() call with a 0 timeout
with an immediate schedule_work() call.

Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
---
 samples/livepatch/livepatch-callbacks-busymod.c |  3 +--
 samples/livepatch/livepatch-shadow-fix1.c       |  3 +--
 samples/livepatch/livepatch-shadow-mod.c        | 15 +++++----------
 3 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/samples/livepatch/livepatch-callbacks-busymod.c b/samples/livepatch/livepatch-callbacks-busymod.c
index 378e2d40271a..0220f7715fcc 100644
--- a/samples/livepatch/livepatch-callbacks-busymod.c
+++ b/samples/livepatch/livepatch-callbacks-busymod.c
@@ -44,8 +44,7 @@ static void busymod_work_func(struct work_struct *work)
 static int livepatch_callbacks_mod_init(void)
 {
 	pr_info("%s\n", __func__);
-	schedule_delayed_work(&work,
-		msecs_to_jiffies(1000 * 0));
+	schedule_work(&work);
 	return 0;
 }
 
diff --git a/samples/livepatch/livepatch-shadow-fix1.c b/samples/livepatch/livepatch-shadow-fix1.c
index 6701641bf12d..f3f153895d6c 100644
--- a/samples/livepatch/livepatch-shadow-fix1.c
+++ b/samples/livepatch/livepatch-shadow-fix1.c
@@ -72,8 +72,7 @@ static struct dummy *livepatch_fix1_dummy_alloc(void)
 	if (!d)
 		return NULL;
 
-	d->jiffies_expire = jiffies +
-		msecs_to_jiffies(1000 * EXPIRE_PERIOD);
+	d->jiffies_expire = jiffies + secs_to_jiffies(EXPIRE_PERIOD);
 
 	/*
 	 * Patch: save the extra memory location into a SV_LEAK shadow
diff --git a/samples/livepatch/livepatch-shadow-mod.c b/samples/livepatch/livepatch-shadow-mod.c
index 7e753b0d2fa6..5d83ad5a8118 100644
--- a/samples/livepatch/livepatch-shadow-mod.c
+++ b/samples/livepatch/livepatch-shadow-mod.c
@@ -101,8 +101,7 @@ static __used noinline struct dummy *dummy_alloc(void)
 	if (!d)
 		return NULL;
 
-	d->jiffies_expire = jiffies +
-		msecs_to_jiffies(1000 * EXPIRE_PERIOD);
+	d->jiffies_expire = jiffies + secs_to_jiffies(EXPIRE_PERIOD);
 
 	/* Oops, forgot to save leak! */
 	leak = kzalloc(sizeof(*leak), GFP_KERNEL);
@@ -152,8 +151,7 @@ static void alloc_work_func(struct work_struct *work)
 	list_add(&d->list, &dummy_list);
 	mutex_unlock(&dummy_list_mutex);
 
-	schedule_delayed_work(&alloc_dwork,
-		msecs_to_jiffies(1000 * ALLOC_PERIOD));
+	schedule_delayed_work(&alloc_dwork, secs_to_jiffies(ALLOC_PERIOD));
 }
 
 /*
@@ -184,16 +182,13 @@ static void cleanup_work_func(struct work_struct *work)
 	}
 	mutex_unlock(&dummy_list_mutex);
 
-	schedule_delayed_work(&cleanup_dwork,
-		msecs_to_jiffies(1000 * CLEANUP_PERIOD));
+	schedule_delayed_work(&cleanup_dwork, secs_to_jiffies(CLEANUP_PERIOD));
 }
 
 static int livepatch_shadow_mod_init(void)
 {
-	schedule_delayed_work(&alloc_dwork,
-		msecs_to_jiffies(1000 * ALLOC_PERIOD));
-	schedule_delayed_work(&cleanup_dwork,
-		msecs_to_jiffies(1000 * CLEANUP_PERIOD));
+	schedule_delayed_work(&alloc_dwork, secs_to_jiffies(ALLOC_PERIOD));
+	schedule_delayed_work(&cleanup_dwork, secs_to_jiffies(CLEANUP_PERIOD));
 
 	return 0;
 }
-- 
2.43.0


