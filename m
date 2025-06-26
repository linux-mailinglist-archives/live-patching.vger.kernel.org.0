Return-Path: <live-patching+bounces-1579-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 04453AEAB66
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:05:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0E3016C2ED
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:05:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B6F228ECDA;
	Thu, 26 Jun 2025 23:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g6u3gQTT"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7564B28EA53;
	Thu, 26 Jun 2025 23:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982206; cv=none; b=JrT199QtenA6cy4QLaEc5aE8a7ZD4bCk5ka0nFWtTfbmhL/w6ENZvQZf+1mAenwEKWcmB0FfKXfky5WLHT2isdeu3cfcI9hC6ekGrw5qP/6Ox8pyRLwL924dViDG9kPMvV++WTyfs7lU/jv3FyX68YJizRMDVfDCy/L3HS51STw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982206; c=relaxed/simple;
	bh=DfYbyyq6pedYFcxfgyY6J9FfqZ28OdxeeJQZ0L8Mf8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=as4kSla5ofLkjMHAK3KU3a+uvQBPLNSOTxpXJhZ9PppjEma0sOUL7mqAOcVH699LZvv/j+jQNnwS+EWY8LjsW9IyLDkJYzOGgsKUggu6ftsaBhBYdmCxq17dZq+X8+Q0b9Pk6wMAC7N9KgOK29VKwEJBVSaO8+MUBgtwQHjtAiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g6u3gQTT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD4CC4CEF2;
	Thu, 26 Jun 2025 23:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982205;
	bh=DfYbyyq6pedYFcxfgyY6J9FfqZ28OdxeeJQZ0L8Mf8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g6u3gQTT8cHzfUvR4/mYgH+dhrTYB3K/yCeMLsYBAmVpX0GdbZ+gXxKz8wvngBJ9T
	 YsZB5HF+NtK7FxS8owVX2PlvoX0Gr+QC93jbP8btD9gWzkvRjbR+lZdFpJ1T47xDLx
	 TuSR/wNM+xMmwr0OHffbmknzrJ67oKzd3vCwbJYiV3BjAQH1fJV1cGzgeKKt3Pq30C
	 hnhAEJv388JYsP1iH02hHrQgpUBOlV3GXa0/Mtf2demkQoUeTnIimjosA4xgPXrGoh
	 HZFzzmg1GQ7990S41z5sFaC5w77ntI5UZG2Ac7GCFPhRqVP8ins2l1E/H0o4KwpfIF
	 eczS2m3D5Najw==
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
Subject: [PATCH v3 49/64] objtool: Unify STACK_FRAME_NON_STANDARD entry sizes
Date: Thu, 26 Jun 2025 16:55:36 -0700
Message-ID: <113d5ea267328c65a2220dbb94eb51a2084d3a27.1750980517.git.jpoimboe@kernel.org>
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

The C implementation of STACK_FRAME_NON_STANDARD emits 8-byte entries,
whereas the asm version's entries are only 4 bytes.

Make them consistent by converting the asm version to 8-byte entries.

This is much easier than converting the C version to 4-bytes, which
would require awkwardly putting inline asm in a dummy function in order
to pass the 'func' pointer to the asm.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 include/linux/objtool.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/objtool.h b/include/linux/objtool.h
index c7a3851ae4ae..7d7bb7f1af69 100644
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -106,7 +106,7 @@
 
 .macro STACK_FRAME_NON_STANDARD func:req
 	.pushsection .discard.func_stack_frame_non_standard, "aw"
-	.long \func - .
+	.quad \func
 	.popsection
 .endm
 
-- 
2.49.0


