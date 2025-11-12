Return-Path: <live-patching+bounces-1847-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B6E2C54D59
	for <lists+live-patching@lfdr.de>; Thu, 13 Nov 2025 00:48:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5D9C4349B65
	for <lists+live-patching@lfdr.de>; Wed, 12 Nov 2025 23:48:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45DDF2F0696;
	Wed, 12 Nov 2025 23:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nrtzBgrn"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6F82EDD64;
	Wed, 12 Nov 2025 23:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762991280; cv=none; b=T9eD76s+65nw6OwX7/a0v8FmDVr6NjcEMlGzD1wEWOaeASJtEnKb+PEOoMoPFVAzbZxAbXR8/SZubc5dhpOhNEIc4c761kdUTv9uP0kfwcobpc2NSl/iDfj4ing1Adt36g6aFE8qd7YVOoJ5dowvl/eG4/pv8lKwBuDbqzYwGDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762991280; c=relaxed/simple;
	bh=TKK1wNI9iOmIoWNuPxKE/E841R5aLZMCkr7faFg095Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fdor1JiC1mFKDenrXozv3R/lh4hXqybPdrrG4JlM8Vd69CpmpjGMItn9yWjrjX3BYMBcsx4RvS3C4MF0T4bJcDhhTfdZdIFfhGBZ+l8QNSYlYMuycjrxcgwgJBsfP8HyqHJSI7BTdov5pfVK0NqjveTWsvZJOPAxpTAbYFL/DZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nrtzBgrn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2AFC16AAE;
	Wed, 12 Nov 2025 23:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762991279;
	bh=TKK1wNI9iOmIoWNuPxKE/E841R5aLZMCkr7faFg095Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nrtzBgrnJ/98cegYCdNpDXtCrbhbPAo61BNLqhCfYQ2NV9oorcSOogo9EDiGv/eKD
	 94+6tFByAvXHlRfsvKSDn3It3QZXWNHpuNgrZkFEYYrRoWdrY8aDu+jTwY1tQqWiUm
	 mdn7ik7DPSejsCv3PcgsIFOD6BTwCGxpakG5KAWfIxGE1mSOYuUiMmFB+KF/0BHAEi
	 ECLyhm99wOcS2VGM9FSu3o7/guw/IdEugQOq3/60VtylX38CdAi1w1EGx6anqv7y8+
	 uU//+6jsxGxTjrIFgNVfmDKXE2tQiCeG5Vo2Q9BPnMX/FygN8gsHb1opnR19Y53PPc
	 UN9DeP8P1s4TA==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	live-patching@vger.kernel.org,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 3/4] drivers/xen/xenbus: Fix split() section placement with AutoFDO
Date: Wed, 12 Nov 2025 15:47:50 -0800
Message-ID: <92a194234a0f757765e275b288bb1a7236c2c35c.1762991150.git.jpoimboe@kernel.org>
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

Cc: Juergen Gross <jgross@suse.com>
Fixes: 6568f14cb5ae ("vmlinux.lds: Exclude .text.startup and .text.exit from TEXT_MAIN")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 drivers/xen/xenbus/xenbus_xs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
index 528682bf0c7f..f794014814be 100644
--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -410,7 +410,7 @@ static char *join(const char *dir, const char *name)
 	return (!buffer) ? ERR_PTR(-ENOMEM) : buffer;
 }
 
-static char **split(char *strings, unsigned int len, unsigned int *num)
+static char **split_strings(char *strings, unsigned int len, unsigned int *num)
 {
 	char *p, **ret;
 
@@ -448,7 +448,7 @@ char **xenbus_directory(struct xenbus_transaction t,
 	if (IS_ERR(strings))
 		return ERR_CAST(strings);
 
-	return split(strings, len, num);
+	return split_strings(strings, len, num);
 }
 EXPORT_SYMBOL_GPL(xenbus_directory);
 
-- 
2.51.1


