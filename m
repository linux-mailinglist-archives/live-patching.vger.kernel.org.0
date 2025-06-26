Return-Path: <live-patching+bounces-1546-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F26AAEAB20
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 01:58:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E81317B63ED
	for <lists+live-patching@lfdr.de>; Thu, 26 Jun 2025 23:57:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6681526A1AD;
	Thu, 26 Jun 2025 23:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s0ShW4rl"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C48D26A08E;
	Thu, 26 Jun 2025 23:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982182; cv=none; b=jnKIL4P7dPPiqXqg2Fr/5Rhiwvsods5VvywGHIqTE6ODJH+cRFLTY0kTvRo+hXImziNz9XG8xJnrafgQCneNgVN4XsvmTdsOdGpSwjYyJ61R9qcx6r3CQ0CdsjSDiZjLUtpqyvxA+cE3Di9IycY63B9pWNpWPgCxIeHl0eP1qjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982182; c=relaxed/simple;
	bh=YyD6KDvlcm2ljvEKZEc8fYvgEk6IvDo2PvpCUwTOJmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4mjL8VqlZWUBg0BqS0TC06LWhQK/kMh+dnTaDpanl7W5PvMXviVMR3Bss5wqZumCufHdfF9zR2mM9UVoTvNwM8ibobWc78SVfhs/SWIqu3JyZRdXidk2/+Y31AoOpWECjbt5nCmR28O3q8R2rtBF10X2/N67/SnMJ3QB6aR/cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s0ShW4rl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8585AC4CEF3;
	Thu, 26 Jun 2025 23:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982182;
	bh=YyD6KDvlcm2ljvEKZEc8fYvgEk6IvDo2PvpCUwTOJmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s0ShW4rlNPj7VtcE19ltlqhuYVjf1n27xMz8JH6ioeQgt41v6i+1WDCl65izFsH5+
	 ZN1Z04PVhzzY96uJmvC3XgIRfkzU3Ep7zoZYwWUXinjEl+5BFIM6hcBqidFrfpxGYb
	 wV0cbzEilL9DeZFztmEdSnRpml0bQU/wDM8xScTT5SGMPe2u/Ybft3gV86BeaFGd7v
	 9ruJsekb0R9sQgmAhlSwDC8GV/kdB6l1KFNhY4DyRJNrSFHDhamTGDHmhuB6RrsKE4
	 qZR2kTmSovXovvaGASbwGejp9L+uYF7VYvQkilBCZonNyCe2YDYDgNRyQ0hj50EyK/
	 ak64ryaqq6xLg==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org,
	Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Dylan Hatch <dylanbhatch@google.com>
Subject: [PATCH v3 16/64] objtool: Fix interval tree insertion for zero-length symbols
Date: Thu, 26 Jun 2025 16:55:03 -0700
Message-ID: <3d051a58df7eaef60c52e60a3f3dfabc71a33b05.1750980517.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750980516.git.jpoimboe@kernel.org>
References: <cover.1750980516.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Zero-length symbols get inserted in the wrong spot.  Fix that.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index a8a78b55d3ec..c024937eb12a 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -92,7 +92,7 @@ static inline unsigned long __sym_start(struct symbol *s)
 
 static inline unsigned long __sym_last(struct symbol *s)
 {
-	return s->offset + s->len - 1;
+	return s->offset + (s->len ? s->len - 1 : 0);
 }
 
 INTERVAL_TREE_DEFINE(struct symbol, node, unsigned long, __subtree_last,
-- 
2.49.0


