Return-Path: <live-patching+bounces-1560-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DC07AEAB3F
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:01:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD1F74E4289
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:01:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4472273811;
	Thu, 26 Jun 2025 23:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bqd+umBd"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDAA273808;
	Thu, 26 Jun 2025 23:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982192; cv=none; b=kxUp7+ypeYeqk7P/M3S0V0NT6//vH9xrftMIa5Kz8/ACfTb+/Aih8+w0m/NdgPg/zU/TK1HE7DHCO477uxNhe6K+2fc6tg0/599X2Dg+qWg9rrrjK2aKsZA6L/8FDak/YGTuOodLBKeYjc2R3C5KEMo41Gmh68RIEOyF4VFkzcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982192; c=relaxed/simple;
	bh=/dfMmZtag0A54opwP96KSw4jAI0xUbayHj6ESsEwguo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8anIKb0yKj7yimnJJq7uSXfatxQlpU56kI6P+pY/14bSMtOxGbMrQDDnTwPGiV+DvihHQjzgH+d/sVTf+MazfRXAhHD/SCcT8D9VnADSsjRM2zrpVOJmHSkoDmX55brbrrxRCbL0kUE9agWduI+n1HvbvScHSlcYNqeyihfx+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bqd+umBd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB990C4CEF3;
	Thu, 26 Jun 2025 23:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982192;
	bh=/dfMmZtag0A54opwP96KSw4jAI0xUbayHj6ESsEwguo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bqd+umBdA8XSMD+BFUE/aYo++Wq4b/omYiv0zwWBEMZYbKsHUWbCyChNyQzS6ZDQY
	 VCG038H/COutCjublnAZyh8BhRiEzuzcmNm5Y+oiqT1NH8oafD9H0WO1UmM7ue4W1u
	 hDiNDykOswmWeWaWYi91iz4zhB4qwkN8UqARz2FlG0y1d7Vh33SFoUpOCR34jjF8sE
	 Oagi44DaSYsaY4KBB8dI9x3zJfVFiILIthQXX/5qTgA5z9VE1nP7bXyHuijStXEdue
	 vYRcGyliEJ00BMTlGZGFE13Cc7LWmOrKMOqHbyCdG1qfosJi2VPUzlYuwd+uA7ybch
	 0AlSGNq/vjMeg==
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
Subject: [PATCH v3 30/64] objtool: Simplify reloc offset calculation in unwind_read_hints()
Date: Thu, 26 Jun 2025 16:55:17 -0700
Message-ID: <81f34e12846bc8a7cda1ec54d5dfc012c0314587.1750980517.git.jpoimboe@kernel.org>
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

Simplify the relocation offset calculation in unwind_read_hints(),
similar to other conversions which have already been done.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 55cc3a2a21c9..9ffde9389c53 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2199,14 +2199,7 @@ static int read_unwind_hints(struct objtool_file *file)
 			return -1;
 		}
 
-		if (is_sec_sym(reloc->sym)) {
-			offset = reloc_addend(reloc);
-		} else if (reloc->sym->local_label) {
-			offset = reloc->sym->offset;
-		} else {
-			ERROR("unexpected relocation symbol type in %s", sec->rsec->name);
-			return -1;
-		}
+		offset = reloc->sym->offset + reloc_addend(reloc);
 
 		insn = find_insn(file, reloc->sym->sec, offset);
 		if (!insn) {
-- 
2.49.0


