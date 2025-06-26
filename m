Return-Path: <live-patching+bounces-1543-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7B81AEAB1B
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 01:58:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24E0117AD72
	for <lists+live-patching@lfdr.de>; Thu, 26 Jun 2025 23:58:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47E132609CC;
	Thu, 26 Jun 2025 23:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rpkwyaSD"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D750260575;
	Thu, 26 Jun 2025 23:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982180; cv=none; b=Q8o7rMMIl0IAAaLABg62ChWFrpakf1RE5/9FW5zgpGfTLr903MjqZS286m3ShkXl5N6pn+1qalPC7EUhzsd0nMrOO+geHDIrhD07VAI0JYLZYMgikd0yP6Vl9z9MuSAk+X1E9khcAf7v5SY+Fa5WjIhyW/UnNMTBZh/HGP/GYkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982180; c=relaxed/simple;
	bh=dH9lJ5pVgRGXRU3nCJAoakjNV0irDXPbwo3dgXZoSp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tt2Vc1y9iK9SiP3hzBxbYH4ZQ3WJuQnaLfUGFYBPna4YqSJq1l/LJq2kXlNG1CtQA9M/YOqN97vIMymnjuXcGv3M6ZODtpyDG6ioe2GC+Ykj57z7qD0rC979BImFZboYpTmMiUKwSCubNUxeos+owyxnGJwkbEWzI6AbNV02iR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rpkwyaSD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735F1C4CEF1;
	Thu, 26 Jun 2025 23:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982180;
	bh=dH9lJ5pVgRGXRU3nCJAoakjNV0irDXPbwo3dgXZoSp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rpkwyaSDXwHMvgADj/Iw35oDFc1zcI+wED1Ynz3z6m8oBWVxbnCiNAXNfMo83KCbb
	 Rt/NEXpjszZWZdA/GqOjCNNEhbyMUJU5dDNOndvzBAogkg9QhMq6fbc0i03S4+gZfF
	 jCzr6fVPS0l5WwtAYjYANncN0bKWlGN0yE+4QgoEB/c32vf9FQNxVrK2iI0FyavlR5
	 rhy3HsW+AkrDM30SeTjSksONr7iAsnVq+NRFZ6ut0Ag8PVkrkKc81Fhbr+/ARY9AGG
	 vvs8sJUxL/Sh8BFNG30EBoK/8G5QJWiNbv/8CATYZS2pT0OwzYxiDUxJ3Vos/4cYaL
	 or9ngntSmQBRQ==
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
Subject: [PATCH v3 13/64] objtool: Propagate elf_truncate_section() error in elf_write()
Date: Thu, 26 Jun 2025 16:55:00 -0700
Message-ID: <7fefa2fc608709425c24ac24f727936df86fcb07.1750980517.git.jpoimboe@kernel.org>
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

Properly check and propagate the return value of elf_truncate_section()
to avoid silent failures.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index b009d9feed76..19e249f4783c 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -1307,7 +1307,6 @@ static int elf_truncate_section(struct elf *elf, struct section *sec)
 	for (;;) {
 		/* get next data descriptor for the relevant section */
 		data = elf_getdata(s, data);
-
 		if (!data) {
 			if (size) {
 				ERROR("end of section data but non-zero size left\n");
@@ -1343,8 +1342,8 @@ int elf_write(struct elf *elf)
 
 	/* Update changed relocation sections and section headers: */
 	list_for_each_entry(sec, &elf->sections, list) {
-		if (sec->truncate)
-			elf_truncate_section(elf, sec);
+		if (sec->truncate && elf_truncate_section(elf, sec))
+			return -1;
 
 		if (sec_changed(sec)) {
 			s = elf_getscn(elf->elf, sec->idx);
-- 
2.49.0


