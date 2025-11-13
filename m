Return-Path: <live-patching+bounces-1852-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE4A5C56010
	for <lists+live-patching@lfdr.de>; Thu, 13 Nov 2025 08:09:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0E263ACEF2
	for <lists+live-patching@lfdr.de>; Thu, 13 Nov 2025 07:09:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 067A132145B;
	Thu, 13 Nov 2025 07:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Ys/Fhprr";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="cTDk4G61"
X-Original-To: live-patching@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4673019B0;
	Thu, 13 Nov 2025 07:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763017738; cv=none; b=idyx9A1MaUqgHWrtwps9FrkGPaM5qWExezxmEb+GT8cQ7NnXZolyLT0toPzF9Fqat4zIoMABP9X8dx7EVhiH+C78ipSsHmf/LMaJS090B/pLFdJcncPH/MkaYk+7MTykigkvxmbXiv179Bk9zOVOUxbAgx/Np9z50j901fEINFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763017738; c=relaxed/simple;
	bh=vywAK+IJoi5Oy1qAfrGsuGzmzSolYCxAkSRK1LKi4XA=;
	h=Date:From:To:Subject:Cc:In-Reply-To:References:MIME-Version:
	 Message-ID:Content-Type; b=Oc3/9GxhXTk73+cTRcX2jtFDfdRNaT71Aa72aoRCsrRVqx2UZG20R+O2gBD27hL1NQyI9h3ApczmGUtE32gBHgTMiLYbpwmnlx/BMRSlTSa+7pa5KEOpn6sf89jKwBDLtfhCs4td0WLVr8YBI30AYykLWeQPW3O5tEAldfPTPM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Ys/Fhprr; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=cTDk4G61; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Date: Thu, 13 Nov 2025 07:08:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1763017735;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hl0iiE4C/KNlKoXLPsscN0KxYBrLWwcmWpJ6ucNfwNQ=;
	b=Ys/FhprroYLikmtEx/BfCLXXAGDFUOJ+QYqoCPsNJFvoiczflz1BR0NsxH/7N5RFeVeZZ0
	QsWiujp4T58BlyqdidSwGuI3m/JY0Psc/PVWlOgzuqEVS5fX2MJfMb7/uLpaZlDc2i54e5
	mrw060tnn2PWXwrLxU5CMzSvu0WNm3kKdo27CEWKKMT6I1DRXkX3W7mX9X3L1p/geOyqNM
	TXfq/ekkz2Q7ab9jwZiCCN3p1A7wfXpkA1Sh4ud1g51XsBaqhSnRS/lgtFvIyw9te2UN5X
	yCu7LM3Ckf7+G+GmdVRYnaKSk/rc7MiUWyoWV3cISfuU3wsE0/xi7ymbiSE0bw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1763017735;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hl0iiE4C/KNlKoXLPsscN0KxYBrLWwcmWpJ6ucNfwNQ=;
	b=cTDk4G61MD9SMbspKyk5Ay0UhGakffPRSV1nH5+yHo08H8AOo2hr4KBWHNIJHYEAw7GZfT
	HmMmT96HsLku2JAg==
From: "tip-bot2 for Josh Poimboeuf" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip: objtool/core] drivers/xen/xenbus: Fix namespace collision and
 split() section placement with AutoFDO
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Ingo Molnar <mingo@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, live-patching@vger.kernel.org,
 Juergen Gross <jgross@suse.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
 linux-kernel@vger.kernel.org
In-Reply-To:
 <92a194234a0f757765e275b288bb1a7236c2c35c.1762991150.git.jpoimboe@kernel.org>
References:
 <92a194234a0f757765e275b288bb1a7236c2c35c.1762991150.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <176301773408.498.8502811332308425737.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe:
 Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Precedence: bulk
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

The following commit has been merged into the objtool/core branch of tip:

Commit-ID:     0330b7fbbf313b35470306a492b9e7a703b5af56
Gitweb:        https://git.kernel.org/tip/0330b7fbbf313b35470306a492b9e7a703b=
5af56
Author:        Josh Poimboeuf <jpoimboe@kernel.org>
AuthorDate:    Wed, 12 Nov 2025 15:47:50 -08:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Thu, 13 Nov 2025 08:03:10 +01:00

drivers/xen/xenbus: Fix namespace collision and split() section placement wit=
h AutoFDO

When compiling the kernel with -ffunction-sections enabled, the split()
function gets compiled into the .text.split section.  In some cases it
can even be cloned into .text.split.constprop.0 or .text.split.isra.0.

However, .text.split.* is already reserved for use by the Clang
-fsplit-machine-functions flag, which is used by AutoFDO.  That may
place part of a function's code in a .text.split.<func> section.

This naming conflict causes the vmlinux linker script to wrongly place
split() with other .text.split.* code, rather than where it belongs with
regular text.

Fix it by renaming split() to split_strings().

Fixes: 6568f14cb5ae ("vmlinux.lds: Exclude .text.startup and .text.exit from =
TEXT_MAIN")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: live-patching@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://patch.msgid.link/92a194234a0f757765e275b288bb1a7236c2c35c.17629=
91150.git.jpoimboe@kernel.org
---
 drivers/xen/xenbus/xenbus_xs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
index 528682b..f794014 100644
--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -410,7 +410,7 @@ static char *join(const char *dir, const char *name)
 	return (!buffer) ? ERR_PTR(-ENOMEM) : buffer;
 }
=20
-static char **split(char *strings, unsigned int len, unsigned int *num)
+static char **split_strings(char *strings, unsigned int len, unsigned int *n=
um)
 {
 	char *p, **ret;
=20
@@ -448,7 +448,7 @@ char **xenbus_directory(struct xenbus_transaction t,
 	if (IS_ERR(strings))
 		return ERR_CAST(strings);
=20
-	return split(strings, len, num);
+	return split_strings(strings, len, num);
 }
 EXPORT_SYMBOL_GPL(xenbus_directory);
=20

