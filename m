Return-Path: <live-patching+bounces-1854-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BA40EC56025
	for <lists+live-patching@lfdr.de>; Thu, 13 Nov 2025 08:09:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C12D13B97E0
	for <lists+live-patching@lfdr.de>; Thu, 13 Nov 2025 07:09:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4B2E322C9A;
	Thu, 13 Nov 2025 07:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="fbOJEKPi";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="5Sr2XQAB"
X-Original-To: live-patching@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F7C320CBA;
	Thu, 13 Nov 2025 07:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763017740; cv=none; b=MGA0v3v8RWk5YRNpO2ILQHTVecsnYAkJz9asp3O/PoiZ/oc74DFfv+NYOvT++5NXienbjXSCfB3Ki5HBbQuk5GR4j8bBdNXhJwBbEQUmqZw430AblHkeWle8GqMeUS+SNNdz4cngj7YZPec5dX0u+zJ/yJRlhUoqYNy5aNhedU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763017740; c=relaxed/simple;
	bh=3f/xC+sWyOsjhVEzIzhCaedM1ABqCJTDRHsZ+f4u3i0=;
	h=Date:From:To:Subject:Cc:In-Reply-To:References:MIME-Version:
	 Message-ID:Content-Type; b=bpG1Be/tS4jV2cgdqyfxjgVLHuPHHSkSLD9MqhO2rhmj278QHMRYk8wwvKmJHvZ4ZKUdBhWvHRRfYzC1GRbHtNRoJB1zdiWAmILU4J33UWodJQuU36wM25wKE9TyKMD5l5PUTj83lx38zin6eo+L3kjN4hW90VedEF6TkHWTrOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=fbOJEKPi; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=5Sr2XQAB; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Date: Thu, 13 Nov 2025 07:08:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1763017737;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vVAGe8sTLyWpP2UpknWqrtvw7FyCc9TWwYxbcU8ZVQ4=;
	b=fbOJEKPi5YHH7Zc1evPVqjkP3FgY3rQmeMIsJdR28NWTtAfBj6xBWziaA/zC0793IU+FYc
	vqK3qLqF6bn5Q5wzdDA5Xhv8l0deV9e+oK5ZzCEqBD5WDMOlk23GNwe+E13abeIEO9aOxD
	BXfz/RntpiP1P9ZhA46sHLIdjMhAqXJV3Ml+4pOIOrveSbCFKUzTokcsV4GogZ2uTAr6GL
	M0RuKt2MeVFJ/i5KNA6vk2kYv45tDe7KF1+zXe3XEH+dsPj2nFRb49gupXicZnsqXGa8ix
	je4FvQHnqboLntKTgSHRV7QxTrQ3lLyWZvYCbaS95JuV1cm9NGZvfWIyS8NRUg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1763017737;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vVAGe8sTLyWpP2UpknWqrtvw7FyCc9TWwYxbcU8ZVQ4=;
	b=5Sr2XQABLexgYaf+pX1S7tSxyRZzQaRN6klDYHe+alMBzilKbEPvunKvuqWZfYU76zYuJe
	ytT+AVsXMbs0rHDg==
From: "tip-bot2 for Josh Poimboeuf" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip: objtool/core] vmlinux.lds: Fix TEXT_MAIN to include .text.start
 and friends
Cc: kernel test robot <lkp@intel.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 live-patching@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
 x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To:
 <cd588144e63df901a656b06b566855019c4a931d.1762991150.git.jpoimboe@kernel.org>
References:
 <cd588144e63df901a656b06b566855019c4a931d.1762991150.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <176301773624.498.11012656445028148598.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe:
 Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Precedence: bulk
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

The following commit has been merged into the objtool/core branch of tip:

Commit-ID:     f6a8919d61484ae9ca6b1855035fcfb2ba6e2af9
Gitweb:        https://git.kernel.org/tip/f6a8919d61484ae9ca6b1855035fcfb2ba6=
e2af9
Author:        Josh Poimboeuf <jpoimboe@kernel.org>
AuthorDate:    Wed, 12 Nov 2025 15:47:48 -08:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Thu, 13 Nov 2025 08:03:09 +01:00

vmlinux.lds: Fix TEXT_MAIN to include .text.start and friends

Since:

  6568f14cb5ae ("vmlinux.lds: Exclude .text.startup and .text.exit from TEXT_=
MAIN")

the TEXT_MAIN macro uses a series of patterns to prevent the
.text.startup[.*] and .text.exit[.*] sections from getting
linked into the vmlinux runtime .text.

That commit is a tad too aggressive: it also inadvertently filters out
valid runtime text sections like .text.start and
.text.start.constprop.0, which can be generated for a function named
start() when -ffunction-sections is enabled.

As a result, those sections become orphans when building with
CONFIG_LD_DEAD_CODE_DATA_ELIMINATION for arm:

  arm-linux-gnueabi-ld: warning: orphan section `.text.start.constprop.0' fro=
m `drivers/usb/host/sl811-hcd.o' being placed in section `.text.start.constpr=
op.0'
  arm-linux-gnueabi-ld: warning: orphan section `.text.start.constprop.0' fro=
m `drivers/media/dvb-frontends/drxk_hard.o' being placed in section `.text.st=
art.constprop.0'
  arm-linux-gnueabi-ld: warning: orphan section `.text.start' from `drivers/m=
edia/dvb-frontends/stv0910.o' being placed in section `.text.start'
  arm-linux-gnueabi-ld: warning: orphan section `.text.start.constprop.0' fro=
m `drivers/media/pci/ddbridge/ddbridge-sx8.o' being placed in section `.text.=
start.constprop.0'

Fix that by explicitly adding the partial "substring" sections (.text.s,
.text.st, .text.sta, etc) and their cloned derivatives.

While this unfortunately means that TEXT_MAIN continues to grow,
these changes are ultimately necessary for proper support of
-ffunction-sections.

Fixes: 6568f14cb5ae ("vmlinux.lds: Exclude .text.startup and .text.exit from =
TEXT_MAIN")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: live-patching@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://patch.msgid.link/cd588144e63df901a656b06b566855019c4a931d.17629=
91150.git.jpoimboe@kernel.org
Closes: https://lore.kernel.org/oe-kbuild-all/202511040812.DFGedJiy-lkp@intel=
.com/
---
 include/asm-generic/vmlinux.lds.h | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.=
lds.h
index cc060ad..8f92d66 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -90,8 +90,9 @@
  * Support -ffunction-sections by matching .text and .text.*,
  * but exclude '.text..*', .text.startup[.*], and .text.exit[.*].
  *
- * .text.startup and .text.startup.* are matched later by INIT_TEXT.
- * .text.exit and .text.exit.* are matched later by EXIT_TEXT.
+ * .text.startup and .text.startup.* are matched later by INIT_TEXT, and
+ * .text.exit and .text.exit.* are matched later by EXIT_TEXT, so they must =
be
+ * explicitly excluded here.
  *
  * Other .text.* sections that are typically grouped separately, such as
  * .text.unlikely or .text.hot, must be matched explicitly before using
@@ -100,16 +101,16 @@
 #define TEXT_MAIN							\
 	.text								\
 	.text.[_0-9A-Za-df-rt-z]*					\
-	.text.s[_0-9A-Za-su-z]*						\
-	.text.st[_0-9A-Zb-z]*						\
-	.text.sta[_0-9A-Za-qs-z]*					\
-	.text.star[_0-9A-Za-su-z]*					\
-	.text.start[_0-9A-Za-tv-z]*					\
-	.text.startu[_0-9A-Za-oq-z]*					\
+	.text.s[_0-9A-Za-su-z]*		.text.s		.text.s.*	\
+	.text.st[_0-9A-Zb-z]*		.text.st	.text.st.*	\
+	.text.sta[_0-9A-Za-qs-z]*	.text.sta	.text.sta.*	\
+	.text.star[_0-9A-Za-su-z]*	.text.star	.text.star.*	\
+	.text.start[_0-9A-Za-tv-z]*	.text.start	.text.start.*	\
+	.text.startu[_0-9A-Za-oq-z]*	.text.startu	.text.startu.*	\
 	.text.startup[_0-9A-Za-z]*					\
-	.text.e[_0-9A-Za-wy-z]*						\
-	.text.ex[_0-9A-Za-hj-z]*					\
-	.text.exi[_0-9A-Za-su-z]*					\
+	.text.e[_0-9A-Za-wy-z]*		.text.e		.text.e.*	\
+	.text.ex[_0-9A-Za-hj-z]*	.text.ex	.text.ex.*	\
+	.text.exi[_0-9A-Za-su-z]*	.text.exi	.text.exi.*	\
 	.text.exit[_0-9A-Za-z]*
=20
 /*

