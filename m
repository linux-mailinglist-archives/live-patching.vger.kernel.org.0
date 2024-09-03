Return-Path: <live-patching+bounces-538-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76B69969271
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 06:00:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D9C81B2081B
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:00:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC0F01CE711;
	Tue,  3 Sep 2024 04:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QfNtunj0"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C981CE708;
	Tue,  3 Sep 2024 04:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725336031; cv=none; b=bii1qSSFVgrJJWLSK9VBNqNIjiq3WU3yIZCPW8i+P/39nX+SaLYWI1xPyoPpZgk/OpTzRL6FLWgJUz7x7jPXv0f4VolTNrvg9QcLuO5gEEDbtHVrpQpDEVTnLZcvxN2L+0kK+duc4xxBpZcq0D1Dmawq800zF0ISlGUdug8cVzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725336031; c=relaxed/simple;
	bh=eVWw//8hfsmd9PQaCYwE+A1M1gV4cGzk9SxhhPEd0cI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFLZai7SA7JsTlwbM5VyY/xHdxxDOKjsOCoJ03SEKm5E6Qg/Vw+K+hiJJQqJgwUP9PRfc/uZixSbsRHYQLFEgLOYqwHVp/DhJ8lUVFPpqNZ0dj0I0Ct2mU8pPbh2QLKMpqqvgX0X5kwM1oXDAYCP8isPh7EZ5cyiOT8hPOlq2Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QfNtunj0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57A9C4CECB;
	Tue,  3 Sep 2024 04:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725336031;
	bh=eVWw//8hfsmd9PQaCYwE+A1M1gV4cGzk9SxhhPEd0cI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QfNtunj0JiQlTj5nRdl/EOKKUfmzCi7EDtEUtA6/QChRPMb/ZaNnnH3aQ76aIhIl9
	 UVEkM8pOuBNWGviqEULB+SAPZkhqlYdw/pwkXMZEKAHzJzKEg82xNfRFdQgYbcKo1s
	 GXxGdQz7jNODyzs6raCTDjOp0RMcekvT3CZTsUGQ8dF7nCOdKCvjJIR7r8S/ZqHk7f
	 sUwBVP/8VgXboRi1L+QbbukYqxf3+bDc8TPou2L6dLC/ML4UzyUYsE7OQMmjIthSYy
	 6d78LcQZN51BTJMhG5l3KQZw/agihIy+Dk6sWOZmlCkfOaBli/nErogSbBW02x/6xk
	 iu5566KYCbEiA==
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
Subject: [RFC 04/31] kernel/sys: Don't reference UTS_RELEASE directly
Date: Mon,  2 Sep 2024 20:59:47 -0700
Message-ID: <203eaa28b60bef8f4396beed554358e3c2483a07.1725334260.git.jpoimboe@kernel.org>
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

Objtool will be getting a new feature to calculate build-time function
checksums, so each function can be uniquely identified.  A function's
checksum is calculated based on its instructions, jump/call targets,
alternatives, string literals, and more.

When there are any changes to the git working tree, UTS_RELEASE is
suffixed with "+".  That can result in an undesired changed checksum for
the functions which inline override_release() due to its direct
reference of the UTS_RELEASE string literal.

Convert the override_release() 'rest' variable to a static local so it
won't affect function checksums.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 kernel/sys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 3a2df1bd9f64..526464ea194b 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1291,7 +1291,7 @@ static int override_release(char __user *release, size_t len)
 	int ret = 0;
 
 	if (current->personality & UNAME26) {
-		const char *rest = UTS_RELEASE;
+		static const char *rest = UTS_RELEASE;
 		char buf[65] = { 0 };
 		int ndots = 0;
 		unsigned v;
-- 
2.45.2


