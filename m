Return-Path: <live-patching+bounces-2650-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SEQcB9Yo9GkH+wEAu9opvQ
	(envelope-from <live-patching+bounces-2650-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:15:18 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F36B4AA2A3
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:15:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 11A623095343
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:10:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1392935A925;
	Fri,  1 May 2026 04:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oeSqdBRv"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAD9359A94;
	Fri,  1 May 2026 04:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608545; cv=none; b=p+LaINcQZ1GZ+LZG8qLLRK8cnZkx9ggypE3O0xV9UHIYJy+oiQwZL6GNL5oLxsOKOC5i3O1dyJJIUoAg0241M2/1MmdXDf+YttNeschl5LnV+VkuYxL7gNTkXoChbwfkFC4FQ3K3IeD8iXmzeWKTrdOam2heqQL0h3wljVhLwxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608545; c=relaxed/simple;
	bh=6jE4uMMHkB1mOztBVCv0yYQ2rdykfzMXfWMb8wecjjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJfwtQgmZ5asqvQ2Iwjp7O/EtVqMcG75h4FnTPCUZbbqSQlnu5ADkmjzerqUHZbWYnoDOgteSJoGssD27bQAdbWLRnwt8BQ4eZDSqHp91SQP3AfsALm7VW6hbJIJFzuNNNZZcs6Ud3/7SG1cld0HcCkxayqJDFrgv+kr3LKY47s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oeSqdBRv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75593C2BCB9;
	Fri,  1 May 2026 04:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608545;
	bh=6jE4uMMHkB1mOztBVCv0yYQ2rdykfzMXfWMb8wecjjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oeSqdBRvDbQ4razru/Lqyx/m/A0iPPvj1Q0InlNU2tF0lzWAIxcoNP7Hc3NbE+/pz
	 X6+Fp56g2XhB7cwwaCHxXnyh0Bpx4D1ZPrqJsLCTfo9S1zsQfpFONLOYdE0SZ1XWOe
	 edRQx/NGA/R0gfOvH2QUM3XuOXogBHwzkeOOmGEtcvkvO0CwAonffCoNQlaN1rPVm7
	 czisz9y3y2hx0XyuHCwrxzblIQVWqI8wi4pU+Q+3cCr7ip8/YhC8h+ZtGIIFm4VSmD
	 KBWwNsfJJmmqZ5XJffrZ3Fi6Nu9i94o8CSklHVwT33geKGohD1MDsfnohrlSHk989Y
	 O09gnPGr+ExbQ==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 33/53] objtool/klp: Don't set sym->file for section symbols
Date: Thu, 30 Apr 2026 21:08:21 -0700
Message-ID: <d44d6a8f8256c9d3896bf531050c969cb15f2661.1777575752.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777575752.git.jpoimboe@kernel.org>
References: <cover.1777575752.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7F36B4AA2A3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2650-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,infradead.org:email]

Section symbols aren't grouped after their corresponding FILE symbols.
Their sym->file should really be NULL rather than whatever random FILE
happened to be last.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index f41280e454ca..d9cee8d5d9e8 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -649,7 +649,7 @@ static int read_symbols(struct elf *elf)
 
 		if (is_file_sym(sym))
 			file = sym;
-		else if (sym->bind == STB_LOCAL)
+		else if (sym->bind == STB_LOCAL && !is_sec_sym(sym))
 			sym->file = file;
 	}
 
-- 
2.53.0


