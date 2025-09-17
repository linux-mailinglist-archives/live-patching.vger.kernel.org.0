Return-Path: <live-patching+bounces-1660-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 345E0B80D31
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:04:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E14893B380C
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:04:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ED2C2F998D;
	Wed, 17 Sep 2025 16:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NXy7YbeX"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270882F9982;
	Wed, 17 Sep 2025 16:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125060; cv=none; b=A6TLoXJtpW0/v7stJEZcfJfPU6fmk8alTDGB4MNmkb0XsG+vqqhdSGDCLfivTlN4Cf+rk8J/oFzzemRki8B+lDz+yQvyRQ4H3Vp4JLKK07Ad1qrsoKmsJY9TQwNeH1TKSdDZokF09zly83WlgrtWK6mHu6BKojtUqpK5RsYV8Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125060; c=relaxed/simple;
	bh=Rh5UBX0/1bsNQ3QSEsWQEOiS84/JDpiHxJE+dhFiXTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dh3Bz5zB1axWFRGUFr2VeoF8oQ5EhHId8hWp6fDhYWjNok0FdGmw6ti3aZsTQHJm4YOWS/Y67xEJBizVVLg3Gm8dzlWH3VlFDQB5k770CyFtA0tMFtjLM7xVPNCiJ2No+eyT5B9MVmz/7CxB53vHQV8MQ0ZfugZ0sALn2B/N1go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NXy7YbeX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2546BC4CEFF;
	Wed, 17 Sep 2025 16:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125059;
	bh=Rh5UBX0/1bsNQ3QSEsWQEOiS84/JDpiHxJE+dhFiXTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NXy7YbeX50cawaJIfrKycWL1MXot5L2iEi2ui2YBLm7EZ7nwAiuE9H02kf0zkv/ql
	 MrjJ1JemiABFGkhrUNx0DHKgUJRxgkldoPgxR7nwV3Q87VAvR79QroEHKs3PrJqqjY
	 CTwlXh2mNh3/sgb7CzKl0HFhpQj0V2WmmwopwD68OfmxaIFDu29lZNNihaWn136HUK
	 6HDEauFtJlN74sZPots1a+BqyOrLRoyRo/F/oivvqPd4MknXTCpOTJ5asW1Dt9Ji0B
	 0OkOhfNiUFciUF1UWmDMdKPnzFBDOOVNemw5leyAtpLYaB04NJprJkrmon3nkgzagq
	 H5GeIJP98slCQ==
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
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v4 05/63] compiler: Tweak __UNIQUE_ID() naming
Date: Wed, 17 Sep 2025 09:03:13 -0700
Message-ID: <81e999dc82d0aa47585c06a9e66f70df4d7e9979.1758067942.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <cover.1758067942.git.jpoimboe@kernel.org>
References: <cover.1758067942.git.jpoimboe@kernel.org>
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
index 64ff73c533e54..db5796b8b0a71 100644
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
2.50.0


