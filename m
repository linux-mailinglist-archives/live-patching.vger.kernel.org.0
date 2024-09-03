Return-Path: <live-patching+bounces-560-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B23A96929E
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 06:05:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ECE01282D6D
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:05:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC4C91D6DBA;
	Tue,  3 Sep 2024 04:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZTd0fV8b"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FA41D6DB1;
	Tue,  3 Sep 2024 04:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725336042; cv=none; b=sHy7ZwbuonJOTljdD6AqPMOhzpj5rxAjmtcgCScd87cdtFxYA74S2uuWry0IipwVfxHRscUEi1XuzeqdUoTyEAz6faH5WWQSDc8OuhzvwFWq/j1tjFar3qHHFd8fQNvbdImYzSPjWhor3pqUhftK+QHOOXye2kFl7TwmWeerlB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725336042; c=relaxed/simple;
	bh=aitFbO2kW3aH4lB1//9h+v3atK493HEbsCZmttf5L+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWKW+lhLcyz8h6eBLZQI3QjTgNAi/RjZ+1fBFL/bhW9LSLh6MIJ/WivQYl03YIwgypKouKw5Ghauv9klIK5vkpIWn3L0HUbtQMfczubvNjQd1ZJFUqwv427naelajIuc660m5aU55gHE2LmFn35dcjt1LorQKGJXl5hKPxRLWOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZTd0fV8b; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E489C4CEC8;
	Tue,  3 Sep 2024 04:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725336042;
	bh=aitFbO2kW3aH4lB1//9h+v3atK493HEbsCZmttf5L+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZTd0fV8bpl8TJ1xemo40S/ioC5OMTo85cAwtGEFaE9Ehnpd+cxsc69EYUM6LrRS7n
	 rpzNu9A43aQcut60QAnfdgpcpbWhWHWPGiF65ljGRb60toQU1Ms8FIpEf+PIGRnI0s
	 psmEioof7Mhqrmm1CIrmUOpWko8ChtOQ+yV2BmOYNSO3JgSsEYzMdVXZevj2ygXFC7
	 0KaAh87ZOfwcUDjUpOEvpUk1mUjn3EIeiiVzgNGnMQC9jcuAtmD2pM4ENegHvjvipi
	 VU+bMmpECTvjz2G+FDBMA4f43gj1WxqgKx/2zTS1cYNw17w/C+Ppyi2rO9+Ha4Vcia
	 OTF+HM4NxAEPg==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: live-patching@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: [RFC 26/31] objtool: Make interval tree functions "static inline"
Date: Mon,  2 Sep 2024 21:00:09 -0700
Message-ID: <cc24c70a22c329cf4fd3fe77a53ecf813a4d89f8.1725334260.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1725334260.git.jpoimboe@kernel.org>
References: <cover.1725334260.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Otherwise the compiler warns if a function isn't used.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 42a657268306..471df0336aa7 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -98,7 +98,7 @@ static inline unsigned long __sym_last(struct symbol *s)
 }
 
 INTERVAL_TREE_DEFINE(struct symbol, node, unsigned long, __subtree_last,
-		     __sym_start, __sym_last, static, __sym)
+		     __sym_start, __sym_last, static inline, __sym)
 
 #define __sym_for_each(_iter, _tree, _start, _end)			\
 	for (_iter = __sym_iter_first((_tree), (_start), (_end));	\
-- 
2.45.2


