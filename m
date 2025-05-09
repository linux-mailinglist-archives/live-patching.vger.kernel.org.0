Return-Path: <live-patching+bounces-1368-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CB6FAB1DDB
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:19:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5237D1C24032
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:19:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D1022627EF;
	Fri,  9 May 2025 20:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AJkEtWvh"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CFE2620D5;
	Fri,  9 May 2025 20:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821870; cv=none; b=AYXzDRgAQNFtjOowQ0e8xAgFi7igVHfI6x95jpuTMmwnGGPThLbNXvv+Rus8Zl7abus5TNIUsIEBHAEAd1K5sNvonFPYOlUuxoza53xRScGUsga2kQiiqAuu0splv/+VJ8UOxboGDqaPtds5BtsMtItfHE4ggLvuTjYX6pDEc9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821870; c=relaxed/simple;
	bh=QEuLubKoQXMBsEx5sHZzFlitGLkxHjeRmTHJo/8LE50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIqv3DczkBTp5bRkUn4WJEkbZXjitJydBBOotJb6WZwwSvV/3gjYRC6jVhEmpnhzl4uHoBgxjfkAERzemZcm72fge0IEBYgxH9gPHcImCOeMYaTh8aqzTN/BlU8HJHipLXwOu9uwu4ZizbUUXpclE+dQ6pzZjkQPWsubxRhm4f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AJkEtWvh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B232CC4CEF1;
	Fri,  9 May 2025 20:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821870;
	bh=QEuLubKoQXMBsEx5sHZzFlitGLkxHjeRmTHJo/8LE50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AJkEtWvhwgUEm69O7cnYy26j+QGpFDMsD3psaSXAryU9kiorxwRZlT91twuv4xCj2
	 4nigkHAjOHSSn8HjVlezDtSolnIstTJEh9GqJCuD3t5Lc0O0XHyVekGmiDcUI5Ige8
	 HmxwEpq7Pa2w+Fg5dOmu5G7rTduN2XfOJrOmtanLuKj6c6VK0pzOb1i/Yg3AqGPn3O
	 jZat6teAq69tIxJW0Ag5poplfkDJEhIiWdPXrzyT5RF/TZ4bvLDaAoxU0VLWnRwdTQ
	 9HUXC6Cf/VdPgR8524YrmqkF/u/LezJgrg9DaUlLtZ11wq9kLvePjI0C2pY4m/P74C
	 pqT71uYMceRrg==
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
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH v2 09/62] modpost: Ignore unresolved section bounds symbols
Date: Fri,  9 May 2025 13:16:33 -0700
Message-ID: <9629c36b9515e9574783d63ea6f937f51b3e7a56.1746821544.git.jpoimboe@kernel.org>
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
index be89921d60b6..84266a19b296 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -604,6 +604,11 @@ static int ignore_undef_symbol(struct elf_info *info, const char *symname)
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
2.49.0


