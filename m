Return-Path: <live-patching+bounces-1373-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 69FE7AB1DE5
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:20:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2030B527B8B
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:20:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07052264FA9;
	Fri,  9 May 2025 20:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gRt8ixP3"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19B9264F83;
	Fri,  9 May 2025 20:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821873; cv=none; b=H0f4kMfJ5by0vWbGBZCiHAHPBW9LJojd69bOvM2dHd0RFuA4Nd0eXDBoNPYzO7OZ3modit2bZg8AJTxQ4JPb1I0/JwCofeQOwdOdBzHinGXRsriwxY08Dx0G0x9SNyu/b42C6Tc7iA0XKqBztWW9EC7rUDQj1fGaY71iMzj8FgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821873; c=relaxed/simple;
	bh=dH9lJ5pVgRGXRU3nCJAoakjNV0irDXPbwo3dgXZoSp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hu+E2wtQNWWFUCu1J+z8t9brasmT0jI5KBodwDrlWxjmD8XHPNsRWcNnQ16XnWr8a2rtoKtlQvuQ5z7ULAD70SXmIGTGXXPuXdAaF9p4i3tHU/TjDCUHDgVCe5Bq0mzKvkvFNI7Nip6dni2KAWHrV3dl7SQ0TCKSiIbJtzXiOp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gRt8ixP3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33610C4CEEE;
	Fri,  9 May 2025 20:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821873;
	bh=dH9lJ5pVgRGXRU3nCJAoakjNV0irDXPbwo3dgXZoSp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gRt8ixP3RHSOf74iwWLF6T/NcmRiNqWTZo7Z1Xel1lqzZmxtSnevF2w4gn3216suL
	 qKUpQTijZcNK5Wg1M+p4yzC9BNQCh1k/Z+um3upi0z+PT2+1FDn8jcqKeQ/DMk5U0t
	 CvJYVad0CKIjYIlQB/Oq3cT5sIaYsVnPhV83WU1GkHyvv5U2AH3WufvigKtKXHiAtM
	 KsyreAZOqGkA6dHCdVQPCwpkTAk5kNK4wt/k51wSkJdFX1aNEZ7/fJ3dptQMtMwFZy
	 BTmQXV0/94ChlH3+Tf8QSlkQKppIDlCmLx1JJ8wLsvNJt+rlgHHDdrAKkARVILp+s7
	 m6Win7eQNmH/w==
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
Subject: [PATCH v2 14/62] objtool: Propagate elf_truncate_section() error in elf_write()
Date: Fri,  9 May 2025 13:16:38 -0700
Message-ID: <57aaef73e092a0d539c07aba00e2063ea7124552.1746821544.git.jpoimboe@kernel.org>
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


