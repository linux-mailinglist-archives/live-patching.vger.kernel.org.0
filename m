Return-Path: <live-patching+bounces-1550-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC070AEAB2D
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:00:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81122567283
	for <lists+live-patching@lfdr.de>; Thu, 26 Jun 2025 23:59:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1DEA26D4E8;
	Thu, 26 Jun 2025 23:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nPnWkkJX"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D7826D4D5;
	Thu, 26 Jun 2025 23:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982185; cv=none; b=mC0xYUjNq/HCGQGvkyafrauqWcHhq7eqqI2ULYiRPh5xUgapbREbBHjtsk7MS+xfWhQHYr7Tojw2PtORIDqcZbBO2MmkW6nH+72Tp1p6vT/89GdBS5pCcgfL+n1NHPFhnX8fzaVciQ1crlCk+++SC3luG1LVoWnQqSKI6iSK4h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982185; c=relaxed/simple;
	bh=dwFCYWV+q/42xLwVEhtVpr+806iYAELTArkqZqjmqns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVAl/QfUS0kGtvajR4b9rlK5bB6D9eSR/htVQHqqh5sH/gVuVLD/RmSNWWYhLk7qfhooaze20Tb+LGjOEkOll0mrY8Nrk0MRdEzitqqSyt/l4Mw6BHdBaQGTkoINRCnZUPTRw+1jD8uEEaYX3Ab+GZwlnejc9BOD7Q3+ngGoWgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nPnWkkJX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E445C4CEEB;
	Thu, 26 Jun 2025 23:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982185;
	bh=dwFCYWV+q/42xLwVEhtVpr+806iYAELTArkqZqjmqns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nPnWkkJXNubD+Lt05Y0JG5f1mu+x+Pnq9bHMw2hewMRDWviA7zX4kO8CxWavHNX9A
	 xbeybxvHLvIELG/uqSMH5MoFuMQejamS/z6TdoaaeX+YKXUhdOrnT4R0TzA2VXa4Tl
	 cYTPWmPrtvJrhW9HWbqfBKynCCDyPkfVTWrTZAQX6ZKUNpCXojHiUzbWTo8wCec+KZ
	 /657kqzakiqo7gxpdZhq8sGVW5pxKopAZiwVvwOatm9XSq7k4gdFc4656umgMF7kxK
	 tV0vEb23tMLUZQt0OXmePfVv28Ei/ztynqbWRJ6ALduF1L8r88WwJEPAk8wUZE7ySP
	 y+PS/sc4m9jzA==
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
Subject: [PATCH v3 20/64] objtool: Fix "unexpected end of section" warning for alternatives
Date: Thu, 26 Jun 2025 16:55:07 -0700
Message-ID: <62942eb3702579d21fc916635173d3d8c9defb6c.1750980517.git.jpoimboe@kernel.org>
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

Due to the short circuiting logic in next_insn_to_validate(), control
flow may silently transition from .altinstr_replacement to .text without
a corresponding nested call to validate_branch().

As a result the validate_branch() 'sec' variable doesn't get
reinitialized, which can trigger a confusing "unexpected end of section"
warning which blames .altinstr_replacement rather than the offending
fallthrough function.

Fix that by not caching the section.  There's no point in doing that
anyway.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index fd93cae8b1b9..b5257a959458 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3508,15 +3508,12 @@ static int validate_branch(struct objtool_file *file, struct symbol *func,
 {
 	struct alternative *alt;
 	struct instruction *next_insn, *prev_insn = NULL;
-	struct section *sec;
 	u8 visited;
 	int ret;
 
 	if (func && func->ignore)
 		return 0;
 
-	sec = insn->sec;
-
 	while (1) {
 		next_insn = next_insn_to_validate(file, insn);
 
@@ -3754,7 +3751,7 @@ static int validate_branch(struct objtool_file *file, struct symbol *func,
 
 			WARN("%s%sunexpected end of section %s",
 			     func ? func->name : "", func ? "(): " : "",
-			     sec->name);
+			     insn->sec->name);
 			return 1;
 		}
 
-- 
2.49.0


