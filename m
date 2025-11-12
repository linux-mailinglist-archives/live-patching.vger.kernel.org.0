Return-Path: <live-patching+bounces-1845-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ED72C54D53
	for <lists+live-patching@lfdr.de>; Thu, 13 Nov 2025 00:48:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E8E11348BA8
	for <lists+live-patching@lfdr.de>; Wed, 12 Nov 2025 23:48:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E9532848B2;
	Wed, 12 Nov 2025 23:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lq9xFeEP"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E1D265298;
	Wed, 12 Nov 2025 23:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762991279; cv=none; b=nUXQIGjDjQ9nXxopUkEXbplx4KrO9QQn1HUq8mjhtBIvk14qKoBpJu8hXiFlD0ly1ETykKDD7AtnsaHDhUuve339rPLr8rwX1fuIsxLOQusc/HYd+H92wx7rTWFGdG3X/UX5yIxkb/KQiudMYzyyNrolZaTMPBBdyzpJ5XXfbYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762991279; c=relaxed/simple;
	bh=Y/7mQcAensFfGgY+W4uvKcEzdOXEVtHTz6plX/dBmjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cAFAdsEcb6pR0W+T1mI1fGgTeKTRyY8c+Pungx9yj6gl5BFMZbxM8PHyi+JXhnEYiYaXy6LPwZ8S/EgB3ByE9qr2IndZRILcZi4/Rp8BEHtF6zgICXnzKVYarH82ZQ46begYX/HkbtcHUkXwCfpX4DjcCf0f0Xly79sT79N6v+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lq9xFeEP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C48C4CEF1;
	Wed, 12 Nov 2025 23:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762991278;
	bh=Y/7mQcAensFfGgY+W4uvKcEzdOXEVtHTz6plX/dBmjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lq9xFeEPLkY/hU5ojQ8Zp6J75pzIma53x7N3f4dk+WXiy3w85XeIpLREFmjrXuccb
	 4usxFx3c4VS8SqEUkRKmUrvWUdhBwKU5F5C60IlbEKecNwJvr39DBgpmhMJQhPQhm0
	 jCkweh8buvpPrhpUFY7w2ZiO3ZxPy+FqhMG8VExjuvha3A7yqCNABXE/HVaQZcRyAQ
	 hIwDol35GBnMjC8sWjp+oNaIcwbQVa14cOuVQgwaCtO5ZB4kYcM/GcgLG3sfRysEmA
	 cf4QBvk8TzYwq+NZKaLOqXdPbDugPslKOpxNEdvpsDJPOwl0mKS/WSpn7qtwgIgPdE
	 T5VmaZwcfYxtg==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	live-patching@vger.kernel.org,
	kernel test robot <lkp@intel.com>
Subject: [PATCH 1/4] vmlinux.lds: Fix TEXT_MAIN to include .text.start and friends
Date: Wed, 12 Nov 2025 15:47:48 -0800
Message-ID: <cd588144e63df901a656b06b566855019c4a931d.1762991150.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <cover.1762991150.git.jpoimboe@kernel.org>
References: <cover.1762991150.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit 6568f14cb5ae ("vmlinux.lds: Exclude .text.startup and
.text.exit from TEXT_MAIN"), the TEXT_MAIN macro uses a series of
patterns to prevent the .text.startup[.*] and .text.exit[.*] sections
from getting linked into vmlinux runtime .text.

That commit is a tad too aggressive: it also inadvertently filters out
valid runtime text sections like .text.start and
.text.start.constprop.0, which can be generated for a function named
start() when -ffunction-sections is enabled.

As a result, those sections become orphans when building with
CONFIG_LD_DEAD_CODE_DATA_ELIMINATION for arm:

  arm-linux-gnueabi-ld: warning: orphan section `.text.start.constprop.0' from `drivers/usb/host/sl811-hcd.o' being placed in section `.text.start.constprop.0'
  arm-linux-gnueabi-ld: warning: orphan section `.text.start.constprop.0' from `drivers/media/dvb-frontends/drxk_hard.o' being placed in section `.text.start.constprop.0'
  arm-linux-gnueabi-ld: warning: orphan section `.text.start' from `drivers/media/dvb-frontends/stv0910.o' being placed in section `.text.start'
  arm-linux-gnueabi-ld: warning: orphan section `.text.start.constprop.0' from `drivers/media/pci/ddbridge/ddbridge-sx8.o' being placed in section `.text.start.constprop.0'

Fix that by explicitly adding the partial "substring" sections (.text.s,
.text.st, .text.sta, etc) and their cloned derivatives.

While this unfortunately means that TEXT_MAIN continues to grow, these
changes are ultimately necessary for proper support of
-ffunction-sections.

Fixes: 6568f14cb5ae ("vmlinux.lds: Exclude .text.startup and .text.exit from TEXT_MAIN")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202511040812.DFGedJiy-lkp@intel.com/
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 include/asm-generic/vmlinux.lds.h | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 9de1d900fa15..20695bc8f174 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -90,8 +90,9 @@
  * Support -ffunction-sections by matching .text and .text.*,
  * but exclude '.text..*', .text.startup[.*], and .text.exit[.*].
  *
- * .text.startup and .text.startup.* are matched later by INIT_TEXT.
- * .text.exit and .text.exit.* are matched later by EXIT_TEXT.
+ * .text.startup and .text.startup.* are matched later by INIT_TEXT, and
+ * .text.exit and .text.exit.* are matched later by EXIT_TEXT, so they must be
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
 
 /*
-- 
2.51.1


