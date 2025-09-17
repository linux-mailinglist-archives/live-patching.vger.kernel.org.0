Return-Path: <live-patching+bounces-1663-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A3A81B80D4C
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:05:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 888A34E3448
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:05:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1BF72FB0B6;
	Wed, 17 Sep 2025 16:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BoIkIqtl"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFF22FB0A7;
	Wed, 17 Sep 2025 16:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125062; cv=none; b=tZiP6vUYAuN5Tmh0gYYb3JWAKeaykvtX32YE8ym+yve644kaozdWDpB6d8tsbu09R9tmaQ3o8m7qihb6CGQonGIxBJlI6osaYjIt0RxdZjgftARmYq/RQBTItVMHv+5PFmeh97Dh56O2TbhNCFL2D5U3FsOZ3CBwAOSBpQnkOwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125062; c=relaxed/simple;
	bh=dxrTl9A4NvZjNOxon5FJcu6lJrpl3HE5uxGv+3v/KTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3bl/VQb58Z6gkJhfXIb/84X+eWe2NPVwY2d2OSNX92B46Joi2CX6zvRh0er+rEhqgEKUZzDmXjDpQFXy4q9VT3niznaK0XHHprV03W146+HDVXL66rFCBtxiJHhI8HUhO/h7oGHwhqajRR/chqLcCwSIGryuFIlaVZdLLDd1Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BoIkIqtl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0863FC4CEF9;
	Wed, 17 Sep 2025 16:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125062;
	bh=dxrTl9A4NvZjNOxon5FJcu6lJrpl3HE5uxGv+3v/KTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BoIkIqtl04IC+gwVZ9IE2a+F7g1jzIOfFifYuSOfaKg/inCdOqJfhi5KdpfysNj4X
	 w1OowhorVAdAcvvKXGRxj+7cDqU4qY1d88pQT8T88B9HMlvrfUY4qCARgacJ5FD4sW
	 +NE/p2SUvZbTMA7ZJ+AncMguycxW9kRvTM8Ny0LjZ63Cb/pe8w2KUSKp5o9wqfb3+4
	 nxAqwx7xLi9OHG+/1K9Ofszqn7ZTqNVpvsDGTc3QXChag585Vflxripa37sFa3wmqt
	 5BGxK13UYUofi8LECjj17r0Cojrn0JR8MNokAZIqsg3YBCE7jyoOO4HVue0WZmzuzY
	 DhQ8ITMnxTUSw==
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
	Peter Zijlstra <peterz@infradead.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH v4 09/63] modpost: Ignore unresolved section bounds symbols
Date: Wed, 17 Sep 2025 09:03:17 -0700
Message-ID: <9610e9e5d3e0747b151b9ea2399a3ebf84b2da46.1758067942.git.jpoimboe@kernel.org>
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
index 5ca7c268294eb..c2b2c8fa6d258 100644
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
2.50.0


