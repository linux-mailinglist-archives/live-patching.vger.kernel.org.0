Return-Path: <live-patching+bounces-1537-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C285EAEAB0F
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 01:57:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED3F33BFB56
	for <lists+live-patching@lfdr.de>; Thu, 26 Jun 2025 23:56:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E66B22D9E6;
	Thu, 26 Jun 2025 23:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p8jY5r2H"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF9C22A4FE;
	Thu, 26 Jun 2025 23:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982176; cv=none; b=jbd10FtfCG1uOH7aHB3NJ/2NDAu42Vt2WYu5BN8yOWFjbLpzWqRd/AczrNmzupFNCwLHX+zbOidMmwnF0tQXsTe+WIZ0n7Z2wE7HLfLWCdC7fB2qHavB+Hz5ZJi2CJzXMrAlFoI8lMT6PZimwKUbdJMoyOFF7RhZ0oYya+cq4lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982176; c=relaxed/simple;
	bh=NqyW7oDawaip0BbU2C/tpiXXTpjR6tMBnlY9JocR4N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SB3gq7UvSC00B075oSJXJVTWDzKkJqLD884reKvEbBf/SJJQ7EUb49yfIbRzR7w5nzH6kn1RkT3RM5882d5n42n3dGLSilPzOiv6jSWqC0mJ18X5HjKGLKp10jYZohJ625BqcVZgYAFr2NiGI77DszDQ8PclAPMK4UTuwD+NY9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p8jY5r2H; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1691C4CEEF;
	Thu, 26 Jun 2025 23:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982174;
	bh=NqyW7oDawaip0BbU2C/tpiXXTpjR6tMBnlY9JocR4N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p8jY5r2Hw/92dBbngXHm8k/d1z+4ddqJP1SGPDyc8Nyorcda+qepe+ijfuWG6s3NM
	 IHQV3Gdt1xQWVeq/UdHFzCa5RoIGS6KXJhx0Xv3doXOfAVps8FXvAGPoJ0pNzrVbQS
	 RZGacQ60bOVe7V9P7df0QhCXx0AbLbIkcWAOtE2R48RYBcmoLPtu12E+cwdTnG8e1i
	 rw0C+4zt2shk6O2B57ImgLHvuh8NbRu3dk0MjQg94xB4ryvB67X2Pq4UmKKrhzS4YJ
	 DuwgVUKRv9DQ0EX5YcCjgcltSAdAzuOfFxjT2ome7R4BRyRLQuW7tyNpPvakU9q79O
	 riNYKpHT9+6Yw==
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
Subject: [PATCH v3 05/64] compiler: Tweak __UNIQUE_ID() naming
Date: Thu, 26 Jun 2025 16:54:52 -0700
Message-ID: <6ca62d2c00410818bac2121ab5e0121075abbb2d.1750980517.git.jpoimboe@kernel.org>
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

In preparation for the objtool klp diff subcommand, add an underscore
between the name and the counter.  This will make it possible for
objtool to distinguish between the non-unique and unique parts of the
symbol name so it can properly correlate the symbols.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 include/linux/compiler.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 6f04a1d8c720..4406c1592d78 100644
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


