Return-Path: <live-patching+bounces-1687-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6B18B80E0C
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:11:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A1F9544031
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:09:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5063F32BC1A;
	Wed, 17 Sep 2025 16:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ILbw/fqd"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290C832898A;
	Wed, 17 Sep 2025 16:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125079; cv=none; b=A6+D4hJbA2FiyQ5aaiz0PzcYB+PJgwd2xU9aqmn4NUaUAE6dygdMTEdooJBp6L/8HJqtISbFz/1veCL9p5Xb4V1R2ZiB1uqUX90k50JFmx5ClfRlynv92+wj57jyDOYA/3EbY8XIrWI9oRAT8VcnProZdHoH61hEdKKQPiNt0W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125079; c=relaxed/simple;
	bh=N+2EyH+rpRcy8Di7tNmxfZO92E0uRDPrwe6F/B9X0fQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3tgJibCdnBBVBRhggKx/DK4jNrX9CF75mwkziPSEjLMCxYpjw5EQGW3usfWinAcvxeHxFpMQw2LdYzGEQBmJLSn6/onUM4d9ktRJPYLvCjmJ/JICHJ//T2T32GPuUL1TX3HrqkL5fVMuDKTP8jq96rSyDKXsZClJ279qH0F/50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ILbw/fqd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B4DC4CEE7;
	Wed, 17 Sep 2025 16:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125079;
	bh=N+2EyH+rpRcy8Di7tNmxfZO92E0uRDPrwe6F/B9X0fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILbw/fqdyyEsYOHwtLDtle9iIgWQ9usOhHhS+sG8YvkwShLTAvP+UmvdWHBfpGq+f
	 CrXSIeFaen/mm98bicvFi6zUDDQahbtQg6KLg6QvIrt+ZuwGq7X2lU5LMtbEvNWkRf
	 HoJwnKPuTwObZO9FAhy1N3ItB2xfylrcvA3X3RKOOYt+otQYJdOWcTFkDzhHJqgk2D
	 U6hCIxt9yb6ZMoYD8uDfe9uqn/AmwKzObI2cgXFFAVIQgxGrJDbIdPqlhBR2lG91hl
	 k4ABxaIhyXjZZb5M3TDZp4ATE1V7H9xdHuu3zpfhUNYgtcpPIc9wVBoDzElq1oaEsV
	 nFZEZfX5zqwxw==
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
Subject: [PATCH v4 32/63] objtool: Simplify reloc offset calculation in unwind_read_hints()
Date: Wed, 17 Sep 2025 09:03:40 -0700
Message-ID: <47f3e5967842ad84919539cdf22c9d390186f276.1758067943.git.jpoimboe@kernel.org>
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

Simplify the relocation offset calculation in unwind_read_hints(),
similar to other conversions which have already been done.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 6f7ed34aea43e..ea53468120d7a 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2200,14 +2200,7 @@ static int read_unwind_hints(struct objtool_file *file)
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
2.50.0


