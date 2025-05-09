Return-Path: <live-patching+bounces-1365-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68F72AB1DD2
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:18:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2DD0EA230CE
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:18:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6983525FA29;
	Fri,  9 May 2025 20:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E7zilWZM"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4079525FA11;
	Fri,  9 May 2025 20:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821868; cv=none; b=I2Owb4e6/peu8BOvF6NV4uLvjr4p5+xwwSnWkPlpXBp9Ot/5J510RIMU7n8dQs+UmK5goCsaFAg+yDwgcdbKTCCGMb7X78aLshkOQn31LvU4TZSYBiDZef4JPwHBZv4iYkXhvS2m5RZ1s659qDWQNLyOF0LB7Sa9Fal6rmd8iG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821868; c=relaxed/simple;
	bh=3tlymgvkIpuX/jFV9LwurncZOXQItfZudGI+G+KrCR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLJl2kjbvqyKgu/lQPJHfbCR9XKcPgDi0mFx0vfbPxCqCnu2ykZ7bSb7Lr44tVOv6VhpUn+B9t7ciHe1ff3iL5XNLLKwpevxcT20bve7aipZKwmtWMLkzpIAwBnDAl6DVVU7zro7j7+oB1I3RAuUDsMSCGdD1s5XSdy8u3a/yyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E7zilWZM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 881C4C4CEF5;
	Fri,  9 May 2025 20:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821868;
	bh=3tlymgvkIpuX/jFV9LwurncZOXQItfZudGI+G+KrCR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E7zilWZMDyqkeZxOb8AHXNr5hpEKIS0O6+t5jLElB4bI/87rGlRjtuarUGKZ0Igvl
	 uOjj4CshgSa+X2qRVY3RQcyGbtu9ni1dhoUIL02dHJsTygV4HhUfdT/cOnoHfSjvmS
	 NLVtxIPNnv6boDruYmYC0UY2x7hymjA5iV3Q4fSh2S+yntZ0VHaJZxGb3OSOIqCI+x
	 qUP5HYhNVeMSRdYRZaL2biEgNVdMSR3LLpREq5j94QsiyjD6Lh/tW16vgn/yHC7QkJ
	 xERsk0I4oO8eWoZxaJz5u6MMVdwGdD3gngqv5f/3vQ1GSRsJWvAARpfrzFPCk7QAtD
	 7IjsmlqxXbJQA==
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
Subject: [PATCH v2 06/62] compiler.h: Make addressable symbols less of an eyesore
Date: Fri,  9 May 2025 13:16:30 -0700
Message-ID: <7a2ba63aa1d1d3a6a904dd31188d910a8b647ba1.1746821544.git.jpoimboe@kernel.org>
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
index 0efcfa6dab0f..1390d5cb2359 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -287,7 +287,7 @@ static inline void *offset_to_ptr(const int *off)
  */
 #define ___ADDRESSABLE(sym, __attrs)						\
 	static void * __used __attrs						\
-	__UNIQUE_ID(__PASTE(__addressable_,sym)) = (void *)(uintptr_t)&sym;
+	__UNIQUE_ID(__PASTE(addressable_,sym)) = (void *)(uintptr_t)&sym;
 
 #define __ADDRESSABLE(sym) \
 	___ADDRESSABLE(sym, __section(".discard.addressable"))
-- 
2.49.0


