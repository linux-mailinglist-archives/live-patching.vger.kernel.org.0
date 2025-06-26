Return-Path: <live-patching+bounces-1535-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36020AEAB0B
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 01:56:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B42B14E32C8
	for <lists+live-patching@lfdr.de>; Thu, 26 Jun 2025 23:56:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A75F23B605;
	Thu, 26 Jun 2025 23:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OnYr6Lqa"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32ED522B8A4;
	Thu, 26 Jun 2025 23:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982175; cv=none; b=Bls52F+zFelBZQ8UEbKpUxbwvovfaC2iKoW8s4eahohwYQ2ZCdVk5FkJDeALA457im11LUn2ZifaoBId7SZIl+dytipJXTuaomZaGrVgnYpDzom8hOh2KL16IC8XXVJl3uDnk26lltTwOMPaVX8muulfv7t7fk5lEJYxruUuIhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982175; c=relaxed/simple;
	bh=+gcNbV45TaLEx/fkSMmJPJZRwj8zt4CCwlysvxWZl8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7jcqCypWHWNGPoWxVFWhtgja58a2Oz2Y/v8UaG3WheCCJFkLpNBoNsAtOGeZWBf6cuuTMAcDWVfu1jgKg+OFqxHEpe700QH9aID49h6X1LTyFe3P3ICbMYaMXkiN7ADuAUHeS1G5+ZgjKpQa8CRcGOw8lhiAY1eCIXLGSVQotE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OnYr6Lqa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851B7C4CEEB;
	Thu, 26 Jun 2025 23:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982175;
	bh=+gcNbV45TaLEx/fkSMmJPJZRwj8zt4CCwlysvxWZl8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OnYr6Lqaq7MGQpQMWza2/EahiaqO69pwpeFksYdUG2hRJsZqHPmpoGvOZiAUkRirm
	 RGcNSFdQhCJEtO9CgPT3b+BAYoLQ/hIyyP4tysk4/GO8rXqml4DtXNjcl89sFdaOSP
	 Kw6hPjvwYKVm4QePFtffdQEvf8OTA4y6t/aCYkwq9D8YE2jqtangRlu2zvMqsapY5j
	 soE+cuQt0/LXN9VCUMfGgdBvI4pJT/HOcD3Crx28fn/lW7HUdqg1oQQijUhq04ogU5
	 1CyQa1qEsXW2qci5xyEQGQ77XAFE9drxQcaWgDhPKCctbl8wGun3tyTph12G1mlQD2
	 nsV4je4njwYjQ==
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
Subject: [PATCH v3 06/64] compiler.h: Make addressable symbols less of an eyesore
Date: Thu, 26 Jun 2025 16:54:53 -0700
Message-ID: <ef25dfe532618a794f15930ef44218f9ee994888.1750980517.git.jpoimboe@kernel.org>
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

Avoid underscore overload by changing:

  __UNIQUE_ID___addressable_loops_per_jiffy_868

to the following:

  __UNIQUE_ID_addressable_loops_per_jiffy_868

This matches the format used by other __UNIQUE_ID()-generated symbols
and improves readability for those who stare at ELF symbol table dumps.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 include/linux/compiler.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 4406c1592d78..2039da81cf16 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -287,7 +287,7 @@ static inline void *offset_to_ptr(const int *off)
  */
 #define ___ADDRESSABLE(sym, __attrs)						\
 	static void * __used __attrs						\
-	__UNIQUE_ID(__PASTE(__addressable_,sym)) = (void *)(uintptr_t)&sym;
+	__UNIQUE_ID(__PASTE(addressable_, sym)) = (void *)(uintptr_t)&sym;
 
 #define __ADDRESSABLE(sym) \
 	___ADDRESSABLE(sym, __section(".discard.addressable"))
-- 
2.49.0


