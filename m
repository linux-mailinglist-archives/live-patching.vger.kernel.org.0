Return-Path: <live-patching+bounces-1539-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 30923AEAB15
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 01:57:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 053791892FDB
	for <lists+live-patching@lfdr.de>; Thu, 26 Jun 2025 23:57:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 821BA25B309;
	Thu, 26 Jun 2025 23:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gwOIcOdT"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F7425B1C4;
	Thu, 26 Jun 2025 23:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982178; cv=none; b=Bla51CPofPPeS/rAswLGdBbl0wjgB+xcz0+qIj6okjMM3rXcP3TD6TwWuJcHA/KzIMcFXq/kY2/zBW46gRlHLGz/Hj0GaeIwNlTP0fjYVM1yb3ahrAsKjPHzxy6xaI20uENxiIq0dhFj4ENqv5JOtDHx0q82h0gY5PeDLbGgpoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982178; c=relaxed/simple;
	bh=TV6ZCyL2++3U5AELA+wSqC4BJLHcopbR5tUeqpd/6yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRqX31BUVQiYb+bUwzNivR/CKoxqXYvZDFwmk2TKhrV5i/2Spw2Qt8Km4Lp3wT7CqTV1OhlJif0qihyCwsL46nTrAvCwb3lEM7toRFv27gh8WJXnLRDGV6mVqZWnHfaWxjDcl3T0WIHj3TgY1lnYaaOLRr7S4ZJwCOEeJRcghQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gwOIcOdT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A36C4CEF7;
	Thu, 26 Jun 2025 23:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982177;
	bh=TV6ZCyL2++3U5AELA+wSqC4BJLHcopbR5tUeqpd/6yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gwOIcOdTxuFWhqIcjquWH1ddSDtXBROTjDwT0s6+NY3sc27kgVkj1tyknhrCaRmai
	 IGh95eZKBL3LBprbDr3Ox7rr1wZH3o4hgxjP8wFD5E3QJsZSU+h/CYYAKc0NRvx6kD
	 4bGA3u5R7lggZcc8BvPNsJwZbtsFD9tLve8uWH6KlD2NvHveHXfVx8wdlzFXdn8Sed
	 OT2WQQufkQTyt+GRfWmHct/K9YlfY4yQBPQbL5AaTxnv86ZMzoDZ0elBqbWFnkCirW
	 Op6RND/Rl5ugsG6gPO0GDMxu/QuL+MBnGPoeAHB+l9h476Wj28qqUqNagnAx+vYlNn
	 RdYheEsrT8t0w==
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
	Dylan Hatch <dylanbhatch@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH v3 09/64] modpost: Ignore unresolved section bounds symbols
Date: Thu, 26 Jun 2025 16:54:56 -0700
Message-ID: <64791e0033a46ca2a6f8cf4f65d4a6de76971ffb.1750980517.git.jpoimboe@kernel.org>
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

In preparation for klp-build livepatch module creation tooling,
suppress warnings for unresolved references to linker-generated
__start_* and __stop_* section bounds symbols.

These symbols are expected to be undefined when modpost runs, as they're
created later by the linker.

Cc: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 scripts/mod/modpost.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 5ca7c268294e..c2b2c8fa6d25 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -606,6 +606,11 @@ static int ignore_undef_symbol(struct elf_info *info, const char *symname)
 		    strstarts(symname, "_savevr_") ||
 		    strcmp(symname, ".TOC.") == 0)
 			return 1;
+
+	/* ignore linker-created section bounds variables */
+	if (strstarts(symname, "__start_") || strstarts(symname, "__stop_"))
+		return 1;
+
 	/* Do not ignore this symbol */
 	return 0;
 }
-- 
2.49.0


