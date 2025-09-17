Return-Path: <live-patching+bounces-1673-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B2C98B80DAC
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:09:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 410BC5417F2
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:07:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADB5B2FE063;
	Wed, 17 Sep 2025 16:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sMUjUtEv"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BC82FE059;
	Wed, 17 Sep 2025 16:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125069; cv=none; b=GxIr4N4KIDtO8CFQJ6b3EXOy5mK3i4nyyWalAfFD9AAKHuUs9UIZIkf2AV0RNrLUoV/vif7KQBt1Er84qS4EX0XkdkYPj47Z6bYtRjUTgx+M8mjMsPEID9wBjaw550gHegS6+ugKt527J3OsoBVbSFjSyQvMYpLAMSqFNdrpJlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125069; c=relaxed/simple;
	bh=vivYDmE2QwnFNZP6brZa4TH9uGKMJ/OXaXdHd5GDhEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCqoMm2IABV1gEBGXMYeomxTKv7zQHpgyXS98CalrVTM0T0brG3JdS2hmdcFJMYPku5X92vYudHL5AyVulQLdkQ2LbZgO+kWkaBZ28Jrrt60ta5TxRykC0Si4W8Od3YPAIMoICxfQeKwYfaumpxf3W1ND393+fOC04MwtWau5Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sMUjUtEv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C34DC4CEF9;
	Wed, 17 Sep 2025 16:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125069;
	bh=vivYDmE2QwnFNZP6brZa4TH9uGKMJ/OXaXdHd5GDhEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sMUjUtEvOI03SkWxmys00Bvn3qV8YIE8vVS7LrhUnYbCK+9jVcTdnJxqGKji5XvM5
	 Xucn4dZR/T8IeFR0RzBZm+1kjTnUhK2wpKYhtn+rr9nhHeJnjKHlGXPvuTYw6QZn0h
	 byF4tOWhbybxQ5JMfURn/9xEpvdzyCWkfIDOQE9Qcs+OHzfUB0KCV9nNa9qjguMKDM
	 hoa0WhV6GPt2VRdIBv/q4j9FRgxatliAl0Z0m9AofY3mVlwITldwvqs8ibcozOIVzO
	 p5q3NVHHm3U3in6z6UW/wCOUCmygoItLNE6xL8PICYyMBqE0DUBqwm0W8ehto5gIzq
	 9tE28Km9GbA1A==
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
Subject: [PATCH v4 18/63] objtool: Fix interval tree insertion for zero-length symbols
Date: Wed, 17 Sep 2025 09:03:26 -0700
Message-ID: <3634b2e4f230766bef8b308302d2c2b07425fe09.1758067942.git.jpoimboe@kernel.org>
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

Zero-length symbols get inserted in the wrong spot.  Fix that.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index a8a78b55d3ece..c024937eb12a2 100644
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
2.50.0


