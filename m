Return-Path: <live-patching+bounces-1364-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 46295AB1DD1
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:18:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 04A23A21C07
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:18:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14FBF25F99E;
	Fri,  9 May 2025 20:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BSNPsosT"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC54A25F993;
	Fri,  9 May 2025 20:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821868; cv=none; b=rLqANfR8PPjLgCBDHhTa9gSNKwUPmzX93xZbXsfTDyck2HDRalcr1XZHeUBHPL7qOT/OUfwzK9ABf3fs1TGf/ORVEy1MuC/BYAIYS0hAxCTYUy88GSulbsckRWpS1KSMr4UhN1xcsZHbmp6A0sZjFgsopObDjmKRXq+5DEawelg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821868; c=relaxed/simple;
	bh=3DCMHlXEkaRnvAyL0pRaZ+Z/6H4tZRgc5zFZ9hxwIjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rxco0rXThG/Cu6Cx1FRzfpsBVvKNOrlxsnnGoWlVw63KFcXcWoJ2+dIehAysOB9UikMzuvja83wSR1Byvq8vRwZRjz40hRD6MmmWSYZE5depMKXXvlgGPCB5ViLYp0/Aw7/t8HfICkw93E7NzDZBQ5N6i0iBLgABwwQApfMxv04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BSNPsosT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D252DC4CEF4;
	Fri,  9 May 2025 20:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821867;
	bh=3DCMHlXEkaRnvAyL0pRaZ+Z/6H4tZRgc5zFZ9hxwIjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BSNPsosT0X5Rrpd3GpV03Wf1lDsBOTd1U+y2oWlG88xzwDDhVBTUd1W0i51jwXfT7
	 xS7631jfxOs50kznyakE5HG45Wjxz1CktlNMZ7YGkE8Pet/fEewbNP1LITq63v580w
	 /Y0ux1kF6eFbinlcqt2xM/cTDaEw9numldGT03pMInvEZdTAlqBtIMw7GCX4w+gIBY
	 98Buhv+VdfEq5Wo6FSDe98I9SUr0esPJXq9zbEiQ+m9mKwiQapsl0Eezdt3KFZ5mgF
	 8C5BeckBcjWy9v+apE6+uyPK7rryAbuQgFyo7epT9Lg0lcvwTb5KWQZjYankwJD99F
	 Qg6LeieCPuMrA==
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
	Puranjay Mohan <puranjay@kernel.org>
Subject: [PATCH v2 05/62] compiler: Tweak __UNIQUE_ID() naming
Date: Fri,  9 May 2025 13:16:29 -0700
Message-ID: <e40a85d6742609779a9a86af95f7cbebdacefe12.1746821544.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1746821544.git.jpoimboe@kernel.org>
References: <cover.1746821544.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for the objtool klp diff subcommand, add an underscore
between the name and the counter.  This will make it possible for
objtool to distinguish between the non-unique and unique parts of the
symbol name so it can properly correlate the symbols.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 include/linux/compiler.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 27725f1ab5ab..0efcfa6dab0f 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -163,7 +163,11 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
 	__asm__ ("" : "=r" (var) : "0" (var))
 #endif
 
-#define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
+/* Format: __UNIQUE_ID_<name>_<__COUNTER__> */
+#define __UNIQUE_ID(name)					\
+	__PASTE(__UNIQUE_ID_,					\
+	__PASTE(name,						\
+	__PASTE(_, __COUNTER__)))
 
 /**
  * data_race - mark an expression as containing intentional data races
-- 
2.49.0


