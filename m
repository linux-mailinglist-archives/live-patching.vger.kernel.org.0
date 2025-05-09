Return-Path: <live-patching+bounces-1406-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FCF3AB1E29
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:26:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 298539E492E
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:26:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 196C4299A89;
	Fri,  9 May 2025 20:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MQ3Pu2tX"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5623299A82;
	Fri,  9 May 2025 20:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821899; cv=none; b=tYNmdfq5PeYjmkp1R+21agxz67pLlaZoGrZ29tEHsRCoFFhUYwJ0B9z/z+xLsbf0J/lyD26wezJ5xM/xhzWaUabPnAA2r1rpkWL3UfTzfwjm1kGOSRAOoCRfjimGhN71/0j3h2FuvpNm4CBL3L5T+Ce9abRklAiB+O3B3ECpZsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821899; c=relaxed/simple;
	bh=jmRXds4o3AwT3YWdbyDdunUyXBqn350OclAJwQXw8Ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mhdopEEDhIA8iJiMZKE/s51W8m0Kwy+UBQJy90Hdl47Y68OtQ3TsL8d0GGQlIzPfLaPizoDQ3J60B61OsZQIHJnq8XX2wOgAojs+JA5eHGt+bbSdln8Z83wx/XFvoVbXb1Zoel2uKwT3JHxXcY4cBIXrkfty2IzfEUBl09h8wjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MQ3Pu2tX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B754C4CEF0;
	Fri,  9 May 2025 20:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821898;
	bh=jmRXds4o3AwT3YWdbyDdunUyXBqn350OclAJwQXw8Ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQ3Pu2tX2+1T+GabJclTmsL2Si4P6W2qh3RHD/TB8qtNL2MqhssfTPbxAmOoAL/cx
	 nNE3pGXvsa8wh7dTtE0F/yB/hM2C+BrIG9Apm9C9Hi/W3N6WN2XH1KBIWYTf94KzZ0
	 +P+rRcFLNtd9Xyn87iFp7oH8ET+Q6nBxpuqelWK0HBvSUuCHzU/onAoiHKi5+VWzR0
	 yPq14TroQ3QWyE4aHmf9UGhBGR52fndAENP2XYg4zaevT+c9JNYJw++eHHYpFdU5UV
	 OkWsuz8qk75V7Wi6jA2k3lqp+WxXLtz+wjvbyADKfr7Eyl07rARms5GX9kUh9E08go
	 WEV92VDU7bgEQ==
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
Subject: [PATCH v2 48/62] objtool: Make STACK_FRAME_NON_STANDARD consistent
Date: Fri,  9 May 2025 13:17:12 -0700
Message-ID: <5a0ab7bfd7a64f1051cd7719327fa1f111082b29.1746821544.git.jpoimboe@kernel.org>
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

The C version of STACK_FRAME_NON_STANDARD differs from its asm
counterpart in that it creates eight-byte entries (vs four) and creates
a superfluous temporary variable.

Make the entry sizes consistent by converting the C version to four byte
entries.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 include/linux/objtool.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/objtool.h b/include/linux/objtool.h
index 483dd3131826..d4137a46ee70 100644
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -33,9 +33,10 @@
  *
  * For more information, see tools/objtool/Documentation/objtool.txt.
  */
-#define STACK_FRAME_NON_STANDARD(func) \
-	static void __used __section(".discard.func_stack_frame_non_standard") \
-		*__func_stack_frame_non_standard_##func = func
+#define STACK_FRAME_NON_STANDARD(func)						\
+	asm(".pushsection .discard.func_stack_frame_non_standard, \"aw\"\n\t"	\
+	    ".long " __stringify(func) " - .\n\t"				\
+	    ".popsection")
 
 /*
  * STACK_FRAME_NON_STANDARD_FP() is a frame-pointer-specific function ignore
-- 
2.49.0


